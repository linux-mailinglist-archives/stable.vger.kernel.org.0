Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3554B994
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357793AbiFNSsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357332AbiFNSqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2176B4B844;
        Tue, 14 Jun 2022 11:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B340661808;
        Tue, 14 Jun 2022 18:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2410C341C4;
        Tue, 14 Jun 2022 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232263;
        bh=ddLRJdnBXp76RgskmoRCcED4kS6cZU+0WZP0iKaDWIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQwUOnN07ziTAUsZ0vqDanspOqIFXoFLgLB4rR73oX13noUIfE2x0R160UZjoLn10
         RxHjS4q+5ea753Eq9Ysr3kpyGSyhdDlcSaSBsC+4w37pKmUykoCsgobwn94RWey6GF
         5AvmEzKQhUkay4B10cN/s/RIwFy+WAPvmlmuUmkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 03/15] x86/cpu: Add Lakefield, Alder Lake and Rocket Lake models to the to Intel CPU family
Date:   Tue, 14 Jun 2022 20:40:12 +0200
Message-Id: <20220614183722.498839511@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
References: <20220614183721.656018793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit e00b62f0b06d0ae2b844049f216807617aff0cdb upstream.

Add three new Intel CPU models.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200721043749.31567-1-tony.luck@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -86,6 +86,13 @@
 #define INTEL_FAM6_COMETLAKE		0xA5
 #define INTEL_FAM6_COMETLAKE_L		0xA6
 
+#define INTEL_FAM6_ROCKETLAKE		0xA7
+
+/* Hybrid Core/Atom Processors */
+
+#define	INTEL_FAM6_LAKEFIELD		0x8A
+#define INTEL_FAM6_ALDERLAKE		0x97
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */


