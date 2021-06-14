Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7368D3A6060
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhFNKd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhFNKdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67266613DE;
        Mon, 14 Jun 2021 10:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666648;
        bh=NanwY2GV8uw8vDVm+GkTxBcxiGenQu18GWXOb5QSM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLwCKpl+7U4H2Y/gEBjXUelE6I4x3T/2cyShAocHSr+xRFh5AK+5jEHe7Fve3755E
         07MFScpVyRgbJ55Q4A30wIZowt+9ugEvHZUM1ORUbSSzCNAZaVu8qwcOC0XmwmJnQQ
         LQ+UeR/1XvZ/vwTWPi8wtciJ7I/ncSQ0nPxtzQSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/42] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:26:54 +0200
Message-Id: <20210614102642.821169612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
index d6e00c77edcd..7cf76661c3cc 100644
--- a/sound/soc/codecs/sti-sas.c
+++ b/sound/soc/codecs/sti-sas.c
@@ -542,6 +542,7 @@ static const struct of_device_id sti_sas_dev_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, sti_sas_dev_match);
 
 static int sti_sas_driver_probe(struct platform_device *pdev)
 {
-- 
2.30.2



