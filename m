Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4E71ED6A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfEOLJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbfEOLJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E9C2084F;
        Wed, 15 May 2019 11:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918563;
        bh=hnUej7ys3ITiP39luoDvCJAWYDcmxkOIaF1YbLFXxxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS5wNnD6V1YqI4kC5zb5VUsGUAywBEbgyOamCCGb7N9kyS+2sX4jYmFboEm0Tc7Qd
         YdXQwTv3vuKKoLwuuPl/8yEHzkigWMMPXPXusPQ/kgqUx3/1+LyXr9wCFAyXKEuKrE
         8+fQfGse2Ui6K6qk5GmAp0Fn4Pe6nufy6GSqECE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 180/266] x86: stop exporting msr-index.h to userland
Date:   Wed, 15 May 2019 12:54:47 +0200
Message-Id: <20190515090729.016771030@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 25dc1d6cc3082aab293e5dad47623b550f7ddd2a upstream.

Even if this file was not in an uapi directory, it was exported because
it was listed in the Kbuild file.

Fixes: b72e7464e4cf ("x86/uapi: Do not export <asm/msr-index.h> as part of the user API headers")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/uapi/asm/Kbuild |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -27,7 +27,6 @@ header-y += ldt.h
 header-y += mce.h
 header-y += mman.h
 header-y += msgbuf.h
-header-y += msr-index.h
 header-y += msr.h
 header-y += mtrr.h
 header-y += param.h


