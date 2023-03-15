Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20526BB209
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjCOMcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjCOMb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:59 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2083.outbound.protection.outlook.com [40.107.9.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED159E7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwx4ER7KJPlQfgxhyJ0NNdeebfNmt4l+TJy1B3dr8Zv57spSIRCWk1r3TefLBcpguOjzhc9FFM/I1T8hf1rCLb4sH2theAR+zCbrnhjKqOpG+KaurMb39ayiyLqHP3Ubu9bJszybupWOPH6gw5//Z9K4IJj9z/g3d5qgHBpCeXVcODQrxZ3oPvulG/EnUUT+3an1VN/n6CdN5UOkwsipgxL+L2EIQGeYI3cCSCZWVBpCoIurv0V12GoYkqG1nrUEoqjVXgaFdm+M+iPbuENF14YRg8Erg4zC+P9wukWliiG0FWuBbzWdeoVysjSGP5gaDZXBQ8qn7JZUC1g3cJITCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXk0kR4CGlIkDcH4RV5S9aKhEAMxWKzupTbgGDpLkf8=;
 b=dl08QaUtZiTwv7mGk7uiNcte8iGH1+sm+UJHziPSVtlHGuhfOObdEqprOJXYmf1RJ/x2HwwGIy0Z67RxH0LNvwCIFB8UX6gddr+zUYokXoB8Ji+LoJS4HytJ/lVurwrwNzPFOak+tojH4o31VwRv5H1C52yyNZA90Dxuw/cIN2XDVSrsgfGOoNX2uBiFuc/Mp2LFxqYU++JIeC/n804lteAFfDoFqr8qTGSDjPfOMXxVfDCI8d8o3iJ5eCFxjMWWZ5GfM6pf7QYn/7OgIKlrU++m+NtBHmP5wj/5G6W1hTNfs6UvXLH/SThCZt7Cj7N4/JZE24DHT4G6pgby+Ec60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXk0kR4CGlIkDcH4RV5S9aKhEAMxWKzupTbgGDpLkf8=;
 b=kjVsB4LdIkH8j2Ki4CQqrS71F4FKycqov/5ryirf0XPId1Tf8JGM9wPR8wb4EuzDqDDXg9p/3ZYTXb9YA7NdxHKKxIKqhZw6w/FUP2h6X4qB7mdQV+tfESix+4XYxvps93YPJV5hrfxKsy17lC4r3KH3V5FD1QBFPOHvOWY5YWVerSENOrKxZUMf5x85mue6E+7+sNA6xyMcKzWN5G4IFzn8aTaLCb/aWYTvFFmpxtGv6tnhh9glUuGHIt+343dm9j+L/Ea/XVjhB5HXHJXE488K+MtKTRissZ0wc8yrxA82vG+nI3fdoZD/ptnjyAZZPWGbTA+vxtjBr41A/WBOfg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB3417.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:180::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 12:31:13 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:31:13 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 52/68] powerpc: Check !irq instead of irq == NO_IRQ
 and remove NO_IRQ
Thread-Topic: [PATCH 5.4 52/68] powerpc: Check !irq instead of irq == NO_IRQ
 and remove NO_IRQ
Thread-Index: AQHZVzhUsllmIM66d0W9kTFIyL5o8K77xZ6A
Date:   Wed, 15 Mar 2023 12:31:13 +0000
Message-ID: <c490a4b5-2061-3a36-bc7f-7d859c55f4ac@csgroup.eu>
References: <20230315115726.103942885@linuxfoundation.org>
 <20230315115728.140743203@linuxfoundation.org>
In-Reply-To: <20230315115728.140743203@linuxfoundation.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR1P264MB3417:EE_
x-ms-office365-filtering-correlation-id: d12c549c-48b4-4837-d290-08db25512a53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uFI5CMFqgP8t3rVwSda88GR54KQQr/oBJKQ7i6njv/yWJKsKFcSOHBC6uTVLVvKaulsKk+C5uLcTrgUpXFa/dm+0pvW5Xh/QHjHwQUksk7z61G0vXGcWUiVZ9u0fvB5TvTh71NKOO+evJ4P97wbpLUvnJ9bor0IX/5eejw/UqPtxDF8Mqjup4mMI/vausmBUFFR2IwTa3TGQ8uzyz7dNFudjYtOxrJpU4GtDTP/HnF+RW2f3Lvremadep+IoXTazApShjcj+9TZkFK0ebhbsuxFAFJ2TfeHm42BuZB+g+w/JN/OVErwyrxsEN6J5azFIAm29dBPfbrS4SRpmQZ/gmKbS3DMn/uZO5Daihib8yngAkokvyC6ltNqv8Ni0nYtMliqRND7QCLlFKAmG1i23t10SnsWxPXD3jjkh7KakJ5VLMoRnRtMKfGmJ/+P9ITIncW/LCqqNN/wnBwDVjOT/277ZEh1qDwUtPKSgNIgShTmuX7OwVFiJKwlOdreXz2Z6nF6MuHMZWb3rYcLbpngnEyIZ6mXYRTgbOBxPgEcLNGd/zn+t1zvWOP1UHX9eTxJ3MHpjtvdmjGyb0vWgR+PsYCsEtajhDv8n5R23QQMga/l2r+M4TfBD83jslEdw5xkOJsbZkgXjCxgDsjGe7VyegrS0iiRIsWXRtPCtli5yC8yOX3TxPG35Ln4oOUj56EbzOeWkI0RoVqURij18uplTPptQE6PMA/R1vMdt1OD+GlZjJAvxGV+yybZQVeAU4ebXTqjgGInc3ZC/+uAgWfoWAMaGGXiGDsBChhqx891UrWs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39850400004)(346002)(366004)(451199018)(91956017)(122000001)(66446008)(66476007)(66946007)(76116006)(66556008)(31686004)(4326008)(64756008)(38100700002)(41300700001)(110136005)(8936002)(38070700005)(316002)(54906003)(83380400001)(5660300002)(478600001)(71200400001)(8676002)(66574015)(31696002)(86362001)(6486002)(6512007)(2616005)(44832011)(186003)(36756003)(6506007)(26005)(2906002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFJCeHBsM2dra3lueG9sRFREaldaTDIybUF6TmxLUlJOVTd4bzZLU1FHYUZk?=
 =?utf-8?B?b0E4TjFOYTJUV2F1ZzVyNjF6b3VuZThlamVnNVVzb3ZjREMxVW5hYTdHK3JN?=
 =?utf-8?B?RmdtcFFHZjhBNTNSMDNtYXNuMGVlaE9PZEw0RzU3NzNmK1NnTkhQdEJmWjgx?=
 =?utf-8?B?dEZNYlAxRDJrTitJbkJrZlNhajdycmloMy9LNXArSE9tUFBXbG9lL3gwemJQ?=
 =?utf-8?B?MUU3OHlTYlk2Vis0MDU4TncrSEpWRGpUcjhNVjBvQnVodTIvM3RCc24zbHpw?=
 =?utf-8?B?VXppWWNlMFJmclR6dzVId1h2cUhnUGpkTlhpdWxLckJCaGEzbnVhOHhJVSs4?=
 =?utf-8?B?QmE5T09DTFRMY28rUXlWUlNmNXdXenFwMUp3RVd1YUVJek1rTEdKbnRMTkt4?=
 =?utf-8?B?dHhhN0lnY3dqWHJNWXViWDY1ZnV0TG1LaUZONVE5ZDJUQ1plUys1YW1ocmRw?=
 =?utf-8?B?cTF3MjlIS2NoRmtFVlhkV1Rwc1lEbk1TcXRxU3dBcENScWFFUmxnS2VObzhJ?=
 =?utf-8?B?OUNPNjZtTS9HdUNXS2wxOTBMUjMzeXA1b0N1R2tLTlQzQllsWEt4dklUc1NW?=
 =?utf-8?B?RENnckIxRUtjdW1UV3kzbVpaNnhneHdzanQ5d01sc2ZmQWtpdVdqUWdicXY3?=
 =?utf-8?B?Y0hxbFBIZUZEN0xRNHZDYzJDNDdMRVNQWGJBU1RLa3ZvTC9JUERqWlA1TXFU?=
 =?utf-8?B?cVJYVTd3b3MvVjc1S2lUY3VOTWZCNFBiRFNWNXliZlZ1dFRyamFETHQ1MFFH?=
 =?utf-8?B?MjlENVpCRko0Q2tqNXVZUmpON3A0SDdBbjRORTd5ZEp6S2RoWElndWcxNVNQ?=
 =?utf-8?B?a1dqMnVlU0lYOXBtbnJtWWEvTGQzTTBNaDBxZEtRS0pKU0pYdExNcDlsTFd2?=
 =?utf-8?B?cjNMYzV4ZVFuSVpEMlo0M25HVDdUdGgzNkpPRnkzSWM1VEFIWGxBRTU1eVRp?=
 =?utf-8?B?ZlRvelBwNE9JaFF1eHJDS3Mvd0o3bTB6ZXNGYkhPOVBhMzZNZmRrNEFleWk2?=
 =?utf-8?B?Zi9zMlQ5S2Y4R3BpVjhsQkJhWDdaRjZXQk1kS25HVTl6bEpmZVR5YmhkQUV0?=
 =?utf-8?B?Ull0WEVPZ0NoTHNZekpoYytoWlBmMWg1a3l1LzdBaVdhTWpSNlZQTlV3MVZm?=
 =?utf-8?B?VmlqUkRaSi9hUFlPUG1yOTVrVWYxem5NczNxRTI0UmVsNGtTTEVjSnR6NVdt?=
 =?utf-8?B?N0MwUW8yaDlMT3QwN3R5aXo3eVRYNE1LazVxNXpXM0JGTElVemQ4cjQ0VmN5?=
 =?utf-8?B?RmdXSVNVNXdJZTZkMHJ4NjQyWkxxa0RydDMwSkxkQTZyaHZQZ3JNRGtyYXRa?=
 =?utf-8?B?UVVyZStmUXFmajdxQ293ZG1rbmd5U3gxV0hrYUZjekZmSFZucjg3WkpEdjJo?=
 =?utf-8?B?TExyblBNd1hVVUJqbENRdXkrQnpiTi9lemxUYVJyWlBwMEVQVld6d1pSWGJt?=
 =?utf-8?B?SkorbjBMR1pSQWgxc3lud1FTQXVHbHBHdTRQcS81L1V1dEVZRnpNNVZuY1VD?=
 =?utf-8?B?M2JqYW9OU1VqQW5LQmpQMTRWUHUydnh0QzF6RTh5eG1mc0Q4aWQ4bHRiU0p1?=
 =?utf-8?B?SXpxSC9UYnltOTRacUFkSzBZOGd3Mk5RTVZZNjhwZWUrSmJzSG1DdEEyaTdj?=
 =?utf-8?B?UzJUencvZnJWZ2lCbWMvNUVTMXp5ODNFeDVMeW5XaDA3cDFqVzRDZVV6WVpB?=
 =?utf-8?B?ajVROTVqWkNHY1duYnhvOG9Ic1YxY05SNFRycEVDRml6dVgrN0ViMlg3OVRi?=
 =?utf-8?B?aGF2SmZyQWxZQ1JYNnA5Wit6QWNUVEF4czVsNmdYZ21FWG5iUDU5Mm53ZlFP?=
 =?utf-8?B?TE9qbUh5b2NjbTdBYktzT0RubklHZ1NHNW1QRks0OHlHSUtlQkw5ZFU1dy80?=
 =?utf-8?B?QndTV3RuNk1tS1NkK2lKVnRsTTV2dGY2NVA2a1RuUS92RVJVUUtza0tBMXFX?=
 =?utf-8?B?dTZqV2tGaHEyT3JZVi9lYzBkbHV5cHFIN0dYQlZQSFE4Y1JodUJ2czJodStB?=
 =?utf-8?B?SFlYVmxPR2xmdk04aWROOFl3Zk1WZXRHb1p2Uk5kTVA3c2FoL2sySjRjYTNO?=
 =?utf-8?B?TU85QXd6eWVva3FpQlYyQmsrUnVHclNyR1ZacXhsUUg1Y0ZpNzUycE5XMFMw?=
 =?utf-8?B?S0kraEJMKy9RMlB1UG1BeUUyQmwvTFE3WHFDZ1hNMWpvMkZyb0FVbUJPcHpu?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6B11307B5F5A643AC87EFD66DE17068@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d12c549c-48b4-4837-d290-08db25512a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 12:31:13.5616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mu/JzkqfqUMTq1gtfN/jC9rfZzDLP7sE8gjPhI73QdPGTmJwRh+vB0YaTkbizqbTVOocl8FTcK2aIpPrEAOwrbVDBezK958A2d5+/qKHp7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3417
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDE1LzAzLzIwMjMgw6AgMTM6MTIsIEdyZWcgS3JvYWgtSGFydG1hbiBhIMOpY3JpdMKg
Og0KPiBGcm9tOiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+
DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1pdCBiYWI1Mzc4MDVhMTBiZGJmNTViMzEzMjRiYTRhOTU5
OWUwNjUxZTVlIF0NCj4gDQo+IE5PX0lSUSBpcyBhIHJlbGljIGZyb20gdGhlIG9sZCBkYXlzLiBJ
dCBpcyBub3QgdXNlZCBhbnltb3JlIGluIGNvcmUNCj4gZnVuY3Rpb25zLiBCeSB0aGUgd2F5LCBm
dW5jdGlvbiBpcnFfb2ZfcGFyc2VfYW5kX21hcCgpIHJldHVybnMgdmFsdWUgMA0KPiBvbiBlcnJv
ci4NCj4gDQo+IEluIHNvbWUgZHJpdmVycywgTk9fSVJRIGlzIGVycm9uZW91c2x5IHVzZWQgdG8g
Y2hlY2sgdGhlIHJldHVybiBvZg0KPiBpcnFfb2ZfcGFyc2VfYW5kX21hcCgpLg0KPiANCj4gSXQg
aXMgbm90IGEgcmVhbCBidWcgdG9kYXkgYmVjYXVzZSB0aGUgb25seSBhcmNoaXRlY3R1cmVzIHVz
aW5nIHRoZQ0KPiBkcml2ZXJzIGJlaW5nIGZpeGVkIGJ5IHRoaXMgcGF0Y2ggZGVmaW5lIE5PX0lS
USBhcyAwLCBidXQgdGhlcmUgYXJlDQo+IGFyY2hpdGVjdHVyZXMgd2hpY2ggZGVmaW5lIE5PX0lS
USBhcyAtMS4gSWYgb25lIGRheSB0aG9zZQ0KPiBhcmNoaXRlY3R1cmVzIHN0YXJ0IHVzaW5nIHRo
ZSBub24gZml4ZWQgZHJpdmVycywgdGhlcmUgd2lsbCBiZSBhDQo+IHByb2JsZW0uDQo+IA0KPiBM
b25nIHRpbWUgYWdvIExpbnVzIGFkdm9jYXRlZCBmb3Igbm90IHVzaW5nIE5PX0lSUSwgc2VlDQo+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9QaW5lLkxOWC40LjY0LjA1MTEyMTExNTAwNDAu
MTM5NTlAZzUub3NkbC5vcmcNCj4gDQo+IEhlIHJlLWl0ZXJhdGVkIHRoZSBzYW1lIHZpZXcgcmVj
ZW50bHkgaW4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL0NBSGstPXdnMlBrYjlrYmZi
c3RiQjkxQUpBMlNGNmN5U2JzZ0hHLWlRTXE1NmozVlRjQUBtYWlsLmdtYWlsLmNvbQ0KPiANCj4g
U28gdGVzdCAhaXJxIGluc3RlYWQgb2YgdGVzaW5nIGlycSA9PSBOT19JUlEuDQo+IA0KPiBBbGwg
b3RoZXIgdXNhZ2Ugb2YgTk9fSVJRIGZvciBwb3dlcnBjIHdlcmUgcmVtb3ZlZCBpbiBwcmV2aW91
cyBjeWNsZXMgc28NCj4gdGhlIHRpbWUgaGFzIGNvbWUgdG8gcmVtb3ZlIE5PX0lSUSBjb21wbGV0
ZWx5IGZvciBwb3dlcnBjLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBMZXJveSA8
Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIEVs
bGVybWFuIDxtcGVAZWxsZXJtYW4uaWQuYXU+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvNGI4ZDRmOTYxNDBhZjAxZGVjM2EzMzMwOTI0ZGRhOGIyNDUxYzMxNi4xNjc0NDc2Nzk4
LmdpdC5jaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXUNCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEg
TGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KDQpZb3UgY2FuJ3QgcmVtb3ZlIE5PX0lSUSBtYWNy
byB3aXRob3V0IGZpcnN0IGFsbCBwcmVwYXJhdGlvbiBwYXRjaGVzIA0KbWVyZ2VkIGR1cmluZyB0
aGUgNi4yIGN5Y2xlLg0KDQpDaHJpc3RvcGhlDQoNCg0KPiAtLS0NCj4gICBhcmNoL3Bvd2VycGMv
aW5jbHVkZS9hc20vaXJxLmggICAgfCAzIC0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMv
NDR4L2ZzcDIuYyB8IDIgKy0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2Fz
bS9pcnEuaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9pcnEuaA0KPiBpbmRleCA4MTRkZmFi
N2UzOTJlLi5mMmY5NTJjYTg3YzM3IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVk
ZS9hc20vaXJxLmgNCj4gKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2lycS5oDQo+IEBA
IC0xNyw5ICsxNyw2IEBADQo+ICAgDQo+ICAgZXh0ZXJuIGF0b21pY190IHBwY19uX2xvc3RfaW50
ZXJydXB0czsNCj4gICANCj4gLS8qIFRoaXMgbnVtYmVyIGlzIHVzZWQgd2hlbiBubyBpbnRlcnJ1
cHQgaGFzIGJlZW4gYXNzaWduZWQgKi8NCj4gLSNkZWZpbmUgTk9fSVJRCQkJKDApDQo+IC0NCj4g
ICAvKiBUb3RhbCBudW1iZXIgb2YgdmlycSBpbiB0aGUgcGxhdGZvcm0gKi8NCj4gICAjZGVmaW5l
IE5SX0lSUVMJCUNPTkZJR19OUl9JUlFTDQo+ICAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL3Bvd2Vy
cGMvcGxhdGZvcm1zLzQ0eC9mc3AyLmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzQ0eC9mc3Ay
LmMNCj4gaW5kZXggODIzMzk3YzgwMmRlZi4uZjhiYmUwNWQ5ZWYyOSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy80NHgvZnNwMi5jDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9w
bGF0Zm9ybXMvNDR4L2ZzcDIuYw0KPiBAQCAtMjA1LDcgKzIwNSw3IEBAIHN0YXRpYyB2b2lkIG5v
ZGVfaXJxX3JlcXVlc3QoY29uc3QgY2hhciAqY29tcGF0LCBpcnFfaGFuZGxlcl90IGVycmlycV9o
YW5kbGVyKQ0KPiAgIA0KPiAgIAlmb3JfZWFjaF9jb21wYXRpYmxlX25vZGUobnAsIE5VTEwsIGNv
bXBhdCkgew0KPiAgIAkJaXJxID0gaXJxX29mX3BhcnNlX2FuZF9tYXAobnAsIDApOw0KPiAtCQlp
ZiAoaXJxID09IE5PX0lSUSkgew0KPiArCQlpZiAoIWlycSkgew0KPiAgIAkJCXByX2VycigiZGV2
aWNlIHRyZWUgbm9kZSAlcE9GbiBpcyBtaXNzaW5nIGEgaW50ZXJydXB0IiwNCj4gICAJCQkgICAg
ICBucCk7DQo+ICAgCQkJb2Zfbm9kZV9wdXQobnApOw0K
