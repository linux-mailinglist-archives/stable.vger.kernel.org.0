Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1191F3BBBAE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhGEK7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 06:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231236AbhGEK7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 06:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5452613BA;
        Mon,  5 Jul 2021 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482620;
        bh=Z3Kp0Wu7ZfNpZd3msrDlZdXfsGyP82bwKXrKjU+kad0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtN7VhsPpDfTv0YfeX32sjFj2asWZYI2kxuu9NLkuRpm6jJ5fJesDVpC3upY9a4CE
         Qw96sN46FyCscXH/U2tFrbwfPEbQkiGJQdbXJyZODR69Y4IEfxuppUrakRmRiQCZlN
         R7FYHKMI1Jx03X9n0eo8S/VGE6rorUtWIs1YVyHfALGfBHnyk/VQxQcP+KmiL4a6hA
         +N3lncA/ktHMV5DVcUYUYUQy3K1xsfjW9s9yezrk1KRHjuBHaTgDGza1osvQzr1gEE
         sbIMw3XGZlcOotjIriDYEnTFbi1xxIeorqoz/EpqGbaqmJ0AK2ig3WkJl39VppdmN7
         TdclnAm6OXj7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 2/2] Linux 5.13.1-rc1
Date:   Mon,  5 Jul 2021 06:56:56 -0400
Message-Id: <20210705105656.1512997-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105656.1512997-1-sashal@kernel.org>
References: <20210705105656.1512997-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.1-rc1
X-KernelTest-Deadline: 2021-07-07T10:49+00:00
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
index 0565caea0362..56fce101656f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 0
-EXTRAVERSION =
+SUBLEVEL = 1
+EXTRAVERSION = -rc1
 NAME = Opossums on Parade
 
 # *DOCUMENTATION*
-- 
2.30.2

