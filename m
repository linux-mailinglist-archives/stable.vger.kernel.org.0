Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135384CAB5B
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiCBRSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 12:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiCBRSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 12:18:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C37D1EEEE;
        Wed,  2 Mar 2022 09:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646241451; x=1677777451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B+2ywSEmrRm8QQ0H0X3O62qncFRSCjI/UzJnQxbK6qw=;
  b=AGT1dyRA4TPcqwQCUYolUMFUYZvH7VQSoSOgpKwXh5uUUr05VffstEnp
   gFlwbvmXz4frwjgpX8992dfBTtwWdG9RyxvoNiSyzs/8WOZuZ0fY7WlK+
   KZiD390WS7uErnFF7HGOHB0RgcJOTy2JgLUiKN5WjPe5socOyG2wVBWdq
   RXgFqZcL5cv9bhdEtdYNkNTZqRe6LvBVZooa6HCZ+rPIjMn322P1s21y5
   n7YacrrdnD+M6RiSSYg4/xg+OaXKSJYBfy7sP4hQiagJCJ5JC7fP801m7
   51wLKUUr839Zo4cZZ7HElDz+S+UGmegiCZnJGo2t/01D3ilLoJXXolT4K
   w==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643698800"; 
   d="scan'208";a="155452228"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Mar 2022 10:17:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Mar 2022 10:17:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 2 Mar 2022 10:17:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgGlY4UfsOuaPpUdha7d+R+6Kcz+vY6fezMncRbscFOgCEt8jELMe9PH46RACZ4Q+dqGNxVUf8INLl6fmBJn3j/XnbIkxiDk+41+96LvkpUft3x7Zqvssccalk6ne/dhZsuRkKFb4Ge3l+3N/ndt8blrp2wXoJWwLOH28MpMtfZnWtM+ib7hcP2QQxZeeJPpHUYIr8xZc5zquwQMJqH+iPXZv/crDoQ44oLzxez4ZL3eeInJ4cMezVIongcONtpd2mKpPmpD3pARx1krlWUDnHQF6MbbZtS0PO4J2S7YD4kdhFSzcQM8BlEt4cyleZ16aHJDeY1CDcnh0QrvsxZRMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+2ywSEmrRm8QQ0H0X3O62qncFRSCjI/UzJnQxbK6qw=;
 b=KoJSTLX6VaEBzRWQfYhq8S8lB1UxGCj6sMjIpXjs1kLeOHvdyCS3gSEnVm9KLfxFsj9PptgSo8jG7UOP/oc0agcsfT0bZcZPN0aQubfN2wFFGTiYexrYlEHB5SGuPUVj3zri2s/EC5tgL0Yzv5MNqycdLaeFYdAdflBhFrcOxH+bysv0lXpTXjr3dFE3v8C+ro/iYDU8Tny6rrUSvonAKZqLKILq/afxQf+pvige8A3Our1VERAiNXDfo0+6cEX3KCqUvuSSRtxm9TbcYo3aJkZz/IFCOBQgOZBJIEHJEs+nGLfOwVR8FwDcZF5+YfzPuWGZGy5+YZvWDhMlLd+/+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+2ywSEmrRm8QQ0H0X3O62qncFRSCjI/UzJnQxbK6qw=;
 b=k3lZ431YP992AOp7CMfGm58EreIcyUxtfxqwhPPw0yFmsIaB7VnGuEaiiLi1OyxHlxH6CHDZIsl1/z+BNgyFoAgLXBLdb22B92bwXxQEKB/Sm9IgOUfYLHqMg1kC9/Ns9eWKAmp8MGM27Soy0eS69M7NMfYeGOlVr1ZdYaQI+a8=
Received: from BL1PR11MB5384.namprd11.prod.outlook.com (2603:10b6:208:311::14)
 by MWHPR11MB1901.namprd11.prod.outlook.com (2603:10b6:300:110::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 17:17:18 +0000
Received: from BL1PR11MB5384.namprd11.prod.outlook.com
 ([fe80::11a5:42e0:3f3d:fcdc]) by BL1PR11MB5384.namprd11.prod.outlook.com
 ([fe80::11a5:42e0:3f3d:fcdc%9]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 17:17:18 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <Tudor.Ambarus@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <robh+dt@kernel.org>, <Codrin.Ciubotariu@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Sergiu.Moga@microchip.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: at91: sama7g5: Remove unused properties in i2c
 nodes
Thread-Topic: [PATCH] ARM: dts: at91: sama7g5: Remove unused properties in i2c
 nodes
Thread-Index: AQHYLlE65Sce7OoYCUG3wldlDygNBqysVhgA
Date:   Wed, 2 Mar 2022 17:17:18 +0000
Message-ID: <40cf7852-5b7e-7991-2faa-bfdddc3a2822@microchip.com>
References: <20220302161854.32177-1-tudor.ambarus@microchip.com>
In-Reply-To: <20220302161854.32177-1-tudor.ambarus@microchip.com>
Accept-Language: en-US, ro-RO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd9b22df-eba2-4651-9d1a-08d9fc70812e
x-ms-traffictypediagnostic: MWHPR11MB1901:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1901510039F4A5B44BFB3FECE8039@MWHPR11MB1901.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvHISeeA2BVOrvissAiizs99i4n6fAn6x6CQCpeA0YLvh/D/TJHe0EV+3FiMDdOVxX0XfVNkqHIe244KUtywiWYobMJQhGOp+LJIqoSBBNoIidu3ZvC1QexrPl6HEod+XKQHARteP1Cy4ryNlngJ8Aflt9iGKSnNcdlE9YWa24KoW4F48sbHpL/eO4+/AfQuYpVHFoDW/WRCQA4k+qWuOXeXmx4gqA+CTxvYWXFwyW+4zX+V/hrkRnVcJwoiBqzZIqle7G424OGye6tUAaIQyv1VEgoKkwTAhtL700mjBzKXolJzAVvKWhm6FgJneBeoCXnmGz0jQxsoEdkEjYwwX6anpoXuqfVVwV13wvwNeg8YXvR8JEDcZwc0qkksX6gBXos+zwoDix5n97xTEjH8abs7Rg2fZG9e0C6ZlTt1HolB8q+5bd6Z98How7Z3VEaYOSRUYG8O/V5zuH8zPugLVxop91WnDcECTWBQ67NIHTunoMcZbvzlyN5qHIPA2WqMFT4Q9UpV53XKNsFTZw0io/b51H9jnJ4sr09jaJZTj++fSzbUF4ADFdYlwMT7BvhcV6St5PVHKZf4M7Y0Hce75aVqeGOjJQqzCBJAE8+vkKm5ejyoGvgN/BcTvERdMTKozneGaC07aj22vLElOEpx+HQkAh7JwjPbr2Ey1p9IxWHUEYQcP2TLvZNqP0FyzQn0km7ZBkTR5I8tZo8c9BEq6fyJ5qg1FQCtHSoDfxKPqslcUcjImBUNlDC2t10fhzEZYtwGXPeDpS4XhQVjBC2qMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5384.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(38070700005)(76116006)(66946007)(66446008)(91956017)(122000001)(64756008)(66556008)(31696002)(66476007)(86362001)(8676002)(4326008)(71200400001)(38100700002)(54906003)(110136005)(36756003)(83380400001)(6506007)(31686004)(2616005)(5660300002)(2906002)(6512007)(186003)(8936002)(26005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SG1oVFpxeld6WDk4MXptSFZUaERCSmlrWjA2bmtGb2ZCZTM3T1h6aFdBbFB2?=
 =?utf-8?B?Z1MzSUdMK3hTTko5N2RONGowWC9hUnk2WWo4QjFjcytPNjYxcjk4MnZsRUZB?=
 =?utf-8?B?ZDBxeTlDL1NaaEFtenE4L01WWGExd05xNWUyY3dDNDVyZ3NZYUlMRDVnMGFX?=
 =?utf-8?B?UFU5V1lIcDlxdDhkcWwxaWk3QW5NeXZjTGNjNnc5b1g5Ny9YWTE0MW56cnlQ?=
 =?utf-8?B?a0g1TEpKMTF2SDJOQUFhZjl6NVRCSS9LcnhpUVNUenY5R1lnREp6YlN4aG9o?=
 =?utf-8?B?QkNhSUtuSk9SbnNBT1I3eHRUbTJGMTR0NW9CcFR0TEZPQlRYMmZBeHNGTnhN?=
 =?utf-8?B?RFBVMkR0dlZLdmkyUDMyRk5YN3RHL1c0dmhGblc4dVZFZTdlL1kySFYvelZL?=
 =?utf-8?B?ZUUyOTlLZ3JuU2RONGFDWDgyY0NrcElDa0x1M1ZXODArU2pHSUxsaTRjQjlX?=
 =?utf-8?B?NTk3MG5oYmU1RW56RVg1TWptU3VzZWEydDNSQS9pblZGSG5BNFNpeDU1QWll?=
 =?utf-8?B?LzBUTDk1UXpySVIyZHRkTmhsL3RsRXcya3g5NzdGSExzeEVGbUVyRlRnV2FT?=
 =?utf-8?B?ZzB6TFBDcExFa01NYjNselkyTjFFQUtRaFZYazhEZmw4Q3VqY3RkajBpSUxD?=
 =?utf-8?B?NThVb2ZqSENNL1lxcTFGbzI3SFpaV09MQ25ZNWM1YWtZRTJlUjJrbURlRFdp?=
 =?utf-8?B?eXBTUDREbEhHOVN6RkhCM3pwOU1Oa2xldFFQRTMvTmRDVE5JZWZqZmRBYWdm?=
 =?utf-8?B?YmFXdk9UZGYrNmF3TjRRSFlkMEplWU52dElPbEkvNkEwZ3BMbzB4TzlGWG9G?=
 =?utf-8?B?bUZ1M0ZhY3lkYlkyZzVmOXhPWnViZS9lSGpGMVRlQkZEMW9TalBaWFh5dDNT?=
 =?utf-8?B?RksxVUJaL2Q5T2NjL3F1SU5DOHdOSkkwbEJMYkNDWTJUS21MSTNRMjI4NWNy?=
 =?utf-8?B?UHBUY1dDVEx1Q3ptektrQW9BRU5rSnhvRVBEaEs1SitPREJ0dFppYkVnZ29x?=
 =?utf-8?B?TzFMN2Rwc2EzVTVrMG82bUpnMDYvQWtjS3FTUGVNQmpQdzBXUmppa3dpNHgy?=
 =?utf-8?B?dHRhdzdZVFZxTGNBdGtZb2NrNDAzVWlvNkw2UnVMSWRpNk0xcnJwdVBIcFVa?=
 =?utf-8?B?eC9tZ3BmSEs2Z0xPeVZ3Q2xBMEZPZnBNTmpsNnpTdC9MYW5ObC9IZzZDK1R2?=
 =?utf-8?B?eGpKNHI1NkIvR1NTejU4MTAvRWpKQy9jeU9tcmtHckxTNzRjM3pXSWdhc01G?=
 =?utf-8?B?VWxlalgrVEQzOGdmMjFFbW4xRnQ4ZllZTXFwcjltb3dTbWUzUjE1ZWFKdFpV?=
 =?utf-8?B?VlA2aXNER0s2VG9EMTh5aEcxSllKaGF6bndVRHlETXJvTU9VeHNhTFNjOXhL?=
 =?utf-8?B?a2F4eFJhRHZEOWxibGcxYlRVajIvTWliS3U0NEhtdlBjaERKMmFmZEQ4NHZP?=
 =?utf-8?B?OUVmNFZiejVxaWVDN3QxeGg4YzBhc2toaVZwTHlWdENnK1N4K09CUEs4cFVP?=
 =?utf-8?B?N2loU0J2alVGbkZrK3Y1UEt6bGpJazlIS1VEK1JmSW9qek8vM3QzK2loeStw?=
 =?utf-8?B?N3MyNFpSWWQrS0lJMEJvTFRuMWFvSHJBTU9NS1NOTkVVTTBxV0cwejc3QjV2?=
 =?utf-8?B?RjdTdFRIbldVdUJOZ2hKTVpNcHh6amdXSUhDaDJvZTdGQ0UwQm1idDF2Q2ZW?=
 =?utf-8?B?d1BnTUJaeGczeTdFdm5lcnAzdnA0NnlMbC9DWnZuaVcxRjdYQ21lcVo4SDgv?=
 =?utf-8?B?RzFnREhXa2x5TWdHQVRFY09TNHhzeGNJcW95bHdnYXdMSmtMNU81YUczNWs0?=
 =?utf-8?B?cE5qcFVTTVJaeTA1QURhMGdscEtUTjZOUlU3WVpXL2JLdGg4TW9pdVUvVzRo?=
 =?utf-8?B?Z29UdGdsQnJxYktObGRxMzVlYWo3NW9hZUIvK3dIWDJJWDhQeHJaajZGOURF?=
 =?utf-8?B?U1dGS0VQcGN4NG9yUndveGc2NGdtbWhYenNzY2VNczZ3V0xYU1cvdjF4RC9a?=
 =?utf-8?B?eHNaSm5PWCtLSURrWE1XUkN2ZXpBRFdZMGgvWVFJZ09EMHBMMERWWE5zT2RZ?=
 =?utf-8?B?Z3lLbnBheU5IYnBuVG1DSDVndmNac09KR1FrVzlWUmhaSnZ6Ym56c3V4Y1BF?=
 =?utf-8?B?VEtFS0FXbk5LS0xUczlHVE1ZR24xNFVldjZPTkM5Wk1va3ZLSXlIbUdPcER3?=
 =?utf-8?B?c3l3Um5DRk9uT2F2NkxBb3hPS2NiekloM0I5eXluRHRwYm1PaEkyWEZUT3Bv?=
 =?utf-8?B?WG1PbzFwN2JOMG05d2dTQzB1b0p3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7D4AF295E4B2746B6DE8BDB11C664EB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5384.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9b22df-eba2-4651-9d1a-08d9fc70812e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 17:17:18.1144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3wQHBv9eUuqFV27i62YciM3kTFketMs0QMol60pc9rWdCaTDDcFXtN03WSrMNcUvM1xH3GofbqNcGMz6KUGFMTfC2TT4iSz3uMyctH73j64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1901
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8yLzIyIDY6MTggUE0sIFR1ZG9yIEFtYmFydXMgd3JvdGU6DQo+IFRoZSAiYXRtZWwsdXNl
LWRtYS1yeCIsICJhdG1lbCx1c2UtZG1hLXJ4IiBkdCBwcm9wZXJ0aWVzIGFyZSBub3QgdXNlZCBi
eQ0KPiB0aGUgaTJjLWF0OTEgZHJpdmVyLCBub3IgdGhleSBhcmUgZGVmaW5lZCBpbiB0aGUgYmlu
ZGluZ3MgZmlsZSwgdGh1cyByZW1vdmUNCj4gdGhlbS4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnDQo+IEZpeGVzOiA3NTQwNjI5ZTJmYzcgKCJBUk06IGR0czogYXQ5MTogYWRkIHNh
bWE3ZzUgU29DIERUIGFuZCBzYW1hN2c1LWVrIikNCj4gU2lnbmVkLW9mZi1ieTogVHVkb3IgQW1i
YXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0KPiAtLS0NCg0KVGhhbmsgeW91IFR1
ZG9yLA0KDQpSZXZpZXdlZC1ieTogRXVnZW4gSHJpc3RldiA8ZXVnZW4uaHJpc3RldkBtaWNyb2No
aXAuY29tPg0KDQo+ICAgYXJjaC9hcm0vYm9vdC9kdHMvc2FtYTdnNS5kdHNpIHwgNiAtLS0tLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL2FybS9ib290L2R0cy9zYW1hN2c1LmR0c2kgYi9hcmNoL2FybS9ib290L2R0cy9zYW1hN2c1
LmR0c2kNCj4gaW5kZXggMWRjMDYzMWU5ZmQ0Li5lNjI2ZjZiZDkyMGEgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gvYXJtL2Jvb3QvZHRzL3NhbWE3ZzUuZHRzaQ0KPiArKysgYi9hcmNoL2FybS9ib290L2R0
cy9zYW1hN2c1LmR0c2kNCj4gQEAgLTU5MSw4ICs1OTEsNiBAQCBpMmMxOiBpMmNANjAwIHsNCj4g
ICAJCQkJZG1hcyA9IDwmZG1hMCBBVDkxX1hETUFDX0RUX1BFUklEKDcpPiwNCj4gICAJCQkJCTwm
ZG1hMCBBVDkxX1hETUFDX0RUX1BFUklEKDgpPjsNCj4gICAJCQkJZG1hLW5hbWVzID0gInJ4Iiwg
InR4IjsNCj4gLQkJCQlhdG1lbCx1c2UtZG1hLXJ4Ow0KPiAtCQkJCWF0bWVsLHVzZS1kbWEtdHg7
DQo+ICAgCQkJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQo+ICAgCQkJfTsNCj4gICAJCX07DQo+IEBA
IC03NzgsOCArNzc2LDYgQEAgaTJjODogaTJjQDYwMCB7DQo+ICAgCQkJCWRtYXMgPSA8JmRtYTAg
QVQ5MV9YRE1BQ19EVF9QRVJJRCgyMSk+LA0KPiAgIAkJCQkJPCZkbWEwIEFUOTFfWERNQUNfRFRf
UEVSSUQoMjIpPjsNCj4gICAJCQkJZG1hLW5hbWVzID0gInJ4IiwgInR4IjsNCj4gLQkJCQlhdG1l
bCx1c2UtZG1hLXJ4Ow0KPiAtCQkJCWF0bWVsLHVzZS1kbWEtdHg7DQo+ICAgCQkJCXN0YXR1cyA9
ICJkaXNhYmxlZCI7DQo+ICAgCQkJfTsNCj4gICAJCX07DQo+IEBAIC04MDQsOCArODAwLDYgQEAg
aTJjOTogaTJjQDYwMCB7DQo+ICAgCQkJCWRtYXMgPSA8JmRtYTAgQVQ5MV9YRE1BQ19EVF9QRVJJ
RCgyMyk+LA0KPiAgIAkJCQkJPCZkbWEwIEFUOTFfWERNQUNfRFRfUEVSSUQoMjQpPjsNCj4gICAJ
CQkJZG1hLW5hbWVzID0gInJ4IiwgInR4IjsNCj4gLQkJCQlhdG1lbCx1c2UtZG1hLXJ4Ow0KPiAt
CQkJCWF0bWVsLHVzZS1kbWEtdHg7DQo+ICAgCQkJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQo+ICAg
CQkJfTsNCj4gICAJCX07DQo+IA0KDQo=
