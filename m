Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A270A12B951
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfL0SDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728562AbfL0SDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09759218AC;
        Fri, 27 Dec 2019 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469791;
        bh=4YON9OFRZy1HzvpVfNd2cG2zRP0S16fccsztPMSe2kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCvVwNbgplr+Z+RFLyy4A61Qoq7d/WUz9E1glmPR6evRM3GPm0TIVA7OBsQlPq4ij
         ABOq7hWVwwasw3fwDX3u07qgA/bvGvYePGfIcx6Z1QwNeRxKZym3g2lYYcnsEoSLD2
         punLjkozB/joDu+iaEFwhKlriKZ1EhR/OPN3eKw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 40/57] regulator: rn5t618: fix module aliases
Date:   Fri, 27 Dec 2019 13:02:05 -0500
Message-Id: <20191227180222.7076-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

