Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3626247EB0
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 11:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfFQJpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 05:45:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43655 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbfFQJpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 05:45:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F27B0222B8;
        Mon, 17 Jun 2019 05:45:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Jun 2019 05:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2/XSbS
        Gx7ly08RYbnK3cGJVhGRaYE+xTkztSYBTnPc4=; b=GZeGNfwtyOu6Cc7zXBu/9X
        l0YMzpAEH4LZYcclWAki8DPJWUzhTPEizgNp/N8u/BNe+ipNauh0EPl2kPcOhV06
        23rUgl50TwRYcHOnxHEjC0MRhDvgzg0X9RCR+XU0Hn7ImuIGNpV53GRevt3BXWDb
        CDe/CumINjuaf5yes9JcXYZGy8C/ZDzXx/dR5LsY7jdS98X8piATyLzzm6ZVXaLs
        WudX8RQwZrgeOdVSybOLY38TlhTqEVH7kCwhMZHkwQFJZ/IxEMRoX83zLC3kUWpy
        e72QNRwLGziwMoEKv0qhF1+dMxuIRyoovLrwWpH+xkCJaeSxp40A/YPI1bBVIlfQ
        ==
X-ME-Sender: <xms:HGEHXfsOEOarTG2Xhr-9olBKSsrxqXPzaNZEwL5bJ_8F93EmEms-iQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HGEHXVXWAN6Tv5mOkCXIjqR_P_uih787navo-S4NQwu4yp6c-5Njnw>
    <xmx:HGEHXQWxc-vBhAaijAbuN82j4l-E-248Z60KYfv6RpOPuDjyU2FV5Q>
    <xmx:HGEHXQSti8QTj1nnP34-3iSZffFm2EP1d13ZRiRlDNavdrXTWh9pEg>
    <xmx:HGEHXU74M95Cp-ZfSQMq1_USdJcOE40Wo3U_GNdczbAQcXNm0gKp0w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8C4A380091;
        Mon, 17 Jun 2019 05:44:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/resctrl: Don't stop walking closids when a locksetup" failed to apply to 5.1-stable tree
To:     james.morse@arm.com, bp@alien8.de, fenghua.yu@intel.com,
        hpa@zytor.com, reinette.chatre@intel.com, stable@vger.kernel.org,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 11:44:58 +0200
Message-ID: <1560764698180165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87d3aa28f345bea77c396855fa5d5fec4c24461f Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Mon, 3 Jun 2019 18:25:31 +0100
Subject: [PATCH] x86/resctrl: Don't stop walking closids when a locksetup
 group is found

When a new control group is created __init_one_rdt_domain() walks all
the other closids to calculate the sets of used and unused bits.

If it discovers a pseudo_locksetup group, it breaks out of the loop.  This
means any later closid doesn't get its used bits added to used_b.  These
bits will then get set in unused_b, and added to the new control group's
configuration, even if they were marked as exclusive for a later closid.

When encountering a pseudo_locksetup group, we should continue. This is
because "a resource group enters 'pseudo-locked' mode after the schemata is
written while the resource group is in 'pseudo-locksetup' mode." When we
find a pseudo_locksetup group, its configuration is expected to be
overwritten, we can skip it.

Fixes: dfe9674b04ff6 ("x86/intel_rdt: Enable entering of pseudo-locksetup mode")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H Peter Avin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190603172531.178830-1-james.morse@arm.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 333c177a2471..869cbef5da81 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2542,7 +2542,12 @@ static int __init_one_rdt_domain(struct rdt_domain *d, struct rdt_resource *r,
 		if (closid_allocated(i) && i != closid) {
 			mode = rdtgroup_mode_by_closid(i);
 			if (mode == RDT_MODE_PSEUDO_LOCKSETUP)
-				break;
+				/*
+				 * ctrl values for locksetup aren't relevant
+				 * until the schemata is written, and the mode
+				 * becomes RDT_MODE_PSEUDO_LOCKED.
+				 */
+				continue;
 			/*
 			 * If CDP is active include peer domain's
 			 * usage to ensure there is no overlap

