Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23596DD8C9
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDKLEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDKLEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B008C5
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8EE06242A
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC366C433D2;
        Tue, 11 Apr 2023 11:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210963;
        bh=b5NiRhqM7ITm1vaG7ULddG8U0ZhTM/lcK8eOy/omF2Y=;
        h=Subject:To:Cc:From:Date:From;
        b=xo5rzUFquQM18dEt9mRhNjnY/u/z3DvAE3jDqgymur5Ly+XzjgjCCI0BTGpRWhaxC
         YUea6jtI4mpoMfR9tz6Y331OEADjqyXzJ7nEkrgYLdqqc0lHFGZbu+IZYE3WjKnZwX
         PbGTDP+ibHGGNPRRYahoq1Y2uZwvjrzIL1eDlnPc=
Subject: FAILED: patch "[PATCH] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug" failed to apply to 4.14-stable tree
To:     scclevenger@os.amperecomputing.com, james.clark@arm.com,
        suzuki.poulose@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:02:29 +0200
Message-ID: <2023041128-almanac-hasty-c1f0@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x bf84937e882009075f57fd213836256fc65d96bc
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041128-almanac-hasty-c1f0@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

bf84937e8820 ("coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug")
f5bd523690d2 ("coresight: etm4x: Convert all register accesses")
df81b43802f4 ("coresight: etm4x: Skip accessing TRCPDCR in save/restore")
f6a18f354c58 ("coresight: etm4x: Handle access to TRCSSPCICRn")
60c519c5d362 ("coresight: etm4x: Handle TRCVIPCSSCTLR accesses")
6288b4ceca86 ("coresight: etm4x: Fix accesses to TRCPROCSELR")
f2603b22e3d2 ("coresight: etm4x: Fix accesses to TRCCIDCTLR1")
93dd64404cbe ("coresight: etm4x: Fix accesses to TRCVMIDCTLR1")
347732627745 ("coresight: etm4x: Fix save and restore of TRCVMIDCCTLR1 register")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")
685d84a7862e ("coresight: etm4x: Fix mis-usage of nr_resource in sysfs interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bf84937e882009075f57fd213836256fc65d96bc Mon Sep 17 00:00:00 2001
From: Steve Clevenger <scclevenger@os.amperecomputing.com>
Date: Mon, 27 Feb 2023 16:54:32 -0700
Subject: [PATCH] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

In etm4_enable_hw, fix for() loop range to represent address comparator pairs.

Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Clevenger <scclevenger@os.amperecomputing.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/4a4ee61ce8ef402615a4528b21a051de3444fb7b.1677540079.git.scclevenger@os.amperecomputing.com

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 1ea8f173cca0..104333c2c8a3 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -472,7 +472,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		if (etm4x_sspcicrn_present(drvdata, i))
 			etm4x_relaxed_write32(csa, config->ss_pe_cmp[i], TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		etm4x_relaxed_write64(csa, config->addr_val[i], TRCACVRn(i));
 		etm4x_relaxed_write64(csa, config->addr_acc[i], TRCACATRn(i));
 	}

