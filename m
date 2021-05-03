Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5D8371D11
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhECQ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhECQzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C004161966;
        Mon,  3 May 2021 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060181;
        bh=Hrpj+fCYf26LzFV3HPho1tE+jS8OQqakpi7z0M9cnBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUTvYn+D5atB40pNcRV6X/EWjoAl3OCGWu/fiKMxPCF2lcD3OnjCCO+iBewTrsy9T
         1KhjCa1rJEK9FE31h1yQiw8Jv6PieRAexs4KOGVtC52bkSJ7wmSDIO9WrKYVOsTdlb
         0U/zoiFuSiXy5krrnIGTH61Jo3MIDait/v0L+ykpFy2DDD7o3soYCDBNxISxkYRkFO
         aXI7gTkeQxE2wQ21T7HuwV9I4hsAmvhYq4uSun5GYgMcQ0kXQArfKxr7UQOagvaYxy
         0ly/C+s12EAfd6H9w36evWyFbElDAiRMwxTCPp4zd36gsfCAg3sKe599c8GkQXUm2L
         a5ybsc9+lsqWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/24] media: pci: saa7164: Rudimentary spelling fixes in the file saa7164-types.h
Date:   Mon,  3 May 2021 12:42:34 -0400
Message-Id: <20210503164252.2854487-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
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
index 1efba6c64ebf..5f3fc64d5efc 100644
--- a/drivers/media/pci/saa7164/saa7164-types.h
+++ b/drivers/media/pci/saa7164/saa7164-types.h
@@ -21,7 +21,7 @@
 
 /* TODO: Cleanup and shorten the namespace */
 
-/* Some structues are passed directly to/from the firmware and
+/* Some structures are passed directly to/from the firmware and
  * have strict alignment requirements. This is one of them.
  */
 struct tmComResHWDescr {
@@ -42,7 +42,7 @@ struct tmComResHWDescr {
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

