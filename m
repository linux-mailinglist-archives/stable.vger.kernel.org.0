Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3B943A226
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhJYTp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236059AbhJYTmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38151610C7;
        Mon, 25 Oct 2021 19:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190619;
        bh=PSynAD9tDcyTdoKBAdHu/7Vmea2T6/k5EZgxOi7PN6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbvwK5lwdjmdY3YR4klg7GzoruoM66HCoZ/nJDWTxLiDTR7LR104UAG8zd06O96xj
         Rvaj0rJ4YQkRWyLiZEeC7/x7158d6h2JBdC0oSjp6oiHYZz2EeADUkvOorZr4/YHY4
         man4fKxuSZgatKc1y9UFqv5dBeLiCS3nX7fgKWEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 020/169] ASoC: pcm179x: Add missing entries SPI to device ID table
Date:   Mon, 25 Oct 2021 21:13:21 +0200
Message-Id: <20211025191020.241975975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit ceef3240f9b7e592dd8d10d619c312c7336117fa ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding SPI IDs for parts that
only have a compatible listed.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210924194956.46079-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm179x-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/pcm179x-spi.c b/sound/soc/codecs/pcm179x-spi.c
index 0a542924ec5f..ebf63ea90a1c 100644
--- a/sound/soc/codecs/pcm179x-spi.c
+++ b/sound/soc/codecs/pcm179x-spi.c
@@ -36,6 +36,7 @@ static const struct of_device_id pcm179x_of_match[] = {
 MODULE_DEVICE_TABLE(of, pcm179x_of_match);
 
 static const struct spi_device_id pcm179x_spi_ids[] = {
+	{ "pcm1792a", 0 },
 	{ "pcm179x", 0 },
 	{ },
 };
-- 
2.33.0



