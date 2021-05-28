Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54854394605
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 18:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhE1Qu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 12:50:29 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:24866
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236253AbhE1Qrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 12:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/i9SqDNEmyjz83O2L9vTcyq2+hDcOMg7avqwsNzA9qPrJYjwuB1h7JVnqUX9kU/qIiNl5Vm8RBxgjxTQCSL0WwVrkQynXn8Eg84QBgLKsBfouhOSLia9GueQTkMnBSUiAEBRlkJwAgiq09YpjwhMri34RLvVeLd+etExG++kD4Y8+Ko9hCjSzXxrE2CA9TPJsk4tovDMgMv/GI88CvYikHL2Z4JwIODwgF1MJbRLzrnHo2qbQJgoTORsbAHsvJITBo2BxO+0buwDuBvT47BXvvA45B60n1wTTeI7wmUS+oEK5Jc013MroYxwwMc8vlrry+u/Vq8o4YPliEZXDGY3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcQbATgkUvfZ6walNphWIu6eXMIxilTtPbeCejUb0lQ=;
 b=gDoM+izZLZQXX6BkrbaBmusbOKiCHJyRHkNuTBBYotUsHX8URXQFttAGkJsmgyF5EjvpohnoWd9iHNYV/O1ekiy93OznJUpaVrfibZGvoNMh2yTlnf3qy3uj6YtUm/UbKf20wJpFqw5jrKU/ryfD0wh6sy9SSGa65I3G6iAQH7q71vUfLx80Fzf7iE8uVhLvxUsmchsyGs60KVfifPF7D0W4kM7joNvT4pz0EKH4AlPv1qP19TJLaBPLpSVEv+oQOfANMe5gE9uuVwjMt9R7iJlyqD9qDHK5X1mFqEVKb+i1Qvb6iLyBc1rwC00KzMEOa54CQLniqlcUW0aYKYcYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcQbATgkUvfZ6walNphWIu6eXMIxilTtPbeCejUb0lQ=;
 b=WPpRtSoFIY4WCd1SHx823pzmK/0U9gML+rBMO8M70DYyR6sJQ9LCkDVxIMyS4mKjEXIfpaGhtOwqmIluqlTtpVv0O77IA4T+X1vL8bm8IXZFzZ5buYJMk721bNAw4k9yYS/HxZx6wFIwjKYXBQyzBUZ7pe/GB85EEd9iUhyIdpk=
Received: from DM6PR06CA0070.namprd06.prod.outlook.com (2603:10b6:5:54::47) by
 BLAPR10MB5362.namprd10.prod.outlook.com (2603:10b6:208:333::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.20; Fri, 28 May 2021 16:46:12 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::89) by DM6PR06CA0070.outlook.office365.com
 (2603:10b6:5:54::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Fri, 28 May 2021 16:46:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 16:46:12 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 09:46:11 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 09:46:11 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 28 May 2021 09:46:10 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 3E0732F45C1D;
        Fri, 28 May 2021 18:46:10 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 3BBB820002B0; Fri, 28 May 2021 18:46:10 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-bluetooth@vger.kernel.org>
CC:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
Date:   Fri, 28 May 2021 18:46:08 +0200
Message-ID: <20210528164608.27941-2-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210528164608.27941-1-joakim.tjernlund@infinera.com>
References: <20210528164608.27941-1-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2021 16:46:11.0126 (UTC) FILETIME=[F6ED8560:01D753E0]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f4be586-30cb-413c-d43c-08d921f81a04
X-MS-TrafficTypeDiagnostic: BLAPR10MB5362:
X-Microsoft-Antispam-PRVS: <BLAPR10MB536279C71A6A1FC05261BD74F4229@BLAPR10MB5362.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:312;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBrkpc01svYTYOSPVvCfmGTElholar7ZKUmt4Rm49D6dyCsRjadYlmmw3vqVJ4gpkalsEZtM4qIXwQaUkjNdubWAkaCVCqLaZ0Q1aZzN9c3TEaifbEzBPQzHDERZKaqSZ1WBHiRBrp3Wc6v/0ITcrvK09tj66o0Ybdevuk2Gijt+mftULa09NcljeMlgoec97vhrgdCAVJMMPO8uJ4Au2k222OX6bYIhG37oVW3zKxIQz2c/AvWkPpBdTnk8ZDLSFlNpSRRN8wDYmc4bF4FXUb+yqf7Fx34S2Wrv0hnJVXrTHHHItfNJu1F3TfFX9deAUJ6II343JiFg4HCj2s+f4EB+UImW3PCuaEDgyO76Ca3bxcgwzl4zORUd/cGaDjr27KTRHpNBTBYvUWbMNJIw67ZSaSOWpkl3YXXgN7GP7KfNQ/lY1a4N7UI7meNPOzHMGs9wkuROx5HCiYsk0pjaoD/30AHbS5IMv8UDBRPqwdAh+s8AgTC2SN4TpHgp4bZsBUbdcj0uNG/T7wVxSi5buhINKTKZzQVabYgtpOqSxR8besjTg4XvT1day2GiDvSOPew4s67K/fQD/EiHytp2i+FhRR7FdWGdSF+YOkq6zc4yWlvyjAdRU0A1+kcDGNYfOgTnkJugtA+6Z+fwCy0D2YMVgJ2ZeNQBCx0BtPcl//xfPc0r9NSQSEZWEW0bzGXI
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(54906003)(2906002)(1076003)(6916009)(356005)(44832011)(4326008)(5660300002)(81166007)(450100002)(42186006)(6266002)(2616005)(426003)(8676002)(82310400003)(70586007)(336012)(70206006)(498600001)(26005)(186003)(36860700001)(47076005)(8936002)(36906005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 16:46:12.0606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4be586-30cb-413c-d43c-08d921f81a04
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5362
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

