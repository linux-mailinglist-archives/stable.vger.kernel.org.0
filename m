Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC714412171
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350472AbhITSFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357024AbhITSCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCD363232;
        Mon, 20 Sep 2021 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158191;
        bh=e4tpBnp4JzHFi5Ikx6WKVk6++wDct7JiyB3GAFnvWQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U11x1bmGWEDOHawYb3Xe7vIwUyxhnJnUwXcGtEcf1QSnTfvjyCiaiS/sNBX+yRI8F
         Wc2VuLJN5Hi/177+nRIVrsvQxPs8fJ3etCeHZOjN/uBVBy8Y68a4MbWyeSJY7Ip7un
         d1dSp8dNVID9rSfAnsjriP8PYYp+USFKgo8KPDdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/260] docs: Fix infiniband uverbs minor number
Date:   Mon, 20 Sep 2021 18:40:59 +0200
Message-Id: <20210920163932.514811016@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 1c5d2281efc9..771d9e7ae082 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -3002,10 +3002,10 @@
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



