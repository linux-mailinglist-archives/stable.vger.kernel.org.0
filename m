Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA84890E4
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbiAJH0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbiAJHZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB70C034001;
        Sun,  9 Jan 2022 23:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B94B1B811FE;
        Mon, 10 Jan 2022 07:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B6C36AE9;
        Mon, 10 Jan 2022 07:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799492;
        bh=aJTMa753pVCb24+LWmO/riXKBIPRQ8WrVh53YMaVTAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMxztVp7UPFeQv/aJ8DRNsJUbQxaAw0lsGW6wlEjJRABT2NZXp4waXKUrrPDzVgpU
         1ZJgaV+PTGJY/BHnU+/0RAXVACEgBWBaLbyUFlnlx91p1Nw7Wkz08p4RR/dfg5RhAK
         hUWKBjgitGUOQFD7zzegWBQ+TCYJnCv+UIw0XKbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Stefan Traby <stefan@hello-penguin.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 12/21] arm64: Remove a redundancy in sysreg.h
Date:   Mon, 10 Jan 2022 08:22:59 +0100
Message-Id: <20220110071813.214703564@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Traby <stefan@hello-penguin.com>

commit d38338e396ee0571b3502962fd2fbaec4d2d9a8f upstream.

This is really trivial; there is a dup (1 << 16) in the code

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stefan Traby <stefan@hello-penguin.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -95,8 +95,8 @@
 #define SCTLR_ELx_M	1
 
 #define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
-			 (1 << 16) | (1 << 18) | (1 << 22) | (1 << 23) | \
-			 (1 << 28) | (1 << 29))
+			 (1 << 18) | (1 << 22) | (1 << 23) | (1 << 28) | \
+			 (1 << 29))
 
 #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
 			 SCTLR_ELx_SA | SCTLR_ELx_I)


