Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1E469F18
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391379AbhLFPpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390535AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D716C0698CC;
        Mon,  6 Dec 2021 07:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A491612D3;
        Mon,  6 Dec 2021 15:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5460C34900;
        Mon,  6 Dec 2021 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804470;
        bh=SRdtPFUvBu3iU7BQ3wrtGJhdzTLEqEJK9iSGiZLZH+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZ5vJF150Uu9gmyJ8Npl801T31JrWTBkkIghIEbk+ytyr9Qm2nhQhLRj1rhPJWNd5
         3C24n4OE9jB7tYQ3Gi91+S+wDXjSuLP3YAwbnOuY/gyifCoO0f1smrMa1S/O8B9a0o
         8rIUGqXqR8/ys3LAv/sz3yT65v0nmCTdgnlJqsJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/207] ASoC: rk817: Add module alias for rk817-codec
Date:   Mon,  6 Dec 2021 15:56:52 +0100
Message-Id: <20211206145615.738729384@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>

[ Upstream commit 428ee30a05cd1362c8aa86a4c909b0d1c6bc48a4 ]

Without a module alias, autoloading the driver does not occurr
when it is built as a module.

By adding a module alias, the driver now probes fine automatically
and therefore analog audio output works as it should.

Fixes: 0d6a04da9b25 ("ASoC: Add Rockchip rk817 audio CODEC support")
Signed-off-by: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
Link: https://lore.kernel.org/r/20211121150521.159543-1-frattaroli.nicolas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk817_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rk817_codec.c b/sound/soc/codecs/rk817_codec.c
index 943d7d933e81b..03f24edfe4f64 100644
--- a/sound/soc/codecs/rk817_codec.c
+++ b/sound/soc/codecs/rk817_codec.c
@@ -539,3 +539,4 @@ module_platform_driver(rk817_codec_driver);
 MODULE_DESCRIPTION("ASoC RK817 codec driver");
 MODULE_AUTHOR("binyuan <kevan.lan@rock-chips.com>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:rk817-codec");
-- 
2.33.0



