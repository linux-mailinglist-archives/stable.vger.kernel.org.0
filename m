Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2024E411FFA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349940AbhITRrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353608AbhITRpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B75961B68;
        Mon, 20 Sep 2021 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157804;
        bh=NGWjGUUBR9q/X3WUOnYWqm+c7xX+4NiPgxSilxeVw8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHequHSalaHbNo+YmKwmbgJmvNLnpBZKi4HKhObEpC6N5zKUwmmeUfP6jP/3V8wad
         6hXcrRlZwvP6VDgSLTrnCkP8L8o0WAogvay9baMPZj6DAvHSDoSRan58PXzAGi8KEu
         cyddXPqHrkUrCk3uzsoSkQBKit/alvKHqMdzTocY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/293] docs: Fix infiniband uverbs minor number
Date:   Mon, 20 Sep 2021 18:42:01 +0200
Message-Id: <20210920163938.732961581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 8d7e415d55610d503fdb8815344846b72d194a40 ]

Starting from the beginning of infiniband subsystem, the uverbs char
devices start from 192 as a minor number, see
commit bc38a6abdd5a ("[PATCH] IB uverbs: core implementation").

This patch updates the admin guide documentation to reflect it.

Fixes: 9d85025b0418 ("docs-rst: create an user's manual book")
Link: https://lore.kernel.org/r/bad03e6bcde45550c01e12908a6fe7dfa4770703.1627477347.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/devices.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 1649117e6087..9cd7926c8781 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2993,10 +2993,10 @@
 		65 = /dev/infiniband/issm1     Second InfiniBand IsSM device
 		  ...
 		127 = /dev/infiniband/issm63    63rd InfiniBand IsSM device
-		128 = /dev/infiniband/uverbs0   First InfiniBand verbs device
-		129 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
+		192 = /dev/infiniband/uverbs0   First InfiniBand verbs device
+		193 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
 		  ...
-		159 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
+		223 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
 
  232 char	Biometric Devices
 		0 = /dev/biometric/sensor0/fingerprint	first fingerprint sensor on first device
-- 
2.30.2



