Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9CB37885A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhEJLVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237022AbhEJLLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCF161554;
        Mon, 10 May 2021 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644783;
        bh=UKmYwDYp+atKyBGY0j+F+SZeHkEihxOzjZeGSlNGlNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwrbAdJV9i37YpBCjvEd5qlCrxHHduTUQD7TTkS7M3IStAYTP7HdX+XPE26kKMEE3
         uQbzZ/lndVHsdZEcZNHlcb+mvgOR8ukpqzDXfQFVLohVmYxq6myVFEtBFQFbWWVqnC
         Lwzrbfqf1iHpXMmt1B824rhwgnRNMjzuz7/iPVgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 221/384] media: vivid: update EDID
Date:   Mon, 10 May 2021 12:20:10 +0200
Message-Id: <20210510102022.191138096@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/media/test-drivers/vivid/vivid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index 0dc65ef3aa14..ca0ebf6ad9cc 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -205,13 +205,13 @@ static const u8 vivid_hdmi_edid[256] = {
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
@@ -220,7 +220,7 @@ static const u8 vivid_hdmi_edid[256] = {
 	0x00, 0x00, 0x1a, 0x1a, 0x1d, 0x00, 0x80, 0x51,
 	0xd0, 0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0xc0,
 	0x1c, 0x32, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x63,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x82,
 };
 
 static int vidioc_querycap(struct file *file, void  *priv,
-- 
2.30.2



