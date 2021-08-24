Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A23F66DA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbhHXR2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239515AbhHXR0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D48FF61B41;
        Tue, 24 Aug 2021 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824652;
        bh=tfKLsJi72j2VyIJ7v5lQewodphllmKv+kx639Fr1qew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAg8pMmYov+gnSYGZ+Tol1F+Rnb1zU4ir6Rg81bxzNi7Hwn24Y+0K/vbxc6p0vKy3
         YQrbKI8oP8hJBnSmTu7E46sGlp8vKGRnjV8QmLkPBSDQ5AD3qIj+Gpo0dIl6WCxnuJ
         R7MHV8WdswT4PeEm38zKuqsZhQnlSxqiTu8B/EsLZw7p4Qt6fvdnk35nKPxCNh4ULh
         6DYWkbc06cd55vRLZEuGNHitWFU92vEta8BkNE/BTqBDmdcdvPfdqEiUWtaILIA1Ep
         yAjQ2jvcuR3gnca4uNQA1lhFE/P7OaQHuy2vThKoD30KUqQDwf+oH49b6/ZfnrK2Bf
         FVtWHFq/D50lA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 84/84] Linux 4.19.205-rc1
Date:   Tue, 24 Aug 2021 13:02:50 -0400
Message-Id: <20210824170250.710392-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index d4ffcafb8efa..c0fd3cd96338 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 204
-EXTRAVERSION =
+SUBLEVEL = 205
+EXTRAVERSION = -rc1
 NAME = "People's Front"
 
 # *DOCUMENTATION*
-- 
2.30.2

