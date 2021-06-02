Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE61399533
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 23:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFBVIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 17:08:51 -0400
Received: from mail-sn1anam02on2052.outbound.protection.outlook.com ([40.107.96.52]:3682
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229667AbhFBVIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 17:08:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke94OgtIy/fD7JjYT0SeibQssK3UbdGVVcTsxF01327rD7cIe21bWpLUDdPjJfm1pFpylhsLgMyMT8Op8R+flMOGcn1m2dLEGV0ouTajKLVwWZ1MJhCI0suDeJNWTqR4v1TjLdcwq9Jlqa4FHrOCtNGLOJ5enQjf1qc0gukKAEf4Pola7rmSoMLKOqvsxZEBP7vU8wbSoW9mDtDKr3alRqiH1PdY4RM8m2ickY/umAd5fHr21kDi0Y87i3g0OyK5etyR49I20tWjnrrkPw4YfwJIxLZQNJq5CuRtBgiBEY+iysP2waLI0/qjKhc29mXEAMHKLjoRKu/2gLHljA+N9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kc9yEuE6Fg6SrNFk4o6nzxZGbJ7aUgYu8132oE56m1E=;
 b=DeNnWl65TiEYiIHE8w4f7KdCquso5aEmmXKosAEKy1RLUwdmaIYyg92Jd/uRmcZbwsp5FhE2krgFJpGmeEhlhfxWh/D1Q3DvB+QZoQSq8IeZ038a5IWbp3dOOSb7dhy/K9WVArdEqY/wHKOWgv+py0thY061Wx8nSW3m9lZqoul5f/e4lcexi6Mqt36kgTqwC3Ry9PDUmG57F0Ie7G7jW1kzKtAEsd0vZweejBcU+uf86EkaZEaucRJjWarB9C0eajDnnjV1aZ+VVId6k2aKIivsXfzCQ6mizf6G/2PE4U0DXWI43/CUtK6wZVF3Atqe5OFzj1y5vxCfQJuxNTJNpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kc9yEuE6Fg6SrNFk4o6nzxZGbJ7aUgYu8132oE56m1E=;
 b=KjITNnbuA2ZNsLHcn0uHWQwHKLThMFySlrHKbgwxp1mNMB9B/xupO3u8lt/tCWRvShQc2zJXRYhAaXRWvA4Xtjvrl7hTuyZyPsxWptbGYMYYOtaIAy8QjkNKKXu/PQXjzvSJbNlU3s09rkzbtuu627D3C0dEKDr8zNVc9bM+IjA=
Received: from DM5PR12CA0015.namprd12.prod.outlook.com (2603:10b6:4:1::25) by
 BN0PR10MB5175.namprd10.prod.outlook.com (2603:10b6:408:115::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.22; Wed, 2 Jun 2021 21:07:06 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::6f) by DM5PR12CA0015.outlook.office365.com
 (2603:10b6:4:1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Wed, 2 Jun 2021 21:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 21:07:05 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:07:05 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 2 Jun 2021 14:07:05 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Wed, 2 Jun 2021 14:07:05 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 89C6F2EEE0C2;
        Wed,  2 Jun 2021 23:07:04 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 8533F20054CB; Wed,  2 Jun 2021 23:07:04 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-bluetooth@vger.kernel.org>
CC:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCHv2 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device
Date:   Wed, 2 Jun 2021 23:07:02 +0200
Message-ID: <20210602210702.26038-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jun 2021 21:07:05.0511 (UTC) FILETIME=[3DBBDB70:01D757F3]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a29733fa-64cb-4dc4-5ff7-08d9260a6074
X-MS-TrafficTypeDiagnostic: BN0PR10MB5175:
X-Microsoft-Antispam-PRVS: <BN0PR10MB517592FB982F4D7CFB799848F43D9@BN0PR10MB5175.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:312;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oWdCQifpH+9pLJ9Bu23qAYi/Ic53Rlmkfe7FKBMnkBwi185PgIP69g5aM9A0fybGJ8EqGCayQolQucOcEFuY5zyxxQgN8CaJUc1Ildo5LOBAArpJEej4AI9+JEDAR1uVTPu4QX+6UMFsEhJpAajEtJMaloyg6vjXkQyIVRe5cZQLgJ+EBo6IhX2+HJ/0g6SMGlFL2sb2JJ7g+XsvfB6H2eWwKliLx1pqTI+UD9A8SMtNeAAsJwNrv9MA+9Cp/1TwgM+jeN3cVmDgNtau7XV54ug3iIaJlGDie8Y+x/AXfnDbHoTeJXvzxBJnA7RH88i1Rgcin+t/Xu1MOM0XbeG2dhf3SPCMykd9l12gbbpHp9m2A/HtVr2zOpsYiKlA3WiOPVn3pxOU+cz8jTEsmaC2ePiCv1jQMIstztk5Dbt7zvHnCK+3BUCHKTG7ihITPdG6FdaQE/x2Bfuh8IfjKYSn248EtjbpYJLYHqSLDWAYvQBfxbH4PiLL/Stnl6XONNbPFLK4HodOkVYrQORmb3J3/j6H1H7yW5si1u/XYEq2TWZxT15QIZamDG9c9DpEpK8MWQb/mrxFPrtqn7Ex6ujMbNM/FFm9mQg2tHjNoOEMmyakPHCQ6/xFA8xdwg1vSFNBVwVfxbvow4Iy8cOfFEHdKGyODOaXFxd0J5oHKj6Np9qLmxvO9Yi4ODwrdvE9syMl
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(70586007)(4326008)(36756003)(186003)(2616005)(450100002)(36860700001)(44832011)(26005)(82740400003)(70206006)(2906002)(8936002)(1076003)(82310400003)(336012)(356005)(5660300002)(86362001)(6266002)(47076005)(42186006)(54906003)(36906005)(6916009)(426003)(8676002)(81166007)(478600001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 21:07:05.7964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a29733fa-64cb-4dc4-5ff7-08d9260a6074
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5175
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>

T:  Bus=01 Lev=01 Prnt=01 Port=08 Cnt=04 Dev#= 18 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0b05 ProdID=190e Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=ASUS USB-BT500
S:  SerialNumber=xxxxxxxx
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---

 v2 - fix SPACE
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5d603ef39bad..37522d7f3e97 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -425,6 +425,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8761BU Bluetooth devices */
+	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH},
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.31.1

