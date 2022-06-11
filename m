Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1904654766C
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiFKQZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 12:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiFKQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 12:25:24 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120075.outbound.protection.outlook.com [40.107.12.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4FCCE7;
        Sat, 11 Jun 2022 09:25:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6SX367OFYFvVgxylZuXium6LwpfOLon46R3vTccO56cn0mD+3TxXnsk2+RBJfeceQ9Q2DcHpfig8WVpY2OPMkCXS/XOt5EnomMAT3x9HJTveZVec4HkvWcv5bwmUFdZmQsQqD1LvICJhFn2xlbDFgOqwFXHru2NnObvjW6IdWyHKrW/SQM9FZi1fc89yoC9aPr2VsNM54JjUDSYuW6jLa/HdU1bCgRjt5SaCZViEbwNefykzgXh/4zXovl52k65hKfEoWCpxDcs4mzqyza65qhchoOhNuAKkTiVsTVOzqIV2CoB6R1w/93Oqt4ngf5mhTG6u4XEjPIehs0CYM43Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exX/yN22TplSWGYAJK6wDpLPhngCOHKPzDLb0TYKxz0=;
 b=JvvWb2+dfMQk3zPIKHXw1i5Dx/AgSsR8+PiCzknKnMREWflbp9lgrquWUhzZNk6nFqXoZl8zadBKsd1BVKMDoTrnzMQBpdCrOAaJldfMmC+TqV3Y4CrkTn58a/mSRJkNCLshqykJz4Tc+thnnIFd4IZ/BUZ5qjwNuh19q0KDsDM+zmG4ggUvreEnQKdpD5DXgMKLDmrwKfrOkQZokXol9B+wN4PgCoGYOkKO5iw9UjG1t9Ny4d5fK7Jari4S4eSA/K/rSAAP9f65zcFiJYXsTLmkcASIuwdxlc6bEA3Gzt7bctU9JJRojhvT1tMFppqZol0zsP5EFmc2+/Aa1clh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exX/yN22TplSWGYAJK6wDpLPhngCOHKPzDLb0TYKxz0=;
 b=Nvq008htiKwKTNr5LkV2c61h2bjw0tR6WkbitWZ+hTnpfiTJYQA/8lk9UxXy4kfkp5sbTnkNgyCYQi6dTUEfMY8Lywloyxt6q7/eilypfc0LVEWICXGhUwAN/uR+W/TD5UFfsu013wAxAeMrJh+3TpH9Gc+s4PR4u4aQTAvkeWYPOKbF1JEBFKMpRTiESumw2ESnvaB/nNXEEFOAhNIfPGppLFUqR1ChuYEuFHqAfk5ewJ3rFsvI5wfcKFvRcndZD3zuHfBT2GhtreEFb5/fP/cv8XZTnHTDVVPkBjlTnLEl7vmtufk3LVukh52Dj1G2UrIlVhCFzf8ayt1QTwCfiA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.11; Sat, 11 Jun
 2022 16:25:18 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 16:25:18 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Topic: [PATCH v3 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Index: AQHYfaVlCdDujtJpQ06Q4oHT/1KOZ61KZGGA
Date:   Sat, 11 Jun 2022 16:25:17 +0000
Message-ID: <709c9859-f8db-6f03-9cf5-50b7442953ae@csgroup.eu>
References: <20220611151015.548325-1-Jason@zx2c4.com>
 <20220611151015.548325-2-Jason@zx2c4.com>
In-Reply-To: <20220611151015.548325-2-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b0227d2-b6d0-4ffd-fe9f-08da4bc6f90b
x-ms-traffictypediagnostic: PAZP264MB2605:EE_
x-microsoft-antispam-prvs: <PAZP264MB260598C92D2B900A5D32744CEDA99@PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EQD2VZP1h+LkNa3dFFz6mkpgRuQEtGeDm169mdNqPRy407YK2YYSqLg4j3WqhB6kleCX10j+e4qjbg6RIODFKWtlwkCSUlSfyDvgeCnD/HkTfp2MKf37XDWh9A/t933Y9HUnI9wFj0qtOMYY1fn0F1+ZkXreCIHgCE7anFSNzYfe8HYrBr4b3/DrR2/gDyX+zOA3xoPI/tm9qyTgSv9j0yKfb5grr4lYwqK+nedPe24TVWY5U1rhnY0UC4f6Vb9U6GuRM895Rx/V5nUCDErv95OWNPa2VrfWYF61dZvQLZ6dOh76ixEoYz89h78/wQl7OHGfUDdKu3MfsX1iwlTzMVTjxlJFEcoCHwLAzJdmDMQcY58Nb53E6HdxbZeokAOj2dVFTz6YTy1/yv5CVOUl8+xH2RwdKzlcdCjTeVcCg0yX4/+ukduSaiElFbrEUbW+EhTDNNVBXzpJA2LAnSbixRmTfRhMFV5GZgXhz4ONO4IIP0nagi6A55l1hP1nMRf4UaxeZqQHVUOfFymvA/wiOKpLf609AmxWmMcY+KTzBK2C+7BrLp/qhYncXv+p5lZpUYfP6rcF4iEnRm8JHRRF4+qpqo16IpNTSsmGyXg2GzAxpa9YKM+zMQFK3fsEIx+OLH3+o9Lj0XN/ksBdPnmNxJHPmlDhrlZCdG3r5EG5kwWk8UDtbJQG5FTX3qaOwnAO90wHjUrTneQjdW2qtQAg7fzjc4EGsVSPINMdTM5KNw1T989zhHr6ErSBkxFMosO8gBgQ5Kid5HKpu4P7j1HVBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(76116006)(66946007)(66476007)(66446008)(64756008)(4326008)(6486002)(6512007)(508600001)(66556008)(5660300002)(8936002)(91956017)(44832011)(71200400001)(26005)(38070700005)(66574015)(2906002)(36756003)(316002)(31686004)(38100700002)(186003)(110136005)(83380400001)(122000001)(86362001)(6506007)(31696002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVMwTS9oU1FiOFY0dVkwN2hEcVJuc29yOTh2MW5oc3U5aUZ3M0pjUGFlM3d5?=
 =?utf-8?B?WmdjZnFsSzlPVEs5OGJJZkRjWmFCc290VW9HVHIrQXFjWkx3c3VsK2dXZ3Yy?=
 =?utf-8?B?YXJ2MVpkR01obFdSWktxMmlua1JaYWUvTTVjb01hV1NYdWRGemFhY3pyVXQ5?=
 =?utf-8?B?SDNTN1EvYVVLdEw0WnlUZ2RIMURZV0J5MXJXMjFNVW55ZWJsRnRnRzFZZWxN?=
 =?utf-8?B?ZlhWZXl1SnhHUitiaENXWlFqcVRpS0YrVTVCeWI3bDk4bDMyRnBnMDN2ejIw?=
 =?utf-8?B?MHNZVTJXRnJTS0N1MGFKNnQ0RS84dW5pemh5T3pUR1phT2hhbDhXNlUrcXl3?=
 =?utf-8?B?ZEFXOE5vS3NIWGxwd3B4RG1PL3hzNFVrb1IzNjJJTEJ3Y2MwQ2M2cks1UGFN?=
 =?utf-8?B?ME1Gb2ZPZGtBNW9LV01saCtqdWtCYWZCTE1WY0Q0Z0V2YWpwKzRaWXFSSUpq?=
 =?utf-8?B?TzhkWWoreHVPU1h5cTNRTnZLd01UWktya2pkVHVFWEJ5clJJWTZxZjNTUkZC?=
 =?utf-8?B?Sk1rakxhZUZpQ3Y5VXBiM3UxUGtBaDcya24zclJBTW5lWHoyVTJuK0tSUlY2?=
 =?utf-8?B?aFNqNjdCejVFSGFKWll0WTczUlFCOUNXTWNJYUM0b1M0MjBsRVFYTXNMZm40?=
 =?utf-8?B?WCtMN1RkOC9Gb3FGNjdtOUJmUHhrZk9ZU2VVT0h6emkvRWpnZmxFZ3NLNWpN?=
 =?utf-8?B?RURWNTU5MmxZMzVJdWx5bzNUMEZlL3VOdFVjVnFMaHRkY1NUV2ZyR21LNDFY?=
 =?utf-8?B?VnJDb1NHdElHNFFjWVI1OEJadWg2MzU1WFhXS1U3TjBlUGtXWjJwbFliYTJD?=
 =?utf-8?B?VWVXUE5GMEpYR3JGdHhaWURONnBBY2JpVHZVVW9UUnZnTGcyYlFUM1V0TmV4?=
 =?utf-8?B?NWFBaXRkTDJQZFl2dGRYNkM2M1NxOUJyRm9tdk5qcUVtejNteE1FV2M2aXNk?=
 =?utf-8?B?c2FWemJkeWwxYUE2ZFJlK3BveitFcDlKc2xqU1YrWkZXQkt6ZjZlbHRSWFE5?=
 =?utf-8?B?alB1b00wMElWU1hrYkErT3Y3L0ZVMUxod0xuc21GOW0wSjBNVWZYa1pndzly?=
 =?utf-8?B?YXdvMnIxWVVrTFMrYzAwRkFQZ3B2UFB6SGkyL2ZDR05DbkttWWVoR0RkL3Jo?=
 =?utf-8?B?UEN0RWlnd1ZLbHpjR0MxRDlBL3NQVlZhLy85bVhGNmtPdk1qNkVqb3ZsLzBs?=
 =?utf-8?B?T1hDWU83YjJQWk9mSVM5ZDNGeUhEZGwvTWJWWGxzYVVPcFFiamdxNktEeHlP?=
 =?utf-8?B?TDlMaktockwxbml5emJrc3JYZVlFcUdqUUNlUU4yOFVPeGRmVVc2WmtNc21D?=
 =?utf-8?B?UFgvbWQza3R2SGFBUTN0Ni9wOWsvcURld05JTmdFRVJ4M2hLUzlSWHp4VU1z?=
 =?utf-8?B?SDVZVHVVMzEveVUwaVRWY09WOUpVSzEvMnBJWUlINXlObHBSOWlGam95S1lP?=
 =?utf-8?B?NlBQYXBJK3VTbXlDVlV4dWMvZlovWHhRVkhxc2YxRHFMaGVoMTk5UmFvdm5s?=
 =?utf-8?B?eXB0cEpyOGxIRWhkcElhL21zd1RyUVJYZzIvQnZkN2hqR2lZSGNxY1h3M0ox?=
 =?utf-8?B?UklsNDhOY1B3OHNqbTVIQTNmZnFBQnZEbmhRVzBtTWhLZDMzTE8xN3NYaE9F?=
 =?utf-8?B?SjE5bWcxNmo1clh1WUJsTnNFYzE3eHpEY29ocmdwV2o1Z3IzSFZRRUpOdUxx?=
 =?utf-8?B?STJkMHVtV3JuNjhncXpsSklQQlF6STBGeHd0QnR0MlRUdENSekwyd1RLZzl2?=
 =?utf-8?B?VHltK2VWWHVEMzhoTE1WTGpka3RlU1F5Q2NBbUpFMC9DMDkzSkJ2ZSt2REEv?=
 =?utf-8?B?UXdrOWpJWXlTM0FLYjVJYWtPT3BSU1NCVDh3YmJUMDZmNEhRSm9rY2xWM3B0?=
 =?utf-8?B?VURqQ0dXcVNhWTUyN3Z2SFN6YXAwblVZeDVwWUZjcEl1cEd3MnQ1SXFSdGxS?=
 =?utf-8?B?TXFWWlQ1cU1Mb0tvbE8xMG1jaU84cThTRkxOM2dYa0E0QldjMis2TjllSkJS?=
 =?utf-8?B?dVRBVDl2VGFpWlFia1lPalgxcUNWbWlBNSs3bTdGOUd5V1BkeUxLdGNqazFU?=
 =?utf-8?B?QVdRSXRCMWhWUjFNS1JTckJ5SWlpMVRvYnFXenRvWTRWcDRzNzNCcVJLWm5T?=
 =?utf-8?B?WE9ZdW83WXlRRkJ1eTN5MzR3V0gzcE9hWnRrdGNwVnQ2bnpyTElGZ0tkWXpl?=
 =?utf-8?B?ZFJpL0JPdUdwbFA1ek9uSXczeEhXMGMrTDRCOWFXZ1E2YmlZejFxT0M3aXl4?=
 =?utf-8?B?L3E2NDQvNDZpRW5CZVNkMHVxTWxPTUFnRjlYT3oyY0ZWTzZDUzFFVHoyU0Nt?=
 =?utf-8?B?alpxcUZDbFBLeDdHUlU1TUFZM3JYZUlUdGRUbmxXZlcrU3JtY3pya1lJTlJE?=
 =?utf-8?Q?6Y7ozppM4pQticqlAggY6B2y4IWYWrNmU7y+s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C3992C6ADCF354C894F401456C49CE5@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0227d2-b6d0-4ffd-fe9f-08da4bc6f90b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 16:25:18.0110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2qVyoJTT30i9tmaznblpHxc6xvL4J8wngcpppiubFBW/OiaeamJ7KIjbbMiM56u2W/YxJWkGY644U2YJ66iXU2un0s87IUwVOKgQ2i1wQlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2605
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTc6MTAsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMNCj4gaXQncyBlYXN5IHRvIHdpcmUgdGhpcyB1cC4gVGhpcyBjb21taXQgYWxzbyBy
ZW1vdmVzIHNvbWUgbm9pc3kgbG9nDQo+IG1lc3NhZ2VzIHRoYXQgZG9uJ3QgYWRkIG11Y2guDQo+
IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBDYzogTWljaGFlbCBFbGxlcm1hbiA8
bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiBDYzogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5s
ZXJveUBjc2dyb3VwLmV1Pg0KPiBGaXhlczogYzI1NzY5ZmRkYWVjICgicG93ZXJwYy9taWNyb3dh
dHQ6IEFkZCBzdXBwb3J0IGZvciBoYXJkd2FyZSByYW5kb20gbnVtYmVyIGdlbmVyYXRvciIpDQo+
IFNpZ25lZC1vZmYtYnk6IEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25AengyYzQuY29tPg0KDQpS
ZXZpZXdlZC1ieTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1
Pg0KDQo+IC0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L21pY3Jvd2F0
dC5oIHwgIDcgKysrKysrKw0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L3Ju
Zy5jICAgICAgIHwgMTAgKysrLS0tLS0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWlj
cm93YXR0L3NldHVwLmMgICAgIHwgIDggKysrKysrKysNCj4gICAzIGZpbGVzIGNoYW5nZWQsIDE4
IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFy
Y2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L21pY3Jvd2F0dC5oDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvbWljcm93YXR0LmggYi9hcmNo
L3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9taWNyb3dhdHQuaA0KPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjMzNTQxN2U5NWU2Ng0KPiAtLS0gL2Rldi9u
dWxsDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L21pY3Jvd2F0dC5o
DQo+IEBAIC0wLDAgKzEsNyBAQA0KPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0y
LjAgKi8NCj4gKyNpZm5kZWYgX01JQ1JPV0FUVF9IDQo+ICsjZGVmaW5lIF9NSUNST1dBVFRfSA0K
PiArDQo+ICt2b2lkIG1pY3Jvd2F0dF9ybmdfaW5pdCh2b2lkKTsNCj4gKw0KPiArI2VuZGlmIC8q
IF9NSUNST1dBVFRfSCAqLw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9t
aWNyb3dhdHQvcm5nLmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9ybmcuYw0K
PiBpbmRleCA3YmM0ZDFjYmZhZjAuLjhlY2U4N2QwMDVjOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvcm5nLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL3Bs
YXRmb3Jtcy9taWNyb3dhdHQvcm5nLmMNCj4gQEAgLTExLDYgKzExLDcgQEANCj4gICAjaW5jbHVk
ZSA8YXNtL2FyY2hyYW5kb20uaD4NCj4gICAjaW5jbHVkZSA8YXNtL2NwdXRhYmxlLmg+DQo+ICAg
I2luY2x1ZGUgPGFzbS9tYWNoZGVwLmg+DQo+ICsjaW5jbHVkZSAibWljcm93YXR0LmgiDQo+ICAg
DQo+ICAgI2RlZmluZSBEQVJOX0VSUiAweEZGRkZGRkZGRkZGRkZGRkZ1bA0KPiAgIA0KPiBAQCAt
MjksNyArMzAsNyBAQCBzdGF0aWMgaW50IG1pY3Jvd2F0dF9nZXRfcmFuZG9tX2Rhcm4odW5zaWdu
ZWQgbG9uZyAqdikNCj4gICAJcmV0dXJuIDE7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIF9faW5p
dCBpbnQgcm5nX2luaXQodm9pZCkNCj4gK3ZvaWQgX19pbml0IG1pY3Jvd2F0dF9ybmdfaW5pdCh2
b2lkKQ0KPiAgIHsNCj4gICAJdW5zaWduZWQgbG9uZyB2YWw7DQo+ICAgCWludCBpOw0KPiBAQCAt
MzcsMTIgKzM4LDcgQEAgc3RhdGljIF9faW5pdCBpbnQgcm5nX2luaXQodm9pZCkNCj4gICAJZm9y
IChpID0gMDsgaSA8IDEwOyBpKyspIHsNCj4gICAJCWlmIChtaWNyb3dhdHRfZ2V0X3JhbmRvbV9k
YXJuKCZ2YWwpKSB7DQo+ICAgCQkJcHBjX21kLmdldF9yYW5kb21fc2VlZCA9IG1pY3Jvd2F0dF9n
ZXRfcmFuZG9tX2Rhcm47DQo+IC0JCQlyZXR1cm4gMDsNCj4gKwkJCXJldHVybjsNCj4gICAJCX0N
Cj4gICAJfQ0KPiAtDQo+IC0JcHJfd2FybigiVW5hYmxlIHRvIHVzZSBEQVJOIGZvciBnZXRfcmFu
ZG9tX3NlZWQoKVxuIik7DQo+IC0NCj4gLQlyZXR1cm4gLUVJTzsNCj4gICB9DQo+IC1tYWNoaW5l
X3N1YnN5c19pbml0Y2FsbCgsIHJuZ19pbml0KTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJw
Yy9wbGF0Zm9ybXMvbWljcm93YXR0L3NldHVwLmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21p
Y3Jvd2F0dC9zZXR1cC5jDQo+IGluZGV4IDBiMDI2MDNiZGI3NC4uNmIzMjUzOTM5NWE0IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9zZXR1cC5jDQo+ICsr
KyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L3NldHVwLmMNCj4gQEAgLTE2LDYg
KzE2LDggQEANCj4gICAjaW5jbHVkZSA8YXNtL3hpY3MuaD4NCj4gICAjaW5jbHVkZSA8YXNtL3Vk
YmcuaD4NCj4gICANCj4gKyNpbmNsdWRlICJtaWNyb3dhdHQuaCINCj4gKw0KPiAgIHN0YXRpYyB2
b2lkIF9faW5pdCBtaWNyb3dhdHRfaW5pdF9JUlEodm9pZCkNCj4gICB7DQo+ICAgCXhpY3NfaW5p
dCgpOw0KPiBAQCAtMzIsMTAgKzM0LDE2IEBAIHN0YXRpYyBpbnQgX19pbml0IG1pY3Jvd2F0dF9w
b3B1bGF0ZSh2b2lkKQ0KPiAgIH0NCj4gICBtYWNoaW5lX2FyY2hfaW5pdGNhbGwobWljcm93YXR0
LCBtaWNyb3dhdHRfcG9wdWxhdGUpOw0KPiAgIA0KPiArc3RhdGljIHZvaWQgX19pbml0IG1pY3Jv
d2F0dF9zZXR1cF9hcmNoKHZvaWQpDQo+ICt7DQo+ICsJbWljcm93YXR0X3JuZ19pbml0KCk7DQo+
ICt9DQo+ICsNCj4gICBkZWZpbmVfbWFjaGluZShtaWNyb3dhdHQpIHsNCj4gICAJLm5hbWUJCQk9
ICJtaWNyb3dhdHQiLA0KPiAgIAkucHJvYmUJCQk9IG1pY3Jvd2F0dF9wcm9iZSwNCj4gICAJLmlu
aXRfSVJRCQk9IG1pY3Jvd2F0dF9pbml0X0lSUSwNCj4gKwkuc2V0dXBfYXJjaAkJPSBtaWNyb3dh
dHRfc2V0dXBfYXJjaCwNCj4gICAJLnByb2dyZXNzCQk9IHVkYmdfcHJvZ3Jlc3MsDQo+ICAgCS5j
YWxpYnJhdGVfZGVjcgkJPSBnZW5lcmljX2NhbGlicmF0ZV9kZWNyLA0KPiAgIH07
