Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828D06430E3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiLES5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbiLES5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:57:00 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2047.outbound.protection.outlook.com [40.107.9.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00212037A;
        Mon,  5 Dec 2022 10:56:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wohkoc+Usk9TjrPjv8R9ZmngjzX/Jpmv3AePoBaTQE4eS6/m0E4/ZCbZEhOGOC1eyeutjO/Z1UzENRGUfxbE3QmIuQsmaNK/7MCO0/gDTZskP2dw2puOeHV+pcuoAaKeGhSzev/ALXc3ts/MNqElp2vCzymDVk9AioW7eMiEEdNmEI73sMTmZhoIkqvKdXr7+LuYkaNYy7wzOjfG53nGFM1HyFgaRv+B7DYaPqdLdt1IdBRIvT3ILzTJHHba8bZcVpVKOE4WpmUPAPs3u5OGcTm/UVJhMyH8Bql/Hdjqnl4dy+85ByIir/ZxqpA9ck301PnoPmzAViLfgQ8PEfQjDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbYsjuOiJMunIkwcj1GTI5unojEAwNDegFgatVJzxhI=;
 b=V2Bsxv3+1YMZy7io1/OJMvTVE3w3tGFGdBOVOrk4K3QTTISrMGifQa9nEx6Qp5NNQGz5KzS+B6JsEVEtiPMB1TVY75mmG2o/8XWGhkqQqmtne8tDydb+7hpTzp73pjVXuezgDmKMQPaiHS5431iXe6OXHqHgCN78t/UaujV+bf+RHeAqRX4vR3IS+wo/D9VTUUcHXHUwK/wQR2xwzpafoBNZWNuTs99PQtKJ9UWeRlxEPRjaodEpnxjcPAehYmhmg4hWp2yGoB3pS4rfy311h96TsC1mvr7RkKkJFQcmZSBuVz989PTL+ZFI0gnJJ6fd8MuZjsh4d4mBpX0lGON34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbYsjuOiJMunIkwcj1GTI5unojEAwNDegFgatVJzxhI=;
 b=WNnavh3GXDcw/g941SBKGIKcPjqF+KTMYpn5yyGISmC3Jbg79OdARtIRysLoIwsSGhYX+sKUjjgEJ8wUq9/5ToZzK2Be5ZptD8+/ZH2i+oN/H2hNlZKnJDnZ87sScpmNK439yrdx/qCnVGw/YkIKJwqXlmep/rrAfIR5r3ViUHlJ48QOv+jAQGQJFSskpQmbt2NJwMDq9LI9of1bjnXaOO6R05kTyVFhucjp/r+DmP+n8k4SfaNDyIKDyEWNkUiMCsMgkBWEwf+5UN1N9b8UWRvTB4sDVcbmN1W4MIDVEjoq9CQ1iQU8TlBquLaxakFva0DtBZn9dts3u/CvNj4X3A==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB2972.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 18:56:52 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 18:56:52 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Michael Jeanson <mjeanson@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Topic: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Index: AQHZBaANAqqRYC4fWEmzGmz7Z31vrK5ey1WAgADVqwCAAApsAA==
Date:   Mon, 5 Dec 2022 18:56:52 +0000
Message-ID: <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
In-Reply-To: <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MRZP264MB2972:EE_
x-ms-office365-filtering-correlation-id: fbaf0d1e-336a-4b11-6b6f-08dad6f278bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bbo4PO6isrFkbi+U0ckDjRmr8t0O3Ib9wElwsORsjS/o+CPsFX/A7mfvkk4w6zJuAycOXtoy00q4gsFw7d6z2CGFjHrH+H88djnM3+T4TnkWrZcPslk899HyU8PsCvged5VHmJmzIUT7TY4EUwM6MSqVpUxf4qvKxSdM7HaP5IYCe/is+1nFvLZGRcLxAZf+rSZHXSdxniz1BrPpY4V2woAaw8j6R09KODvHVd0FhlrXmknj3pipdf19P4Aqa8sH7+GF1sDnFeBdnpQN3Eqc2WCdqaO/Fg3wR4w1n4qIAnPgnr8drynR+FLVk7x2tW7z60GYaiG2jIgHduupZYBcSjMHzUvloV85l0RrTpHsgSFu9/Wngs801EY4tWjjMUv7GPfHT6laVe5Nq0dk7ppk+92Qv62Ogxb/iom/j2DVsFJSqVZRnSdzDJ78fKDh+NDbhqeOh/dsYs6N6lAlPKA6t9S+x9NHZZwawNkJaWjNkZr7nShN4yl+dlAzQTwGRF6/pt9wQaE0T2V6SOjsXMuLkn9oma/yFY6gRqMd7YAAeYpj1+atgcVGytEyNm69WHEfOrZD5myTvGX8+VTkuJ9OwslViIzsvvd40c/IafY6a1lvGvwqnM+wlhTtGma+g5d7xk+gelrrtSGkF43Fb/SB7TfdFXUQrhoyKhWQYyMYv3gIgnJDvEOBCILUmh3pA6LzYJmw852tLKptKmlq3CWBPNzOhTHuJ4JOOOOujju0DAaOFzKm2FoFkZGI2cYLXGLKFnh06PGmUFk308W1IW4wBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(36756003)(31686004)(86362001)(31696002)(4326008)(66446008)(76116006)(66946007)(8936002)(2906002)(66476007)(8676002)(91956017)(66556008)(41300700001)(38070700005)(44832011)(64756008)(7416002)(122000001)(38100700002)(83380400001)(6486002)(478600001)(2616005)(316002)(110136005)(54906003)(966005)(5660300002)(186003)(71200400001)(66574015)(26005)(53546011)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MThzUlU2bHhJc1RWQ0UxNDZGV2JCTjNQQ0NNL3I3cW5DTUtuRGpwR0lFTEJO?=
 =?utf-8?B?d0VqZVdVaS9hUG10VkxMemRsZ05CQUFUc2hHOGVyaUltQzQxS1NFWGhWWlUz?=
 =?utf-8?B?T3FhM1daRGVNVllCclEwTWhtcnVDc3B0bVR3a0oxeVIxU2hEMTdSelA0V1ZV?=
 =?utf-8?B?ZXlhcHQrU2tnbTZCZDQ4SkJoNi9IN2drNXZHWWRHbUZpaEhIT1RPb3Bwbkh5?=
 =?utf-8?B?dVNteG5mV2pHdnMyTWxyM2R5OWkyaGdybmI4Z3ozMTB2YkpXekVWcjhRVzd0?=
 =?utf-8?B?THBtaHdzV2IrY3RlNm84enFEVVR1VkxMUUJoMnIwVTBzWU9pZ3VTRGp2Y3dh?=
 =?utf-8?B?VTRQSkswcXhYSVh3UWJYaWQ3VTY1NkJqeEZ6N3VYcDRNTTMyUEcvbEZxM2ZE?=
 =?utf-8?B?TlZxYVBxU1VyQUZhem5EVy9USHV0aWMyU3VFb2dLQUZROWhwQk9KYVRKVWRV?=
 =?utf-8?B?bWNzQ0dxa0ZlSmdjOXlDZjhOVllDd2FVc1g3ZHhTMW9Tc0NxUWRrbE9zV3J5?=
 =?utf-8?B?WFR3b3RkZTFzRCtHdzlsNmVra3I1RlFYZnpHdG5EWWZVMG5SOXVUWkVvWnpr?=
 =?utf-8?B?K2xRaEIzRW5ZR1dRNVZzem56RlY2WHZ0S1lZRmFSMGVSek5Tc2tGaFdqcWsx?=
 =?utf-8?B?ajUzOE1URm5COWJ6ajVzRWhOTElvZ0lESHZNNzMyRFNzaGFVR3cwRHNvZWxn?=
 =?utf-8?B?aFZZelNrM0lWTXd0SmtyR2Q5WUlGTUpWaEtaSXc3TUdBWm5ZUFE2OGU4UXlP?=
 =?utf-8?B?RWJaTEVuc3hkblgyaFk4YmhicFJYMHJHTlBmY3A1Q05SeThqWUZSakJKN0tO?=
 =?utf-8?B?UlB5V1VQU1pQeUFHTisvdW9zT2d5Y0U0ODlFdDNNczhYeHYvRGdBV0lzYXBC?=
 =?utf-8?B?eFNMQW9HKy9GbDZDUXl3NjMvVlBZOGxXT0psQ3dmeFdsTDdNellzc2Q5dHFz?=
 =?utf-8?B?a0FZL3cxSEE5ZnQ2ajFHWFhBMFQ1Wm5ZSHdTMEVHLzJjdUtJNEt4SG1scnlX?=
 =?utf-8?B?Zm5vYTV5WVlHL1FhVzBBVUtUSEI4cml3cG9FdWxheTY0YXFka0UxeVVLZGNV?=
 =?utf-8?B?VGhQYW85cmNybWNwbWVDTEU0ME9nT0luQVNUV01VdW1VWEk0azdXR3R1aFlu?=
 =?utf-8?B?ZGVRTmRpUkZTVWN6WjRpanlxS2V6VHlpWXB6U2UyTWcyNEFJUk9STzJiQkVB?=
 =?utf-8?B?OW1KSFFLWmlKNUpJbHJGVDRPMmFOaG5FKzczTGdZQ0tYaFVDempGaE5XSHQy?=
 =?utf-8?B?YVBhZUNSbHV4VVlVNDA3MmVzT2E5bzNUc204MHk4bFV4SlYxK3BuYnFudjQ3?=
 =?utf-8?B?TWl1R0lnQVQwakxYVWRzKzB3bG1yUFZjcXZrSFU2TUhuM0pIbHhHQTNxeEx4?=
 =?utf-8?B?NmJqZzhrQ2UvM2tHSzBlZGI2MTA3eTA3cSt0cUxoS1lGckVNK0FDZlh2cTNs?=
 =?utf-8?B?SFZJa25xZHZ1SzZsZDFhNS96VkN3cFRoWVUxNEdiNnVVRFo4eU5pcjZ1UkJZ?=
 =?utf-8?B?aFBBWmsxMUtpVnpZOHRBajRaV1d3ek1Nd2hkYUs0Q0dJbENEVHA0blJlcGkr?=
 =?utf-8?B?QzZibm1QOFpsR1dySXp3RHRJRldnUUNZb2M3d0M1L293bTBobkdoQlUyd3ZV?=
 =?utf-8?B?WThTQjZYYnI5bTQxUFFqYXRTNHdzVGhvQ1hGRUs4c0trZzdVempDVHV3LzVS?=
 =?utf-8?B?MEpJd3dNRXA3YmYwaFFLV0EyMGEwWU9rUW8wUHIzZGJPY0ZhREdrSnRUeVll?=
 =?utf-8?B?b0NTNHdtNkpwU281Qy8xTmp6MmhERGt6NUdOMTlqNkdkTVpHRjZBOFNwZFhp?=
 =?utf-8?B?T1VldG9ma3g5WDNDNlZWQUtkdFJJMVl2ZHQ3NlFuT2k0Y1B3M1RsQTlHVk5L?=
 =?utf-8?B?NzBJZG9HellEc0lGb2I3V29ZZ2VtT0ZXQXQ3QUhHK2xpL0NUUm5mMXJRdklW?=
 =?utf-8?B?b2NOZlZYU29uM3I4dGoyOTEwTVVzRHZIazZPbkhvQnhaK1hvODBDK2N6N1dp?=
 =?utf-8?B?TVJuSlMwQzQ4Y1g0OGVpQWNVMVI4cUQ4Z1ZJRHJGSjNWeTBSbUc3MXl0dUgw?=
 =?utf-8?B?UTZGUjBJdk00REFSWjlneGc5bEpvb0wxNVJ2K1NRNkNhWDRyOE9id2FSdm1s?=
 =?utf-8?B?YWdiM3AyNUhaR0VWRUlWaGZMMU02YVVyWEZWaHhLV3NlZkJsLzVwaXAyVHpP?=
 =?utf-8?B?amc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3759ED1FB8B3DF44BD970FC5D2F3B91A@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fbaf0d1e-336a-4b11-6b6f-08dad6f278bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 18:56:52.2118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rM6gLyGCKQKGZ4wl+arYMvsRAln4sHGkv8ztYI9t9RbFmXOqX7gjTxBqetfBLySf+ABoWXZO8Oge9CzGiJTmwjgS4BOlZCObDKy9+of9oEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2972
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDA1LzEyLzIwMjIgw6AgMTk6MTksIE1pY2hhZWwgSmVhbnNvbiBhIMOpY3JpdMKgOg0K
PiBbVm91cyBuZSByZWNldmV6IHBhcyBzb3V2ZW50IGRlIGNvdXJyaWVycyBkZSBtamVhbnNvbkBl
ZmZpY2lvcy5jb20uIA0KPiBEw6ljb3V2cmV6IHBvdXJxdW9pIGNlY2kgZXN0IGltcG9ydGFudCDD
oCANCj4gaHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4g
DQo+IE9uIDIwMjItMTItMDUgMDA6MzQsIE1pY2hhZWwgRWxsZXJtYW4gd3JvdGU6DQo+PiBNaWNo
YWVsIEplYW5zb24gPG1qZWFuc29uQGVmZmljaW9zLmNvbT4gd3JpdGVzOg0KPj4+IEluIHY1Ljcg
dGhlIHBvd2VycGMgc3lzY2FsbCBlbnRyeS9leGl0IGxvZ2ljIHdhcyByZXdyaXR0ZW4gaW4gQywg
b24NCj4+PiBQUEM2NF9FTEZfQUJJX1YxIHRoaXMgcmVzdWx0ZWQgaW4gdGhlIHN5bWJvbHMgaW4g
dGhlIHN5c2NhbGwgdGFibGUNCj4+PiBjaGFuZ2luZyBmcm9tIHRoZWlyIGRvdCBwcmVmaXhlZCB2
YXJpYW50IHRvIHRoZSBub24tcHJlZml4ZWQgb25lcy4NCj4+Pg0KPj4+IFNpbmNlIGZ0cmFjZSBw
cmVmaXhlcyBhIGRvdCB0byB0aGUgc3lzY2FsbCBuYW1lcyB3aGVuIG1hdGNoaW5nIHRoZW0gdG8N
Cj4+PiBidWlsZCBpdHMgc3lzY2FsbCBldmVudCBsaXN0LCB0aGlzIHJlc3VsdGVkIGluIG5vIHN5
c2NhbGwgZXZlbnRzIGJlaW5nDQo+Pj4gYXZhaWxhYmxlLg0KPj4+DQo+Pj4gUmVtb3ZlIHRoZSBQ
UEM2NF9FTEZfQUJJX1YxIHNwZWNpZmljIHZlcnNpb24gb2YNCj4+PiBhcmNoX3N5c2NhbGxfbWF0
Y2hfc3ltX25hbWUgdG8gaGF2ZSB0aGUgc2FtZSBiZWhhdmlvciBhY3Jvc3MgYWxsIHBvd2VycGMN
Cj4+PiB2YXJpYW50cy4NCj4+DQo+PiBUaGlzIGRvZXNuJ3Qgc2VlbSB0byB3b3JrIGZvciBtZS4N
Cj4+DQo+PiBFdmVudCB3aXRoIGl0IGFwcGxpZWQgSSBzdGlsbCBkb24ndCBzZWUgYW55dGhpbmcg
aW4gDQo+PiAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2ZW50cy9zeXNjYWxscw0KPj4NCj4+
IERpZCB3ZSBicmVhayBpdCBpbiBzb21lIG90aGVyIHdheSByZWNlbnRseT8NCj4+DQo+PiBjaGVl
cnMNCj4gDQo+IEkndmUganVzdCB0cmllZCB0aGlzIGNoYW5nZSBvbiB0b3Agb2YgdjYuMS1yYzgg
aW4gcWVtdSB3aXRoIGEgYmFzZSANCj4gY29uZmlnIG9mDQo+ICdjb3JlbmV0MzJfc21wX2RlZmNv
bmZpZycgYW5kIHRoZXNlIG9wdGlvbnMgb24gdG9wOg0KPiANCj4gQ09ORklHX0ZUUkFDRT15DQo+
IENPTkZJR19GVFJBQ0VfU1lTQ0FMTFM9eQ0KPiANCj4gQW5kIEkgY2FuIHRyYWNlIHN5c2NhbGxz
IHdpdGggZnRyYWNlLg0KPiANCj4gV2hhdCBrZXJuZWwgdHJlZSBhbmQgY29uZmlnIGFyZSB5b3Ug
dXNpbmc/DQoNCklmIHlvdSBhcmUgdXNpbmcgYSBwcGMzMiBjb25maWcsIENPTkZJR19QUEM2NF9F
TEZfQUJJX1YxIHdvbid0IGJlIHNldCwgDQpzbyBpdCBkb2Vzbid0IG1hdHRlciB3aGV0aGVyIHRo
aXMgY2hhbmdlIGlzIHRoZXJlIG9yIG5vdC4NCg0KWW91IHNob3VsZCB0cnkgY29yZW5ldDY0X3Nt
cF9kZWZjb25maWcgaWYgeW91IHdhbnQgDQpDT05GSUdfUFBDNjRfRUxGX0FCSV9WMSB0byBiZSBz
ZXQuDQoNCllvdSBjYW4gYWxzbyB1c2UgcHBjNjRfZGVmY29uZmlnLCB0aGF0J3MgYSBkaWZmZXJl
bnQgcGxhdGZvcm0gYnV0IGl0IA0KYWxzbyBoYXMgQ09ORklHX1BQQzY0X0VMRl9BQklfVjEuDQoN
CkNocmlzdG9waGUNCg0KPiANCj4gVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhpcy4NCj4gDQo+
Pg0KPj4NCj4+PiBGaXhlczogNjhiMzQ1ODhlMjAyICgicG93ZXJwYy82NC9zeWNhbGw6IEltcGxl
bWVudCBzeXNjYWxsIGVudHJ5L2V4aXQgDQo+Pj4gbG9naWMgaW4gQyIpDQo+Pj4gQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NS43Kw0KPj4+IENjOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVk
dEBnb29kbWlzLm9yZz4NCj4+PiBDYzogTWFzYW1pIEhpcmFtYXRzdSA8bWhpcmFtYXRAa2VybmVs
Lm9yZz4NCj4+PiBDYzogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4NCj4+PiBD
YzogTWljaGFlbCBFbGxlcm1hbiA8bXBlQGVsbGVybWFuLmlkLmF1Pg0KPj4+IENjOiBOaWNob2xh
cyBQaWdnaW4gPG5waWdnaW5AZ21haWwuY29tPg0KPj4+IENjOiBDaHJpc3RvcGhlIExlcm95IDxj
aHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+DQo+Pj4gQ2M6IE1pY2hhbCBTdWNoYW5layA8bXN1
Y2hhbmVrQHN1c2UuZGU+DQo+Pj4gQ2M6IGxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnDQo+
Pj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4+PiBTaWduZWQtb2ZmLWJ5OiBN
aWNoYWVsIEplYW5zb24gPG1qZWFuc29uQGVmZmljaW9zLmNvbT4NCj4+PiBSZXZpZXdlZC1ieTog
TWF0aGlldSBEZXNub3llcnMgPG1hdGhpZXUuZGVzbm95ZXJzQGVmZmljaW9zLmNvbT4NCj4+PiAt
LS0NCj4+PiDCoCBhcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vZnRyYWNlLmggfCAxMiAtLS0tLS0t
LS0tLS0NCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMTIgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBk
aWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Z0cmFjZS5oIA0KPj4+IGIvYXJj
aC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Z0cmFjZS5oDQo+Pj4gaW5kZXggM2NlZTcxMTU0NDFiLi5l
M2QxZjM3N2JjNWIgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Z0
cmFjZS5oDQo+Pj4gKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Z0cmFjZS5oDQo+Pj4g
QEAgLTY0LDE3ICs2NCw2IEBAIHZvaWQgZnRyYWNlX2dyYXBoX2Z1bmModW5zaWduZWQgbG9uZyBp
cCwgdW5zaWduZWQgDQo+Pj4gbG9uZyBwYXJlbnRfaXAsDQo+Pj4gwqDCoCAqIHRob3NlLg0KPj4+
IMKgwqAgKi8NCj4+PiDCoCAjZGVmaW5lIEFSQ0hfSEFTX1NZU0NBTExfTUFUQ0hfU1lNX05BTUUN
Cj4+PiAtI2lmZGVmIENPTkZJR19QUEM2NF9FTEZfQUJJX1YxDQo+Pj4gLXN0YXRpYyBpbmxpbmUg
Ym9vbCBhcmNoX3N5c2NhbGxfbWF0Y2hfc3ltX25hbWUoY29uc3QgY2hhciAqc3ltLCANCj4+PiBj
b25zdCBjaGFyICpuYW1lKQ0KPj4+IC17DQo+Pj4gLcKgwqDCoCAvKiBXZSBuZWVkIHRvIHNraXAg
cGFzdCB0aGUgaW5pdGlhbCBkb3QsIGFuZCB0aGUgX19zZV9zeXMgYWxpYXMgKi8NCj4+PiAtwqDC
oMKgIHJldHVybiAhc3RyY21wKHN5bSArIDEsIG5hbWUpIHx8DQo+Pj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKCFzdHJuY21wKHN5bSwgIi5fX3NlX3N5cyIsIDkpICYmICFzdHJjbXAoc3ltICsg
NiwgDQo+Pj4gbmFtZSkpIHx8DQo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKCFzdHJuY21w
KHN5bSwgIi5wcGNfIiwgNSkgJiYgIXN0cmNtcChzeW0gKyA1LCBuYW1lICsgDQo+Pj4gNCkpIHx8
DQo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKCFzdHJuY21wKHN5bSwgIi5wcGMzMl8iLCA3
KSAmJiAhc3RyY21wKHN5bSArIDcsIG5hbWUgKyANCj4+PiA0KSkgfHwNCj4+PiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAoIXN0cm5jbXAoc3ltLCAiLnBwYzY0XyIsIDcpICYmICFzdHJjbXAoc3lt
ICsgNywgbmFtZSArIA0KPj4+IDQpKTsNCj4+PiAtfQ0KPj4+IC0jZWxzZQ0KPj4+IMKgIHN0YXRp
YyBpbmxpbmUgYm9vbCBhcmNoX3N5c2NhbGxfbWF0Y2hfc3ltX25hbWUoY29uc3QgY2hhciAqc3lt
LCANCj4+PiBjb25zdCBjaGFyICpuYW1lKQ0KPj4+IMKgIHsNCj4+PiDCoMKgwqDCoCByZXR1cm4g
IXN0cmNtcChzeW0sIG5hbWUpIHx8DQo+Pj4gQEAgLTgzLDcgKzcyLDYgQEAgc3RhdGljIGlubGlu
ZSBib29sIA0KPj4+IGFyY2hfc3lzY2FsbF9tYXRjaF9zeW1fbmFtZShjb25zdCBjaGFyICpzeW0s
IGNvbnN0IGNoYXIgKm5hbWUNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKCFzdHJuY21w
KHN5bSwgInBwYzMyXyIsIDYpICYmICFzdHJjbXAoc3ltICsgNiwgbmFtZSArIA0KPj4+IDQpKSB8
fA0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoIXN0cm5jbXAoc3ltLCAicHBjNjRfIiwg
NikgJiYgIXN0cmNtcChzeW0gKyA2LCBuYW1lICsgNCkpOw0KPj4+IMKgIH0NCj4+PiAtI2VuZGlm
IC8qIENPTkZJR19QUEM2NF9FTEZfQUJJX1YxICovDQo+Pj4gwqAgI2VuZGlmIC8qIENPTkZJR19G
VFJBQ0VfU1lTQ0FMTFMgKi8NCj4+Pg0KPj4+IMKgICNpZiBkZWZpbmVkKENPTkZJR19QUEM2NCkg
JiYgZGVmaW5lZChDT05GSUdfRlVOQ1RJT05fVFJBQ0VSKQ0KPj4+IC0tIA0KPj4+IDIuMzQuMQ0K
PiANCg==
