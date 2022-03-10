Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77104D49F5
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbiCJO0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243449AbiCJOZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E8B164D1E;
        Thu, 10 Mar 2022 06:22:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7613461CF0;
        Thu, 10 Mar 2022 14:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A44EC340E8;
        Thu, 10 Mar 2022 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922099;
        bh=wBLb1JgeLGCmIlJRSZ+nBqsfFArPm7x3PghLmULm8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8qjqkDInkyjbcI6kLsrI+zQI5413+4DWpE86yK4s0a7FcqXFrzwchyyT3zMBuEUo
         mDrX26qFA5povs9YpPSSfzIB6rUR1EiZ46Wny9OloGx+pzjuLhJ8KuQt+hMYbwLYvX
         wxVaPyt2+BJBLr66vwDv890RmoY1Bwn/S5KyB0M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 08/31] x86/speculation: Update link to AMD speculation whitepaper
Date:   Thu, 10 Mar 2022 15:18:21 +0100
Message-Id: <20220310140807.776338487@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit e9b6013a7ce31535b04b02ba99babefe8a8599fa upstream.

Update the link to the "Software Techniques for Managing Speculation
on AMD Processors" whitepaper.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -60,8 +60,8 @@ privileged data touched during the specu
 Spectre variant 1 attacks take advantage of speculative execution of
 conditional branches, while Spectre variant 2 attacks use speculative
 execution of indirect branches to leak privileged memory.
-See :ref:`[1] <spec_ref1>` :ref:`[5] <spec_ref5>` :ref:`[7] <spec_ref7>`
-:ref:`[10] <spec_ref10>` :ref:`[11] <spec_ref11>`.
+See :ref:`[1] <spec_ref1>` :ref:`[5] <spec_ref5>` :ref:`[6] <spec_ref6>`
+:ref:`[7] <spec_ref7>` :ref:`[10] <spec_ref10>` :ref:`[11] <spec_ref11>`.
 
 Spectre variant 1 (Bounds Check Bypass)
 ---------------------------------------
@@ -746,7 +746,7 @@ AMD white papers:
 
 .. _spec_ref6:
 
-[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/90343-B_SoftwareTechniquesforManagingSpeculation_WP_7-18Update_FNL.pdf>`_.
+[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/Managing-Speculation-on-AMD-Processors.pdf>`_.
 
 ARM white papers:
 


