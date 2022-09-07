Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38A25AFFE0
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiIGJGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiIGJGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:06:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172235FBA;
        Wed,  7 Sep 2022 02:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662541608; x=1694077608;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YM4C0UJi9PQPGV4RYrSE1o3h8r20Qs/aQ7g3GvrA94U=;
  b=cJA4rona2UWBf5zUGXQaIpW638Ws8mZ+q+se3QBAA62NVcOyd/7TqrDb
   zCy6kEy7Q0E4h35a6adi9L4AfhwW0YcTo87FHZ1l2EBiP1Kq4G2KGXNOA
   X67hMmePSTC7rwmUGMUnKdpBkRNELrS/n0q+SAdGpjSuHbO3M9YAtXnL0
   wNQxtck9IZvD8ctLS66KVnlbBHnQ+EgO4FYjHo4BzEs2VVUOmugrySPao
   NwjRLyKvGyLctVfrJ2EZxOClr4GEme7Ur0VZqvz1Bo1/FBAYatbHfj8GW
   KJqmJYD8I9o8ewrcP0jSBTQjJ8myTZ9E/2K2UaVpjir8283500cd5JtpJ
   w==;
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="172731095"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 02:06:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 02:06:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Sep 2022 02:06:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In5u17k6d5H9e/NfEWB+gzqex5zA8LuGcn5ayr27qfivF03TYrJ3wkvyC5QsKRgqP27RnwoecrWJ88I2zHMms0ySozdhyiir+OowSVDWrnp+zJ+0Rz4V7X7A2tBL7ALcD9yrJ1lt7JEj0KqlJtgBmPW4gXw0A34k2hAoj8CjNzeLyAbnD6zVAF6kzIvANbX3nWeZyyNxjC3uQF6buuww1A9Xzjis2d5mjB9A4+dwbXq7cPlPEjENFOvZhh4td2uJR2gSN8STeUuD6h6gMjoUkFX7xt96HAm3x76aCDmQs0gcu2Xieef0hofkwVRoB5p1XyW/QA6duWfWL5rNts121Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YM4C0UJi9PQPGV4RYrSE1o3h8r20Qs/aQ7g3GvrA94U=;
 b=CxiAf6QwZ/wpo8JJeApCz6QYd/M9Vsgm0gOw7M1yxhDr8WH3c7l87Q7pWGyIgVCcRPAsA4LRRvgh0HhTpM8Qmrptnz2dlAn4ueFoannULHdux1uBzFBCzA8zwOepCciVwVnfN91bz/4JTnKe96fQCzZj+716TdYq42GdvM8F3WURYSXvRxrPGC/tWWCyYBUz8t2e9nWs4gMNIh3mbbV5H0EZ1pmI8mjZMPUL4qGnfKns3fQVBFo+dQdDDBPwJgvcFHrDm2yhvG195hVTlsXbJeY/9AfFN8hZk9LK0ykdNT3ViQdKQbyDfoGPsV9XVuRF3XMdOjJdGrg/LM/pjt5/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YM4C0UJi9PQPGV4RYrSE1o3h8r20Qs/aQ7g3GvrA94U=;
 b=tWh1xUY2oSXoR+eqbMG1V0JlA7xAvt75QoAAfJ7wrfe8b75HgYBXhL80SmCqOEFgytn3pzK2Rd273zPl0yLkZ6yxOugq4Z+9EogFzuXOKPeNu7H1EilOnjpiAnQxYjBSXoKCreLUq0HBD34rvowMq2sEWdyNZCnr5U0B0Ck+NAQ=
Received: from DM4PR11MB6479.namprd11.prod.outlook.com (2603:10b6:8:8c::19) by
 DM6PR11MB2874.namprd11.prod.outlook.com (2603:10b6:5:c9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.15; Wed, 7 Sep 2022 09:06:40 +0000
Received: from DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::ca1:6392:bc2:8338]) by DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::ca1:6392:bc2:8338%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 09:06:39 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <peda@axentia.se>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Claudiu.Beznea@microchip.com>, <bbrezillon@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Thread-Topic: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Thread-Index: AQHYwpkoL5Ep9vCWYUG2OKyYBcNYJg==
Date:   Wed, 7 Sep 2022 09:06:39 +0000
Message-ID: <86158844-b314-bee8-c5b8-0b757c6b6ab0@microchip.com>
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
In-Reply-To: <20220728074014.145406-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46707ffc-3e71-44ff-3818-08da90b0463e
x-ms-traffictypediagnostic: DM6PR11MB2874:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0phJXeCXwa/XhwVgqOnrZGk7wL4nlryhAWRV/zZ/D+9CjYmQl4aZfBhvIJKBgRsmlXa59cipTW566D2bdIq4/z02DLsEcBwHOkZmwkI24XSnOtcOPirh1+erYoPpn1BkpXw/gZ1zIP0faNLw0EdyHHzsNw+4FlTyTG4didMYIBUb6RFFgPZSsAhPe1jRVjGfHIUS6RCXYANvFO9Zn+gqgFMxo2D0FzGqC830tWmW2UYAURQljDqPgqOBNxUDJa2KX6fOTZiSBxwnkXs3++TaJ69Vz4ZH7gHK4Hd9w4XaP/jqREWYvfGdyfGrakI+aWJp01DdzWARTLftvmNZm9M6idxHsDNPJzPGlVbTtjttC0KOEsn3Wjc9cD2a+BHuD1bnZayJCX1Bgb8NC+uW/VpfOO4Gr+bnQtZYwxAI6fZWOgJ/Q/al1WZBjKN3VZrg3cuYaKbz+fNY78EoLq9LephgrPPkhGP0TFg8qpkfsouIaIxdFxBk0X/VajOyZxYZAyHNADzPU7eKpQTLqjDDgMpLtEx+m7gL0KS2xVbCPJXqG9JnILiekdbDpoSxsIdMUlG2kIGV8Gv+rgZQRX4Op6Lh1jTiP0/o2fkZcIUfqO1pVMTXYLmzoRwxe4UOZwmIyL28d/nNBJnWUUITQeNZ3ahU5/BBSH+il/tOjiWvG5rQPGwQ08p7zRgKbxXHxv76ht0ufbwDECeGr+Wk1E93bL+d2IeMBRScI3IVJ+aBeDrIhik0BjOuwZTRmZ0wTBl9rcyZPczVmr+vT9d3vlo1+QScI0IF2DlwfFJOZ7p+LxE+a3eOqFdu8ZWwu/BqJDWqwzkOovS4mi4g6vnCRMqS7jbp6JDQ6XOQ1/Sj2Qp8gs63DxQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6479.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(366004)(39860400002)(136003)(31686004)(122000001)(316002)(31696002)(86362001)(38070700005)(6486002)(71200400001)(966005)(91956017)(110136005)(54906003)(36756003)(38100700002)(26005)(6512007)(6506007)(53546011)(41300700001)(64756008)(7416002)(2906002)(66556008)(2616005)(478600001)(186003)(66476007)(76116006)(66946007)(8676002)(4326008)(66446008)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czYrdTdnbE5HSC9xRmNIb0k1ZlY1MVAzK2k0bW1mMEpOZ2JLdllpbTY0VG41?=
 =?utf-8?B?UEtNVE1xUHRmVXVXQUdaSmNoZTZvNHZJZ2NPV3hhNTN1SnlXUkoySStXSHlW?=
 =?utf-8?B?QmVtZHloczg2ZVR3ckd5K0RPYlFocTkzQUpJUEdoOG1ZenVsY1FnNCs2MEJl?=
 =?utf-8?B?SVMzS3ZqNnFGR3VoNUhjSmhvY3ZnUEU2U0pJNGlEc2pYbjM3MExCaEFqNkd2?=
 =?utf-8?B?ZG12dzZ0ZmFDK0UyQVdZZ1I5ejBxSlM0Z1owQUE3TnpGM1oweVYwTDMxbkZY?=
 =?utf-8?B?bFZadENDTVFhSUsrVnRuSlpkam9OTmUzZEs5cFhIdUlSWE5kbXRYd2M1MWY5?=
 =?utf-8?B?STBRMERtY1QweEN0cFRmamxseXpoeVdGZkVFYno0V0h1VkR0T3k4Y2d6aDk2?=
 =?utf-8?B?SnBaY1cyaXFQRGpMM0pmLzRUZDVRWG1zRXo3WmQrUzFQMUd1VTYxSUZBRGw1?=
 =?utf-8?B?T1VzNGIrRnVSZXhJMWxsQ0tndmM4eFY4R1IxYjY0QXpVSTR2TCtZQ0YyWFk2?=
 =?utf-8?B?cGUzSkY5L2JZYnVKdEh4ajJTV1NsYi9VeEF3dWx3UkFWRFFvdkFtVGpXRUxH?=
 =?utf-8?B?VS96NndKQTQxcWpDQjRLbGZxampKTG1VTWI2MGllNWtkSjBvRjFmOFloTFJs?=
 =?utf-8?B?cjhKODA3b3grOTVvTFRqR2cram5CeTU1emFQY3RGZ3IzQzNjT2swNUNTOEkx?=
 =?utf-8?B?Mzl2UXBkQlJab25WYzU3anpJaXZqTmI2K3BJMWVqWnBjRWF3cGVDSkJNN2hT?=
 =?utf-8?B?dmF2ZlRQWEVJUW1tTzQ5VkFybWNkdXRlcXZrYk9sZ1JYR3R4SGFkdFJ4akQv?=
 =?utf-8?B?NjU4YVJQdWVaWll1eU9BQnVVSDhMSzh6NjVGbUNiaUNKTklVU01TZEx5UUhw?=
 =?utf-8?B?ZEhqRkVzTUNGa3ljcFdvcFJ5RG5KL3dwdGd1WUYwbDlLN094NTRMQnVlQ3RQ?=
 =?utf-8?B?Y1YyR25IdURQc0dZeG1LU3FEdnVrZ2dDN1hHNVMwbnZZNFJYbUE5S3RlS3dP?=
 =?utf-8?B?S04vWXFyTkoxVlZhMzV1OTVaMEtCaFlPcFZCVWlwaWtoVmtWNHFDc24zcVVT?=
 =?utf-8?B?aW5vbVVBVXpwL2FzZHFhNEFFL0pKcVJIT0hoSGtRbnp4bzhnZ1RKRW5Tak5i?=
 =?utf-8?B?aEQ4bjNxRVpJa3F4SWlQNkNEVWtoU0NzdGQzWXBaMkJib0V4cG42V09NSVc3?=
 =?utf-8?B?S09CS3EwM3U3akhyK3hWbitOMUpHWW5CWTU3UWNMeVhZMjFLZ0ZleUtzZFgw?=
 =?utf-8?B?ZXREaUZ4dFlnRXl2Ry9zWW53c084eXFPZ2c3a3pVRXRXNTVRaTlDVjhJanNP?=
 =?utf-8?B?MDlkNFdvQ3JnR2tmSW5DR1BMRmpNcmxITVRwTUNTa0lyL3k2QmdKRHRMOW9B?=
 =?utf-8?B?MWRxRHNYbzZpYmppYU5VMnBEVUhQcFhwL081amYwb2JwWGxoczlPeW14MnZx?=
 =?utf-8?B?bklIRU95LzVHMG1QOG0wUjhob3M4UDJqNXprWEM2eU14REl6c0hoR0ZyeC9C?=
 =?utf-8?B?TU5IWmpNbDloTkFXUDdUSWtOajJFNVhhUnl0YTNvMExkRE5XREl2N21HZzIz?=
 =?utf-8?B?V1pYNHVYTC9CLy9NcUtrR2hmQ3E1emwrbFhsYVJuS2tBeDVmRzFGK3pHR3JJ?=
 =?utf-8?B?cllJWjR1S0JkcHVuMlhvc0ZaYmd0YUNyUnNjaWlQUXZERXNvdHFXbUFPSE5z?=
 =?utf-8?B?emxaUVIwanNYLzBJNDdhaURwemtWd0pseTFWTUNMQ0lheXE0d0tXVzlVYkNH?=
 =?utf-8?B?MGQ1OGc0V1RJZlJLSVFvMXV1L2dPT29BWSt3Nk5SeU1HOFNFbzRWL2NLSXdS?=
 =?utf-8?B?SHUxa20yS1Y1K0t0dUlIZDh3Z3NvbmRMOFRsYXp0V1hEemRENkNnZHM0ZmVH?=
 =?utf-8?B?d2M3bTRwU05zV2piR3BXeFM4REY1L05KbmozK1MzRG5QQ3dtKzJMQ3JYNi9n?=
 =?utf-8?B?VUo2ZytjeGQxRjNsRWVmOGpVWEc2dTRaOEJvTk5td0wvc2kweHFId3p3bHhk?=
 =?utf-8?B?SVNkNmV2WDBvaWN4T3YvWXVVUjgrUENOQ3ZlZ1VCR1UvQS9ldGhYcGY4empr?=
 =?utf-8?B?NjQ1UGtiWlM3WnRNVUlNWHpqZzZEVXBOaGs0dGViT0tibXo4QUVLSVg5WW1q?=
 =?utf-8?B?WW5rMkpJamp0R1VwaVBuUkcwZGFzS3Z4N3ZVR1k1Z2hjMU5VSDhYNExwNXBw?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1A3D7C819AA0D4498C8D7EFB48EEF88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6479.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46707ffc-3e71-44ff-3818-08da90b0463e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 09:06:39.3160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LA6EFL+Z5Ke3C7i7koLkKYrT1T51/YQw9LAkXeS/NbOicypIyKBGyTGNQlFqw0mKolMszY4BVWWX2WBV+IMtSuIpXf+Qh8OgTyXXvqAHKSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2874
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8yOC8yMiAxMDo0MCwgVHVkb3IgQW1iYXJ1cyB3cm90ZToNCj4gRXZlcnkgZG1hX21hcF9z
aW5nbGUoKSBjYWxsIHNob3VsZCBoYXZlIGl0cyBkbWFfdW5tYXBfc2luZ2xlKCkgY291bnRlcnBh
cnQsDQo+IGJlY2F1c2UgdGhlIERNQSBhZGRyZXNzIHNwYWNlIGlzIGEgc2hhcmVkIHJlc291cmNl
IGFuZCBvbmUgY291bGQgcmVuZGVyIHRoZQ0KPiBtYWNoaW5lIHVudXNhYmxlIGJ5IGNvbnN1bWlu
ZyBhbGwgRE1BIGFkZHJlc3Nlcy4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IEZpeGVzOiBmODhmYzEyMmNjMzQgKCJtdGQ6IG5hbmQ6IENsZWFudXAvcmV3b3JrIHRoZSBhdG1l
bF9uYW5kIGRyaXZlciIpDQo+IFNpZ25lZC1vZmYtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFt
YmFydXNAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL210ZC9uYW5kL3Jhdy9hdG1l
bC9uYW5kLWNvbnRyb2xsZXIuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbmFuZC9yYXcvYXRtZWwvbmFuZC1j
b250cm9sbGVyLmMgYi9kcml2ZXJzL210ZC9uYW5kL3Jhdy9hdG1lbC9uYW5kLWNvbnRyb2xsZXIu
Yw0KPiBpbmRleCA2ZWYxNDQ0MmM3MWEuLjMzMGQyZGFmZGQyZCAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9tdGQvbmFuZC9yYXcvYXRtZWwvbmFuZC1jb250cm9sbGVyLmMNCj4gKysrIGIvZHJpdmVy
cy9tdGQvbmFuZC9yYXcvYXRtZWwvbmFuZC1jb250cm9sbGVyLmMNCj4gQEAgLTQwNSw2ICs0MDUs
NyBAQCBzdGF0aWMgaW50IGF0bWVsX25hbmRfZG1hX3RyYW5zZmVyKHN0cnVjdCBhdG1lbF9uYW5k
X2NvbnRyb2xsZXIgKm5jLA0KPiAgDQo+ICAJZG1hX2FzeW5jX2lzc3VlX3BlbmRpbmcobmMtPmRt
YWMpOw0KPiAgCXdhaXRfZm9yX2NvbXBsZXRpb24oJmZpbmlzaGVkKTsNCj4gKwlkbWFfdW5tYXBf
c2luZ2xlKG5jLT5kZXYsIGJ1Zl9kbWEsIGxlbiwgZGlyKTsNCj4gIA0KPiAgCXJldHVybiAwOw0K
PiAgDQoNCkhpLCBSaWNoYXJkLCBNaXF1ZWwsDQoNCldvdWxkIHlvdSBwbGVhc2UgY29uc2lkZXIg
dG8gaW5jbHVkZSB0aGlzIHBhdGNoIGluIHlvdXIgcXVldWU/DQpJZiB5ZXMsIHBsZWFzZSBhZGQg
dGhlIGZvbGxvd2luZyB0YWcsIGl0IHNvbHZlcyBhIHJlZ3Jlc3Npb246DQoNCkxpbms6IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMTNjNmM5YTItNmRiNS1jM2JmLTM0OWItNGMxMjdhZDM0
OTZhQGF4ZW50aWEuc2UvDQoNCi0tIA0KQ2hlZXJzLA0KdGENCg==
