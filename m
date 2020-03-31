Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF37199721
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgCaNLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbgCaNLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:21 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A2120784;
        Tue, 31 Mar 2020 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660281;
        bh=PJjRpgSRAbKNR3vA/VLgtYNrcsUaXX7nSe+2cX8sgQ8=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=rgrivWVMjpzpcdTDMlh8J7vky5fnuGobTUGBJd3HNSMKxqFkxuoIOT0mCgnvLBNEV
         X2GmUmTKJLBGiyagcQ+BoaE1fwVUXBhwTogfC5nSf0ASurYivRipJFA1lAI1MHWkcs
         xoWLvwn+GHNUZbBCs6YKD5QXFX2sXQP1Z8kdSBrw=
Date:   Tue, 31 Mar 2020 13:11:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Clement Courbet <courbet@google.com>
To:     unlisted-recipients:; (no To-header on input)
Cc:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] powerpc: Make setjmp/longjmp signature standard
In-Reply-To: <20200330080400.124803-1-courbet@google.com>
References: <20200330080400.124803-1-courbet@google.com>
Message-Id: <20200331131120.C4A2120784@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp").

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174.

v5.5.13: Build OK!
v5.4.28: Failed to apply! Possible dependencies:
    74277f00b232 ("powerpc/fsl_booke/kaslr: export offset in VMCOREINFO ELF notes")
    793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
    9f7bd9201521 ("powerpc/32: Split kexec low level code out of misc_32.S")

v4.19.113: Failed to apply! Possible dependencies:
    2874c5fd2842 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 152")
    40b0b3f8fb2d ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 230")
    793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
    9f7bd9201521 ("powerpc/32: Split kexec low level code out of misc_32.S")
    aa497d435241 ("powerpc: Add attributes for setjmp/longjmp")
    c47ca98d32a2 ("powerpc: Move core kernel logic into arch/powerpc/Kbuild")
    fb0b0a73b223 ("powerpc: Enable kcov")

v4.14.174: Failed to apply! Possible dependencies:
    06bb53b33804 ("powerpc: store and restore the pkey state across context switches")
    1421dc6d4829 ("powerpc/kbuild: Use flags variables rather than overriding LD/CC/AS")
    1b4037deadb6 ("powerpc: helper function to read, write AMR, IAMR, UAMOR registers")
    2ddc53f3a751 ("powerpc: implementation for arch_set_user_pkey_access()")
    471d7ff8b51b ("powerpc/64s: Remove POWER4 support")
    4d70b698f957 ("powerpc: helper functions to initialize AMR, IAMR and UAMOR registers")
    4fb158f65ac5 ("powerpc: track allocation status of all pkeys")
    793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
    92e3da3cf193 ("powerpc: initial pkey plumbing")
    a73657ea19ae ("powerpc/64: Add GENERIC_CPU support for little endian")
    aa497d435241 ("powerpc: Add attributes for setjmp/longjmp")
    badf436f6fa5 ("powerpc/Makefiles: Convert ifeq to ifdef where possible")
    c0d64cf9fefd ("powerpc: Use feature bit for RTC presence rather than timebase presence")
    c1807e3f8466 ("powerpc/64: Free up CPU_FTR_ICSWX")
    c47ca98d32a2 ("powerpc: Move core kernel logic into arch/powerpc/Kbuild")
    cf43d3b26452 ("powerpc: Enable pkey subsystem")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
