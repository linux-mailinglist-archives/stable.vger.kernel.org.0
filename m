Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4D39A8C5
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhFCRRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhFCRQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521BC61414;
        Thu,  3 Jun 2021 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740278;
        bh=lx8jq7mPqQ3kCY7XSW3VJbgNJ/7c/ehoVg1psI985bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkc5eXgxJhy1tQr3mxka9X/GLNxEKVpcusUotk4mZF53foC+3RslRu3w+cPDixXp+
         j5pQBYEcF0XQcSxzO1Qgf3Gv6srwrxQ2cbVUYq2EjZNdWUOe+Kl9lUKkpoYAFuv6MB
         rdfyIPgBgIdBoTF0KFSgjgXob4h0llc7EXLpQIHp+hh9ccYYuqL1l9DZywlH3zUSVd
         hO+KBrWe2EkxIVRRUdstB+LlyqyLG/CcFm+eE0OH0ldQE6RYqBTa5yOx4hqjeLZCIU
         aYTFQdgXMVLVzXYwFOKmF/LNLMZtP7AVifhA2Js3YtvRrWU3bPWqF4Ymfs93tgDQzG
         bfwldV+49fwvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 02/15] ASoC: sti-sas: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:11:01 -0400
Message-Id: <20210603171114.3170086-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
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
index 160d61a66204..71a1fde5a7ef 100644
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

