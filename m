Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D06812FF
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbjA3O1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjA3O0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A763F29F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009B8B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568CFC433D2;
        Mon, 30 Jan 2023 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088721;
        bh=t81y/5xpFsM6gTyCVxAYwDAiqeJZDU1W2qaORAleL+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bu8ayYZEpP0U4e/WtG21i8fKYL6Um4+1t3Jh86g1uzjXNGFgDNRb3WYJ22clBMr8g
         103ptoE8ojEuDhYHWQ0d7YqRpfD11q5qsSYAqS70qjRF10qofpqGDgvF5b/gMkJjYP
         6IyJ5lUXLToRytkuakX0iVNi9VLlN486cWOf4aI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/143] units: Add Watt units
Date:   Mon, 30 Jan 2023 14:52:49 +0100
Message-Id: <20230130134311.481185460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 2ee5f8f05949735fa2f4c463a5e13fcb3660c719 ]

As there are the temperature units, let's add the Watt macros definition.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c8c37bc51451 ("i2c: designware: use casting of u64 in clock multiplication to avoid overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index aaf716364ec3..92c234e71cab 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,10 @@
 
 #include <linux/kernel.h>
 
+#define MILLIWATT_PER_WATT	1000L
+#define MICROWATT_PER_MILLIWATT	1000L
+#define MICROWATT_PER_WATT	1000000L
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
-- 
2.39.0



