Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD13F6831
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242279AbhHXRlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242404AbhHXRjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA93361BD3;
        Tue, 24 Aug 2021 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824894;
        bh=y/CgQNhb7k1Wuz5qY1bm3nMhu8jzx5k8zKYaf7lglcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rv89s51WPxAcq/D5KNd9EyMWK6xml5r7gVPM8qBREm4JvWwwb1E2rODvTisAlgrb+
         O+QmMfThvNbPqQT6aBQzAzoJwJsKM9vpcyJ8VELf1kIIwpjWV8tX8zIadTGtC//Iyl
         9XcZ2bAi4Kr6FibDQ2ilPkzrPMEGNKvCiNQ6pz2ltxaa80aQOwsX9IVIFEJrT1KlcC
         Mg5Wj1IKgt6qS9nc+jJjATRMnV6URI3bt7784ZKGEBdOve9FEHTLB2+dU/eFZsf8g+
         9Od3Csg23mwmEQ3X3ckuljJd2kNK7Wo2SXgsWyhqQ2yGA9ATII0mEucg4Yvfm4Vtms
         HEPW7Nas+LlyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 31/31] Linux 4.4.282-rc1
Date:   Tue, 24 Aug 2021 13:07:43 -0400
Message-Id: <20210824170743.710957-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index abc388047b47..6de2701bdca0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 281
-EXTRAVERSION =
+SUBLEVEL = 282
+EXTRAVERSION = -rc1
 NAME = Blurry Fish Butt
 
 # *DOCUMENTATION*
-- 
2.30.2

