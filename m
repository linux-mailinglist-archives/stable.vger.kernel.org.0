Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D13F64A1
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbhHXRGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238614AbhHXRCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C04BC6187F;
        Tue, 24 Aug 2021 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824294;
        bh=fz9+MKxsgL5CkXd1SqsmFnmnbedTz+Q9LxX6XyBNhpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7vLTbv9yuMv78jbI9FqYaUQ+b4IJlYLRrobNnDbGjPwA+jpwZfJ26Vwvph0jxL+L
         CN6QLs2kGAoyNe4yGCodsb6RxWQAbsjL+B0VzljdnSH3hC/uSIm42pyNY39pwoTwLl
         NzLjP50+Da/L/41t08GWy8viu4LU6pfJ0NHSw32qH6RvDLASM5VRvZTPG9Xjdl9KQL
         u3LSmx5BNFMycsGAnqDn1UDxVFAeXFjdbxwSLUtU+8sGJ9NPeQuo2n9yym0LDvRz6e
         Z+jNmeBI3DEF+8P1A2rQO15OiXacC5UPd9YUgjCcX5PWmYVBR1sEzpyLAqih4Gx6vJ
         U/m4Ed0jFL7Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 127/127] Linux 5.13.13-rc1
Date:   Tue, 24 Aug 2021 12:56:07 -0400
Message-Id: <20210824165607.709387-128-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 2458a4abcbcc..6faf16adbae1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 12
-EXTRAVERSION =
+SUBLEVEL = 13
+EXTRAVERSION = -rc1
 NAME = Opossums on Parade
 
 # *DOCUMENTATION*
-- 
2.30.2

