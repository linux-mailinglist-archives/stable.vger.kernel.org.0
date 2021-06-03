Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D1F39A7E0
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhFCRM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232514AbhFCRMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 540A261430;
        Thu,  3 Jun 2021 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740206;
        bh=ZJEJ+ezvyNiiZ1HMcpI0t6S34kzYxeNrMghwbFkwJiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rql02ZSzlMFaUfyGK7w+GX0t6cIxwUJ1pLgUkdy5c+vxRLiBlJcY+j0jEjDQCRce7
         oFRGSTRgZG6ujfvkzomBz0ItkWMFDaaILePxS3nElnsYolGpyYk9Thv3aMc9qM/bJZ
         XPnp/Y+4dp+fqeyLZtjvqfOZYtVscc2oRN9vA3wrSEYCgq6sTDU7gMvsYxI5zJCeKe
         Ip743VStg4+BaeEm+/cQzsDFIYugTGLqb2vWNFyYwJbd9Hao6ovbIof65pJJk/4OLC
         6pj44UJC/vgdmdTyAmt7CAi/RUgyEQ4uTbS2VoYaba7IjuzRtDd17SSvJAFj/Hu1SD
         Mspzpd/bx4UBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 05/23] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:09:41 -0400
Message-Id: <20210603170959.3169420-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index 7316c80b8179..27196126f710 100644
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

