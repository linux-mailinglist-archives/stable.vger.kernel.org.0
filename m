Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6683797F4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 21:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhEJTvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 15:51:08 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:53024 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230390AbhEJTvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 15:51:08 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CE51D4016B;
        Mon, 10 May 2021 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1620676203; bh=btA7VbGZsIA1ZcSoeToSSD0M7j7Gj4F8ach+f/ygVRY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=BuIf9e81OFOic5K3cZSEpf3SCNPrqVSKcDV07dtZAG9QRxnwZKNBgzUHDuGypbrw5
         kiL90iF/t3yhd3cj80Mr97Z31TcgD6KBaHQzvGe1/oDAd6F8XspGkTDyv2/4B/GqCK
         Qbk+aHbDvtyqVjW4a9i/5kB0ZwaXJU/C4ot0mUjIxUBbfE1IhS7Bm5YLeLfoBX2gpG
         UXkh8L1NwBr2FqryaaZVXvShTyZmXYiaDzHJix6AmxyU83efG4KL7QKPnUn3rtru4k
         hfhWv2nLgijx/kur3zNSMnY9B8uLqXUzCXCqKHoX4F8tJ4q5LkTrg1RnawChhTB9ss
         nicgGokwBEGbA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E1B99A00A8;
        Mon, 10 May 2021 19:50:00 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 9995540139;
        Mon, 10 May 2021 19:49:59 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="RO42zOjk";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyWK7hMfuNquLC2FmNTG+xUMRuaph8LZUa+yKLMW9qb7aBLmQj9TdkeqritcnYQ0+O7Ukb9QEBFTlvyT99X5Sj0gfdnY3YaSa9tuS1/j/MRO5abeoVow9LxR5DUGhpErlV/CERedbldR1zACdD+qg8TLqW7uHmqMdGF59rfuTtk6j5DjfWdDRk9SGfyeO2qUsSSbLAsxHcmqCcr1DYNTgVVKXxgjsY3njY5qNy1tn/FwvvjJsDAwJM921gN+YZ+AE/OhRV1irumX6p9D/TyN692b9RkIzGgEq37FtApj/RoEOdw2wB4yLPCjHB2aZyuFvzR/1sxYADIIFQtXzUMaag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btA7VbGZsIA1ZcSoeToSSD0M7j7Gj4F8ach+f/ygVRY=;
 b=oWXz45Of+QwgJKLN9cUBsT4F2x7D+7vq5J/htpS/fr2fEr8TQltVGOJiSCeil1NcFSqNdNR8XPIFuxr2rceh/2L42hEqDc7PKRwci4gAm+TlSp8muhCoB88vf8vC0vvt3tMWQIaho6xwQKhYMEi9BlaYF1tmKLP85zrjKUoc2PWjDong6y3R2GdIQ/SNjNMaRneuBWOQp1XOSBra9jnATnwOHzDadzoWaCDKfw73ek8HePgaNRQDjsOu9G48zKP/WtZdRoU5nB3lXpFAiBC3ZqDaSyVuEAuiXKWx7tnnrfVDUcGqzyNIvGCbeINpuUAq+ZYAKrrQ7PgLNP9gRj20xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btA7VbGZsIA1ZcSoeToSSD0M7j7Gj4F8ach+f/ygVRY=;
 b=RO42zOjknO3d2u3Cu6b+U3CbBocFKQU9bjTq+3VbJW0rX3W2j7IH9fXdV1qPDlxHcD1tU8pMyK4x1OQ0Y8WHg7350/vUvaXs2dIxhTUud5+AZSqFyDOR+slfy9AmAmaYA5StW9Una0zJAfBKfYjeOFcPFdU4qM2DjvRROpL53Ic=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BYAPR12MB2629.namprd12.prod.outlook.com (2603:10b6:a03:69::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Mon, 10 May
 2021 19:49:57 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::d1a0:ed05:b9cc:e94d%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 19:49:57 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Vladimir Isaev <Vladimir.Isaev@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>
CC:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARC: Use 40-bit physical page mask for PAE
Thread-Topic: [PATCH v2] ARC: Use 40-bit physical page mask for PAE
Thread-Index: AQHXO16okJPGilDbKkCQWeJzblHZjKrdNJAA
Date:   Mon, 10 May 2021 19:49:57 +0000
Message-ID: <4cff46a0-6e25-7a34-f67f-983e2f5fb08d@synopsys.com>
References: <20210427121237.2889-1-isaev@synopsys.com>
In-Reply-To: <20210427121237.2889-1-isaev@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [24.4.73.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53c9b317-7f5b-4828-75e0-08d913ecca1a
x-ms-traffictypediagnostic: BYAPR12MB2629:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB26290EDE09649987F9CF6BAFB6549@BYAPR12MB2629.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:31;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fUtaHLKoawQzZqBi+UQHjb/12I2KbPjP2/mkyCfACoDzI7aCjd7Aavg3IX6JEvvcOh8owGpPxLKulb5Jw9ynckA8NuyjHKiMI3jsRCIs1ctrWknkvLTGDpBntRkQ1VEYBvLecSQWG2M0f3E4ilqWL7tHYS6gfRW47ijFXLUSIVMBc7D//hIxUGyJbIGW4e176dGTw7b67uGazRci9KmBN3+jdMANdX8YfC3ERDW2QltwMgHi9LVB+sulbqaEFlKXuyGayTOmOaIPFnukz9+D38ps+KFJunqNvurz9yQe0xaWtVXkbmqufRawMeua9ManamHTQ28YIQfu7IQif5hKoYB3xYYT2ePZn6LhWoDdNt0Gfexn9FT2G0v9hD8ok/M3Gr0/TL15hUDvQpP8SmkwnuGQur75FnYP4jK+HPTeIxpgC69fCRf97yWdDFBBD8mW9qRp0D9uk/QN6NN5hIeb/IOkhY0hmLO8ZYSc+dcnL/aD63yd06ZySlINdZNG91btqrpNV7G5OQzEB4HLznldsw9MxwaXP8Es/ZSBId2ov+7Z+pNfbYFfrPOXSmO4rt+kLRDPETXsG5yuiVCtD0/7b09ToItFmFP+Yl6O5vpJFV9WwkIsr/up4VM6E+0E3EAmFo3tD5maPGJ+b7+qcXr23I/IY0SfxoZ954UcporuYYAPEgLO6lgaxcvY2LcxFmOt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(110136005)(2616005)(6486002)(66476007)(64756008)(54906003)(186003)(66446008)(66946007)(316002)(36756003)(66556008)(4326008)(5660300002)(6506007)(2906002)(31686004)(53546011)(71200400001)(8936002)(26005)(6512007)(8676002)(478600001)(86362001)(38100700002)(83380400001)(122000001)(31696002)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VEdpVGFNaS9rTzNpVStvZHJTL2xoUm1wS1dMUUJ6OTEwcVplT2xOZ01zZWV2?=
 =?utf-8?B?blVPZm02TGQrUlUxYjNvajJZS0VRWllaMEFjR0NvZ2lwR3liY2xqVHlkOHU1?=
 =?utf-8?B?bWJEaFluVTdYNFNuM2NkTHpPamFlVm4wYVJYbFJucHpQU2Eyb3VqTXBnZ3hm?=
 =?utf-8?B?cjE2SHYraGhGRElvc2FXMDk2ZFdyUThMalJEQ0daL1MzSCtIcjF6N3czSmli?=
 =?utf-8?B?RVh1WGxYeGk0dFlsakRnKytDM1lvVlFKd0w5cGJxL1BJM0dzVFEvV04rTno0?=
 =?utf-8?B?S3BlRU5vb0F1d3h6eGdWRVJZTFVEaXZtRThJYlhXSk9zclh1eSswN1pLSllI?=
 =?utf-8?B?YlZTSWhlQ0oreTBnNE4vRVRzRDVRLzlLb0laM2tITFNEQXpEK3p5Mnh4Qy9v?=
 =?utf-8?B?aGlvejZyRkV4cnNoWkZ4Q3lQak9ucWJnQjVaTFlaaVJYWGRSWHRRcFk3VXZB?=
 =?utf-8?B?emxxSW1mSkFMektMZStwS1BuNjk1WTlZUmo4RXRLYjhuR2lSdjRuejdHRFVH?=
 =?utf-8?B?YlZtVXBPMVMwRGg3ZWZhU0NvZWxkK2t3K3hnZEw4YmI5Umd1RVdqN1dVc1Az?=
 =?utf-8?B?ZWN0MnRteDg0YWpSU3J1a1pxQ3E5OGdGRStDR0lHaXByRUluZzhVVmhaL2V3?=
 =?utf-8?B?NURxcW9BY1hlcGZYMndENDVFeEZpU0JVTnR3MTJ2emtUQnRlSk85S2RFeTcw?=
 =?utf-8?B?U1VPR0lZMWVkUUExN2E0OTc2YkdycnV1OGdWZTArL2ZmTzg2WDNVK3dnVHpt?=
 =?utf-8?B?MndHbFJyT2J1L0hrUzA1U0dLTXdzWGM2MEMzMTBNRGVxMGhMbitiVVNPVkh1?=
 =?utf-8?B?V3AzUGM1QVI5dFlqdjRYQm1HOUZtNW5pMzJ1am05RFRTYTlSamY0YW1JL2NO?=
 =?utf-8?B?Ym4xMEdzSGZvcjQxU285cGl0elFEWXFqeXJqTndWVkpRUUw1WVQyWjR5cHlO?=
 =?utf-8?B?UEJVVWhtV3VQZmQ0T2EyNjN4aCthZVpDM2NYME01cXZNWktUOXRMMW9PMFNB?=
 =?utf-8?B?Qy9aZ0VRSTFLMkdIdWUxT1NPWFh3Ky9Bdmc2bDljQ05BTSsvK1BIdmUyQVFX?=
 =?utf-8?B?QTNjOGR5VWE5WStSd2RHNms3V3BqYzRCL052cW0vTGkzYUhyVUtCbDRhcDVw?=
 =?utf-8?B?NW5MRThpUm9NR1g5Z3dRbjE4SW1qcjM3VWtxSkRLL1luYm1qc3FQdTlQZTU4?=
 =?utf-8?B?S2s3OEp6Z2Z1dFNZclMxbHFtRUw4aVZVNkpScEF4SFJ1V3owYWVodTZpV2hv?=
 =?utf-8?B?NEg2dUw5N1hWSk1yaE0zL2IvWXRVSDRzanRENTBBZTFsU3cyLzZ6WGMxNjRh?=
 =?utf-8?B?ZnVLRXVIWXMyeGVxWlQ0OFR1QS9rd3REOW95emR3NHA1SmJnV3MwU25CRFZn?=
 =?utf-8?B?VUpRdUdhSEZrT3N3YlFCcFFDOXM5TmNQV0lENDVKQVMxUFAyWHdHMjV4NU5u?=
 =?utf-8?B?ODl3QkMzOTM0QlZGNmk2QU1iaU5xU3hVeUVPQnFWdDVudmpndGhJQmVXdHBY?=
 =?utf-8?B?QytkM3RJRDF0d2lRQktpL3hBakVHeGZnalNiVGlTN0NNcXVoMUJ4dk8wOEJl?=
 =?utf-8?B?ZE45THo0RWpseGExQnVRMmZsaTcrOTVDK24wWWNQZDVqd0xPYUlWSjNRekZN?=
 =?utf-8?B?L0NSOER1TWhMYjFLNllwYkJJemVJQ0djdjVuTFp6Rm1wckxZQ2wzOENwMzBX?=
 =?utf-8?B?bEtLSTJqM255Y3dua0Z6dUZ5bytKVnBIeWFJRGtybmVCUGcyWkM1cG9yK0Mr?=
 =?utf-8?Q?1cNF7hifr/IXrSvBVE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D95BC756D289F449B547E62D18F1ACFE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c9b317-7f5b-4828-75e0-08d913ecca1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 19:49:57.2098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y7siIfvJ9MSbIwNLhhsJYuLJcUi/PhY8udRz+678DzWN9qlEzjKIkDWqzBEj8MpEGj4Hw4Fn2JPJxwL1vL10RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2629
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNC8yNy8yMSA1OjEyIEFNLCBWbGFkaW1pciBJc2FldiB3cm90ZToNCj4gMzItYml0IFBBR0Vf
TUFTSyBjYW4gbm90IGJlIHVzZWQgYXMgYSBtYXNrIGZvciBwaHlzaWNhbCBhZGRyZXNzZXMNCj4g
d2hlbiBQQUUgaXMgZW5hYmxlZC4gUEFHRV9NQVNLX1BIWVMgbXVzdCBiZSB1c2VkIGZvciBwaHlz
aWNhbA0KPiBhZGRyZXNzZXMgaW5zdGVhZCBvZiBQQUdFX01BU0suDQo+DQo+IFdpdGhvdXQgdGhp
cywgaW5pdCBnZXRzIFNJR1NFR1YgaWYgcHRlX21vZGlmeSB3YXMgY2FsbGVkOg0KPg0KPiBwb3Rl
bnRpYWxseSB1bmV4cGVjdGVkIGZhdGFsIHNpZ25hbCAxMS4NCj4gUGF0aDogL2Jpbi9idXN5Ym94
DQo+IENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCA1LjEyLjAtcmM1LTAwMDAz
LWcxZTQzYzM3N2E3OWYtZGlydHkNCj4gSW5zbiBjb3VsZCBub3QgYmUgZmV0Y2hlZA0KPiAgICAg
IEBObyBtYXRjaGluZyBWTUEgZm91bmQNCj4gRUNSOiAweDAwMDQwMDAwIEVGQTogMHgwMDAwMDAw
MCBFUkVUOiAweDAwMDAwMDAwDQo+IFNUQVQ6IDB4ODAwODAwODIgW0lFIFUgICAgIF0gICBCVEE6
IDB4MDAwMDAwMDANCj4gICBTUDogMHg1ZjlmZmU0NCAgRlA6IDB4MDAwMDAwMDAgQkxLOiAweGFm
M2Q0DQo+IExQUzogMHgwMDBkMDkzZSBMUEU6IDB4MDAwZDA5NTAgTFBDOiAweDAwMDAwMDAwDQo+
IHIwMDogMHgwMDAwMDAwMiByMDE6IDB4NWY5ZmZmMTQgcjAyOiAweDVmOWZmZjIwDQo+IHIwMzog
MHgwMDAwMDAwMCByMDQ6IDB4MDAwMDBhNDggcjA1OiAweDAwMTg1NWI4DQo+IHIwNjogMHgwMDE4
NjY1NCByMDc6IDB4MDAwMTAwMzQgcjA4OiAweDAwMDAwMGUyDQo+IHIwOTogMHgwMDAwMDAwNyBy
MTA6IDB4MDAwMDAwMDAgcjExOiAweDAwMDAwMDAwDQo+IHIxMjogMHgwMDAwMDAwMCByMTM6IDB4
MDAwMDAwMDEgcjE0OiAweDAwMDAwMDAyDQo+IHIxNTogMHg1ZjlmZmYxNCByMTY6IDB4NWY5ZmZm
MjAgcjE3OiAweDAwMTg1NWQwDQo+IHIxODogMHgwMDAwMDAwMSByMTk6IDB4MDAwMDAwMDAgcjIw
OiAweDAwMDAwMDAwDQo+IHIyMTogMHgwMDAwMDAwMCByMjI6IDB4MDAwMDAwMDAgcjIzOiAweDAw
MDAwMDAwDQo+IHIyNDogMHgwMDAwMDAwMCByMjU6IDB4MDAxOGE0ODgNCj4gS2VybmVsIHBhbmlj
IC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAw
MGINCj4NCj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgSXNhZXYgPGlzYWV2QHN5bm9wc3lzLmNv
bT4NCj4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiBD
YzogVmluZWV0IEd1cHRhIDx2Z3VwdGFAc3lub3BzeXMuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KDQpBcHBsaWVkIHRvIGZvci1jdXJyICENCg0KVGh4LA0KLVZpbmVldA0KDQo+
IC0tLQ0KPiBDaGFuZ2VzIGZvciB2MjoNCj4gICAtIFBIWVNJQ0FMX1BBR0VfTUFTSyAtPiBQQUdF
X01BU0tfUEhZUw0KPiAgIC0gb2ZmIHZhcmlhYmxlIGluIGlvcmVtYXBfcHJvdCBpcyBub3cgdW5z
aWduZWQgaW50IGFuZCB1c2VzIFBBR0VfTUFTSw0KPiAgIC0gUmV2aXNlZCBjb21taXQgbWVzc2Fn
ZQ0KPiAtLS0NCj4gICBhcmNoL2FyYy9pbmNsdWRlL2FzbS9wYWdlLmggICAgICB8IDEyICsrKysr
KysrKysrKw0KPiAgIGFyY2gvYXJjL2luY2x1ZGUvYXNtL3BndGFibGUuaCAgIHwgMTIgKysrLS0t
LS0tLS0tDQo+ICAgYXJjaC9hcmMvaW5jbHVkZS91YXBpL2FzbS9wYWdlLmggfCAgMSAtDQo+ICAg
YXJjaC9hcmMvbW0vaW9yZW1hcC5jICAgICAgICAgICAgfCAgNSArKystLQ0KPiAgIGFyY2gvYXJj
L21tL3RsYi5jICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICA1IGZpbGVzIGNoYW5nZWQsIDE5
IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cmMvaW5jbHVkZS9hc20vcGFnZS5oIGIvYXJjaC9hcmMvaW5jbHVkZS9hc20vcGFnZS5oDQo+IGlu
ZGV4IGFkOWI3ZmU0ZGJhMy4uNGE5ZDMzMzcyZmUyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FyYy9p
bmNsdWRlL2FzbS9wYWdlLmgNCj4gKysrIGIvYXJjaC9hcmMvaW5jbHVkZS9hc20vcGFnZS5oDQo+
IEBAIC03LDYgKzcsMTggQEANCj4gICANCj4gICAjaW5jbHVkZSA8dWFwaS9hc20vcGFnZS5oPg0K
PiAgIA0KPiArI2lmZGVmIENPTkZJR19BUkNfSEFTX1BBRTQwDQo+ICsNCj4gKyNkZWZpbmUgTUFY
X1BPU1NJQkxFX1BIWVNNRU1fQklUUwk0MA0KPiArI2RlZmluZSBQQUdFX01BU0tfUEhZUwkJCSgw
eGZmMDAwMDAwMDB1bGwgfCBQQUdFX01BU0spDQo+ICsNCj4gKyNlbHNlIC8qIENPTkZJR19BUkNf
SEFTX1BBRTQwICovDQo+ICsNCj4gKyNkZWZpbmUgTUFYX1BPU1NJQkxFX1BIWVNNRU1fQklUUwkz
Mg0KPiArI2RlZmluZSBQQUdFX01BU0tfUEhZUwkJCVBBR0VfTUFTSw0KPiArDQo+ICsjZW5kaWYg
LyogQ09ORklHX0FSQ19IQVNfUEFFNDAgKi8NCj4gKw0KPiAgICNpZm5kZWYgX19BU1NFTUJMWV9f
DQo+ICAgDQo+ICAgI2RlZmluZSBjbGVhcl9wYWdlKHBhZGRyKQkJbWVtc2V0KChwYWRkciksIDAs
IFBBR0VfU0laRSkNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJjL2luY2x1ZGUvYXNtL3BndGFibGUu
aCBiL2FyY2gvYXJjL2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiBpbmRleCAxNjM2NDE3MjZhMmIu
LjU4Nzg4NDZmMDBjZiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcmMvaW5jbHVkZS9hc20vcGd0YWJs
ZS5oDQo+ICsrKyBiL2FyY2gvYXJjL2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiBAQCAtMTA3LDgg
KzEwNyw4IEBADQo+ICAgI2RlZmluZSBfX19ERUYgKF9QQUdFX1BSRVNFTlQgfCBfUEFHRV9DQUNI
RUFCTEUpDQo+ICAgDQo+ICAgLyogU2V0IG9mIGJpdHMgbm90IGNoYW5nZWQgaW4gcHRlX21vZGlm
eSAqLw0KPiAtI2RlZmluZSBfUEFHRV9DSEdfTUFTSwkoUEFHRV9NQVNLIHwgX1BBR0VfQUNDRVNT
RUQgfCBfUEFHRV9ESVJUWSB8IF9QQUdFX1NQRUNJQUwpDQo+IC0NCj4gKyNkZWZpbmUgX1BBR0Vf
Q0hHX01BU0sJKFBBR0VfTUFTS19QSFlTIHwgX1BBR0VfQUNDRVNTRUQgfCBfUEFHRV9ESVJUWSB8
IFwNCj4gKwkJCQkJCQkgICBfUEFHRV9TUEVDSUFMKQ0KPiAgIC8qIE1vcmUgQWJicmV2YWl0ZWQg
aGVscGVycyAqLw0KPiAgICNkZWZpbmUgUEFHRV9VX05PTkUgICAgIF9fcGdwcm90KF9fX0RFRikN
Cj4gICAjZGVmaW5lIFBBR0VfVV9SICAgICAgICBfX3BncHJvdChfX19ERUYgfCBfUEFHRV9SRUFE
KQ0KPiBAQCAtMTMyLDEzICsxMzIsNyBAQA0KPiAgICNkZWZpbmUgUFRFX0JJVFNfSU5fUEQwCQko
X1BBR0VfR0xPQkFMIHwgX1BBR0VfUFJFU0VOVCB8IF9QQUdFX0hXX1NaKQ0KPiAgICNkZWZpbmUg
UFRFX0JJVFNfUldYCQkoX1BBR0VfRVhFQ1VURSB8IF9QQUdFX1dSSVRFIHwgX1BBR0VfUkVBRCkN
Cj4gICANCj4gLSNpZmRlZiBDT05GSUdfQVJDX0hBU19QQUU0MA0KPiAtI2RlZmluZSBQVEVfQklU
U19OT05fUldYX0lOX1BEMQkoMHhmZjAwMDAwMDAwIHwgUEFHRV9NQVNLIHwgX1BBR0VfQ0FDSEVB
QkxFKQ0KPiAtI2RlZmluZSBNQVhfUE9TU0lCTEVfUEhZU01FTV9CSVRTIDQwDQo+IC0jZWxzZQ0K
PiAtI2RlZmluZSBQVEVfQklUU19OT05fUldYX0lOX1BEMQkoUEFHRV9NQVNLIHwgX1BBR0VfQ0FD
SEVBQkxFKQ0KPiAtI2RlZmluZSBNQVhfUE9TU0lCTEVfUEhZU01FTV9CSVRTIDMyDQo+IC0jZW5k
aWYNCj4gKyNkZWZpbmUgUFRFX0JJVFNfTk9OX1JXWF9JTl9QRDEJKFBBR0VfTUFTS19QSFlTIHwg
X1BBR0VfQ0FDSEVBQkxFKQ0KPiAgIA0KPiAgIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KPiAgICAqIE1h
cHBpbmcgb2Ygdm1fZmxhZ3MgKEdlbmVyaWMgVk0pIHRvIFBURSBmbGFncyAoYXJjaCBzcGVjaWZp
YykNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJjL2luY2x1ZGUvdWFwaS9hc20vcGFnZS5oIGIvYXJj
aC9hcmMvaW5jbHVkZS91YXBpL2FzbS9wYWdlLmgNCj4gaW5kZXggMmE5N2UyNzE4YTIxLi4yYTRh
ZDYxOWFiZmIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJjL2luY2x1ZGUvdWFwaS9hc20vcGFnZS5o
DQo+ICsrKyBiL2FyY2gvYXJjL2luY2x1ZGUvdWFwaS9hc20vcGFnZS5oDQo+IEBAIC0zMyw1ICsz
Myw0IEBADQo+ICAgDQo+ICAgI2RlZmluZSBQQUdFX01BU0sJKH4oUEFHRV9TSVpFLTEpKQ0KPiAg
IA0KPiAtDQo+ICAgI2VuZGlmIC8qIF9VQVBJX19BU01fQVJDX1BBR0VfSCAqLw0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcmMvbW0vaW9yZW1hcC5jIGIvYXJjaC9hcmMvbW0vaW9yZW1hcC5jDQo+IGlu
ZGV4IGZhYzRhZGM5MDIwNC4uOTVjNjQ5ZmJjOTVhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FyYy9t
bS9pb3JlbWFwLmMNCj4gKysrIGIvYXJjaC9hcmMvbW0vaW9yZW1hcC5jDQo+IEBAIC01Myw5ICs1
MywxMCBAQCBFWFBPUlRfU1lNQk9MKGlvcmVtYXApOw0KPiAgIHZvaWQgX19pb21lbSAqaW9yZW1h
cF9wcm90KHBoeXNfYWRkcl90IHBhZGRyLCB1bnNpZ25lZCBsb25nIHNpemUsDQo+ICAgCQkJICAg
dW5zaWduZWQgbG9uZyBmbGFncykNCj4gICB7DQo+ICsJdW5zaWduZWQgaW50IG9mZjsNCj4gICAJ
dW5zaWduZWQgbG9uZyB2YWRkcjsNCj4gICAJc3RydWN0IHZtX3N0cnVjdCAqYXJlYTsNCj4gLQlw
aHlzX2FkZHJfdCBvZmYsIGVuZDsNCj4gKwlwaHlzX2FkZHJfdCBlbmQ7DQo+ICAgCXBncHJvdF90
IHByb3QgPSBfX3BncHJvdChmbGFncyk7DQo+ICAgDQo+ICAgCS8qIERvbid0IGFsbG93IHdyYXBh
cm91bmQsIHplcm8gc2l6ZSAqLw0KPiBAQCAtNzIsNyArNzMsNyBAQCB2b2lkIF9faW9tZW0gKmlv
cmVtYXBfcHJvdChwaHlzX2FkZHJfdCBwYWRkciwgdW5zaWduZWQgbG9uZyBzaXplLA0KPiAgIA0K
PiAgIAkvKiBNYXBwaW5ncyBoYXZlIHRvIGJlIHBhZ2UtYWxpZ25lZCAqLw0KPiAgIAlvZmYgPSBw
YWRkciAmIH5QQUdFX01BU0s7DQo+IC0JcGFkZHIgJj0gUEFHRV9NQVNLOw0KPiArCXBhZGRyICY9
IFBBR0VfTUFTS19QSFlTOw0KPiAgIAlzaXplID0gUEFHRV9BTElHTihlbmQgKyAxKSAtIHBhZGRy
Ow0KPiAgIA0KPiAgIAkvKg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcmMvbW0vdGxiLmMgYi9hcmNo
L2FyYy9tbS90bGIuYw0KPiBpbmRleCA5YmIzYzI0ZjM2NzcuLjljN2M2ODI0NzI4OSAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC9hcmMvbW0vdGxiLmMNCj4gKysrIGIvYXJjaC9hcmMvbW0vdGxiLmMNCj4g
QEAgLTU3Niw3ICs1NzYsNyBAQCB2b2lkIHVwZGF0ZV9tbXVfY2FjaGUoc3RydWN0IHZtX2FyZWFf
c3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgdmFkZHJfdW5hbGlnbmVkLA0KPiAgIAkJICAgICAg
cHRlX3QgKnB0ZXApDQo+ICAgew0KPiAgIAl1bnNpZ25lZCBsb25nIHZhZGRyID0gdmFkZHJfdW5h
bGlnbmVkICYgUEFHRV9NQVNLOw0KPiAtCXBoeXNfYWRkcl90IHBhZGRyID0gcHRlX3ZhbCgqcHRl
cCkgJiBQQUdFX01BU0s7DQo+ICsJcGh5c19hZGRyX3QgcGFkZHIgPSBwdGVfdmFsKCpwdGVwKSAm
IFBBR0VfTUFTS19QSFlTOw0KPiAgIAlzdHJ1Y3QgcGFnZSAqcGFnZSA9IHBmbl90b19wYWdlKHB0
ZV9wZm4oKnB0ZXApKTsNCj4gICANCj4gICAJY3JlYXRlX3RsYih2bWEsIHZhZGRyLCBwdGVwKTsN
Cg0K
