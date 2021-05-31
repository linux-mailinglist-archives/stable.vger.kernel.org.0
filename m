Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85E396257
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhEaOzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhEaOwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A6961934;
        Mon, 31 May 2021 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469506;
        bh=TPhC4X7LHDYNfwFynm+l7isf1+cHxuReC14F/T3U5yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu+RGX4SA4Lc9ZRtrTNEXY3gqnkUETKbtmRZnhXHjFxIOL8Zz/K3HecbaBqCwna0E
         +rhY7h8kXTlyNSOJaobcqiG7gTnikQLzdxra6VeOWqLD1xDPsPF8SdNnutTrEBxhB+
         JWIGUwZNf/B2UjkS80zw5SUcNPHx7MdQ+z4puNqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 224/296] interconnect: qcom: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 31 May 2021 15:14:39 +0200
Message-Id: <20210531130711.357241673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1fd86e280d8b21762901e43d42d66dbfe8b8e0d3 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620704673-104205-1-git-send-email-zou_wei@huawei.com
Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/bcm-voter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/bcm-voter.c b/drivers/interconnect/qcom/bcm-voter.c
index dd18cd8474f8..1da6cea8ecbc 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -363,6 +363,7 @@ static const struct of_device_id bcm_voter_of_match[] = {
 	{ .compatible = "qcom,bcm-voter" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, bcm_voter_of_match);
 
 static struct platform_driver qcom_icc_bcm_voter_driver = {
 	.probe = qcom_icc_bcm_voter_probe,
-- 
2.30.2



