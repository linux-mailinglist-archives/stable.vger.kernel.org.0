Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD2C2B1EE9
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgKMPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:37:38 -0500
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:33633
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbgKMPhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 10:37:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Svnwv7ebJ2UuBMg3+wwnCarRlMaZ/eOEy2gVkN4A7HoaC+mMibz1HhoW2oPE3WauzA+fd7MyseA6JEWtfsnYyVufaWjHLO4gkT4uBpypmnVEQRQLZkpJaKE21W5wyRbNWIjT7UnNmTrX4LYq+lOz3Wzn2Uv49N8yn1vcAUBcK/9t3STf8kOxrVJxq8w+FNvOivFsG9vCZUmg6DLDrWLjYQUB8hCQ9oL5iyL7U4gjvJFQkTnOJF2OEsVyJ218LGairqKyha80VoVn+dwnJQXsO4FM29quTeCkXj4eFyT4mQBmj41Xhllo+jVSB0Dp8dDdF0p1fXsA0jkk9+GwntrPSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS1Hpqdt/AZ/tDODWOjpu8hfGMwmTShq5Kb6i5jz5+0=;
 b=HlwkShfGjpdLCYB65QiagQMHSzUf3oxK+GVxQNlapxU++FHYPQ5ak0YPSdhEGqzzVMDEjgGRWUX1Aqf0Jd2a8Dafs/qO4mt7cAIFwUHztnoeKgPxnVp+yLB9qtXc3QmoR7SkLwGrlBt/+H1Wp+a/c9j9CVburLfjqyxsaH85+ugOGWON5RQ3dvxu8Ki3QraRQZsTSdPxkfWH9nMeqZaxDfLo7JorwdpNB2vNzMl4RoQUcAdTgPh9ICOen36ysxVd8f8NJk8T/Z9nJi9OyuL419a6xJftPH6O8BjMGB4ohRmjv+kQmTysAY9Zbmb2S3EWtgm9BdVWkHLgzR9DNK8Y0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS1Hpqdt/AZ/tDODWOjpu8hfGMwmTShq5Kb6i5jz5+0=;
 b=dIbaAHomto0astBTc5E2iBoPrQxQEy4WhO8jyXZicvyaPtGkBrpFaWopfweKJXe7XxjG1XeJIaRdJFYyJaFGDKn+xToBrqZ2Uoxfu961qjEfa04bsJIpgpMw5nTJo/mVSKtg/rAA+RfZWPUJg9RZB8DE+/NI2yekyKocL+zFE5M=
Received: from MWHPR07CA0023.namprd07.prod.outlook.com (2603:10b6:300:116::33)
 by MWHPR10MB1981.namprd10.prod.outlook.com (2603:10b6:300:10c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Fri, 13 Nov
 2020 15:37:33 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::8e) by MWHPR07CA0023.outlook.office365.com
 (2603:10b6:300:116::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend
 Transport; Fri, 13 Nov 2020 15:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3541.22 via Frontend Transport; Fri, 13 Nov 2020 15:37:32 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Nov 2020 07:37:32 -0800
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Fri, 13 Nov 2020 07:37:32 -0800
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 13 Nov 2020 07:37:31 -0800
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 75E9D2C03201;
        Fri, 13 Nov 2020 16:37:31 +0100 (CET)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 6D4F0E0A9; Fri, 13 Nov 2020 16:37:31 +0100 (CET)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-usb@vger.kernel.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB devices
Date:   Fri, 13 Nov 2020 16:37:20 +0100
Message-ID: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2020 15:37:32.0294 (UTC) FILETIME=[E6F2A260:01D6B9D2]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee69584d-999f-4e82-56fc-08d887ea09dc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1981:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1981E5FBE294B87A92F87136F4E60@MWHPR10MB1981.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: goJMnjAJa9IGVrT0QTC2zfQP1StjhtGuCm2DlrvwQaqLn9ztco5kEvPyr3c0pfawkxgtYgSQyhXD29RjlUTSTxlOZMPl3eZM/SWce2h+Xsy+omD3syvO9ZiOIpAA7naApImflKlBjcyVuRMKF9inDh3s/HPs5QSbpIg5ycsG1/S2ZlMXY1s0L6EvX7TmgShAnQGRQ5sbTFwoyn/FRDX3SnrLg52k+CZ2RlSrIogqv5V7aQlpO1Hi0w8vQIjp6IbYsECHbyGm4u/h8Xnc8032XMY+uINFfZTjo0O2o/JceT7QQ7jvG6XhrTjoiBKIlz988rby4uzEUrDndFaXomfDG7ndAK758b2iCt+2WW1K1QmqSSQ0lKTPmG6Oh/US+vFtm9euWmQiqyXG98Sc+dApMg==
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(46966005)(70206006)(36756003)(6266002)(82310400003)(450100002)(82740400003)(54906003)(8676002)(5660300002)(70586007)(426003)(44832011)(47076004)(42186006)(356005)(36906005)(336012)(6916009)(81166007)(186003)(478600001)(316002)(26005)(83380400001)(2906002)(2616005)(6666004)(86362001)(4326008)(1076003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 15:37:32.9857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee69584d-999f-4e82-56fc-08d887ea09dc
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1981
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Found one more Logitech device, BCC950 ConferenceCam, which needs
the same delay here. This makes 3 out of 3 devices I have tried.

Therefore, add a delay for all Logitech devices as it does not hurt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
CC: stable@vger.kernel.org (4.19, 5.4)

---
 sound/usb/quirks.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c989ad8052ae..c50be2f75f70 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1672,13 +1672,13 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e/H570e, Jabra 550a, Kingston HyperX
-	 *  needs a tiny delay here, otherwise requests like get/set
-	 *  frequency return as failed despite actually succeeding.
+	/* Zoom R16/24, many Logitech(at least H650e/H570e/BCC950),
+	 * Jabra 550a, Kingston HyperX needs a tiny delay here,
+	 * otherwise requests like get/set frequency return
+	 * as failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a56) ||
+	     USB_ID_VENDOR(chip->usb_id) == 0x046d  || /* Logitech */
 	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
-- 
2.26.2

