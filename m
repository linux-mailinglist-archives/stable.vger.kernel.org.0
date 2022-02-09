Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F34AF8EE
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbiBISCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiBISCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:02:40 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2057.outbound.protection.outlook.com [40.92.103.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7F0C0613C9;
        Wed,  9 Feb 2022 10:02:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDPAteXmHvYzzp1rTPQKEnYegOjg8LrnAfXG449itB7c/9cVJLldnEiTRTAdESKYTo7u1zldu9IIJE5W9KXdq8h4RwDH3d7IELko+hXRhDrT8ozNAQSkRQscM9rtlTDgKPEPq+lGRYUdvKCFUzV52thOXQd7Rss4Md5Rzdrm6NfUC9xI+h6O92INigB+e5snx0jiTkFfGMHnornOFwi7nv67WPkR6ApwJ9YvSOtqFg0mgoCtu9ykYjXadcPZNVL7C2una0GPD7YUkUbCp2Pbd4Nqu/ci5uKJJh96IvLuP9W24vVR5yCh0em/Iy4D6//fEmLTC0qjh4CwVns9ChPBiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NxdijGaKuoG2D0QfjjJ11BbQKxxJapN9Qo+UhpUofI=;
 b=Qu8WUNx4/Qt3xfY4PhyrHN+3KNFZjHLezHJQqyL2HPveeF2Y4ZOBymmLu/h/u1AQrX86LBUDV1oHhsBw4InYQyiTjZU6WU3qqGr2wddSLQXUu363suaQgE0ttEMlrfaKGpH2Tg6dTwz4puLqkQE0f3x6B5wXMpOyMG6kV0PXIfFP29uambi1sJd/MTuDtr5Yeozt6RdhqvFTZru/6AtxFCrgAcgkfr1sDSCaQAO805dQKyb4JEVfgQ5yoX9SvEB8hPlRBYDJNNELROjUw2ets9ZMgFDKDxKRldYC6k9qZKENt39LVzUMYmuMzgyPJ0x6VE8AT9AXmDn4s8+WK2aO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NxdijGaKuoG2D0QfjjJ11BbQKxxJapN9Qo+UhpUofI=;
 b=ojII6gT8XU11f3txRCqMsI2jsU6bZ3cWxg6VaQECsT+4WHAWkaSIhE7iHcZFXauZggyXI1GKc4TIMleog2yUquBOFMFRUcAIoIsV92jJYvOV2XPHdOeJhlWlJc5X+VUBO47DQ9sqKImjkr1W/JryqBrKjPy1eBGaCCcMYypj5TQ/iWWAeh3wbypx50HcMcGzQAjfKcY7zLioVGtMT4OnpykNUWE3mXGH9NNPgdJSj2qUYv5Y3zc9zRkmg0X4iAMrNIGGs+8ytcjbxnvYxQGCliWUO6XjOL/3F+Kj30TtVR31poT7zH+AwiDkpyBBycMQB9T/lOEfhVupskQaCtTJ5Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA1PR01MB0938.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Wed, 9 Feb
 2022 18:02:35 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 18:02:35 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
CC:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwA=
Date:   Wed, 9 Feb 2022 18:02:34 +0000
Message-ID: <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
In-Reply-To: <20220209164957.GB12763@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [OScqbh1LnW6HxDEfsuzQ5P+wdrWvksSthJ6UAgNvEeJ8dNAiCf7nnmtv8a0KstNA]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa1ac157-e9fc-4e60-ad9a-08d9ebf659d8
x-ms-traffictypediagnostic: MA1PR01MB0938:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8F6teMvroAvfV4BqyBujYZyAscEK+BtqoO9k/OPCYru0cRFZMWvqQ5EPZ8S/1rdKkWnMSUvPrueXPJvKob/jlT1+YSaj5aL3amGXmWzqpNYNnEuI8WrOwOifVCj2hYzdojn50CDsqKEDZH0WiKTMJaeuxhDijX8jputKoA9jeQatoQSc1lFoJaaYFj0v75TDH7rsCFPte8zbvmf02FAoq1mMBEYpjkF6GY9csAy19OBIZWKHx2dDKymuqB6QCEghZb28pyVaPjeFLqgtavh/Qtu+LlAQ03M9W5gXDezuozbOG1hQpVJ5N5vy88L+V1Wp9vtLu+im2ZFeIKdwOHD12HL6+1dw4GXCV1svplgYoGis27RkRxvQ7jOsNj2j3Ppr0d0FQ+URWliBMEXAoRjVToZeGh+UEgkkWWAL93bN4sOnOh1Yj1yVlExDdsDg5OIBuqXqyMucONh2rabdwx7mjeufMRQ2TSZfqxERYka/p3IFr6Fy8LaJigb5aV/aogxCzwDgpjc5MoIPSHboEwIZAtfH35gc9EZ36F+yKwMfiH8HGp06hYzj0W0PD0GKTCueSPiIqX0Dk0B/iX6+hWepg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGUwWXZLKzRZbml4ZGNKRFU4ZDhuNDBoRStNRWhZZEpWd0VsOC9PajRBUmRk?=
 =?utf-8?B?VmxDV25VaWNzblVKS3kyWjBkRzV1eWFDR1NueXRuc2ZrcVhKM0U4N0lwZEdC?=
 =?utf-8?B?dE56Tit6TXJnL2dhL0R6bndoT1Rqc3VRVzc1TFVobGZqdyt6dVJITTYxZUJV?=
 =?utf-8?B?dnlKMVd1ZWtycCt3SEluZEhHVTQ5YVNRRVpBZytoRHZoSUQ3WXQ0aGZBcGE3?=
 =?utf-8?B?MlJWY0VaNk1GanpDTXpNaWNVYUw5UzZTSHBtd05JVFJ0K0FiNHpPVEFGSTVx?=
 =?utf-8?B?WklqdFlxcWxTdEpTa01oTEJ0UnBHQyttc2Zza1dZSFZsWDcwcWFJV1dQRkRN?=
 =?utf-8?B?TU5odnN0VmtGMnNYZml4NWVMbDdDbVM5R3g1VlRvR1BSRW9NRzRuOG1tZ0Uy?=
 =?utf-8?B?Tkg2V3ZiUGtMMzBzT2FmSHpXWWFMOWN3emdMUWp3T3ZDNHl1UngwT1RKdzFQ?=
 =?utf-8?B?UUcxR014RzJIQ3g3dVFITkNob1Vkb200dE5xTzZNN0h3dzZsZ3BONDR4bU84?=
 =?utf-8?B?T2J4RVpGeXQ0VXJsOVY5K0JJaWZ4ZG1zWUQwdDBLdjZmeFRmNmJMS2lVQy9v?=
 =?utf-8?B?MW1ZK1JaNmd4Yk1jV1Q3M1ZDN3Bua05sQlJQaUhseWZ0MlRmZ21JbzFrc3Ur?=
 =?utf-8?B?bnVRcEdEbDJKRGJqUlhTbDFUNGJpYVpFa2xGZ3gzYzJUTnlZRnNSL0NJRENi?=
 =?utf-8?B?OThhNmdyYzJqYVRleUZOWlA2UjM3QmpNUytTTmhUcFVkZVR0aHFpMWdpWFpL?=
 =?utf-8?B?UldwUVdtRFB3dVNxWkJzcFkyTnFxMjNYZHB3MkJhMml6dlN0cTRVcFlHbXI3?=
 =?utf-8?B?a0tVS2g4bk5GNFNQTHpHUTdYNWtiVXZpSkdNRjZORFIxdk4yNkIvQnJrVVJa?=
 =?utf-8?B?L1JFRzNZSlNGeVlBdjFIOElTTkpENFFMcUF4TlNnR0N4NWIwVHJCc3RESktl?=
 =?utf-8?B?NFlHNm9rVUQyR3pOUVV0cVM3bUhkNmpqZjBERlJZMFIwSHFZREI5clhKa3Zs?=
 =?utf-8?B?M1ZNTTRkWkF3cEpPS2lqVWUxOHhUOFVTNGVxVkZvRFRVRGF6U015eXRRR1h0?=
 =?utf-8?B?K2tiS2JXc2RJakpQWU9NcmJSMnNtWW9pcHh2RjNSdnU2VGxtajF0aFNzTUJk?=
 =?utf-8?B?Yk1tWThkelZVVUJab1VyeGs3SUFGcU16WEVhYkwzOGFNZit0bEFGaEhPaGxB?=
 =?utf-8?B?YUVSaml5eDdqOXFmU2pCMHZXU3hWWjFxSGFKeEs5ZlFlWnc1RHBEQzllYXp5?=
 =?utf-8?B?THRyb2xQdmpUWVJ0VDY4V1pvaWRjTDdwemJscWRDbSsrTm5BN0N6cnAyRzFk?=
 =?utf-8?B?Y0ZOT3pWbVZkRmVIaUVxYzVqdUdpZTNZdE0zVVdwYnZkRUZSZkNkcFRSNU13?=
 =?utf-8?B?UjVrY2MrUmY2dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDB63009120527439A45D62FE3572368@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1ac157-e9fc-4e60-ad9a-08d9ebf659d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:02:34.8522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB0938
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gMDktRmViLTIwMjIsIGF0IDEwOjE5IFBNLCBNYXR0aGV3IEdhcnJldHQgPG1qZzU5
QHNyY2YudWNhbS5vcmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBGZWIgMDksIDIwMjIgYXQgMDI6
Mjc6NTFQTSArMDAwMCwgQWRpdHlhIEdhcmcgd3JvdGU6DQo+PiBGcm9tOiBBZGl0eWEgR2FyZyA8
Z2FyZ2FkaXR5YTA4QGxpdmUuY29tPg0KPj4gDQo+PiBPbiBUMiBNYWNzLCB0aGUgc2VjdXJlIGJv
b3QgaXMgaGFuZGxlZCBieSB0aGUgVDIgQ2hpcC4gSWYgZW5hYmxlZCwgb25seQ0KPj4gbWFjT1Mg
YW5kIFdpbmRvd3MgYXJlIGFsbG93ZWQgdG8gYm9vdCBvbiB0aGVzZSBtYWNoaW5lcy4gVGh1cyB3
ZSBuZWVkIHRvDQo+PiBkaXNhYmxlIHNlY3VyZSBib290IGZvciBMaW51eC4gSWYgd2UgYm9vdCBp
bnRvIExpbnV4IGFmdGVyIGRpc2FibGluZw0KPj4gc2VjdXJlIGJvb3QsIGlmIENPTkZJR19MT0FE
X1VFRklfS0VZUyBpcyBlbmFibGVkLCBFRkkgUnVudGltZSBzZXJ2aWNlcw0KPj4gZmFpbCB0byBz
dGFydCwgd2l0aCB0aGUgZm9sbG93aW5nIGxvZ3MgaW4gZG1lc2cNCj4gDQo+IFdoaWNoIHNwZWNp
ZmljIHZhcmlhYmxlIHJlcXVlc3QgaXMgdHJpZ2dlcmluZyB0aGUgZmFpbHVyZT8gRG8gYW55IA0K
PiBydW50aW1lIHZhcmlhYmxlIGFjY2Vzc2VzIHdvcmsgb24gdGhlc2UgbWFjaGluZXM/DQpDb21t
aXQgZjUzOTBjZDBiNDNjMmU1NGM3Y2Y1NTA2YzdkYTRhMzdjNWNlZjc0NiBpbiBMaW51c+KAmSB0
cmVlIHdhcyBhbHNvIGFkZGVkIHRvIGZvcmNlIEVGSSB2MS4xIG9uIHRoZXNlIG1hY2hpbmVzLCBz
aW5jZSB2Mi40LCByZXBvcnRlZCBieSB0aGVtIHdhcyBjYXVzaW5nIGtlcm5lbCBwYW5pY3MuDQoN
ClNvLCBFRkkgMS4xIHdpdGhvdXQgaW1wb3J0IGNlcnRpZmljYXRlcyBzZWVtcyB0byB3b3JrIGFu
ZCBoYXZlIGJlZW4gYWJsZSB0byBtb2RpZnkgdGhlIHZhcmlhYmxlcywgdGh1cyB0aGUgcmVtYWlu
aW5nIEVGSSB2YXJpYWJsZSBhY2Nlc3NlcyBzZWVtIHRvIHdvcmsu
