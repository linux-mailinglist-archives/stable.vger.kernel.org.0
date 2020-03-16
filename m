Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E0C186A83
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgCPMED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgCPMED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 08:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33DB520663;
        Mon, 16 Mar 2020 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584360242;
        bh=djLtu8ZyX5BAvc0azv2CNH7DSjwhMzu6V1wVYHyv7Xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoWRlKNQuAXtj6yxjLnl/lz6Cx4zrHmvJlA1PVNghXNDRuqozUeXTF/nFFarHuHlO
         nWLIvzw0NyorgrFbAldml8uxrE38g6tF7I/caW/6PBFqCGFbhPTggxyJMphTTKBzG8
         5AFrIUNggzBHHc7Vnzi8KDMgWmHnBh1Ug5PkvHo4=
Date:   Mon, 16 Mar 2020 13:03:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.19.110
Message-ID: <20200316120359.GB3735485@kroah.com>
References: <20200316120351.GA3735485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316120351.GA3735485@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 059c5e0aac15..ada958d1bc2b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 109
+SUBLEVEL = 110
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3f0565e1a7a8..cc8f3b41a1b2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1336,7 +1336,7 @@ static __init void svm_adjust_mmio_mask(void)
 	 */
 	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	kvm_mmu_set_mmio_spte_mask(mask, mask);
 }
 
 static __init int svm_hardware_setup(void)
