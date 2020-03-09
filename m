Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629C517E837
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgCITWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:22:32 -0400
Received: from mail-me1aus01hn2026.outbound.protection.outlook.com ([52.103.198.26]:50144
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbgCITWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FB8squexs5YLNfD9eMf7cR7SrFbCKc8JOByWPGpoNIDOiu4qzfHmGixs3uCRLxYlvUrTUvql3sTGL8PsIbQp6ux4jmpVW+4P7yeno2z/pvmr68MIPI3Sd4GZTwlteb2rIVtHR4LQCzDjra/P/hvNUDeR89gQvn7Gyd8JukSih2IKDdkILbGj6JIQ+HOxrDG2Ov/TaQgQMg5GiEDIDvW6pqRqZ7Zu+7EaTK6lqg8B+o2BFg9s4stGRVb/Pi9R0/ILcBgBmoCfAVlGqV8wuG7GyPs7QcWu8pjTWSgXjE3j9UHDGt3thQDmpZd6rPEGh+dsY8KC3wVDiUmRyxr/y5Umqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRNED6SnWfoviUfCfFrF2HSUBYaunbsC31j7+8o7rr4=;
 b=XD+Ibxg/QqwK9nAjvyH9emXde9+s04C1o/kClI7bIRFQs1iczQ536LDvPSacV/0+6jOuYohIXKJM7I8KCtNxwi1DXr2yrjMe8O02DusaMl7hole5siBQFqHPTLq7QYn0gTnoWeIZmsCF/h71HKpiJvrG8rHg5avXJwDKdIl3OXWRfP/4kiaK+dpyYDCcYybWvyyRdIrDM6vfKiI5tCSmET8pIM+Sx4XmabdtfDNkkYsFhnvoXVRxRcjZNvAbzpa5vTRy4mFws27FNMNsnhWpeh9S762HK2PJmBlXTDbMMufU+L5XobN4LxxN8n1Sy4iztvAmHGQdZo9E+WjBvmtzwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=student.uts.edu.au; dmarc=pass action=none
 header.from=student.uts.edu.au; dkim=pass header.d=student.uts.edu.au;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=studentutsedu.onmicrosoft.com; s=selector1-studentutsedu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRNED6SnWfoviUfCfFrF2HSUBYaunbsC31j7+8o7rr4=;
 b=ZXWT42FkxFHEDGV8PstOUOdftXfgmLymikUKx07UX9e57UnHRdMCMd9bLlXp7iHDC7vIxqWhWEPH6IhcY2QJxGYWbEMDXOby7WjNqk9NWB1ywv9f0N5yyhagSzeSVBQR1kg9q4iwOXG3Fus2efA4GfwP8WrBQ/OKr5XLoUZeedI=
Received: from SYCPR01MB3760.ausprd01.prod.outlook.com (20.177.106.137) by
 SYCPR01MB4704.ausprd01.prod.outlook.com (20.178.186.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Mon, 9 Mar 2020 19:22:27 +0000
Received: from SYCPR01MB3760.ausprd01.prod.outlook.com
 ([fe80::c1d6:243b:dbdf:42a4]) by SYCPR01MB3760.ausprd01.prod.outlook.com
 ([fe80::c1d6:243b:dbdf:42a4%6]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 19:22:27 +0000
Received: from [10.85.110.231] (105.8.4.232) by JN2P275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::18) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2793.14 via Frontend Transport; Mon, 9 Mar 2020 19:22:17 +0000
From:   Jeff Lindsay <3176220@student.uts.edu.au>
To:     Chunsong Jin <Chunsong.Jin@student.uts.edu.au>
Subject: =?utf-8?B?U3BlbmRlICjigqwgMi4wMDAuMDAwLDAwIEVVUik=?=
Thread-Topic: =?utf-8?B?U3BlbmRlICjigqwgMi4wMDAuMDAwLDAwIEVVUik=?=
Thread-Index: AQHV9kgRWppPG+eG40+7cCabtVLWUg==
Date:   Mon, 9 Mar 2020 19:22:27 +0000
Message-ID: <SYCPR01MB3760F39F4087BE1E7F08C95E9CFE0@SYCPR01MB3760.ausprd01.prod.outlook.com>
Reply-To: "janfourie376@gmail.com" <janfourie376@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: JN2P275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::18)
 To SYCPR01MB3760.ausprd01.prod.outlook.com (2603:10c6:10:a::9)
x-originating-ip: [105.8.4.232]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chunsong.Jin@student.uts.edu.au; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58e9aea3-dbe7-45e9-ec9d-08d7c45f344e
x-ms-traffictypediagnostic: SYCPR01MB4704:
x-microsoft-antispam-prvs: <SYCPR01MB47047D9551CFACAB1656CCADE9FE0@SYCPR01MB4704.ausprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(189003)(4744005)(33656002)(66806009)(66556008)(6636002)(64756008)(66946007)(66476007)(5660300002)(316002)(786003)(16576012)(6666004)(26005)(52116002)(6862004)(71200400001)(66574012)(478600001)(956004)(7416002)(5003540100004)(52536014)(2906002)(16526019)(186003)(55236004)(8796002)(66446008)(9686003)(8936002)(81156014)(6486002)(81166006)(2860700004);DIR:OUT;SFP:1501;SCL:1;SRVR:SYCPR01MB4704;H:SYCPR01MB3760.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: student.uts.edu.au does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yQWZNSU3IPlDvoKIss3KAiBZr0uv2BLEk8vvD8s/w0qasK1IBHfrbD55WZrkrzVixE5PYv9BoVhkvKRRZkUVFl6mLbeJIAK4wcNPKijLHQXFuOgFVCK4NTDfshjEhu9KEwRtJP0JMNzGyObnFB/NhTLbgBHco+NMSnwx0j27Mrtkahz0SvZjNg/tyXIWF8tkGqYO+tz8ns7pffQgx13++6eRlTvA7p961vQsyUTNKetCrG1u7sjCTjVBwTCGMKqWLAwKCO9J55AQSHo0GJ/CW05gYtItIjUJQpI9rl4cPqqpY8U5amxj+VRjdoCPnfC32KEMbsMyiuHG1gyltDGTFMPIkkLQhi3Ym0oOgzjQoyuJczqdQz3tyi6O7FCsDKbgtkMY3FglYbKwBeTnWyoU+hFlqvF5RtPcSJzNgmzjlVRVpP3f2lnr9bN2np909e6O
x-ms-exchange-antispam-messagedata: Ddnecuzw7zmqb7wj9T+JT8YqwlO0Jp/JUWwRKYVeqJKB8C21AAS1s9vdfdOPa+AWV872S+lHnmLhsRMv/Qi9FOKdglOnvLmrRv5Rvimdh0SI79yKVBcl2Cht1umUgrIg8KoG9TQuqEf62vD1Dhe1Gg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8BAB0BE56E94148BC731AA8284E4718@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: student.uts.edu.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e9aea3-dbe7-45e9-ec9d-08d7c45f344e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:22:27.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8911c26-cf9f-4a9c-878e-527807be8791
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DkLHFEJvwOFajWExNvCEhSbAYFDHqEqCM9rR3fHnPfrbIBv2gini6uWpdz5AYqpZQ9T9JFmmYdJDfh6heH5YWiQSzNdNDLlYFiF9nY86ACA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYCPR01MB4704
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SWNoIGJpbiBKZWZmIExpbmRzYXksIGVpbiDDpGx0ZXJlciBCw7xyZ2VyIGF1cyBLYWxpZm9ybmll
biwgVVNBLiBJY2ggaGFiZSBlaW5lbiBKYWNrcG90IHZvbiA0NDcsOCBNaWxsaW9uZW4gRG9sbGFy
IGdld29ubmVuLCBkZXIgZ3LDtsOfdGUgTG90dGVyaWUtSmFja3BvdC4gSW0gTmFtZW4gbWVpbmVy
IEZhbWlsaWUgdW5kIGF1cyBndXRlbSBXaWxsZW4gc3BlbmRlbiB3aXIgSWhuZW4gdW5kIElocmVy
IEZhbWlsaWUgZWluZW4gQmV0cmFnIHZvbiAo4oKsIDIuMDAwLjAwMCwwMCBFVVIpLCB3YXMgKCQg
Mi40NzQuOTYyLDg1IFVTRCkgZW50c3ByaWNodC4gSWNoIHZlcnN1Y2hlLCBkaWUgw7ZmZmVudGxp
Y2hlbiBXYWlzZW5ow6R1c2VyIHp1IGVycmVpY2hlbi4gQmVpdHJhZyB6dXIgQXJtdXRzYmVrw6Rt
cGZ1bmcgdW5kIEdld8OkaHJsZWlzdHVuZyBlaW5lciBhbmdlbWVzc2VuZW4gR2VzdW5kaGVpdHN2
ZXJzb3JndW5nIGbDvHIgZGVuIEVpbnplbG5lbi4gSWNoIG3DtmNodGUgYXVjaCwgZGFzcyBTaWUg
ZWluZW4gVGVpbCBkaWVzZXIgU3BlbmRlIGluIGRpZSDDtmZmZW50bGljaGUgSW5mcmFzdHJ1a3R1
ciBpbnZlc3RpZXJlbiwgdW0gQXJiZWl0c2xvc2VuIGluIElocmVtIExhbmQgQXJiZWl0c3Bsw6R0
emUgenUgYmlldGVuLiBJY2ggaGFiZSBkaWNoIGdld8OkaGx0LCB3ZWlsIGljaCBhbiBkaWNoIGds
YXViZS4gSWNoIGJyYXVjaGUgSWhyZSB1bmVpbmdlc2NocsOkbmt0ZSBNaXRhcmJlaXQgaW4gQmV6
dWcgYXVmIGRpZXNlIFNwZW5kZS4gQml0dGUga29udGFrdGllcmVuIFNpZSBtaWNoIGhpZXIgenVy
w7xjayB1bnRlciBtZWluZXIgcHJpdmF0ZW4gRS1NYWlsOiBpbmZvQGVyYWRpY2F0ZXBvdmVydHlv
cmcuY29tDQo=
