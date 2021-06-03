Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8139A887
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhFCRQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233326AbhFCROJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678D56143C;
        Thu,  3 Jun 2021 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740256;
        bh=NanwY2GV8uw8vDVm+GkTxBcxiGenQu18GWXOb5QSM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DST+vxTmvQ1F2JjXhANhlf7If/RDqM7bLLgRH9Pt4Q7lhvK2U/yJQKCOaqSN6a2jW
         tRP2sgZ6lHzmZvqghg8y2ejrXlTiNRdq/5oP1l2rk/AGq/qCzwuL16XME3r3nPPH0b
         R4wBdimDZyn6UFdq3NcYVtoWgSvNIBrp3UU1ZeBTkq9rpn39gSNHOhLqsh1zBQOM9H
         oGX7BfUzm+ACXjwJwQosOYOilEEsl+ssoBdUrGzfHkQkCdEa0MHN8Dv9dZaovATZbX
         E9VXZJdpQaOSEOSnJtOOYLAV/sKV62FAFMHJpThMgz2VTicN8iBxfkfOan/WbjIZvW
         v/w9erCRMvhXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 02/17] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:10:37 -0400
Message-Id: <20210603171052.3169893-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

