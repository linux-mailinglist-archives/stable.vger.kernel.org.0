Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02411B3D3D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgDVKNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDVKNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D9720575;
        Wed, 22 Apr 2020 10:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550398;
        bh=HFt2cNSRVwRrNyRATsHeOZAVGfis+zFjOerb5zwBaPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQwUWEYsdM1a04HqI/sutsBj48VBpxhVWOxRd0quxz+JDuyhjzO76SaBfx04pJJnX
         OKitXWNzE2Nvgen+3bnqcRmcdAGDpLkWTAwR8VB4dBhNcuC/HQcb4E1vnhdE1YiNaR
         ZshZAG5TNl4HsbSHdgD402w0PdbyNJGyACAPBYBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Allen <john.allen@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 129/199] x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE
Date:   Wed, 22 Apr 2020 11:57:35 +0200
Message-Id: <20200422095110.749884551@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Allen <john.allen@amd.com>

commit bdf89df3c54518eed879d8fac7577fcfb220c67e upstream.

Future AMD CPUs will have microcode patches that exceed the default 4K
patch size. Raise our limit.

Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v4.14..
Link: https://lkml.kernel.org/r/20200409152931.GA685273@mojo.amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/microcode_amd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -41,7 +41,7 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define PATCH_MAX_SIZE PAGE_SIZE
+#define PATCH_MAX_SIZE (3 * PAGE_SIZE)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern void __init load_ucode_amd_bsp(unsigned int family);


