Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C4A2BBF76
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 15:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgKUOLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 09:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbgKUOLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 09:11:17 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6931C0613CF
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 06:11:16 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l1so13797439wrb.9
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 06:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=f9pMUTUEFqi+YkPWcA1aHqddVZKg7lAbJppz0YGFDUI=;
        b=kQ+HF4rC1mQX7ttfYGBVr9Uf2Sal69jnmuY5gWCqwsPRgo7kcKFkOtR689+Zr+58/T
         khZhR5eyAO6l56YIckqrLfwTlOeRKXxsnv1qCbhLH5DGn1b/QRb9JUho85BApEexV/hs
         qCUADDU0tckgOuaHn8ZdE7kM/C7Do5+lwxIXGJLndRbKPmnUkOX1OjRedGPaChZOiyIm
         68cbIGN+G9uKX+1b/RtISnVAhwfb0zE9XUQoIKUDvORjeo0q/JmPQUsCaN/rlVjI8SV3
         rMc7bg5SKfOEqYe4CAfMcC5lQxL4x2rOy3AcfY7/3HvvJCTZmBujtQUzjR1t8FqGH119
         g4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=f9pMUTUEFqi+YkPWcA1aHqddVZKg7lAbJppz0YGFDUI=;
        b=Jc+eQ5dmRmsLy1FeVfF4i8YapzVCGHklWpaYxY42mW+nfiWvr29GIu5t5NccTvBAl5
         Trm8iK46D/Q2aSqf4ppxiq4e1lWtWvVWRx7bzjlfbYP/a9sMfq8yh6gyvisG8kPk+otm
         wgPpDLMiRAyViOCsSFrk1fJm2PfnoylyEGM2cT5+OiMFBq1/j7wMOkivtuUWWpNCyfvK
         gnwYYb5uJ/0JjJxoYUaU0dWLpRJz4EtBlXOp8nxHv9m3aeK6aciXtisAugqhW8iVwcXt
         B+gp9wpOCdn6aUeR0jSDu44XeksiP+rjQ2tBADm+iMFUodc+2ld9sewryMUl2lLwVT1p
         3ByA==
X-Gm-Message-State: AOAM5326Uuh/EqP63TVFGIBD94Sj+CpZCF873DPV0P/bceHdKi8wvH+m
        NPL3J57+R6Ire/uwVnkEgQs=
X-Google-Smtp-Source: ABdhPJwO7tjDgp/zJHhDsx+AhxsUIm9LUjUi0zyXDM2J0qR0gQM14jAjTl+q8GhsK5wt70Z95dl1xA==
X-Received: by 2002:adf:a315:: with SMTP id c21mr21283040wrb.272.1605967875691;
        Sat, 21 Nov 2020 06:11:15 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id e6sm7902332wme.27.2020.11.21.06.11.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Nov 2020 06:11:14 -0800 (PST)
Date:   Sat, 21 Nov 2020 14:11:12 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: request for 4.4-stable: 1eefcbc89cf3 ("MIPS: Fix
 BUILD_ROLLBACK_PROLOGUE for microMIPS")
Message-ID: <20201121141112.kz2t74nxo6txb5sk@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tof72e6keyxbi24q"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tof72e6keyxbi24q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

Some mips builds of v4.4.y were failing. Please consider the attached
backport of 1eefcbc89cf3 ("MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS").


--
Regards
Sudip

--tof72e6keyxbi24q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-MIPS-Fix-BUILD_ROLLBACK_PROLOGUE-for-microMIPS.patch"

From 21865305f123377d6223c9e880d40137747770af Mon Sep 17 00:00:00 2001
From: Paul Burton <paul.burton@imgtec.com>
Date: Fri, 19 Aug 2016 18:15:40 +0100
Subject: [PATCH] MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS

commit 1eefcbc89cf3a8e252e5aeb25825594699b47360 upstream

When the kernel is built for microMIPS, branches targets need to be
known to be microMIPS code in order to result in bit 0 of the PC being
set. The branch target in the BUILD_ROLLBACK_PROLOGUE macro was simply
the end of the macro, which may be pointing at padding rather than at
code. This results in recent enough GNU linkers complaining like so:

    mips-img-linux-gnu-ld: arch/mips/built-in.o: .text+0x3e3c: Unsupported branch between ISA modes.
    mips-img-linux-gnu-ld: final link failed: Bad value
    Makefile:936: recipe for target 'vmlinux' failed
    make: *** [vmlinux] Error 1

Fix this by changing the branch target to be the start of the
appropriate handler, skipping over any padding.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/14019/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/kernel/genex.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 7ffd158de76e..1b837d6f73de 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -142,9 +142,8 @@ LEAF(__r4k_wait)
 	PTR_LA	k1, __r4k_wait
 	ori	k0, 0x1f	/* 32 byte rollback region */
 	xori	k0, 0x1f
-	bne	k0, k1, 9f
+	bne	k0, k1, \handler
 	MTC0	k0, CP0_EPC
-9:
 	.set pop
 	.endm
 
-- 
2.11.0


--tof72e6keyxbi24q--
