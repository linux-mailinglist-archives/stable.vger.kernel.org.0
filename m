Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52821B911B
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgDZPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:15:29 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7841 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgDZPP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 11:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587914128; x=1619450128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DXJILhrCRXz3W4BRFU8aqfVikaSDX932QZqqKM7V1A0=;
  b=eGYHV0bgTyxK7dXkSqOOzVnWfbG5hNmXzG88WpZOKsUgBxnN89iIm5tX
   BaES1Gpasxu6LrGfAedJbJvViXg14e7T2Cc5ZNfK0c7BX3q3gATxVek+s
   HHVn4Osm2axnoQZ/PV/bVRjUKuE1SN6XXqmAjhdCeianFjTtcRXl6WwIu
   6oOxYv4JRgmn4ah951tmkebVUflYw0Laj+n3m60S4Pc6w9NA5oyC6TuAX
   7wJlAyjnY8EXqFvSvgupvPkf7luYmsmqC8UwTjH1On9FFEPUUobpposDh
   N5DiocnUmYbb2H9YWHbMHfImPTxEGVPSQZPb7vDU8VriUxVXZCYqr9fX2
   A==;
IronPort-SDR: 10/Ptq41MXvNr/R7hSc27OfesP4ne0FqoI5FIUlyfKEFiUp436NGmXrIwz3SqTEbevMm1NHkwn
 iywDeyY+/f2j+2Re6KI8ZfFawNUbQ2fE7tnB2mCS00gwyq3AwCvS4m1W24lP5qvMcvzVi4ni6X
 jMcDnIwGF72hfovfXPfl+YhVmPnH4CEpxPM5KDF7BLYKcb9I+TF1tkonOZqQv41aArEdtMfKyt
 6T4dcLpyusGg5wEjErJSOpob0Rqr08FXqug9qV61q727PB9XFf7PFuWUHsdUYUafPauvy92MBL
 Fg4=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="71556192"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 08:15:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 08:14:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 26 Apr 2020 08:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnOac57ZG8i+F20Vzt+5zfiEBUErGzy18eTOK55Ww6oZnS8GueUq3NvX/kBS49GkaRwEYk2Axcki0o/s/ZS8YkrDbzMQ+eSSwA0JPxUMmNicw9DCW15SwzzDdgsHYp8oIEY6RTlAXytvTw+C/Sy85dTc2voybNB1WgWh3xKXSC900/wUVRuzMVqmeCH0f1yVq7VJ9rUpWY/uf/uykuaLbkj6WCXtNpCUHTz+9kNJUOqY2YSz+cWozuFw3Y9gL0mW9weJryZfcO4wU/FJ5eDZXc5SYE9Pxyw2V8FYhE8ZQSVn3N/t3DZTy5n9G6//5v3WjXfcujU6AdR3KLbYXxuQ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tsdq+6R+iXAHjyr6dBJIvOmvHg+TG8JFzcrz6kQWX5s=;
 b=GcIrlXBO0bR0HtmLG7JGMHjBAo3//iroQbL0AmReIHA6UY+CgP+EzvIKkCg3lJal5g9M9TMxw8Rdk4DIFXmMh1dd54Cd+VZ/fUvm/UQqcm/n6PonjKFJLR9D6qM6IpBgDlCwudOajXPg7bZMX/riSbzYX0x17+ygQYbZf04OP4qziJ4eS+Toaskwr0MuHica1pRgApCO3VoLf8i/NTx78XsLJxHHIfgBOkXfOd0ehairyEg/YPubrV6n7mjeTZPI2CIBggmS7LFWJC3eJmBY9qBjVw9Vg2sRloYNuuh8FeRZ3cjUqLK/symnsBF/HhVpn1An6oFHgVnYeYL+eVYpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tsdq+6R+iXAHjyr6dBJIvOmvHg+TG8JFzcrz6kQWX5s=;
 b=DnXi0BJc4AVod0f78Cim9N7TdI/yL8jxZwEaBd5lcOxgzuwoLJMtejpyjOnLqeYfku4nr9gLDjClxGRd/DlIRuIFmfHXMDzZfYSH5f87exCLpb2cgXUqlXCx3yCxWnNWJHW0Sg4L5nAQH5WTE/oNHIdcqlh/ajqSzJh2vMQTlFM=
Received: from BY5PR11MB4419.namprd11.prod.outlook.com (2603:10b6:a03:1c8::13)
 by BY5PR11MB4500.namprd11.prod.outlook.com (2603:10b6:a03:1c3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Sun, 26 Apr
 2020 15:15:25 +0000
Received: from BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536]) by BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536%7]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 15:15:25 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <john.garry@huawei.com>
CC:     <alexander.sverdlin@nokia.com>, <chenxiang66@hisilicon.com>,
        <linux-mtd@lists.infradead.org>, <richard@nod.at>,
        <stable@vger.kernel.org>, <marek.vasut@gmail.com>,
        <computersforpeace@gmail.com>, <dwmw2@infradead.org>,
        <bbrezillon@kernel.org>
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Topic: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Index: AQHWG92CIWpaopvk8EurQ9gTxEc0wA==
Date:   Sun, 26 Apr 2020 15:15:24 +0000
Message-ID: <2955278.kW1ZWP0GTs@192.168.0.120>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <60b272c1-ab6a-7a7a-6f56-03d7c7daf8bc@nokia.com>
 <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
In-Reply-To: <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tudor.Ambarus@microchip.com; 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78ff8a7d-1d0b-4077-4c92-08d7e9f4a557
x-ms-traffictypediagnostic: BY5PR11MB4500:
x-microsoft-antispam-prvs: <BY5PR11MB45006D1690700F2FEA377B6CF0AE0@BY5PR11MB4500.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03853D523D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(366004)(39850400004)(396003)(346002)(136003)(6506007)(53546011)(2906002)(26005)(316002)(71200400001)(54906003)(478600001)(14286002)(8676002)(81156014)(8936002)(6916009)(6486002)(5660300002)(9686003)(4326008)(91956017)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(186003)(6512007)(7416002)(86362001)(39026012);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JF+kOBjY8KAB1mENA8JtgS5oLEG5S8Ud97Xumo/qZZva1m+1uagaKrc7CSzliZMdo+ZJ6JOONtKlZ+U+kU0ZRTqq6QBnv7uRJVXGA8JZUKXJUzeaDhqiWjFcAriGaQuSGUuiLziwkIN9lsYNJX687T65ZIhMk7baiPLkFIO01gdyRoHh3QJfI+pMLldn2+uUkJBXxHdtkuTHzqaWPgmq1lmXSDX04hZr3VCrW4N6btWMgTgs8UlFd2eMoWDVEAwNUstxzPpSF6xNp+VxznknICqA+oKFCtShCNQyO8XGOZFWT/4MCNNGq3lOy7dbEdSal5hnW2aQVD8NrIbOGve2yBseRxdxTY9H4lXwm1OWg2bDUpM5HRJYPEWNJ1QUKBhUI/upKcbSianOHtJLozd6FiC4DdJrKmPUQNlYSPokCEDFWTCyCycnm40YewOdSABOvYE8y2gnkl/7s/9Zmj6cRqSxhXsFyMr9t3L3saxG50T2jEibA9pRzaXEEKwt/X7u
x-ms-exchange-antispam-messagedata: MbyUhF7DiD4TCA6dzEt5q5eDUycl9dqr+GsK6+WJpcQe+YgSFb/hSuT8dMR8DE9/FLiVeGHrLxqSmmbw8lgXQwVYo3X+ahU6iC1V4+bkMZ2iZ60JgU7xZohTv5iPN3OcGwvjr1yt1eAlw0VYKCWvV1G0V3IxxN19pxFQiJ6Vx45NPD3WmaVhXUKbRtn6UDtGCfWPLmlCh8hIrxt4ayWpJGzSkvJOsZ/iHMfsvluvy/QtF8JtHFqqZNRMSWoNrKzutWF4YehQou+V/e5M9hTStFlLEsKwMKM/tudlyTuWS7pKP0riAtrvIa8LO68kctStq11UBMPa5OF6h7sc8pflN+eQnjVdvDxt4wZIChWDRSOlfk5uB0WnIEMgQGC+pe5r0j1sKpo/HbQ5yRy8uUM590sV1d9bUx5hBXHBNmxnlHZToaki87DSX/n1mmKcHmFNzbU/y4aqjCG0dHkVHJgnjSIcC4V1rFEqRYyosxqm0a8FW/x3HgUiCI7aAm56T/Hw7Y/SR6NdtBSwYgT0w6uXFN0C8hf1qsTeQv7DiuZpX8i9uWKzaA3cEpolFMzkVdgeehxCkrndL/Qty8blR3uxDNPlTWJC1tDkaHTFS9Y+fL2Z1QVoT5dq3m7uxdHv2MjjXFGz9iF58txcABqHoj3+0Xicc8MvqLZ4g4Q/illnmsNSdbAsKv1RNt6X3xHOYUkzfWzRX9wZb4grDSbdldd7Ljt+h7y+f+69+8BD/OwWm+I/ytTdP65c6dUmPSx8w58FpYlRA6Opf++vGWG2iqT63TznsIL+Yuu2rTIiKSempD0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E7938CCF41FD944A9A90FD9BB7E8B78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ff8a7d-1d0b-4077-4c92-08d7e9f4a557
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2020 15:15:24.9379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3kt3Oa02on6VBj/ijDJiCCYydX5GBENR8OE1kmgsMg46Mr2ZBtXkGr4N9vx7j9nprNaMaGkV2XA29ddbcrhmTCqs7QxAJghTODprqkFiADE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4500
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, John,

On Monday, March 2, 2020 8:25:48 PM EEST John Garry wrote:
> So do you know how we can tell if the part is s25fl129p1 or S25FS128S?
> Is it based on family id? For the part of my board, it has the same id
> according to "s25fl129p1" entry in the spi-nor driver, yet the SFDP
> signature is not present (signature reads as 0x4d182001 vs expected

 0x4d182001 looks like the flash id, but in reversed order.

> 0x50444653). I printed the family id, and it is 81h, which seems to
> align with S25FS (which should support SFDP). Confused.
>=20

We can differentiate between flashes by the family id:  80h for FL-S and 81=
h=20
for FS-S. If I understood correctly your flash id is 0x01, 0x20, 0x18, 0x4d=
,=20
0x01, 0x81. According to the spansion datasheets, this should identify with=
 a=20
s25fs128s1 entry. Please check the patch from below, let me know if it's ok=
.

> What's more, the spi-nor probe is failing for this part since I enabled
> quad spi. So I am interested to know if there is some differences
> between these part families for that.

In which conditions is it failing? Please open a separate thread.

Cheers,
ta

Author: Tudor Ambarus <tudor.ambarus@microchip.com>
Date:   Sun Apr 26 17:59:23 2020 +0300

    mtd: spi-nor: spansion: Add support for s25fs128s1
   =20
    The old s25fl129p1 flash uses just five bytes for manufacturer and
    device identification, while newer spansion flashes use six bytes.
    s25fs128s1 was incorrectly identified as s25fl129p1. Use INFO6
    to differentiate between them.
   =20
    Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.=
c
index 88183eba8ac1..ea72f0e5be73 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -22,6 +22,9 @@ static const struct flash_info spansion_parts[] =3D {
        { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
                              SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
                              USE_CLSR) },
+       { "s25fs128s1", INFO6(0x012018, 0x4d0181,  64 * 1024, 256,
+                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
+                             USE_CLSR) },
        { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128,
                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
                             USE_CLSR) },


