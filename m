Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E085260204
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIGRQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:16:15 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24167 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbgIGRQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 13:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599498959; x=1631034959;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=t5isL0osKFWIeyLDyAytAq4Gy18Nh8qK5IvlcS2HtkE=;
  b=Qp3VUrmTibcxB7/zOtchO+IpwI4Zts/o/b1pfLVaVtB6wHMFO6TIbzHZ
   69opT3jFtvrt3nZOtJ9bu35d/Vg/DNz0qb7veZk8tpnwUDNq01S//E5sT
   QPkn4E5htWcRR/UI/3p14NZgDGwufqTAwVVpZBit8U7uREI2VPQqi0PCg
   zhN2d8Qz9rtPRrvzhBGMjL+LfFbWjZ69aQpf4QaQf6stO/NZKFNZC4bL4
   s19xAn+piUtPQNKDfNkYULla6MoxoKDnr5/dK49AL9rL5oFYb/fYW46AA
   ocpgSywB3jZ7VcwrBd1qAFVKgyfZpe8aASCHKf7ZnqV+r92iupCrEI2KF
   Q==;
IronPort-SDR: N0LCSEtVNfd7Hk+daf462GY8vE2XykKyF4C0NZo+eq9H+qtNdYDX4oVm2mqpQZZ8HsuadcVEIP
 dAR7o4L4gFIm33SQGV8R2kL9P2poAqPcjpywa2mB1dIMbwGeXzLn7rGBHtPSwqnVnCwB+QC8i8
 rBHIIzJXvM/EV9PncojiF/Zq845LR80HAFcyGutBwrPg7on633WdGKz2YxXcYXOvBZby3PzWtM
 fcRMWZycurSBFw7mENxrMpMbGT9+ND1J3++RB+gBif4RcA1vPiCTiViMKw2vfnEVIuoryscsXb
 cHs=
X-IronPort-AV: E=Sophos;i="5.76,402,1592895600"; 
   d="scan'208";a="25576085"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2020 10:15:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Sep 2020 10:15:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 7 Sep 2020 10:15:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqdWPnMD3o1SpNJnR8UGb6Nt1rTvd8vP93EvgBjzlUm6RTCS165bIOqiwQZ8RzVn1n89u95yLyHHrk5SL8oeispwb7vEZ8ZNwMN9GmKBShmE45RIaZu2V4VQYbyVXtBDqSF6tdYYMVVW56HZflZapOYp4u5LIA+gizI2MN3WvH3ePl1+Hm81wEina3YN8/gm59vXM7+27sHEisBTefBN47df9RJkaL09fhqdR/Hs/ux28Htw6mUqaJZUr/1zrk0rL3b21ZlkPuJ4zKR83uTIJeS4eqO8GBhcU60SUwHyUiz3DIl53YSQaY1b7lCVycb4S3IJJtaPlsjYsekJ0QMy0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5isL0osKFWIeyLDyAytAq4Gy18Nh8qK5IvlcS2HtkE=;
 b=gxJoDlveWHuXnmdgFYXVEYQm48rGIcG3iI9CHwzu2fRJHBbWNy/TnmRRefIiL3Cc939iCbDbmq3ctocJ9rWM8z3HT7ramAqk/xKZa0/tIv3tvFh6x+FXQKpepj1CSfHzekYSYKsmhPkfVV1wDoomznbiIsNN6lIcof0jmg7WNK/1bNRmoOOKwKJ9yM01nad91YpodxAIjOuWEsJ6hjUEMDr6jaHxNMms0kO0zN8M1+k20p8sHftyz+OeGkxtKxFXG4n7NoO3e5LQCvR/+ULN16QK6kG0pZoI6iicTwuMIw61uictoEVc1E1jx9TVwrWDfizY39qvT2dzVI+/uAE1gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5isL0osKFWIeyLDyAytAq4Gy18Nh8qK5IvlcS2HtkE=;
 b=FxpHstD7knNU96hqQh0T7uibCaj6/KPJ4ku0G26OcjKXlUmyUblvr9SyMf+eC93uPubjWDWOzDVIvdRax1MF3+f+cQZDGSMBTu0tGJ8eMXnfcq5EAYkQ872TpVim7zyZzf1/B7W1ZhP2ObZjlBzYJFf83OyHCfLInhAHtJlKNzA=
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com
 (2603:10b6:903:b1::22) by CY4PR11MB1829.namprd11.prod.outlook.com
 (2603:10b6:903:124::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 17:15:50 +0000
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::c57b:e93f:98a8:c654]) by CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::c57b:e93f:98a8:c654%11]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 17:15:50 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <havasiefr@gmail.com>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: duplicated patch in 5.4
Thread-Topic: duplicated patch in 5.4
Thread-Index: AQHWhSKNyQIp8JfpLUKNBhCKaiw8yqldasqA
Date:   Mon, 7 Sep 2020 17:15:49 +0000
Message-ID: <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com>
References: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
In-Reply-To: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 756c2445-117c-4b2d-db18-08d85351ab18
x-ms-traffictypediagnostic: CY4PR11MB1829:
x-microsoft-antispam-prvs: <CY4PR11MB1829CA575DA20CCC303220D6E7280@CY4PR11MB1829.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PWP6A3BUk7psBxV8LzdPCsLHvdsTM+YHtMc5cUBX8lIChMnrXt0/8StXarAFKi/djQWOFsAcf3mhmEoDZwW6GA1QNP4hz3LWESj9vAODIzs25CPLhau0OcOQ7zLdWkIF8Z2dIHYNwXTRv0VCV4TcFLw4T1LZJznOmDNrOWC7cj+PzKIAF341uFZHSy9Nx2HOUokb2dUWLstkqlE9KRp+U8QPopu8mipc11+ClNWGzArB0VwsnLvjbLPf4+1ND0tQSCbYkQBieNx3sIgSm/+t98JZAPPlbq6sjMtZ0e7bcUjbmgKn3ebJ9JlqTDuXGw8AYSyxnytT2gQYTTjz6WN9Z3LTRGCVGWI6YYRpysW2BiBoO3cPrv/DMPt4kF/mhHAKNEV+V/htYqlKnU904HypKG8y9EKn9wS1z8/EMrva54GXB3GY//KdU5YjhlFaYarl53q2iJlRpfXXFgCes2B23w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2341.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(366004)(396003)(66476007)(6486002)(66446008)(966005)(71200400001)(6506007)(7116003)(31696002)(36756003)(64756008)(26005)(83380400001)(186003)(6512007)(53546011)(86362001)(76116006)(91956017)(478600001)(66946007)(66556008)(2616005)(110136005)(31686004)(2906002)(316002)(8936002)(8676002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: u55wJtcTh7Glh8PcoQNZNM+VrBNdmhYdORgEi/a2usG+pYrPqMErSA5mY96VbJnkIRfgY5ZL4IFEL8plxiyj3eqGNcezowc+ka6SJuSeLgj8nt2W/BimXjY5H1rdAnZSbsi5piQ54D5V/9lbmgu7eT/mbzegaCmjUjh9T+qrqVq1rK43kZ18gssPjYrXbDmoCN/v6DbjhRtV0k9f6Mjrc7VrFHKYPGj2qyfK+dw4VZEovER1221Z+qmMKX817y+zfF2mJe5rQdQdi6L8x2L/Nr7CcBsk2X28sqLiwS5gbNthdsFTO9qIdhZ/gGktJxwpgihdht7JNTueEqajkH6oOg/tuBRsv57w7WNzOxZMrY9TDY9ixG4ODzVIiJkz86xIYoeXSJz1E1dGutHrOukPgLwsOWa4O+h1cLDcdVk4uUHFOWG7XUPKRahI2HUtuoQ/Xf0rMxsHqpIVe76089RSAQ3ElUTxBxPgqq4odwFNiYFAdKh3I1GLBFAQhZv/6+MztXYIED1/bH4bZmjbhDypX9rlT0mrnVfyEQAjFWUy6bCjSiX/5Lni50d3ofcuqet/nEw7Nac93bPKHamLs9jentRC8vpm+2a5O0l+3/asJ3/oCWobbiAuC2r8MgkmAXEoX2Xgh8t6uECTtk89UXYgrw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <278394664924434387A95A2A29C7005E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2341.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756c2445-117c-4b2d-db18-08d85351ab18
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 17:15:49.9425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4A1pEJokGVkbsPJTv2jPx0ocHz6PtTicroM7d5GPGWnn6XxBG7s0I34nuzjP0EQAAoRdmLbmt7gJ356Lugc6H9YImrM1dCAeotfKkZZF2K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1829
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDcuMDkuMjAyMCAxNzoyNCwgS3Jpc3RvZiBIYXZhc2kgd3JvdGU6DQo+IERlYXIgQ2l1YmF0
YXJpdSwNCj4gDQo+IGFzIEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdGhlIGxpbnV4IGRldmVsb3Bt
ZW50IHdvcmtmbG93LCBJIGFtDQo+IGNvbnRhY3RpbmcgeW91IGRpcmVjdGx5IGFzIHRoZSBhdXRo
b3Igb2YgdGhlIHVwc3RyZWFtIHBhdGNoOg0KPiBhZjE5OWExYTljYjAyZWMwMTk0ODA0YmQ0NmMx
NzRiNmRiMjYyMDc1DQo+IA0KPiBJIG5vdGljZWQgdGhhdCB5b3VyIGFkZGl0aW9uIHRoZXJlIHdh
cyBhcHBsaWVkIHR3aWNlIGludG8gNS40IFsxXQ0KPiANCj4gZDliODIwNmU1MzIzYWUzYzliNWI0
MTc3NDc4YTEyMjQxMDg2NDJmNyAgICB2NS40LjUxLTQ1LWdkOWI4MjA2ZTUzMjMNCj4gZDU1ZGFk
OGIxZDg5M2ZhZTBjNGU3NzhhYmYyYWNlMDQ4YmNiYWQ4NiAgICAgdjUuNC41Mi0xMy1nZDU1ZGFk
OGIxZDg5DQo+IA0KPiByZXN1bHRpbmcgaW4gYSBub24taGFybWZ1bCwgYnV0IHVubmVjZXNzYXJ5
IGRvdWJsZSBzZXR0aW5nIG9mIHRoZSB2YXJpYWJsZS4NCj4gDQo+IC8qIHNldCB0aGUgcmVhbCBu
dW1iZXIgb2YgcG9ydHMgKi8NCj4gZGV2LT5kcy0+bnVtX3BvcnRzID0gZGV2LT5wb3J0X2NudDsN
Cj4gDQo+IC8qIHNldCB0aGUgcmVhbCBudW1iZXIgb2YgcG9ydHMgKi8NCj4gZGV2LT5kcy0+bnVt
X3BvcnRzID0gZGV2LT5wb3J0X2NudDsNCj4gDQo+IHJldHVybiAwOw0KPiANCj4gQ291bGQgeW91
IG5vdGlmeSB0aGUgc3RhYmxlIG1haW50YWluZXJzIHRvIGFwcGx5IHlvdXIgcGF0Y2ggY29ycmVj
dGx5Pw0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcmlzdMOzZiBIYXZhc2kNCj4gDQo+IA0KPiBb
MV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxl
L2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jP2g9djUu
NC42MyNuMTI3NA0KPiANCg0KSGVsbG8sDQoNCktyaXN0w7NmIGRpc2NvdmVyZWQgdGhhdCBvbmUg
cGF0Y2ggb2YgbWluZSB3YXMgYXBwbGllZCB0d2ljZS4gV2hhdCBpcyB0aGUgDQpiZXN0IHdheSB0
byBhZGRyZXNzIHRoaXM/DQoNClRoYW5rIHlvdSBLcmlzdMOzZiBmb3IgZmluZGluZyB0aGlzLg0K
DQpCZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg==
