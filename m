Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3AF5475B9
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiFKOpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiFKOpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:45:21 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120072.outbound.protection.outlook.com [40.107.12.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD342661;
        Sat, 11 Jun 2022 07:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3pAXL2uTng/m30AO8V01ylzuWg/UMf5jjs2aaimSEp0w5zAobUYnvHR/OrrCTtKCDv7wogw+tgJQ1Ct00Y08n+DkPWwI4zzgM4E8oGhYOZ5kJU3Hv9YEcluERfhIZCdVciceTqtSFiB7/+MZlqHGMBFQvv7L2CDtpag3+Ev9LMMKKZZ/p03aDr2+28CA/JKOg7027nZPyPL+3cJMDvMqlE/Rkhe0dVfaiDW2p+MjDfwGMBLLH98V3U6Xk7bZXHUcOvr+w/NGoE4hxkqRFPBUVBSt8kl38A1d2HMJ5ACMMNQFvwrQj+qaWRwMVVQios0aqxAmiQsLNWPTb9NNPMB+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vmi3xEUId5CvbF8YGez8aKBnj6HDWQzVoLDoFZxVuqc=;
 b=IBMPezXHb7GDltP8Vy2/XeeHacVT9pzouVQCbg0h5H1zNjQ26J8SbTojAm0w9cVyWT7PElYaA3wd+Cyu4p5JheipbMqpYxQ+0uJlcv4Sq10GnS1T47cTNsh35E7w4j7iE5BplVTLV9rl3U3PDH5oU6anUVO+K3sOzBkO4k7Iu2lSL4eE8YGlxYWCxqZKN0Uetl4RQHlJSn/Y9inqUBvf6swDdQTW2Hy+Q1ERAvIaTK4V0dsZwrvAuY95FBYt9aQu0r0QOQP4doSpUXJkUoWK0O/z2ruX2VCTCH9kXeudhRfXJj6pqWF39/5wByqtO2fc773aO38GLr+n+A/kMK0WuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmi3xEUId5CvbF8YGez8aKBnj6HDWQzVoLDoFZxVuqc=;
 b=66bPNt4NhP6yAONy8j1A4w+5b6qfW8kqDPUpld1P2SQxMi4Qd62eWettgf2uHppveR0U2GtqKK7wj7WaQIaPmn03GSv4Tr44Gtb8ZOaJjrpdUIwhWiwllAhBJwuVrz9G8dHoSr/JpN9NTjigY//+ch1vOndCFdocWqMWbLOrWEPHGObmrDvTNimaze877zri4QnwI8/ri8+1PYDNumqFQNYYGZqE0axWb6R0xEoaHh11AL31hj5aRx5m1aA1WJ2rsC/VAFAA0819jwXwiQMkHFxtavx71Jy6b6H1JkDjOjHpVQhV5abV7oNw2vNPP8WJ5KPJYzGCOyXIPuzYOhg1vQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 14:45:17 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 14:45:17 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] powerpc/pseries: wire up rng during setup_arch
Thread-Topic: [PATCH v2 3/3] powerpc/pseries: wire up rng during setup_arch
Thread-Index: AQHYfXrAlqnTbTsIrEKs940sVKmKdK1KSMcA
Date:   Sat, 11 Jun 2022 14:45:17 +0000
Message-ID: <80cca718-d637-b48a-ddb3-e6931cd08c24@csgroup.eu>
References: <20220611100447.5066-1-Jason@zx2c4.com>
 <20220611100447.5066-4-Jason@zx2c4.com>
In-Reply-To: <20220611100447.5066-4-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1f0d302-efbb-47cc-b443-08da4bb900b4
x-ms-traffictypediagnostic: MR1P264MB3905:EE_
x-microsoft-antispam-prvs: <MR1P264MB39053B028BDB8B09DF7D86C5EDA99@MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l34EVjxsB5lFOEDFYsG/4eql71kXIz4W+ZsAa/mGgz8pEPWP0X8Yz8/H0WZ+Wp2VFXNpUp9J4t2wOk7xvKVRNQA3yQXqvN9TlCRbLDTlKhkCJZmBqSJOq3f8q+ZlIC5Btqt6UHsf7T3JhO2LG5U08fdnvhPxUP3koqm7EtSMWzyzQaRxli0YEPlf5nH/Puy6e55VmwwWxjha+1TUi/m4/ctPHIJ0Y7wIiQpV41lCrXLbR2e2o9ASYgFahwvUD3jNiEmi2XbJM97MnaFprpNoB4qP36pP4gi/DhfaBYaCZpOzhGXRzwudSs/WYMOFFYf1H8Q9j4irGwZnTJ327ijp921Llpy6EX6OPnO23q/DwFa8bEVSCqUaLwGj2cv9SjYVL6OxUHMMi9NTuPROeUZ9NT9vSbF0nk24GGWRqOHl6VyGtKt9zkSeo4CMjE8KcCYHgPt2mbSUubp6EMwL0XxdHHS+J+XKt71TJUmlVLhVcfLeQyfzTrmSOY3v9eYOI2fj21sMElzvLbhxW0xwC0WuQEZ9mHDs9mYZkCxsNT8Ua99ZDJiCPwLc3BTFE8BzQNJdlkfZD2HnOfrxGAqsYRoGVpkyhe00TcdNBQBQZ0N3c/JzP0tUxiawIXF42kzXqYBYrVG0MQdITZbjWSIF00urP4k3r6jZBGIIsrwjDp5kS9zMDNQFmFuAfHE3VV54ZvRL/BTAs/56pfLdkZXES9WWLtE2MWFcMV0VvvUBvU2CueXIP3/nvqfzfuedMLgH33iaObstvnzenP0RaoiF4T7GhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(64756008)(8676002)(76116006)(91956017)(31686004)(44832011)(36756003)(66446008)(66476007)(66556008)(8936002)(316002)(5660300002)(66946007)(71200400001)(6486002)(6506007)(110136005)(2906002)(508600001)(38070700005)(6512007)(26005)(122000001)(38100700002)(66574015)(186003)(86362001)(2616005)(83380400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3RKa2NlV0ZKTXVZeFprMjJta0ZUTW9qYW53QWNhVWV3SnhjYVFJSE42OEl3?=
 =?utf-8?B?T3NwZkVYOXpDMC90aWhCWVNRbGNoUTA3RjZuZlEzZkdNZjFiZzNlS1FTTG5V?=
 =?utf-8?B?TUI2bE80NWRqdG1vb0JEb2lLZXJoS1QrOGlRdjV3d3hOWWFjYlFLeFdqZi8r?=
 =?utf-8?B?bjZmRlV1NExWNzdod0JTVmx1T1RQdDJ5MlVkdFY2dWhrRURZRGxoSXhoQVhW?=
 =?utf-8?B?UG9wcWd5THZGRUxSYnh1TW1meDZ0aXBEWnN5YXlIQmRyRzUyeU1VMmNyRHRv?=
 =?utf-8?B?cFpFSlpRWHEybHRoNnVTVXNTbTFOMXVQem16bVJKeTlTQWJaOVRDZEl1NGFF?=
 =?utf-8?B?d1F6L0lMM2xYc3hqd0F6L1grU1NjYi91dmZUVWwrMHYzMy9CeER6dS83eXNt?=
 =?utf-8?B?RHl4aC9DSlAyZGRnY21IblR6TzF2NXRJSTB3WEgrd0t0c3NEL2FGbG9keU9M?=
 =?utf-8?B?aWRwdnlhTk1tc09OYXRKNmNRY0tyeWhpeXRXcVV6Y2NDUE1Lb0dpdTNOUlRI?=
 =?utf-8?B?ditRMVBGSDhPdy93ZE8vNFFDV0hRUmJoUE84cys4QWxnRUNPRGlXczNFbG41?=
 =?utf-8?B?NzRJS3NMQXBzV1ZZczhVT0dUdmdWVngrTkdiY3N2Yjd6c1ppbzdnQVorbStO?=
 =?utf-8?B?cjU5aEs2eWdhRjMxM24wblRaUmcyTldkdk0zblczajB2elJSZ0ZMdjd2UURl?=
 =?utf-8?B?SnBSQVhYbStUaTRDNDM4MW0rVUpnc29ybFNwL1JQZFZMdmkvTjBCS2NVT3ZU?=
 =?utf-8?B?ZThWb1BFYlRZYUJkYUI3MEIxZHdhNG9OQTNhdDZXL1o4VjFLVkJaMFZUQ3pD?=
 =?utf-8?B?Ti91eTR5Um9Nb0p5Rzh3S09xR0VqRXdvTEp4Ri9yV0pHOGszRTB5RG1zMVZD?=
 =?utf-8?B?Nm9sRDQrWFVxdG12VHBNazhIY3ZCRTFPRU1qSmY3RlRXb3dDY0VJYnpWUUxY?=
 =?utf-8?B?RFNuOFlYVkJRVlk1ZTE2TWFLckFKRnM3Yjk3ZUxsdTZtZzh3cGljclRlVEFC?=
 =?utf-8?B?cjlGeit0aStOOWJ3VWhORFVZWDhYcGZna1ovUTVIVG5BMnZtVXNzS0ZFaERZ?=
 =?utf-8?B?NW9CZEk2UTgvYTVpTHVQa2xMaFFub3lHOGlVWVVCbHlJQnRnSi9xbytITG1t?=
 =?utf-8?B?Sitrb0pHbWZlY005cEErTEMvMkNhKzV5dEZwSkFmVjVEQmZ0Q0FQcWhTbWFR?=
 =?utf-8?B?WjBLMTFDUk1USEVjM1FmVGpwUnhvY1ltVjJMNWJETUpBSlMxQmJDR0QvcDdZ?=
 =?utf-8?B?UXJiZUJrVlhJemlGTVNsdVRlbW1PWjlrMldqWSthUVlWc3NERG5mTFRnaldH?=
 =?utf-8?B?N2lrRGJuZis0RUpVaXFaM1N1c2ZJUzFsYThibDlLYitFWS9OcVU1UFJxSTZi?=
 =?utf-8?B?WDdpbXNBYzVPOXZXaDR0dDNWVTlJMWJzSlJPelZ2YnZKVmNNbTdGREZMbkN1?=
 =?utf-8?B?eit2RFlSdXRkcEZRNGQ4Wk4wTVZWMWx2VitETVZDSGVrMXB1VFZXaGdOZHZX?=
 =?utf-8?B?dEtHMWVic0EySkNCcEc5ZG82UExZVThNaUVxRndVdEJxUkJ4Yng4WjhkMkhI?=
 =?utf-8?B?SUViK2tzR3kvZ1k2c2ZPcERSSkcyUVFMcnhxeTJpUkxFWTREQjJUemxaOGtR?=
 =?utf-8?B?b0VuVEdXbnJsZUQ1WGxkalhlL3hock1xUVRnSUZCWUhLZk9kRWxXY2g1TThJ?=
 =?utf-8?B?c09qTDVOVXcrMGtqSjE3NHNFUlErWStOR2VsUjZZRVgyYytaWlJqMnF3SGFV?=
 =?utf-8?B?dDdYeXRaUEo5VDAxTDZSenVoOHFkMy9oa0wwNzFMVW9PVWYxNkhvQVhvUnJZ?=
 =?utf-8?B?SGJ3VFBuNk5BZCs3Mmd6RHBxQURna2dqVHU3Zy9aV083clcycG9TZmx2SzFv?=
 =?utf-8?B?VXkxVWxPZTZoaW1tSmJUVXNmVzJIM1YrdEZDTmpOeFRvUWlueE4ydG5ZcnBG?=
 =?utf-8?B?TTZXNWlncWluamZzcGV2OWl3M0UzUVo1NUJjTk84NkNHRjdNclpGV3phN1Q5?=
 =?utf-8?B?WURmallpVExJcmhSUUJib3hRdkZMblVEaFdwOU0yU0NxaEEyUUJ2V2VMVGI0?=
 =?utf-8?B?cFNJQ3UrQkNBUFQzOGJ0SUFBZmpaemVmOHBYYWZHYjF2a2VHbUJZbkcxelNk?=
 =?utf-8?B?S2g0b2Y0OUYxdkFjRmhEUVBQVmFpdG5qTDYyRDFudUdrUTdhbjZGQkRrSWpQ?=
 =?utf-8?B?ZzM0cUxpNGpMTkoyd2JXUlVtdjlQUXNacVRnNUd2bCtQODFGZHRZU2V4NHox?=
 =?utf-8?B?NVI0QnhQWHVtTDM2L3VyR21JUFJQbmNPeitLakFpdzJYaVVWSldybDcrZmNQ?=
 =?utf-8?B?Qk9kblpsRmFidDBlZXlybUk1UTh6RlAwdjZJUStXTFE1VDVXQjZVUXd0V3RX?=
 =?utf-8?Q?Z1jPvTycyjy+tdFnK/QEtxTXUTlLETvrlasqJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <514D34F46C44BF4F9AEF4883489243E6@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f0d302-efbb-47cc-b443-08da4bb900b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 14:45:17.8909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ktGh4X06IzZfPAl6f1WfeMglAQ9Adhw7xIxiG3NAoGmq4VTKg7Nzk4LKs7nNHLQidE7Wp/SQ2X+PTrm0zyA9AG1bLzVkRPyUbDC3nzDNDoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3905
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTI6MDQsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMNCj4gaXQncyBlYXN5IHRvIHdpcmUgdGhpcyB1cCBmb3IgZWFjaCBvZiB0aGUgdGhy
ZWUgcGxhdGZvcm1zIHRoYXQgaGF2ZSBhbg0KPiBSTkcuIFRoaXMgY29tbWl0IGFsc28gcmVtb3Zl
cyBzb21lIG5vaXN5IGxvZyBtZXNzYWdlcyB0aGF0IGRvbid0IGFkZA0KPiBtdWNoLg0KPiANCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IE1pY2hhZWwgRWxsZXJtYW4gPG1wZUBl
bGxlcm1hbi5pZC5hdT4NCj4gQ2M6IENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lA
Y3Nncm91cC5ldT4NCj4gRml4ZXM6IGE0ODkwNDNmNDYyNiAoInBvd2VycGMvcHNlcmllczogSW1w
bGVtZW50IGFyY2hfZ2V0X3JhbmRvbV9sb25nKCkgYmFzZWQgb24gSF9SQU5ET00iKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT4NCj4gLS0tDQo+
ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3JuZy5jICAgfCAxMSArKy0tLS0tLS0t
LQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9zZXR1cC5jIHwgIDMgKysrDQo+
ICAgMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3JuZy5jIGIvYXJj
aC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3JuZy5jDQo+IGluZGV4IDYyNjg1NDU5NDdiOC4u
ZDM5YmZjZTM5YWExIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3BzZXJp
ZXMvcm5nLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3JuZy5jDQo+
IEBAIC0yNCwxOSArMjQsMTIgQEAgc3RhdGljIGludCBwc2VyaWVzX2dldF9yYW5kb21fbG9uZyh1
bnNpZ25lZCBsb25nICp2KQ0KPiAgIAlyZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+IC1zdGF0aWMg
X19pbml0IGludCBybmdfaW5pdCh2b2lkKQ0KPiArX19pbml0IHZvaWQgcHNlcmllc19ybmdfaW5p
dCh2b2lkKQ0KPiAgIHsNCj4gICAJc3RydWN0IGRldmljZV9ub2RlICpkbjsNCj4gLQ0KDQpUaGVy
ZSBtdXN0IGJlIGEgZW1wdHkgbGluZSBiZXR3ZWVuIGRlY2xhcmF0aW9ucyBhbmQgY29kZS4NCg0K
PiAgIAlkbiA9IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlKE5VTEwsIE5VTEwsICJpYm0scmFuZG9t
Iik7DQo+ICAgCWlmICghZG4pDQo+IC0JCXJldHVybiAtRU5PREVWOw0KPiAtDQo+IC0JcHJfaW5m
bygiUmVnaXN0ZXJpbmcgYXJjaCByYW5kb20gaG9vay5cbiIpOw0KPiAtDQo+ICsJCXJldHVybjsN
Cj4gICAJcHBjX21kLmdldF9yYW5kb21fc2VlZCA9IHBzZXJpZXNfZ2V0X3JhbmRvbV9sb25nOw0K
PiAtDQo+ICAgCW9mX25vZGVfcHV0KGRuKTsNCj4gLQlyZXR1cm4gMDsNCj4gICB9DQo+IC1tYWNo
aW5lX3N1YnN5c19pbml0Y2FsbChwc2VyaWVzLCBybmdfaW5pdCk7DQo+IGRpZmYgLS1naXQgYS9h
cmNoL3Bvd2VycGMvcGxhdGZvcm1zL3BzZXJpZXMvc2V0dXAuYyBiL2FyY2gvcG93ZXJwYy9wbGF0
Zm9ybXMvcHNlcmllcy9zZXR1cC5jDQo+IGluZGV4IGFmYjA3NDI2OWI0Mi4uN2YzZWUyNjU4MTYz
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3BzZXJpZXMvc2V0dXAuYw0K
PiArKysgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3BzZXJpZXMvc2V0dXAuYw0KPiBAQCAtNzc5
LDYgKzc3OSw4IEBAIHN0YXRpYyByZXNvdXJjZV9zaXplX3QgcHNlcmllc19wY2lfaW92X3Jlc291
cmNlX2FsaWdubWVudChzdHJ1Y3QgcGNpX2RldiAqcGRldiwNCj4gICB9DQo+ICAgI2VuZGlmDQo+
ICAgDQo+ICtfX2luaXQgdm9pZCBwc2VyaWVzX3JuZ19pbml0KHZvaWQpOw0KPiArDQoNClByb3Rv
dHlwZSBoYXMgdG8gZ28gaW4gYSBoZWFkZXIgZmlsZSwgYW5kIHNob3VsZCBiZSBwU2VyaWVzIG1h
eWJlIA0KYWxsdGhvdWdoIGNhbWVsQ2FzZSBpbiB0aHJvdyB1cCBvbi4NCg0KPiAgIHN0YXRpYyB2
b2lkIF9faW5pdCBwU2VyaWVzX3NldHVwX2FyY2godm9pZCkNCj4gICB7DQo+ICAgCXNldF9hcmNo
X3BhbmljX3RpbWVvdXQoMTAsIEFSQ0hfUEFOSUNfVElNRU9VVCk7DQo+IEBAIC04MzksNiArODQx
LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IHBTZXJpZXNfc2V0dXBfYXJjaCh2b2lkKQ0KPiAgIAl9
DQo+ICAgDQo+ICAgCXBwY19tZC5wY2liaW9zX3Jvb3RfYnJpZGdlX3ByZXBhcmUgPSBwc2VyaWVz
X3Jvb3RfYnJpZGdlX3ByZXBhcmU7DQo+ICsJcHNlcmllc19ybmdfaW5pdCgpOw0KPiAgIH0NCj4g
ICANCj4gICBzdGF0aWMgdm9pZCBwc2VyaWVzX3BhbmljKGNoYXIgKnN0cik=
