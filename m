Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FCE1B9139
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgDZPkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:40:37 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:43113 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgDZPkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 11:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587915636; x=1619451636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nU3rYDd7GQkWPMz3Kj6QRnk1cweVqL+a2y09rWEmLRY=;
  b=dCHc1jXEB8tiHWXkjt5PCJeb/LiaVkC89rKLhnN0372P4PDwqjvUubF8
   zcGD3ORkK1tfJgqkCJnhXQ1llsCTkoK9/7+/KJXoZQ4jsKi5JeclPeZgv
   qXib3Yj4L4DZqkMjjd1RnYPg4A/6Px+U23ZKpUFJQ19YIclAOb2UQy9XR
   lHPdRl6K9Tf6Cwe9v1cYQOkXTFtTY7oQqgiJ+rtqK6c1KVrjrnZaD4Ujx
   GwKx0eXfLJDVt3zDQ9CkSKEzwBD7c7GE4y/wLAFLgBT6ePiNm67wZS8L8
   d4NPiP/F8fmI4F2R7FtQvtAf7/AsHeFPHOUMyUMH8Qjq/5ztwKARH6NVF
   Q==;
IronPort-SDR: yq0OSX3wvyl4xt/W+GjpflUWsaXJ8W0zau65FU+9Dszs1rkAo4AKho0TxNqfLtfgrT9d8GCjvL
 /ss0GikvC8SzMnIkTnpJEefoQGX8ZBQdUb3jdfresd3oCxdTMJLkC09bPjJCy31XtOMhzIQurl
 SF7GJMQaX7zk/XF/OqevNnMwjwQJoYqpjoisJZe9D4HtPi8VzUbHcPARPRa8REaPRfsn37wGX7
 XjFzbyPO8OyitdR21D9I7AwzBUrKGeLv6uI2M3dABIDnd37mgNCj18oy+x1MrqnSMFEYh7En/F
 W7Q=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="71558383"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 08:40:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 08:40:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 26 Apr 2020 08:40:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlQ0UZPIwovpp2Me1nKk6dHoiLKA6jjU3LQgIi/0ysbNAg4FXOPiAkJdenIuW0cSMHd1Hc64q5pHTbHeVHspuPhTb3p7FGRPvu14XwtH7VevK2q9nAzlmLU9w/oVldyIYpVJQs0QLbGsRtwwj8aInXybma78WpfUWIce3Jy5ITK5RYc8D0BgQHjJ+3q6KQm1cZAWeb3YDvbu0bxc5T3JvkIMR4GWPmGARinu0GqvgN60s5ygywK5OJYU7EBdPUWhCL9CDHS+pJF/26wG0pzpYFDWTY/I1dhjPzx6I0g+uSxlAtRbGAFLq6y4zJBJ3dnmE3Ynq5SL+ixhSOD7Oso9kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNxj2ytlkVrB1f6tqFZGq5e7F9cMcFXNwjrUsoSMn0I=;
 b=SN6RdYx3rbYL7LYO2/G0YZC4cGu65vjleI5BEi1EycXKIxSiIH7W38VNitSf/0VALjWAClbDK86KZHFFzxaHPI091VJn4ry7kSIyQy5c7pzNw3xnzl4PYKRY7MN1yjJccz99T0B5lmH3LdIOeNLJrWaWkV0LjbRKg9QFY8H0IkENMseh6W4emq89JZkKwRxM6ls3RXHq8OSEnYU25o69kLyOgIY0jf1UNaCQ730k7O05IIBxG1zuDgMfPws6lbFoZ02QW/rDI1ViO5neVMkvx01wSO3mSJfsUuI2Of2dizOvR8ZD/uhULZuR7cWqWTgVCiAIODQjq5eeGE01MiDKvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNxj2ytlkVrB1f6tqFZGq5e7F9cMcFXNwjrUsoSMn0I=;
 b=Q+7M95JOGrBN7zXlSIiZ/faDN8X8VKG7d2YReouGDOPvr9DHNnXDFZk+ihE/lRFXVfHuYzoZo49EkOYCzfnPUVYsvJBAtUTQ/14NuVsZjeL2f7LiE+Ir58hZ2Iqg1MmqHpo78CxiWqDv8SNPsHPtmkC+mRURPaM1Fc/DxrKHDMI=
Received: from BY5PR11MB4419.namprd11.prod.outlook.com (2603:10b6:a03:1c8::13)
 by BY5PR11MB4292.namprd11.prod.outlook.com (2603:10b6:a03:1cb::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 15:40:31 +0000
Received: from BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536]) by BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536%7]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 15:40:31 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>
CC:     <linux-mtd@lists.infradead.org>, <john.garry@huawei.com>,
        <marek.vasut@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <bbrezillon@kernel.org>,
        <richard@nod.at>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Topic: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Index: AQHWG+EDIWpaopvk8EurQ9gTxEc0wA==
Date:   Sun, 26 Apr 2020 15:40:30 +0000
Message-ID: <2670775.TqFIqkCU4V@192.168.0.120>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tudor.Ambarus@microchip.com; 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a995de54-3778-4c15-d696-08d7e9f826f6
x-ms-traffictypediagnostic: BY5PR11MB4292:
x-microsoft-antispam-prvs: <BY5PR11MB42923BA2527EC791A35B4E58F0AE0@BY5PR11MB4292.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03853D523D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39850400004)(396003)(376002)(346002)(478600001)(66946007)(66476007)(4326008)(6512007)(9686003)(91956017)(76116006)(66556008)(64756008)(66446008)(54906003)(296002)(316002)(186003)(6506007)(53546011)(8936002)(81156014)(6486002)(2906002)(26005)(86362001)(71200400001)(8676002)(6916009)(14286002)(5660300002)(39026012);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: abO54QmymRdTU6jUH19xYNlcguqdtGWybwbMhaoziSakQIsuFqSD5AfNJbqaJau/fSN3JvzLxmifdjO5eJpeXSORzs7BiWzgRuzssJ2qc59uer6BC8DvYeoQsyKLwF3hB3+PYGbBeXPTVm9DDocDu08hGotLLzsWXB9FsY6BzltbI2C3i5vd+sg0P1Tcb6CBa8RVp2hI4dIzsQhp1xL7Tu1DCVuHHwzCB42Tv86PQpXmGmcEohdBo0Hmt9+hzBwRDYnFe3rle5Kqc4ky1u55AzJmAtv/GWA2vWt3AEGF1J4M85k9NoovNVzkH2EytgAe3TzuneAiIqWakIze0lKraVe0fWQtHG+2h9iAEkxKV0s1VrKtqnfMScu237w9xRNPU8I2/4EhoVUTbNosvGMkgrvQ3aOmIgp55d/yQXX8SPRu46EkC70BDBQn3tRz20mp/szc6V49anLuca8XxCrZbUc9SpJq6mvm9uiGuV/zq5sUmGRPxZVwKnZGWGLRJFGn
x-ms-exchange-antispam-messagedata: zWaj+fKgoAdraR8YU9BMu3uU+2+j0ygT6SkiayQlAYlak2xTScDBr8cuVW6CN/dzuUUs3dUWZXJZ/iwpBkjZRGSVsvYLCvZXo1yyk9Qpp8ZXI6BzPsECqfN1QkAzAtB3cwFYdisHNeJsFFAJpyvyToHewFDlU9IjWx3dQHEgilthaPl++fH9lh0nC/rPN3lvEatUypHz2fxwzEfW7RtXG2ekSo0YtEUNB+tJof3PjatTLz5l6XRZc29KJAEr467yQ7KAwUm90o/M/DX62VOBX4D50tDGJJpNdv85ef3zN83vIWOipF0oho/Thrh7Vv2qHQnQ0nb4RsnYctLGuAwyNOCwLtWq1wJcs3A7xssF+xnO/+VkGDFYA7Cl8BOj3T931a7WUmYDKK8jrfcvnD5W/L9aWdY7PmTuJ9YP2FRbQKJe9ihPJaTNhVWplCDaXkdZ46b3G/jFnj20cbh9lXNtn3vbQkxuzEMtQXOba9GRxx1vXiGAZhRx6if1uxi0hfuji6LyimHIxTDUVWH/ujWUIgN+EUQtU7V4IBTPz77QcGa3EhU6I4hCkQ3hSpRfe6sK9ZX1KXox+CPvHDVj146BcRL5PtX173qy8F1f8PfNy/mFgJwZjLmdWEa9ZClxXHmUS1WzjCiGujverZBbRfZoztz4HDzz5699lB7FQYvS0wB3kfMAAKXXHd2Z2fHinLI32Nw8NG63hc1p/4urur63LtgAuCHLkXCYW/gQAup5eIdRfAm+GdvQfKvCaOMZdlkaShEsHHUuLVC15slKbO4dmDVzUiyXF9W9CzlxWpWif1A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A26D32D83F408A43B867B2A22A89A2DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a995de54-3778-4c15-d696-08d7e9f826f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2020 15:40:30.9887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dlqj74tEP1yJ+SdADYfovEQVVm3YiDG+n6D5gtutrDxHuIRsPbyoTR496cKYECL9+RBfXs6DkMCDygn496guxXZDU6SFhyLP9yGW/7ABtVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4292
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, February 27, 2020 2:36:57 PM EEST Alexander A Sverdlin wrote:
> Spansion S25FS-S family has an issue in Basic Flash Parameter Table:

But you modify the s25fl256s0 entry. We have to fix the flash identificatio=
n=20
first. How about the patch from below?


Author: Tudor Ambarus <tudor.ambarus@microchip.com>
Date:   Sun Apr 26 18:33:33 2020 +0300

    mtd: spi-nor: spansion: Differentiate between s25fl256s and s25fs256s
   =20
    s25fs256s was identified as s25fl256s. Differentiate between them by
    the Family ID using the INFO6 macro.
   =20
    Fixes: c4b3eacc1dfe ("spi-nor: Recover from Spansion/Cypress errors")
    Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.=
c
index ea72f0e5be73..8ea30491cdd7 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -25,15 +25,21 @@ static const struct flash_info spansion_parts[] =3D {
        { "s25fs128s1", INFO6(0x012018, 0x4d0181,  64 * 1024, 256,
                              SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
                              USE_CLSR) },
-       { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128,
-                            SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
-                            USE_CLSR) },
-       { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512,
-                            SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
-                            USE_CLSR) },
+       { "s25fl256s0", INFO6(0x010219, 0x4d0080, 256 * 1024, 128,
+                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
+                             USE_CLSR) },
+       { "s25fl256s1", INFO6(0x010219, 0x4d0180, 64 * 1024, 512,
+                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
+                             USE_CLSR) },
        { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
                              SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
                              SPI_NOR_HAS_LOCK | USE_CLSR) },
+       { "s25fs256s0", INFO6(0x010219, 0x4d0081, 256 * 1024, 128,
+                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
+                             USE_CLSR) },
+       { "s25fs256s1", INFO6(0x010219, 0x4d0181, 64 * 1024, 512,
+                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
+                             USE_CLSR) },
        { "s25fs512s",  INFO6(0x010220, 0x4d0081, 256 * 1024, 256,
                              SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
                              USE_CLSR) },


