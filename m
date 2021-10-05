Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADE421D1D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 06:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJEEHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 00:07:50 -0400
Received: from mail-bo1ind01olkn0170.outbound.protection.outlook.com ([104.47.101.170]:6110
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhJEEHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 00:07:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KH6gU9ixiXin231YcQJEu2Fg4fzkXcbYfHy9AysYGuXiMkfhJCA7vsOa+GBUfECduQ+/6QcNicQ8ohqguqOU3rsYaUa3HdHNn9DWWPxoPs2SCdEQXvwAphKAexwfmVFg6+q28ZXoQ4jtjdvfQ4mmdVok4PJH35uhNrrdjfscdIcyBvgDmP5wEJfNed+gM5frVAxsBGDtva3C8Fpu4z/UWIdKPuB+n8t8XPixvoqBsdaNG8bOkLdfkT1ZG6y1KdWimruJztbSD8g0fcSx/z8DZnkV+IvgdWP9MVmYm9k7GHacscl/gr4sIkyTFksnzFp49G0Hq3vtmep5ymkIoFhi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTmxTgJaUTgTdu+soctbZKN6E/SG84+5XRAnd/YL8u4=;
 b=PIDbQi9ca/pkXZhO37o2qxZZ7h6AcgzoQIImTemebWCMqz02Ll5kiGI9zRad7eT860tN+jV6c/PeX15HSGjxiHDNQ8T25pKRFZ+c1zs5eYuUoQuZ7YNv/JDlqmW2xriXEQynyUaMSgGkHP/q3h1mQHgcyHqg8BX4CzA7wd5xscQsg3GTvLPT5Ree8Zc0zMa6qLNC/mwJmAeW1avB6edJjJPeHIZE9OSZ6eTJVnzTsKWNpb3KJuRjpIvoPaxXZCJo1abMM7smuggXaXGEaLSiiMQb5uJlLR4xik43Wb64jxuh6XGzWt2QTKe+xVwcH6EyClfZJdQrC69aTybOlTGFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTmxTgJaUTgTdu+soctbZKN6E/SG84+5XRAnd/YL8u4=;
 b=jzsyynJtCJBfc1Qbl+NTinmPpTTeGBxJmdM1BXZ6xdaztkPi9kDpXjXX/mlTjdIiKCtSdVpwcUsXOh+Rh2W5+PblQF3Gc0lRiGAPxXb2ek9P4f2RKt8uWfKUZihFeRkSW2KLrNL6JCHmHbiGe273A5g9lZ9vf6FUwwrRbeRkxbJRXWVJA/EoB0L/8gTdVTDViE8IzNY9mdWy4wgkM/kSg9FzqZW9b2MR4xGSvjEdxpQZ7D7eRa/l3v5/YxW3VC01VmEWMjC/uytjNdMRg4/vO1+zveJC6UIUI2E20Wr2tj3MFLw4Pag3GsX/xdQyXa18WCW7FlIwEjxGankcq6oM+A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB5520.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:7b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 04:05:56 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea%3]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:05:56 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Orlando Chamberlain <redecorating@protonmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N UART
Thread-Topic: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Thread-Index: AQHXuZ5MsJKL1IrMDUG96U54DVzKvw==
Date:   Tue, 5 Oct 2021 04:05:56 +0000
Message-ID: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [2zzvoxVMAW+SRXM4u24/sEL5Y+nabW8T1pca3mncUA699lWsgDXummVQkDywu5N9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 111eafdb-385f-4c29-03cf-08d987b56ec5
x-ms-traffictypediagnostic: PN3PR01MB5520:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aKqk/Cieh8kYTNv3oayN4/asjquTGdcq3pZYLin5EeSW+Nd8+aAbOKAPlkj+X/SS4a8ke5DwHuDqtmlLznCBSG6BVWBLysQWFpaKEI/k9aqa7hjpYJx9H7qvUPa1YDWtsQUBvby3X0HfsAQwT1ahYrdMTWwuRC5fXTo+ObrmBAPvF1vn0te7kG7uei8i/nkjCEnSYvDUydY0R/Sy2fx21kPHeA8z9jNCAcdUju0u4OJ9ryrAB90yJBmOLXobb096QL4rW5G98/JXnmlidgUNFQatlvvrzzHomSJt67s9nYzqwllGDq07eyOZw5G17J1SVMTLfwFgM4RcR576VizhtosTlc6ogaldR8bOrzPXnpeBJ6dtmoP4RupmHwOMu2fNlGODBidHX0Sy2431Dzy6dvQotoOJQiG2qDEOZ37TX+1XYgrNEqS4lDIuQd6lYXOG
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: VnY3A+coS3GQZStSCo+PjElM6cGb96izhqgdavzgFPf+KMxgAEC4NexK0fdiQBPyoB36SbCGD0pxE82+Ol/vHJXUnbb7qCLi9p/KhEBrZdtXmOCjsvwl8SVPtiqFnw8clJrjbbQjY7HQ70RVFB+SAA4sEW2X8ugjsuM44W8xU2CkoRlUXpqWPORl1jFaMDWH3UrZ1SIdkV8LRsgYAYMJHQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CECCBCCFE2DA874D81DD0218268A9BE6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 111eafdb-385f-4c29-03cf-08d987b56ec5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 04:05:56.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB5520
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added 8086:38a8 to the intel_lpss_pci driver. It is an Intel Ice Lake
PCH-N UART controler present on the MacBookPro16,2.

Cc: stable@vger.kernel.org
Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v3->v4: reviewed-by line
=20
drivers/mfd/intel-lpss-pci.c
 | 2 ++
 1 file changed, 2 insertions(+)


diff
 --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index c54d19fb184c..a872b4485eac 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c

@@ -253,6 +253,8 @@ static const struct pci_device_id intel_lpss_pci_ids[] =
=3D {

 	{ PCI_VDEVICE(INTEL, 0x34ea), (kernel_ulong_t)&bxt_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },

+	/* ICL-N */
+	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },

 	/* TGL-H */
 	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },
--=20
2.33.0


