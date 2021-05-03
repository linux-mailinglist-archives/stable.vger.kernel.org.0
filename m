Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACF8371C8D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhECQxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhECQvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148EA61942;
        Mon,  3 May 2021 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060085;
        bh=TGnB09hAp/OvJkjaNGH9MPChVVbZkr26Bz5yspJ/3XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcDXNw/iK515Ey/iVW+wt/OOLKWx4y4HlAoeG79xYEyzySy7uJ2v3uN6LCUHAaJhL
         1RHjck5csp7Y6C6bMOSAvFYcmzNcc0MyE8SX7qbUQnjCtiIGZG8wwZUpg7qDnlwHgh
         +ZYEBVTY6iBqywIsvQNt9mXYCLf2pcf0SaXRZ03BKtqs2fCHrB6GskfC4k1XrY1luV
         i9C3fxMdH+J0dqRIVPXZxY3Gik1jiPy+AsIbLH08QCp0TI0gc4Whrubb5oYu5PuiBq
         Sf/8UTC+eG+wpa+Z4olgUCoE0k/pvIQpZlyE5y/NB1AWPcYVfj/2od04WUfmHR4O5x
         rZDqOcdKfkzWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/35] media: pci: saa7164: Rudimentary spelling fixes in the file saa7164-types.h
Date:   Mon,  3 May 2021 12:40:44 -0400
Message-Id: <20210503164109.2853838-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index ae241103b261..6572bc313f96 100644
--- a/drivers/media/pci/saa7164/saa7164-types.h
+++ b/drivers/media/pci/saa7164/saa7164-types.h
@@ -17,7 +17,7 @@
 
 /* TODO: Cleanup and shorten the namespace */
 
-/* Some structues are passed directly to/from the firmware and
+/* Some structures are passed directly to/from the firmware and
  * have strict alignment requirements. This is one of them.
  */
 struct tmComResHWDescr {
@@ -38,7 +38,7 @@ struct tmComResHWDescr {
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

