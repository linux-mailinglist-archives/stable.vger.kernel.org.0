Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB6A3B6471
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhF1PIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235442AbhF1PGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C025F61D8D;
        Mon, 28 Jun 2021 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891426;
        bh=lKb7DXgQdrbXKlakHqrzoQ1oNOAYdWzsVkxYKPu5IRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHF2S6h7VMQtjzfYbhXEn60gtZbIK4jv/RFXFCrQgeT8U8yG4URQRc/DQ+9cSnrJw
         X02HXilDgQ4r8JxWbQzz4AxQdxpCKqskHi2F5hGMYfvWHUUcnf3BnWYg+8f7EGbK4Z
         7WPhqWq5XPOPG+6htw6uLIVEtTse5T8epeCCIdiSMmOkiYSjIuwnFLX53NmuNneKEM
         hzhLNGMFle2stgorBNBWFHmvDZzjMExIPoZWNEWJAmWkX1CV7xXRmcl964h1QAebvm
         e/zX3u8fcZYTgnkaVMT38PEb6w0Ny2QHKJldsP83AXbz1IfSnQ0O0KwUZhsxXN+TTi
         pvvani42CgOGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 57/57] Linux 4.4.274-rc1
Date:   Mon, 28 Jun 2021 10:42:56 -0400
Message-Id: <20210628144256.34524-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 691072b50fb5..19d33abd21dc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 273
-EXTRAVERSION =
+SUBLEVEL = 274
+EXTRAVERSION = -rc1
 NAME = Blurry Fish Butt
 
 # *DOCUMENTATION*
-- 
2.30.2

