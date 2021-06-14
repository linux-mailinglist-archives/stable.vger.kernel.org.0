Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52553A626A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhFNLAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234479AbhFNK5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224FB61425;
        Mon, 14 Jun 2021 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667288;
        bh=UtaTbqjqvTZDE1FmFEJXLNETUsHxwA5ZfmWH+yUhYX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhIfQ7vUFEn6cL9xhmyITlUFVGLeROS3TO80OjOGm0mNALEVhd8Nu8smu6wQa7G7k
         ig4L6LSMiTg/SgRQDFgkiv342mAAYn7dYAuhYpmNFpvvQM/Hrq3z/Pz2YM7KnMXZh7
         8lWxaOayl/FHpL+kksNdt5zlIzgTs+t1VEirvZzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/131] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:26:15 +0200
Message-Id: <20210614102653.475282344@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit e072b2671606c77538d6a4dd5dda80b508cb4816 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620789145-14936-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sti-sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/sti-sas.c b/sound/soc/codecs/sti-sas.c
index ec9933b054ad..423daac9d5a9 100644
--- a/sound/soc/codecs/sti-sas.c
+++ b/sound/soc/codecs/sti-sas.c
@@ -411,6 +411,7 @@ static const struct of_device_id sti_sas_dev_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, sti_sas_dev_match);
 
 static int sti_sas_driver_probe(struct platform_device *pdev)
 {
-- 
2.30.2



