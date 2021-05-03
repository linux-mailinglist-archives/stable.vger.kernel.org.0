Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8909371B17
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhECQnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhECQko (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0EBF61428;
        Mon,  3 May 2021 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059874;
        bh=NEAnHfX4dM6Yys28LD/GQ3z4xz/R0/tEf/kpaqy6+xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1RtcWvV25RmDF5fqC9XvBkVc6cBNPzJhDMTdsEEOuhEzlDJdyy27fDFpyYVZpzqB
         VfiAEGFBWl1n8TunbIyAH7ulFM6Q9TKsSOCl6mYPGQkdP9QiGA8i2MtROCz+Ja03aB
         fKAeCOo94xosNjQzvWuWtgdlHhhxugEkzfTHnq/V0hIEEEkOAa+LTAh+Xp7h66mREz
         EOyfLSQrdt+je1mPWgwTEy/LcORy6nSCq4WVOikH908sNQkfjxoW0TLnfMxOv7BGh9
         6nb0GgGxvzo1dF1EodmwrS7Zhjzu+2JS374wVkINGCPPCl8cpMKMKw3mQFnH+lHBWJ
         wuEKMw/6Titgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 036/115] media: pci: saa7164: Rudimentary spelling fixes in the file saa7164-types.h
Date:   Mon,  3 May 2021 12:35:40 -0400
Message-Id: <20210503163700.2852194-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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

