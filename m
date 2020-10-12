Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0C328AB60
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 03:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgJLBW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 21:22:57 -0400
Received: from mail-mw2nam10on2134.outbound.protection.outlook.com ([40.107.94.134]:25939
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbgJLBW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Oct 2020 21:22:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFLz5h/ewVy2Qs2hTNOinjyCZYvNRoQ+f7cmgdNZavUkn8LwvNwUtc5MwU60Mv6RSx2bxVckdjpvJYa2JuBVMl5wsNJxZ7GyLb5d3is38OotSyJQpVqljA/jUl6xRBoTR/WKkGeRq3U2h6l0+TFaPkUZUJ/QSS1y7N33VOmkU/pp382rSJR+19/+M/CARIP5+0pFSUDxDdmdIEk8FQvAjfyfNn2s2dfFwDWDSK9rS8C9EVWxgMTt8nlrTNk2toAByAEXzPYR+tBU1FRwmJmyNaOxyXcMHjRAwgj65mrpUM3SEyIQ4BMnx9YsTUL25Cr3juzE+BNgq+GVqsKua3He8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJBWmHCPVEGgrr0uNmkfq4gSMWojwUf5l8tOeZAEAjo=;
 b=L11BeWZ4NuHGScBrWt9ObvINffeTGqNAwQfJ/Hq8t0OJ/4fsJNCJW50IjwmejQQHu4fsLFmB3KCefE6nSc0Rmjs6hVc6/KM10H2BPY34Dfl154xnR7Gu7CHV+iLC+X1aEhHkO3wP9QTM+6F+wH1DH3UlQTbGbe01XLYys87Axk2D/svimfQ8/bI7O7tuLdnSZ2d5IqstGlgpy9W3YOmWvTx9TnlUTpPscQugRwFewddW1DlPTmRjvTr4PeZeF+TrACFLg32UrcioMWjxz6k4xzPwnBH6TB3FweOnERck1JH/IRC4v9w81idgVbIXf3O9w6duJe6r36q+f0T5fib3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=estudiantes.uv.mx; dmarc=pass action=none
 header.from=estudiantes.uv.mx; dkim=pass header.d=estudiantes.uv.mx; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uvmx.onmicrosoft.com;
 s=selector2-uvmx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJBWmHCPVEGgrr0uNmkfq4gSMWojwUf5l8tOeZAEAjo=;
 b=rwX1JuqtfEWyQ/Xil9oN2Mou23fIuyDQvt4x4wa/H0563uvwm2iWJctHFLw7QDCR77ccRs+1ydQ38Ov9M6MwT4PhIFJESJ7fkPM86TZi2htdxBUUA4IquClYPs2e9not2Cl+zR5os+rhINcbmOt3noDD7DL1apj8KIfFjRYAf8A=
Received: from SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12)
 by SA2PR10MB4427.namprd10.prod.outlook.com (2603:10b6:806:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Mon, 12 Oct
 2020 01:22:54 +0000
Received: from SN6PR10MB2717.namprd10.prod.outlook.com
 ([fe80::5b0:b936:5016:5ab2]) by SN6PR10MB2717.namprd10.prod.outlook.com
 ([fe80::5b0:b936:5016:5ab2%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 01:22:54 +0000
From:   AMORES HURTADO DE MENDOZA MELISSA SINAI 
        <zS14009670@estudiantes.uv.mx>
To:     AMORES HURTADO DE MENDOZA MELISSA SINAI 
        <zS14009670@estudiantes.uv.mx>
Subject: =?utf-8?B?UkU6IEjDpGxzbmluZ2FyIGZyw6VuIE9wZWMgRm91bmRhdGlvbi4=?=
Thread-Topic: =?utf-8?B?SMOkbHNuaW5nYXIgZnLDpW4gT3BlYyBGb3VuZGF0aW9uLg==?=
Thread-Index: Adaf/l9Kl+ucHOu9Quy1xPR/rcNLUwAABR8wAAbnLNAAAosf4A==
Date:   Mon, 12 Oct 2020 01:22:54 +0000
Message-ID: <SN6PR10MB2717A1A4C81E875548FE969F9F070@SN6PR10MB2717.namprd10.prod.outlook.com>
References: <SN6PR10MB27173F7A077F9F4C575039C79F060@SN6PR10MB2717.namprd10.prod.outlook.com>
 <SN6PR10MB2717B84EB5E55669F07843469F060@SN6PR10MB2717.namprd10.prod.outlook.com>
 <SN6PR10MB2717B5AF0BAADEB6A7F3F83B9F060@SN6PR10MB2717.namprd10.prod.outlook.com>
In-Reply-To: <SN6PR10MB2717B5AF0BAADEB6A7F3F83B9F060@SN6PR10MB2717.namprd10.prod.outlook.com>
Accept-Language: es-MX, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: estudiantes.uv.mx; dkim=none (message not signed)
 header.d=none;estudiantes.uv.mx; dmarc=none action=none
 header.from=estudiantes.uv.mx;
x-originating-ip: [82.102.17.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b845648-f523-4fc8-5def-08d86e4d587c
x-ms-traffictypediagnostic: SA2PR10MB4427:
x-ld-processed: 3c907651-d8c6-4ca6-a8a4-6a242430e653,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB44275322B5E59B43336B4CE99F070@SA2PR10MB4427.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vCggZhIOLhnBwH/Ll9qUBZ1XfkTamEPoWI2qzTZHXTnLAwpiV+klZ7opLOujJyGMkSM7CJXS/7wgjyGOPUazXWLGHjIQbmZv+0OwqfG8omh0L6bOJTYzDFJnLRreMceg6Lw6B5pNlr3JZlBMCCBYuVg05dEZncAdZ0moPKqXJwqkvlMWHXfV1uuswfHD/TUzHfiiUX0ZkTBtxTpatuYiWzYnJNavrK6xYUvggGShulzaqw48sXTVlMALxbyvw1p69huRqBMQAtyL58XJcnuDlSDBXoi0b7DL2rEPsWbWHq6ZAk37Ah0K8cyO3accjWYBZ0hgCDivlxOs/6wYNuH/Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:sv;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2717.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39850400004)(7696005)(66446008)(66556008)(8936002)(316002)(786003)(64756008)(66476007)(9686003)(52536014)(55016002)(26005)(6200100001)(6506007)(5660300002)(66946007)(186003)(76116006)(6862004)(33656002)(478600001)(224303003)(2906002)(86362001)(71200400001)(7406005)(7416002)(7366002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +CJF0dReaRNMjH49lWU2OkadPpZ7TwylG/DYGwiCQc82IsFwQx5Fts2zaPJZJqv9C9j1Eh2S0JitLr2Dsjx8IMr1APKvx3kR2TutLFvGSvxlstQt0RpEZKCIe1+IYzr1nTSdDAorJQEpAhGXjt8cpnKnCT3vwEuzeKdr6CHupI4g4aGuwsqwbvHjku9MKq44S9tX+R5vhvhU6SWehW29MUif6z/tJnsaDloM31/+Ui8SWyC9ywWVgDMQZXEsLaQkTAkX72hKflvKVJ9N3fqI0Zw5A2JJkQ7mKidojrfbJpBnW+OBh3RwW0pSnEXzCvXxFnXm3/tz0byjFlfNyegfRizmZobVuN0G47h7KLxSzTn1Scei24sktXgeTIVnxWtlYNbCfCFOPcjN/hN77Ly3zZN+wNsOa5lQrRy4GV2gx2wZdJ41HElLKr1vMCqMX58/+EnCUPWU6GF2lx60QfLasFvyccV06UP9N2F9K4hxihriuzzVVMqJNNobx0kfHwsDUIAF5oDUphvENlKJuRW5QOS+VQCy+rvOc7LmS4zRIrLZ7iK67dmQeix/Whj/tj79gCEJ/lFX1TUeq4rB/WvdCrMXyfRlAqIZ0uIoaSxjlBZHldDzS+4RzrLpdMNKC4VLEMwWEFz9d/RevNyO8YvZKA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: estudiantes.uv.mx
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2717.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b845648-f523-4fc8-5def-08d86e4d587c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 01:22:54.4800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c907651-d8c6-4ca6-a8a4-6a242430e653
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJsGG+9ghrPu2Wihk7iYLStBgD4tMrf957Av/0X3VVY8z0leQw62/LSsEhyhKT3kUIpjZFbXBRLoe560sEjcCofVOAXkHsFHn6sLtJMWAZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4427
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

eA0KDQpIw6Rsc25pbmdhciBmcsOlbiBPcGVjIEZvdW5kYXRpb24uDQoNCkRldHRhIGbDtnIgYXR0
IGluZm9ybWVyYSBkaWcgb20gYXR0IHZpIGhhciBlbiBkb25hdGlvbiB0aWxsIGV0dCB2w6RyZGUg
YXYgNzUwMDAwLDAwIOKCrCAvIEVVUiAoc2p1IGh1bmRyYSBvY2ggZmVtdGlvIHR1c2VuIGV1cm8p
IGbDtnIgZGlnIGZyw6VuIE9wZWMtYmlkcmFnIGbDtnIgaW50ZXJuYXRpb25lbGwgdXR2ZWNrbGlu
ZywgZGV0dGEgYmVyb3IgcMOlIGRlbiBudXZhcmFuZGUgc2l0dWF0aW9uZW4gbWVkIGtvcm9uYXZp
cnVzIHJ1bnQgb20gaSB2w6RybGRlbiBqdXN0IG51LiBPcGVjIEZ1bmQgZm9yIEludGVybmF0aW9u
YWwgRGV2ZWxvcG1lbnQgKE9GSUQpIMOkciBlbiBzdGlmdGVsc2Ugc29tIMOkZ3MgYXYgT3JnYW5p
c2F0aW9uZW4gZsO2ciBvbGplZXhwb3J0bMOkbmRlciAoT1BFQykuIERlbm5hIHN0aWZ0ZWxzZSBm
aW5hbnNpZXJhcyBhdiBtZWRsZW1zbMOkbmRlciBzb20gaW5rbHVkZXJhcjogQWxnZXJpZXQsIEFu
Z29sYSwgRGVtb2tyYXRpc2thIHJlcHVibGlrZW4gS29uZ28sIEVrdmF0b3JpYWxndWluZWEsIEdh
Ym9uLCBJcmFuLCBJcmFrLCBLdXdhaXQsIExpYnllbiwgU3ZlcmlnZSwgU2F1ZGlhcmFiaWVuLCBG
w7ZyZW5hZGUgQXJhYmVtaXJhdGVuLCBUYWl3YW4uIE9GSUQgw6RyIGVuIHV0dmVja2xpbmdzb3Jn
YW5pc2F0aW9uIHNvbSBzeWZ0YXIgdGlsbCBhdHQgZsO2cmLDpHR0cmEgbGl2IMO2dmVyIGhlbGEg
dsOkcmxkZW4uIERldHRhIHByb2dyYW0gbcOkcmt0IOKAnUdyYXNzLVJvb3RzIFByb2dyYW3igJ0g
w6RyIGVuIGRlbCBhdiBhbnN0csOkbmduaW5nYXJuYSBmw7ZyIGF0dCBmw7ZyYsOkdHRyYSBsZXZu
YWRzc3RhbmRhcmRlbiBnZW5vbSBkaXJla3QgZGVsdGFnYW5kZSBpIGxpdnN1dHZlY2tsaW5nIMO2
dmVyIGhlbGEgdsOkcmxkZW4gZ2Vub20gYXR0IGJlbXluZGlnYSB1dHZhbGRhIGluZGl2aWRlci4g
RGVubmEgZG9uYXRpb24ga29tbWVyIGF0dCB0asOkbmEgc29tIGVuIHN0b3IgaGrDpGxwIGbDtnIg
dsOkcmxkZW4uIER1IHRhciA1MCUgYXYgZGV0dGEgZG9uYXRpb25zYmVsb3BwIG9jaCBkZWxhciBy
ZXN0ZW4gNTAlIHRpbGwgZGUgYmVow7Z2YW5kZSBydW50IGRpbiBvcnQuIGtvbnRha3RhIG9zcyBt
ZWQgZGl0dCBmdWxsc3TDpG5kaWdhIG5hbW46IMOFbGRlcjogTGFuZDogU3RhdDogWXJrZTogVGVs
ZWZvbm51bW1lcjogb2NoIGVuIHNrYW5uYWQga29waWEgYXYgZGl0dCBJRC1iZXZpcyBlbGxlciBp
bnRlcm5hdGlvbmVsbGEgcGFzczogdGlsbCB2w6VyIGUtcG9zdDogaW5mbzQzQG9wZWNkb25hdGlv
bi5vcmcNCg0KVsOkbmxpZ2EgaMOkbHNuaW5nYXINCkRyIEFiZHVsaGFtaWQgQWxraGFsaWZhDQoo
R2VuZXJhbGRpcmVrdMO2cikgT3BlYyBGb3VuZGF0aW9uDQpLb250YWt0IGUtcG9zdDogaW5mbzQz
QG9wZWNkb25hdGlvbi5vcmcNCg==
