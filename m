Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71BEF65B5
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfKJCop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbfKJCom (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE4F221D7B;
        Sun, 10 Nov 2019 02:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353881;
        bh=irSFSlP4lDy18Th9gU+TMXSW4JZxVtRA522JoQhDzh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epz5I0ydhLZtxw06ZtIgQPeG4w7P4pXiLG9Xe/b428NihDvKEt8CFbJndK71DlONm
         oSdA58LsGx0NKbG+Nzd40kPzW/2cA8S+3HOAGLOnIolTec+u5rPC9BCw5Wn6yXubOk
         zJ5vk+Lbd/5dz7yGfJ0JaPtN04STiYi+xpf82gjM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/191] crypto: s5p-sss: Fix Fix argument list alignment
Date:   Sat,  9 Nov 2019 21:39:40 -0500
Message-Id: <20191110024013.29782-158-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Manszewski <c.manszewski@samsung.com>

[ Upstream commit 6c12b6ba45490eeb820fdceccf5a53f42a26799c ]

Fix misalignment of continued argument list.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 9021ad9df0c45..b7216935236f0 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -491,7 +491,7 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
 }
 
 static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
-			    struct scatterlist **dst)
+			   struct scatterlist **dst)
 {
 	void *pages;
 	int len;
@@ -1889,7 +1889,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
 }
 
 static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
-				struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
-- 
2.20.1

