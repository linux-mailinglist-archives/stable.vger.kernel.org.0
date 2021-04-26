Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B175E36AE73
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhDZHpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhDZHnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D03EA613AA;
        Mon, 26 Apr 2021 07:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422784;
        bh=oyP6LS1k5NAJuRJ7cgqeIJDp4HwS7W3aMhJT+0+SU/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Et7FLxLcL1ZC7JeNwbQj1yDtJHcU5+NYDs8gVKgm/vJpYJtGRHT0L5DHkyTfQsOj
         T/VgbiMdpYAPf2ebhQv4ZZbqiDylwBMZOyfazFgHqla7B2/wgZFwprIwQgwbN6CTxn
         MCXYAL/fS3v2Jnp79iwZL2o099oPFMELhVGCgDM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuanyuan Zhong <yzhong@purestorage.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/36] pinctrl: lewisburg: Update number of pins in community
Date:   Mon, 26 Apr 2021 09:29:47 +0200
Message-Id: <20210426072818.969086612@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuanyuan Zhong <yzhong@purestorage.com>

[ Upstream commit 196d941753297d0ca73c563ccd7d00be049ec226 ]

When updating pin names for Intel Lewisburg, the numbers of pins were
left behind. Update them accordingly.

Fixes: e66ff71fd0db ("pinctrl: lewisburg: Update pin list according to v1.1v6")
Signed-off-by: Yuanyuan Zhong <yzhong@purestorage.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-lewisburg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-lewisburg.c b/drivers/pinctrl/intel/pinctrl-lewisburg.c
index 7fdf4257df1e..ad4b446d588e 100644
--- a/drivers/pinctrl/intel/pinctrl-lewisburg.c
+++ b/drivers/pinctrl/intel/pinctrl-lewisburg.c
@@ -299,9 +299,9 @@ static const struct pinctrl_pin_desc lbg_pins[] = {
 static const struct intel_community lbg_communities[] = {
 	LBG_COMMUNITY(0, 0, 71),
 	LBG_COMMUNITY(1, 72, 132),
-	LBG_COMMUNITY(3, 133, 144),
-	LBG_COMMUNITY(4, 145, 180),
-	LBG_COMMUNITY(5, 181, 246),
+	LBG_COMMUNITY(3, 133, 143),
+	LBG_COMMUNITY(4, 144, 178),
+	LBG_COMMUNITY(5, 179, 246),
 };
 
 static const struct intel_pinctrl_soc_data lbg_soc_data = {
-- 
2.30.2



