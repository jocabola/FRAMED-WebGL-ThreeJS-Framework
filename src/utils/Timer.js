export default class Timer {
	constructor () {
		this.startTime = Date.now();
		this.lastUpdate = this.startTime;
		this.time = 0;
		this.delta = 0;
	}

	update () {
		let t = Date.now() - this.startTime;
		this.delta = t - this.time;
		this.time = t;
	}

	getTimeMs () {
		return this.time;
	}

	getTimeS () {
		return this.time * .001;
	}
}