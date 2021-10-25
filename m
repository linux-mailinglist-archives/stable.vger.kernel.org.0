Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1332C43A374
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbhJYT7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238682AbhJYT42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628A261250;
        Mon, 25 Oct 2021 19:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191191;
        bh=1xegg9otK+EYQE5/gQFWIgDapWZg9gOwTNJfiEqWEog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0JvGJbpChtZodBqZwUU1tPU1vu/Q52O0jZO7WrBxjvwSlsHMnSCUuKSkY8XzIm1V
         HIsO8EcMLK88ArB+F4sAJbHvdFLjFF9nSNJzXEvyIJpG6UIoqWPYkWZ+C874z6/8vy
         QCNHrItilks7QH7CTYggntRZE16P+OJYvii5PRXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Prasad Potturu <potturu@codeaurora.org>,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 148/169] ASoC: codec: wcd938x: Add irq config support
Date:   Mon, 25 Oct 2021 21:15:29 +0200
Message-Id: <20211025191036.315557077@linuxfoundation.org>
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

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit 214174d9f56c7f81f4860a26b6b8b961a6b92654 ]

This patch fixes compilation error in wcd98x codec driver.

Fixes: 045442228868 ("ASoC: codecs: wcd938x: add audio routing and Kconfig")

Signed-off-by: Venkata Prasad Potturu <potturu@codeaurora.org>
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/1633614675-27122-1-git-send-email-srivasam@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index db16071205ba..dd1ae611fc2a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1564,6 +1564,7 @@ config SND_SOC_WCD938X
 config SND_SOC_WCD938X_SDW
 	tristate "WCD9380/WCD9385 Codec - SDW"
 	select SND_SOC_WCD938X
+	select REGMAP_IRQ
 	depends on SOUNDWIRE
 	select REGMAP_SOUNDWIRE
 	help
-- 
2.33.0



