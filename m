Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A453B371CEE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhECQ53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43305 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234821AbhECQzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02DFA6194D;
        Mon,  3 May 2021 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060151;
        bh=rDITWcHQR7WEXYie3ztrYHP2UAh7XPB22lNRAsSJRhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4HLYmv4p202Ku1HIHDONdplslhuBD2ugj9jijXBAAwOY9RIH7/got5198A3EQwGN
         6rGPtY/ope5xyuuhi42KksnX5Rocj9IkUWtDqVYQtIrYfBiQbylHdivJCF2aAq39De
         qyJ8/B/2+A0GVO+V/F5WEa4MYeBsU4qXuq5IaLv14PLfZUQhpLmB1dMF+em3YmBFSG
         udx/cx/HjrIUYB88yZUNVGm07INx1M1SjtJWU7uwNkUJM2Lp5v1AYkFoOehd/jGwn+
         DWYibujesRavkM/WEeMTPvRVPeoMei0LiAv3HSO7Q9DROkyI8H5uaqicqEGmCIVOwq
         Mjz5Kd18nT+Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/31] media: vivid: update EDID
Date:   Mon,  3 May 2021 12:41:51 -0400
Message-Id: <20210503164204.2854178-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 443ec4bbc6116f6f492a7a1282bfd8422c862158 ]

The EDID had a few mistakes as reported by edid-decode:

Block 1, CTA-861 Extension Block:
  Video Data Block: For improved preferred timing interoperability, set 'Native detailed modes' to 1.
  Video Capability Data Block: S_PT is equal to S_IT and S_CE, so should be set to 0 instead.

Fixed those.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 5f316a5e38db..6754e5fcc4c4 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -186,13 +186,13 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x7b,
 
-	0x02, 0x03, 0x3f, 0xf0, 0x51, 0x61, 0x60, 0x5f,
+	0x02, 0x03, 0x3f, 0xf1, 0x51, 0x61, 0x60, 0x5f,
 	0x5e, 0x5d, 0x10, 0x1f, 0x04, 0x13, 0x22, 0x21,
 	0x20, 0x05, 0x14, 0x02, 0x11, 0x01, 0x23, 0x09,
 	0x07, 0x07, 0x83, 0x01, 0x00, 0x00, 0x6d, 0x03,
 	0x0c, 0x00, 0x10, 0x00, 0x00, 0x3c, 0x21, 0x00,
 	0x60, 0x01, 0x02, 0x03, 0x67, 0xd8, 0x5d, 0xc4,
-	0x01, 0x78, 0x00, 0x00, 0xe2, 0x00, 0xea, 0xe3,
+	0x01, 0x78, 0x00, 0x00, 0xe2, 0x00, 0xca, 0xe3,
 	0x05, 0x00, 0x00, 0xe3, 0x06, 0x01, 0x00, 0x4d,
 	0xd0, 0x00, 0xa0, 0xf0, 0x70, 0x3e, 0x80, 0x30,
 	0x20, 0x35, 0x00, 0xc0, 0x1c, 0x32, 0x00, 0x00,
@@ -201,7 +201,7 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x00, 0x00, 0x1a, 0x1a, 0x1d, 0x00, 0x80, 0x51,
 	0xd0, 0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0xc0,
 	0x1c, 0x32, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x63,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x82,
 };
 
 static int vidioc_querycap(struct file *file, void  *priv,
-- 
2.30.2

