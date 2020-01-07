Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF9132354
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 11:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgAGKPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 05:15:41 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:45186 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgAGKPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 05:15:41 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9AA49C0516;
        Tue,  7 Jan 2020 10:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578392139; bh=iObhOSprcxxCk26t2mFFKfyP/I2aJh039jBnQnNRHTI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=C3xaj7U7WO8RUQ3o2BbfnNgUzBvpQXTk+encpKhWfua143KJokbf4HsgZZ3C2FUzv
         wLaDTxU9nX61kcUv5EvdVvyEG5L9fP+QfxitVcOsglb6cKIBMGH80G2X5bmq5Qy+q7
         fFCEA9v4ia18weVEf1btas2nCP8Os2gzaF++rkKF8NDfL3JYILvO0Rkn2TjBEjJJYQ
         e1eNsCy5jjUkj0W2MvYVZizzWtbiIbqFTrwTDN+4rcZ0MO30SdaNu+jd14J9FYvTsi
         +FH1lGN+w0rDBnPxHLM+2xvSf7xAAhkz8SOPp4B79qtMyjZCdk+X4lipeLlOWW2ORd
         SCJ/EpVBGvouA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2F169A0079;
        Tue,  7 Jan 2020 10:15:39 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 02:15:38 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 02:15:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fec5HkQK4M9zrjOKFz6TcNxpxbyZPYOkeR8TUJB3GFNOcZdv/h5At34OwTLgLjZwq/t7dq1D4dPmpt1TOL/jiMn0QDyJiw9JVJ7DVA0PUDRfXAF4GNdlCty9vDDcUf4bMV9+5jAeWlmnfRKamrv87al9z/GgCN/dKtuYUCIgpoitCyW7Mz43PgFD645jUFoelNHhyn+4+oqgeT5Rz43kqSY8zhZRgbgGhpBiqRfRSlVQPcuaASnrvvVQfAEsVIpZ/euhYD4shje5dmVoE/bTXgatt45TNk4gKOhXyToiNWIyjN/GYcnL3UQf1D+Txd3EtuclyNWGfjgVpk1pSS0fCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iObhOSprcxxCk26t2mFFKfyP/I2aJh039jBnQnNRHTI=;
 b=dP7v+dDSeIvZyDzqM2I19o5Lg406IAfCbVBiBionMZRRCD6vAcdzYlyvWsikpR9ZxOEpAP3pVBdk6VItEajbTQh/qjlGnPx7VB4Sab3vpx4RM0aCha8ud+MNSeYA8u/erfMnAWXqc8MQ5omL0BqMeUmjSHC6KZVBdJf2zCtrdKqv4mNhEZ4x/pBGHCfwXgrnQYyW4/nfIDKTP2muDkrJLJm0lekplDoUjQEDQcvNnjnJbz4lFn7Byl6GwGFtjL+xY9Ev3rGg6eF6z3iJbnz0thbTAYrFbPtXjYo27sHNJYHGQqn4DyYcOSzMBo3KiYa3Y1PZ1y40D5th5Q+q6crQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iObhOSprcxxCk26t2mFFKfyP/I2aJh039jBnQnNRHTI=;
 b=piQ4PgF3F7A2EaT0glhdVNm020ystVVX0N8Uj9mLwMhHcadC/py/SWc+YHED9qtHoHT6d2cML1+xRBFlKsCxt1BKQUctH9p2xJWg5e/Dby1ZCohpaxPjccf2qX+UwW3r87G2UQ7F5R+e/FaqA7sUQc72Ii/plUVU6bjkGmaDmSg=
Received: from BN7PR12MB2802.namprd12.prod.outlook.com (20.176.27.97) by
 BN7PR12MB2771.namprd12.prod.outlook.com (20.176.176.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 10:15:36 +0000
Received: from BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::e420:5711:3657:f3ca]) by BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::e420:5711:3657:f3ca%3]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 10:15:35 +0000
From:   Tejas Joglekar <Tejas.Joglekar@synopsys.com>
To:     Ran Wang <ran.wang_1@nxp.com>, Felipe Balbi <balbi@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@nxp.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking
 extra transfer in wrong case
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking
 extra transfer in wrong case
Thread-Index: AQHVxSp4HjqpGxpTOEWsDIhAyQCdSqfe/HYA
Date:   Tue, 7 Jan 2020 10:15:35 +0000
Message-ID: <9f9d0193-8fe6-33b3-4f5c-95a1181e6681@synopsys.com>
References: <20200107071441.480-1-ran.wang_1@nxp.com>
In-Reply-To: <20200107071441.480-1-ran.wang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joglekar@synopsys.com; 
x-originating-ip: [198.182.52.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49bcadfc-e71c-491f-c7d3-08d7935a8983
x-ms-traffictypediagnostic: BN7PR12MB2771:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR12MB277194AB0EF1BC0457ADC0CAA43F0@BN7PR12MB2771.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(81156014)(81166006)(4326008)(71200400001)(8676002)(6512007)(498600001)(107886003)(31686004)(966005)(31696002)(2616005)(6486002)(86362001)(76116006)(26005)(64756008)(186003)(66446008)(66476007)(6506007)(53546011)(66946007)(5660300002)(8936002)(66556008)(36756003)(91956017)(54906003)(2906002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR12MB2771;H:BN7PR12MB2802.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JwfIGu8lafc5YHyVkttGOUQTuJVQxR/cBhidJnB9frt8NwSriJRBXP1u+wroeR1RaTuTsLJNwYVV/Tcq/ebA0VVjZ4VlgWVdNhYPUzGe3+pmSaWc37yHNNBx5MiV8P27MKujYd0gPs8ULn/UTAhMg5lZxBOz7Si/nPLT4+L2EIBzZfU1ptXe0YdkflMQdLGt0soQjO2a6DU46nrmkCfGVz5P/9GFpGtlTqlbrlRTD5VR6sbEY0P/2FLoLp4kCPZlxog1seIPOEchDPcebRDSB4ZJmxWCRntN6jHQTnPtsD4+cPf6C3BiuW9hlYteba1MNi1CFjCp8riYYq2bYK+62/07PohNpUZZtw5YcRZQI0w+uOnA8+uGuCVXmLhsEfqVmo0GHJrNH1TcJdtyQwGKY+t4V6sZ+rmMycxfufXmuJS/G1mOgniYc4JaUxFpQgRccOzT41czdsMu04CPjJnrgS+ti4gRfB0iE18NG3m7GzqRwvFK5l2oAiMtcPK+0M/RiyYE8M6SMLvIkH+08fmxkg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <24AC5196730C684B8E005D19D62EEF8C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bcadfc-e71c-491f-c7d3-08d7935a8983
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 10:15:35.7210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v3RLbsQnVG+2VIxFOR0/9Bbr91S3Tvcjg0fZbn5F0LMNY7u+lytmv6ofDPU0T7QtRCTZYeVXGD5UYakttYfckA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2771
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQpPbiAxLzcvMjAyMCAxMjo0NCBQTSwgUmFuIFdhbmcgd3JvdGU6DQo+IEFjY29yZGluZyB0
byBvcmlnaW5hbCBjb21taXQgYzk2ZTY3MjVkYjlkNmEgKCJ1c2I6IGR3YzM6IGdhZGdldDogQ29y
cmVjdCB0aGUNCj4gbG9naWMgZm9yIHF1ZXVpbmcgc2dzIiksIHdlIHdvdWxkIG9ubHkga2ljayBv
ZmYgYW5vdGhlciB0cmFuc2ZlciBpbiBjYXNlIG9mDQo+IHJlcS0+bnVtX3BlbmRpbmdfc2dzID4g
MC4NCj4gDQpUaGUgY29tbWl0IDhjN2Q0YjdiM2Q0MyAoInVzYjogZHdjMzogZ2FkZ2V0OiBGaXgg
bG9naWNhbCBjb25kaXRpb24iKSBmaXhlcyB0aGUgY29tbWl0IGYzOGUzNWRkODRlMiAodXNiOiBk
d2MzOiBnYWRnZXQ6IHNwbGl0IGR3YzNfZ2FkZ2V0X2VwX2NsZWFudXBfY29tcGxldGVkX3JlcXVl
c3RzKCkpLg0KDQo+IEhvd2V2ZXIsIGN1cnJlbnQgbG9naWMgd2lsbCBkbyB0aGlzIGFzIGxvbmcg
YXMgcmVxLT5yZW1haW5pbmcgPiAwLCB0aGlzIHdpbGwNCj4gaW5jbHVkZSB0aGUgY2FzZSBvZiBu
b24tc2dzIChib3RoIGR3YzNfZ2FkZ2V0X2VwX3JlcXVlc3RfY29tcGxldGVkKHJlcSkgYW5kDQo+
IHJlcS0+bnVtX3BlbmRpbmdfc2dzIGFyZSAwKSB0aGF0IHdlIGRpZCBub3Qgd2FudCB0by4NCj4g
DQo+IFdpdGhvdXQgdGhpcyBmaXgsIHdlIG9ic2VydmVkIGR3YzMgZ290IHN0dWNrIG9uIExheWVy
c2NhcGUgcGxhZnRvcm1zIChzdWNoIGFzDQo+IExTMTA4OEFSREIpIHdoZW4gZW5hYmxpbmcgZ2Fk
Z2V0IChtYXNzIHN0b3JhZ2UgZnVuY3Rpb24pIGFzIGJlbG93Og0KPg0KU2ltaWxhciBpc3N1ZSB3
YXMgcmVwb3J0ZWQgYnkgVGhpbmggYWZ0ZXIgbXkgZml4LCBhbmQgaGUgaGFzIHN1Ym1pdHRlZCBh
IHBhdGNoIGZvciB0aGUgc2FtZS4gWW91IGNhbiByZWZlciB0aGUgZGlzY3Vzc2lvbiBodHRwczov
L3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzExMjkyMDg3Ly4NCiANCj4gWyAgIDI3LjkyMzk1
OV0gTWFzcyBTdG9yYWdlIEZ1bmN0aW9uLCB2ZXJzaW9uOiAyMDA5LzA5LzExDQo+IFsgICAyNy45
MjkxMTVdIExVTjogcmVtb3ZhYmxlIGZpbGU6IChubyBtZWRpdW0pDQo+IFsgICAyNy45MzM0MzJd
IExVTjogZmlsZTogL3J1bi9tZWRpYS9zZGExLzQxOS90ZXN0DQo+IFsgICAyNy45Mzc5NjNdIE51
bWJlciBvZiBMVU5zPTENCj4gWyAgIDI3Ljk0MTA0Ml0gZ19tYXNzX3N0b3JhZ2UgZ2FkZ2V0OiBN
YXNzIFN0b3JhZ2UgR2FkZ2V0LCB2ZXJzaW9uOiAyMDA5LzA5LzExDQo+IFsgICAyNy45NDgwMTld
IGdfbWFzc19zdG9yYWdlIGdhZGdldDogdXNlcnNwYWNlIGZhaWxlZCB0byBwcm92aWRlIGlTZXJp
YWxOdW1iZXINCj4gWyAgIDI3Ljk1NTA2OV0gZ19tYXNzX3N0b3JhZ2UgZ2FkZ2V0OiBnX21hc3Nf
c3RvcmFnZSByZWFkeQ0KPiBbICAgMjguNDExMTg4XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1
cGVyLXNwZWVkIGNvbmZpZyAjMTogTGludXggRmlsZS1CYWNrZWQgU3RvcmFnZQ0KPiBbICAgNDgu
MzE5NzY2XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNwZWVkIGNvbmZpZyAjMTogTGlu
dXggRmlsZS1CYWNrZWQgU3RvcmFnZQ0KPiBbICAgNjguMzIwNzk0XSBnX21hc3Nfc3RvcmFnZSBn
YWRnZXQ6IHN1cGVyLXNwZWVkIGNvbmZpZyAjMTogTGludXggRmlsZS1CYWNrZWQgU3RvcmFnZQ0K
PiBbICAgODguMzE5ODk4XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNwZWVkIGNvbmZp
ZyAjMTogTGludXggRmlsZS1CYWNrZWQgU3RvcmFnZQ0KPiBbICAxMDguMzIwODA4XSBnX21hc3Nf
c3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNwZWVkIGNvbmZpZyAjMTogTGludXggRmlsZS1CYWNrZWQg
U3RvcmFnZQ0KPiBbICAxMjguMzIzNDE5XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNw
ZWVkIGNvbmZpZyAjMTogTGludXggRmlsZS1CYWNrZWQgU3RvcmFnZQ0KPiBbICAxNDguMzIwODU3
XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNwZWVkIGNvbmZpZyAjMTogTGludXggRmls
ZS1CYWNrZWQgU3RvcmFnZQ0KPiBbICAxNDguMzYyMDIzXSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6
IHN1cGVyLXNwZWVkIGNvbmZpZyAjMDogdW5jb25maWd1cmVkDQo+IA0KPiBGaXhlczogOGM3ZDRi
N2IzZDQzICgidXNiOiBkd2MzOiBnYWRnZXQ6IEZpeCBsb2dpY2FsIGNvbmRpdGlvbiIpDQo+IA0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBSYW4gV2FuZyA8
cmFuLndhbmdfMUBueHAuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMg
fCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91
c2IvZHdjMy9nYWRnZXQuYw0KPiBpbmRleCAwYzk2MGE5Li41YjBmMDJmIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2Fk
Z2V0LmMNCj4gQEAgLTI0OTEsNyArMjQ5MSw3IEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfZXBf
Y2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdChzdHJ1Y3QgZHdjM19lcCAqZGVwLA0KPiAgDQo+ICAJ
cmVxLT5yZXF1ZXN0LmFjdHVhbCA9IHJlcS0+cmVxdWVzdC5sZW5ndGggLSByZXEtPnJlbWFpbmlu
ZzsNCj4gIA0KPiAtCWlmICghZHdjM19nYWRnZXRfZXBfcmVxdWVzdF9jb21wbGV0ZWQocmVxKSB8
fA0KPiArCWlmICghZHdjM19nYWRnZXRfZXBfcmVxdWVzdF9jb21wbGV0ZWQocmVxKSAmJg0KPiAg
CQkJcmVxLT5udW1fcGVuZGluZ19zZ3MpIHsNCj4gIAkJX19kd2MzX2dhZGdldF9raWNrX3RyYW5z
ZmVyKGRlcCk7DQo+ICAJCWdvdG8gb3V0Ow0KPiANCg0KVGhhbmtzICYgUmVnYXJkcywNCiBUZWph
cyBKb2dsZWthcg0K
