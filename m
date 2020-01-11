Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A503D137E70
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgAKKJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbgAKKJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:09:54 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3640F206DA;
        Sat, 11 Jan 2020 10:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737394;
        bh=4YON9OFRZy1HzvpVfNd2cG2zRP0S16fccsztPMSe2kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKJACQizYG1rOFV9TjY/QmNvPjNglFZMJ4jfh7Ulswz0LnhkbJ9E6yxDWMpFjlM2q
         L6Y4yJiu50ejkTuhnft4s+Mkbo+gDRCpAeUBZU7wR1bqjls6qRxxn1TgPqrkobdh3z
         UUtO6boCuGEZBXxXnSzy+EmXOxdI5xwt02JZYuZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/62] regulator: rn5t618: fix module aliases
Date:   Sat, 11 Jan 2020 10:50:10 +0100
Message-Id: <20200111094845.196707660@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 62a1923cc8fe095912e6213ed5de27abbf1de77e ]

platform device aliases were missing, preventing
autoloading of module.

Fixes: 811b700630ff ("regulator: rn5t618: add driver for Ricoh RN5T618 regulators")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20191211221600.29438-1-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rn5t618-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/rn5t618-regulator.c b/drivers/regulator/rn5t618-regulator.c
index 790a4a73ea2c..40b74648bd31 100644
--- a/drivers/regulator/rn5t618-regulator.c
+++ b/drivers/regulator/rn5t618-regulator.c
@@ -154,6 +154,7 @@ static struct platform_driver rn5t618_regulator_driver = {
 
 module_platform_driver(rn5t618_regulator_driver);
 
+MODULE_ALIAS("platform:rn5t618-regulator");
 MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
 MODULE_DESCRIPTION("RN5T618 regulator driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1



