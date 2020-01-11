Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FB137D41
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgAKJz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgAKJzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:55:25 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEFE20882;
        Sat, 11 Jan 2020 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736525;
        bh=5qimiPvZgZq/KiEoumXC++uKAGaZfv4SvZt7uJ03xv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D+YN+WVJ0gWsQMDB75LZnnCF/xEVLqDJDHsN6bf7JuAnp7zdV3ysQccRSSRzbL7x
         YVB/EDSFQ3IDX6jKwa/EX7kZM7C7yJoc2/frOvONTihRJtVrhWOJFbc67E4PDHG4ve
         4mvu7QgbDfayvtNS8+bgk8+IB6jgQ9SQtdx9OE8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 45/59] regulator: rn5t618: fix module aliases
Date:   Sat, 11 Jan 2020 10:49:54 +0100
Message-Id: <20200111094847.777243017@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
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
index b85ceb8ff911..eccdddcf5315 100644
--- a/drivers/regulator/rn5t618-regulator.c
+++ b/drivers/regulator/rn5t618-regulator.c
@@ -95,6 +95,7 @@ static struct platform_driver rn5t618_regulator_driver = {
 
 module_platform_driver(rn5t618_regulator_driver);
 
+MODULE_ALIAS("platform:rn5t618-regulator");
 MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
 MODULE_DESCRIPTION("RN5T618 regulator driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1



