Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE64D32E1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiCIQO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiCIQNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:13:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A837E167F93;
        Wed,  9 Mar 2022 08:10:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7207B8222F;
        Wed,  9 Mar 2022 16:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E242AC340E8;
        Wed,  9 Mar 2022 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842227;
        bh=PGRE0saXYgT+u/n78gzLARVUPRogumyF8xx5U1oiHyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anfUJE4zF1u72igsXbIByhD8N6PI0gwkxQC/lJx5g33O/OXSNdIDZl9mWKx+6Qzcu
         oBSVL8Sy0PxsaxlBXb6Jxcdl8z9tsfijYFo/pDecrBD2NGLRPBX/s6IGnTPEsL1BQy
         HALDHeJeKcw2gIOdyvafevLX37kMZ+x9ZAEtX0h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.16 06/37] x86/speculation: Update link to AMD speculation whitepaper
Date:   Wed,  9 Mar 2022 17:00:07 +0100
Message-Id: <20220309155859.273485501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
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
@@ -697,7 +697,7 @@ AMD white papers:
 
 .. _spec_ref6:
 
-[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/90343-B_SoftwareTechniquesforManagingSpeculation_WP_7-18Update_FNL.pdf>`_.
+[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/Managing-Speculation-on-AMD-Processors.pdf>`_.
 
 ARM white papers:
 


