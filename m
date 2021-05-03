Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1CD371BA8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhECQrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhECQpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EC5613BC;
        Mon,  3 May 2021 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059948;
        bh=NEAnHfX4dM6Yys28LD/GQ3z4xz/R0/tEf/kpaqy6+xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FifF1ERtsx56LdkSvYQ+9HnUo1RA+Bhi+Y4XSnPY3AEU+UydZAZbsHrQhlQ0GtUex
         xmRpsbZMouPNKZMgcRy4gV8T9H/wpPRqrQDK2D+fYPgQ8rNiXep6AuM6xpd0dUuG1o
         kGVk8lMhke82YW8/aM9lQjRdBgSj4JLaFBQiM3N6vIT17nlSkh4UGHkM0GWAn7f4S0
         VWP0CFJi7tSDhBM0imeVBrxYlCzNj9GgbariLUQDXGPlhheI25yI2CEdhlRlBAn/ww
         PP5xxxY8vw48czlyT/C/yPCZzWd+hiNs1v99CguAEWaBPWw2CNTdB2mstYDVB/p7DO
         kGw3ZpMHE4YPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 026/100] media: pci: saa7164: Rudimentary spelling fixes in the file saa7164-types.h
Date:   Mon,  3 May 2021 12:37:15 -0400
Message-Id: <20210503163829.2852775-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 4b19f9716ad89af51f07f9b611aabfd5fd80c625 ]

s/structues/structures/
s/decies/decides/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-types.h b/drivers/media/pci/saa7164/saa7164-types.h
index 34dd2be6fce4..00f163b38d40 100644
--- a/drivers/media/pci/saa7164/saa7164-types.h
+++ b/drivers/media/pci/saa7164/saa7164-types.h
@@ -7,7 +7,7 @@
 
 /* TODO: Cleanup and shorten the namespace */
 
-/* Some structues are passed directly to/from the firmware and
+/* Some structures are passed directly to/from the firmware and
  * have strict alignment requirements. This is one of them.
  */
 struct tmComResHWDescr {
@@ -28,7 +28,7 @@ struct tmComResHWDescr {
 /* This is DWORD aligned on windows but I can't find the right
  * gcc syntax to match the binary data from the device.
  * I've manually padded with Reserved[3] bytes to match the hardware,
- * but this could break if GCC decies to pack in a different way.
+ * but this could break if GCC decides to pack in a different way.
  */
 struct tmComResInterfaceDescr {
 	u8	bLength;
-- 
2.30.2

