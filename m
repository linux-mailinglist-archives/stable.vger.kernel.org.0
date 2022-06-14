Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4454B8F5
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357094AbiFNSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347374AbiFNSmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:42:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973424992C;
        Tue, 14 Jun 2022 11:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280BFB81AEC;
        Tue, 14 Jun 2022 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70645C3411D;
        Tue, 14 Jun 2022 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232108;
        bh=aeVpXKbqdQ5mK8L5Tc3oxflXliKoE2X0ydk71CIoT28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zC63BLgS/jOg0x+UDsBzgkytblvODVJP91QIT3n6UGvt15xJNybuNKI3v5OrCuE07
         ul5/Cj2Or2gm4D+EWz8J3XT7p1q9U5EBiZ4+2TV2MfUDPtqg3keYhtV2xgn5j/8AcA
         LXMTbcEvx48/Z68Cw22Uee06J4RqHHfSo0wuwvV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 09/20] x86/cpu: Add another Alder Lake CPU to the Intel family
Date:   Tue, 14 Jun 2022 20:39:52 +0200
Message-Id: <20220614183724.312334964@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
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

From: Gayatri Kammela <gayatri.kammela@intel.com>

commit 6e1239c13953f3c2a76e70031f74ddca9ae57cd3 upstream.

Add Alder Lake mobile CPU model number to Intel family.

Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20210121215004.11618-1-tony.luck@intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -68,6 +68,7 @@
 
 #define	INTEL_FAM6_LAKEFIELD		0x8A
 #define INTEL_FAM6_ALDERLAKE		0x97
+#define INTEL_FAM6_ALDERLAKE_L		0x9A
 
 /* "Small Core" Processors (Atom) */
 


