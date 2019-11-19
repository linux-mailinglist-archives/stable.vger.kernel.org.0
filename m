Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC41016AF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbfKSFzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732232AbfKSFzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:55:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20E31218BA;
        Tue, 19 Nov 2019 05:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142905;
        bh=BIKvivTgbhJmyqsY0AFtQ/h+1Vep9bWqDEIZO2zDLAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POK6MKBbpZ/sdx2dO6do9grqn6AD4sbDzPQXyTu1AaFLP+Pps5s2SVmbrC2mWyU2y
         GCUTXVzoA0vCmhu8xfVyxdom0cG8dZyqI/H/XKABUAxZ51HnEhouXoswnabC3BTJ6H
         IXTl5F3CPHvloCrJ8knvZJtkrWPVzV2h1/o7YAOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 215/239] crypto: s5p-sss: Fix Fix argument list alignment
Date:   Tue, 19 Nov 2019 06:20:15 +0100
Message-Id: <20191119051339.100438972@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aec66159566dd..9a5213cbcbe18 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -323,7 +323,7 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
 }
 
 static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
-			    struct scatterlist **dst)
+			   struct scatterlist **dst)
 {
 	void *pages;
 	int len;
@@ -569,7 +569,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
 }
 
 static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
-				struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
-- 
2.20.1



