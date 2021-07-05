Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058C3BBBE5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhGELDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhGELDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:03:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6829561483;
        Mon,  5 Jul 2021 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482836;
        bh=NOeJ/IEyu/+NViwYqSsnGJOcv7H6lyAYy78LjLfebAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEvgLzKdciA4OsU0XH6lvBjUAICZjR+BYwl5bYOC6BuBw5tEBV6GVQGE4s9NT7jZF
         IC1BlD9plnDVJlGlR1Elivs5zbKom/hvvABdWD99sekE7E4zmoyd8Ua+nYpQGt1MLp
         5UjDl6qyn4axZLe7f5AT/QNELJt119OdoD9U/fWFI8SL/bopQ31KgOitq+abk5/C/h
         r2wcsF8h6rJca4QEn+x9OATU+HmT+TGnwZzWodqHH38MEv4HO4IR3PZxwyn3WZR8Jv
         Ls5TUHb3hlzIlQnsx1g+dbxYjsHExEUDZ34i3H7LvbLzq/uzbRdGW549NDJpuf09u8
         Cacdxvf+SSJqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 6/6] Linux 5.4.130-rc1
Date:   Mon,  5 Jul 2021 07:00:29 -0400
Message-Id: <20210705110029.1513384-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.130-rc1
X-KernelTest-Deadline: 2021-07-07T11:00+00:00
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
index 802520ad08cc..2b137cdeb78d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 129
-EXTRAVERSION =
+SUBLEVEL = 130
+EXTRAVERSION = -rc1
 NAME = Kleptomaniac Octopus
 
 # *DOCUMENTATION*
-- 
2.30.2

