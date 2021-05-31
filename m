Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9907F395F4F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhEaOJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhEaOH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA6861962;
        Mon, 31 May 2021 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468375;
        bh=FbchGuyAEMtbN0+/wE1KtzCZb8uk4wJGjnk+iKF2RW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nENtSTngr6BMGMe5V+F2o9x0g6VBABfg+4gmV3RPZ8Bfym6QKM6yxTWl17mpLrRc
         42QCehYbufi8FWpRMY8vSS+U1HQH3OQqDpCWUNtYxD6GASTHtWaJ7Ntl3hds0VNJY8
         oHGcfiWRxxyhhkuU517ffdy9w2YD9erjZWR/oDIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/252] interconnect: qcom: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 31 May 2021 15:14:17 +0200
Message-Id: <20210531130704.528644462@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 7c3ef817e99c..dd0e3bd50b94 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -370,6 +370,7 @@ static const struct of_device_id bcm_voter_of_match[] = {
 	{ .compatible = "qcom,bcm-voter" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, bcm_voter_of_match);
 
 static struct platform_driver qcom_icc_bcm_voter_driver = {
 	.probe = qcom_icc_bcm_voter_probe,
-- 
2.30.2



