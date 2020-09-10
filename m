Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF31B264094
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 10:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIJIxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 04:53:42 -0400
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:57994
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727820AbgIJIxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 04:53:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKDhert42/g9k8UgHKlwAh+2G1IjbG4hQ1cn6oNAsRVsEDDqOnu1bwPBOBxcAqRym04CFXsJnNHNb4wuEMA6KIEXbKWddWJdQkvYtAXxg06LjNhKX+mHbtJxJpD88DgpMZSjXBlYrWQJJHMZChUJ/ANCeL+HDwcnIpq5YRmIS0adtdyZvacJip2Ou78HyxRQN7cYfhJ7dirR9baFtSsS5BPxuhGieiTAxBypdh30jKKonfnRFsDGWqdpdEebi/U1aaFv86JlBa5qZs6QDIbPxRPm0uP3FdJUyiNpqv3UdoI1DmGkwuo/zzk3lUu4Iv/yXSn0EpbeofXmeoIChe2iqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPOCEX8ljTcxsyYyl39b03L1F7qBLlocdPa6VU6aA54=;
 b=kkxf0ScCTkk46/i//tGEc1Vfqc+AOODy2lxR7XtwyUVGt9Wq94UdSMDMD3BnrEYBUP07Ss5xkczbcFS44ynQ9iLV3rtPUgtcY/XYY8xkpWYnJ8iTuwL5P4vnC6aRywHjNjBG/BhI4CVD8/epCEItd6R2/hXlfcLbrkmBjIvMKc/oGzO7buSH052YkCEkOogjpXuVayuoQBb37AhfQgoHUn3n4qsFnSX32pcCmBx/b7RnD7Z6aSWq6KI5vi1+a3w9d7k+7Qppy4LTd3N7gNCm5GZSzKrOMEpI03IMonZ4ZiKpdgtuLCOtIQsCRuRHkOqdDrOFcmlUVebT4Z2KOycTMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPOCEX8ljTcxsyYyl39b03L1F7qBLlocdPa6VU6aA54=;
 b=jkmMEJHbViakc8cIGAFAXrgwH+7ZFDoDjTE4s3oA0MTQWtHmrnWltbatHul/y1cK4IPCK2/LMSYMlL5HpAGOqyOUppwufDPOGHwEfi20tiBJ+sXAIzvnDgLUBiCy+SC4Lzu6dfTP0GNZSozqEJbsSxZR0Dg8ZDur+Z6130/JxWk=
Received: from CO2PR04CA0145.namprd04.prod.outlook.com (2603:10b6:104::23) by
 BN6PR10MB1492.namprd10.prod.outlook.com (2603:10b6:404:46::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Thu, 10 Sep 2020 08:53:35 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::69) by CO2PR04CA0145.outlook.office365.com
 (2603:10b6:104::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend
 Transport; Thu, 10 Sep 2020 08:53:35 +0000
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
 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 08:53:34 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 10 Sep 2020 01:53:34 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Thu, 10 Sep 2020 01:53:34 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Thu, 10 Sep 2020 01:53:34 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 807D72C06DF0;
        Thu, 10 Sep 2020 10:53:33 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 72CE55EE3; Thu, 10 Sep 2020 10:53:33 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <alsa-devel@alsa-project.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ALSA: usb-audio: Add delay quirk for H570e USB headsets
Date:   Thu, 10 Sep 2020 10:53:28 +0200
Message-ID: <20200910085328.19188-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Sep 2020 08:53:34.0456 (UTC) FILETIME=[DDA20F80:01D6874F]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79fc1aa1-242f-4054-3c52-08d855670073
X-MS-TrafficTypeDiagnostic: BN6PR10MB1492:
X-Microsoft-Antispam-PRVS: <BN6PR10MB1492478F399D1ED1525F3D34F4270@BN6PR10MB1492.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBrUyeb1h0bjWDPopYeLcoyIhcmrgKo+ZntlXg16rOzGjKqZe13UnJGksQ4Yd5TJgaNTf1wKSw1++QVcisifx3m+VHy0bOVjQeni2DoZqXVMMSukPUhhUQG5nUStnOIY5EFJCbJAWUB0mWWYjlLKO9Cq0qvRlAA5DWMwtVClCV6AZHw9FB9BsEyU5ZivsGqfjxg8wEXawPGjdvDuj3/cesWM7Q+B3ANBWUXzonGQHsKKjW/L0B2ePvmtaHmhW2z/MBX/Fti8kxRDqGGw9wXh7JNH0/DYwC82O6hEZLBh1+J5OhllzgkniM7DW79hNr1vC1PcCHeiYO5YTvQIDlAqeCcw0RyAnB2S1KbNJABLZCCTwTR27zEch3Wo6Cg2fL6tQ9VT/ZwmA7hM59Pu4S8gMezyPEc1+UtFaUwCC7AYooxC9DzrdqfS9KkZhQBx8pOG
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(46966005)(186003)(82740400003)(8676002)(336012)(5660300002)(83380400001)(26005)(70206006)(426003)(70586007)(4326008)(8936002)(6862004)(36756003)(82310400003)(47076004)(2616005)(6266002)(86362001)(44832011)(2906002)(356005)(42186006)(54906003)(316002)(36906005)(478600001)(1076003)(34020700004)(81166007)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 08:53:34.9870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fc1aa1-242f-4054-3c52-08d855670073
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1492
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Needs the same delay as H650e

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 sound/usb/quirks.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 75bbdc691243..892296df131d 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1678,12 +1678,13 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e, Jabra 550a, Kingston HyperX needs a tiny
-	 * delay here, otherwise requests like get/set frequency return as
-	 * failed despite actually succeeding.
+	/* Zoom R16/24, Logitech H650e/H570e, Jabra 550a, Kingston HyperX
+	 *  needs a tiny delay here, otherwise requests like get/set
+	 *  frequency return as failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
 	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
+	     chip->usb_id == USB_ID(0x046d, 0x0a56) ||
 	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
-- 
2.26.2

