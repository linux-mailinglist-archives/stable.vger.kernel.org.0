Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B427E2C085A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgKWMtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732854AbgKWMsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B612100A;
        Mon, 23 Nov 2020 12:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135722;
        bh=gM89MfZ998p/Ja/OWi4kBdesmpq9uN6SgkbmSVygvk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/Dxo0XRO0ckauz0X/KNbI0LEasItVgDIgnJUNdq9wI5gxrqaN9WmTBQiq/IkNnP9
         YvshvktcpXntkk2SWfkGpDid8E5ehsUnFWpc9pHR0HTA4waQJ3Oxgp1vBpTKDF02xB
         5h6NhyF8iXFwr6ne1ZW7mzVnt9VW+pistFXok6Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 171/252] selftests/seccomp: powerpc: Fix typo in macro variable name
Date:   Mon, 23 Nov 2020 13:22:01 +0100
Message-Id: <20201123121843.845269996@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f5098e34dd4c774c3040e417960f1637e5daade8 ]

A typo sneaked into the powerpc selftest. Fix the name so it builds again.

Fixes: 46138329faea ("selftests/seccomp: powerpc: Fix seccomp return value testing")
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/lkml/87y2ix2895.fsf@mpe.ellerman.id.au
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 9a9eb02539fb4..6a27b12e9b3c2 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1710,10 +1710,10 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 		 * and the code is stored as a positive value.	\
 		 */						\
 		if (_result < 0) {				\
-			SYSCALL_RET(_regs) = -result;		\
+			SYSCALL_RET(_regs) = -_result;		\
 			(_regs).ccr |= 0x10000000;		\
 		} else {					\
-			SYSCALL_RET(_regs) = result;		\
+			SYSCALL_RET(_regs) = _result;		\
 			(_regs).ccr &= ~0x10000000;		\
 		}						\
 	} while (0)
-- 
2.27.0



