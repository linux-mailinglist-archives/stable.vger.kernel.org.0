Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAA136ADAF
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhDZHhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232647AbhDZHhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F01613CA;
        Mon, 26 Apr 2021 07:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422502;
        bh=7oGr0g9icFPszOKRcqDL9oUHKkt/Jp5iVJTKzP88aNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAB5i1506h6kYuU6QHq3V3ZROGfYhNbVHtX6aIIC/J+c5k7WiawDCZSrMZdHj5utL
         w9O02/In2zRh7UA3fVoExMGr/XhkUdd4pP63jZ3fM5PrRi4CY21M5rLv1AcqsWFgDO
         VofUZ0GZB/Irmvqo3KJRdfM/be7ELMZwPLzsGNCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuanyuan Zhong <yzhong@purestorage.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/49] pinctrl: lewisburg: Update number of pins in community
Date:   Mon, 26 Apr 2021 09:29:35 +0200
Message-Id: <20210426072821.058504610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
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
index c2164db14e9c..9fdcae3260e8 100644
--- a/drivers/pinctrl/intel/pinctrl-lewisburg.c
+++ b/drivers/pinctrl/intel/pinctrl-lewisburg.c
@@ -300,9 +300,9 @@ static const struct pinctrl_pin_desc lbg_pins[] = {
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



