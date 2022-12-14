Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94664CD1A
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiLNPda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLNPd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:33:28 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1C62E3;
        Wed, 14 Dec 2022 07:33:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0T5tri4BztxDqivoPuTaWI1aZiuBik7JMQBAuDfJp11/nkBCl+Vpg1yJGzepw+JNt3NdTK/rGgoflZr0ISXqPXeglaQJBfEgfsHElXdxWYyN2AqjfOS0GkgsrUQySlrMx4F0hBfTQ1NJCwg81vJhC9ZMyDRVCyBLzxqts6m6ODGXIUEB7AUL+R54zauh66jhNUtYVYgpmoVFwcbvI1cJ/+1mw+gGcVeLpam3RijgXhg27JCdeEEt2ifRfjhULCt+UXKpsWWCChpikAMzuB9qsnQ1mSLto6gR2lSV+0uLnJ4HlqG8wkQ+x4hu1oo0IDTemgfqqbrJxfeIFh4EjbLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5nYw8MBAW6eTIQ2LCYEGieYguFJhRCMeUv75BmeLhk=;
 b=CfdCVNtk49544hlTWPmmAPVEhu5XLFkvUckQwH/njcYztYSDrK174sHlNGkYD/fCQHw3jzn42FgeOtL+JBolx6fo+OzaHFxAWjBU/85w7d5djnBZXo18qdYCK28CF4nyEl3Ia8CvRO4mIQzlPyE6KRHX/+5FWf7QQh4zkwncYa+cURQageaGVWM2p+391/FHIXWRgRNLQHrsDDlOzh71oFsTpIzTbw0PFCxOVjVsDTb3i3GpQtiqDrOaIWpZTAIYkzfUi4ZkIwykr97xUVP9o5jjPaIKh2kJzpB6Th3fTeL7EdawbdbpWdKG2a6BNOcUR8SeE57OJhQoKojS9ln+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5nYw8MBAW6eTIQ2LCYEGieYguFJhRCMeUv75BmeLhk=;
 b=5L6ZazM3z/TGkmdKmWcfX8K1deB10C2fUrSwnxuGUBpX8olykKs2D7vaZSBm5ZBqXJV8UvtjNPEmzqWYHuSAmaigEa3/i1fMLQ+0Vy4n/zb4k/YuqGFxttVdd8FkoE5kCX27RZmBhtAxnZv05ld8vFKvr5kIshMbkgGPbzmrPQp2eMS5OW0iBCSMMpXqwRt2hkG3BZWtDnLmgaavTwHg9GgCayiI7yCzkAmneeb9Rc3Cbfj60A8f6nKgG44Bs4M6HlJdaEPbkQptxDP7Cl1dZ5j3XlQezH2xGD/yPdHmoP5e4mrS78YygjAr8Zbb7n5KD+tC1L03jKFlgN+op2x7rw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3422.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:149::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 15:33:24 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 15:33:24 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Segher Boessenkool <segher@kernel.crashing.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH] [BACKPORT FOR 4.14] libtraceevent: Fix build with
 binutils 2.35
Thread-Topic: [PATCH] [BACKPORT FOR 4.14] libtraceevent: Fix build with
 binutils 2.35
Thread-Index: AQHZDx07BWV7PFnWCU6wSGiwnwd9yK5sQ+GAgAFAsYA=
Date:   Wed, 14 Dec 2022 15:33:24 +0000
Message-ID: <8d1c27fe-bac5-8007-a852-f9c15a49a6ba@csgroup.eu>
References: <c4629a12d4a2a21ff131624d3ef1d9f8b5fd64ad.1670954579.git.christophe.leroy@csgroup.eu>
 <20221213202535.GL25951@gate.crashing.org>
In-Reply-To: <20221213202535.GL25951@gate.crashing.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB3422:EE_
x-ms-office365-filtering-correlation-id: 99c03171-b50a-4625-da5e-08dadde889ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P7FaTd2BGJKy6dv44bRGiOlJ5iVChglh4CBTQ5mqn6Z26v/OTqkxbmM7TA+bh2MnZmdmZw5mYmiQ4tn620oYcASu2rsiVHd13m7FCGlDria6jScVdSoxm1yFn343kkBOKAYrjdfFOk6GQpAL1QWIUsSIcn2IF/yMb8OsDUNxQHuPQW8DRix3f6ILTDAeCAFjUL5iJX5m5SFTEYvD9HH3S2FSfcWy97G11Aka5pPt4Qhx8/NP0dbpm/Jj9t/IqJHLntPvVlwXCkkzV68TslV3nqXNj5O8RaitMmLDj52V6wKwUSwqCkvb1vPcTCBPD61FekRQWT9cxw5zIsx5aMo8oGcX4b+drcwxT9v0srcfTLs2F3oijeFKoIjtL8DQijZ3NaqQTpOkub79Ds79VRErvhf2at8IqRPHPCXITh6nQgH84sBBxdVW9ERDKk1CKJ1b3V9FS2JVhwzebFuD7vO6NO6XaIkAZTY21sO1CU3JOnPLdeXn/jO4mBAPyJxAAWjWCvU7t2wdgQzGYDqxeezkg7XrDoisIW+sFXyhcMxK70CleLy/V0cPUpMNrxFy77rA6NzLNGJNqJb2EtZd+hM+yyOpoqQCJe3fZfVtJOrW1SgIXl0/mVCaCSrTyvGJk5YbTPzqDLL4A7FMZZxBcVhZd3wkRrMxvTQNxMS+P8/TNf4ip+AHugqmvPigc4i31mjSt06qYKY/Can1I2yKT40kVVtFlXFjsZJFzsvUxsXkMd0D+fzpbBsXw6G8k7X4Psb5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(39850400004)(346002)(451199015)(38100700002)(122000001)(31696002)(8936002)(41300700001)(86362001)(6486002)(71200400001)(478600001)(4326008)(7416002)(66556008)(76116006)(110136005)(6506007)(186003)(64756008)(8676002)(2906002)(54906003)(316002)(66574015)(26005)(6512007)(83380400001)(66476007)(4744005)(44832011)(91956017)(2616005)(5660300002)(31686004)(66946007)(66446008)(38070700005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bllBNG15NElMa1dORElCaEo2NUJGbW1ueEZpN0xQVXFzd2hHKzJIbk1LajBx?=
 =?utf-8?B?NnhTMjhKVVRzejhWQnh4alNySmlKOTR5WVkzWnA5RjNRWTZCbmZiOGpHK2lV?=
 =?utf-8?B?b2l4WU03YnBHLzg2S09SbHhmYXhqdWxGRXUydXBkdldlNHoxd28vOHhiOUtX?=
 =?utf-8?B?a3pKeXhxWlNRaEg1SExnOG1raER6Um92ekMzUXpyeHpGNjNKcGR1cmFlUk8v?=
 =?utf-8?B?WnlFUHBJZVpSN0FqSHhrMGw4dFNtaGNUcU9CQ0J2aisrbTJENndXaE5pMmhy?=
 =?utf-8?B?VHhGODRpQXdpcjZwODFZaUM1RlpMK01RY0RNR2ZrMnlNWjJRQldxbVhURFlu?=
 =?utf-8?B?cWRUNjh0SGVLN1F6RStLL0x0R0hQQTJBUjNzeThIeTRaUVpGazh5UzRBckt6?=
 =?utf-8?B?VTRtdkdqNG1JaUFZSGtjdnI4Lzl3ekErS2NpaG1DcXdBaWJFS1gwUlhhb1RC?=
 =?utf-8?B?cUtuVmVtUFlyM3Brc1hhQWNGYXVFakpHcDFtWXJLQVdvSTdWcWR0V0NyR3Nl?=
 =?utf-8?B?UFRFOFc1VWtQUGZlaEY3bllqMmt0N3l1YTZMVDFZZmdzbUxXT0hFSzFMNnFq?=
 =?utf-8?B?L28ydW1FZkRmOFdqK1hXVlVSem1FU2R1Rjh1Vlg2bStyQ0xYT0k1dkdvVXVn?=
 =?utf-8?B?WkUwd0g4RC9jdGtBVDZ2c0N4WlVGWExwMnhVZUJ6YlZacHRrRkJCUC9CRyt0?=
 =?utf-8?B?VDh5eFJiekdHclU2TWVhb1M4RHhIbFQ4R3htZzlqVG9sNmhIckZBbkNSS0Fa?=
 =?utf-8?B?Y1kxaXhZb0NuUitpYW9LSnBCMklVOEFFampKc0UzWm82Y2VENEMxWlBseFpm?=
 =?utf-8?B?bFRDYVlZZ043N3h5YXYwRDN2dlo0dE43S25CTnR2bkRlZTJkSFBlOThrRi96?=
 =?utf-8?B?bFdJYUt3eG9VVXFoL2ZsL3E4eDZWWE9TWUhLQUQ0TnRjT01lNTE3U1lGVDcx?=
 =?utf-8?B?dGRhV1FUdmZiaHJoUDBCZlROVkdBaHpJNU40aU83VGI1Zi9nNGJRVk1QM1pB?=
 =?utf-8?B?WmJpQXlEaFdFWERsK2dMZzVLVTZZWDIyK04ydTNMU3lDYlY2NWpFSnNvOERa?=
 =?utf-8?B?NGJFeENiamt4MmFhZGNrdnYxZmcvb1NDU0RQVjNQZFU4blVUbDUrUmlxSDln?=
 =?utf-8?B?eXJ1NGJNeW56Q3pjQTNTN0FoellWSk9QbVppVjk1S0k0dk5POHYxKzFxZTl2?=
 =?utf-8?B?MVV1Mk02S0ptU3VVTjdMR1RZdHEwMkNrSTRnVFd5RW1QaHA5UzBCVnM1cXNM?=
 =?utf-8?B?VEl3em9xU2Z0OVJVY3F3OC9KejdzK0VYdFJaa3NaTFkyTlVkR2N6SHh3MXBm?=
 =?utf-8?B?QWt6OXFQWEtzbU9rRXZqZ3AxUUxmNTljOEhUSXdjWGJIRjE2ZXo2T0g3cCtZ?=
 =?utf-8?B?T09GRDRwWlFhVzI0dkN0SndtcW5MRkxnRndMRGhjZytZYXJ2NWM1cDVMcndy?=
 =?utf-8?B?R0ZXRGUwV1dkakVScGxES0tNMEhNa040clQzcmZScGliZDBJSzVvc0RjSlEz?=
 =?utf-8?B?eHN4cExRZHJGREdOQmRPQ0RSVFFqQUJjc3JaNzFVOVl1YkYvWTJUQklma0gx?=
 =?utf-8?B?ZVIrak03ZzNBa3BxZ0VyeVN3Ty9wTTl1eFhPSDVFY3VrTm5YOGpudS95SlVr?=
 =?utf-8?B?L1JoR2tkaHBaWWtna3lULzAzKzRvdzBzdUhscGhkbUpzS3Zyd1ZwWllLQVhN?=
 =?utf-8?B?bU9QOTNxc2gwaUlycUtDWVpWdVJwQ2VRSm5IenBNS3BRaWlwd1FUNytPLzlt?=
 =?utf-8?B?OEE4MUxiR2k5MUFXWW5VMzdlamZPR2lrK0NBbVlvZFQ3NEpydXRjeWl4RTRJ?=
 =?utf-8?B?d3M5emovamVKZlVYa0JXVENXZUFYQXFLUUNnYzNxRTJxSUJVUTU5T0FncWlr?=
 =?utf-8?B?YjFCc3RQd1h1dzlTdkRrcHE1MnZrR3hCVmVlQ0NUaU9oSklxMjBWODBVQ2t3?=
 =?utf-8?B?bWlsVWY4eFBKYlprMGM0MDQ0TzdROGhya3hZN0FWbWJ2YVZFaTVLQ2hEd0wv?=
 =?utf-8?B?emxBL3RSK1hETjczK0xUVytnVmY4TzY2djJHWUY0UTRtOENCK1J4bkE0a2VI?=
 =?utf-8?B?Yi9nNHFCbHVQWUhFbzhUcEdTNUFqSkM3MXUxRkFsZkhuQ2l4M2lOUHhjZWxs?=
 =?utf-8?B?MDZLRGZHQUxLSFRVZDhCaEpIaFluODhlRUUzUjhWalNjNUZ4bk5XL0ZydStn?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <872455864A12D54FBF067F65CC9C1BE5@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c03171-b50a-4625-da5e-08dadde889ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 15:33:24.2069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epgYTtkxYCwdy8uUbHCzg7T5+BRDqhy55+YdpaV2q+7ZXFTi7hkWY9Ut7PFrqNgRQzA/U+ErL6h/APAECeXQn3Ve9Ov/k9+F0/MR7BR2ZAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDEzLzEyLzIwMjIgw6AgMjE6MjUsIFNlZ2hlciBCb2Vzc2Vua29vbCBhIMOpY3JpdMKg
Og0KPiBPbiBUdWUsIERlYyAxMywgMjAyMiBhdCAwNzowMzowN1BNICswMTAwLCBDaHJpc3RvcGhl
IExlcm95IHdyb3RlOg0KPj4gSW4gYmludXRpbHMgMi4zNSwgJ25tIC1EJyBjaGFuZ2VkIHRvIHNo
b3cgc3ltYm9sIHZlcnNpb25zIGFsb25nIHdpdGgNCj4+IHN5bWJvbCBuYW1lcywgd2l0aCB0aGUg
dXN1YWwgQEAgc2VwYXJhdG9yLg0KPiANCj4gMi4zNyBpbnN0ZWFkPyAgQW5kIC0td2l0aG91dC1z
eW1ib2wtdmVyc2lvbnMgaXMgdGhlcmUgdG8gcmVzdG9yZSB0aGUNCj4gb2xkIGJlaGF2aW91ci4g
IFRoZSBzY3JpcHQgaXMgcGFyc2luZyB0aGUgb3V0cHV0IGFscmVhZHkgc28gdGhpcyBwYXRjaA0K
PiBpcyBzaW1wbGVyIG1heWJlLCBidXQgOi0pDQo+IA0KDQpEbyB5b3UgbWVhbiB0aGF0IHRoZSBv
cmlnaW5hbCBjb21taXQgZnJvbSBCZW4gc2hvdWxkIGhhdmUgZG9uZSBpdCANCmRpZmZlcmVudGx5
ID8NCg0KTXkgcGF0Y2ggaXMgb25seSBhIGJhY2twb3J0IG9mIG9yaWdpbmFsIGNvbW1pdCAzOWVm
ZGQ5NGUzMTQgDQooImxpYnRyYWNlZXZlbnQ6IEZpeCBidWlsZCB3aXRoIGJpbnV0aWxzIDIuMzUi
KSBkdWUgdG8gTWFrZWZpbGUgYmVpbmcgYXQgDQphIGRpZmZlcmVudCBwbGFjZSBpbiA0LjE0Lg0K
DQpDaHJpc3RvcGhlDQo=
