Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D4F3833C1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbhEQPB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242551AbhEQO7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:59:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8157460FDB;
        Mon, 17 May 2021 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261594;
        bh=k5C75qtX6axUQoPUFNu69OAcxdQJxSQiBnEDC1eZvvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kASheDvLRf0EVoZj/FlRJYG8QklVbHHJmjbpRxnZjV+JzytBesU+2nYirPqUwgBPK
         geS9BaKAZxPutYOUW0yzME2bcBaUnxIwNR/RMMiC0k28FVgzCMCWtrXyDP7AHJ8Y/a
         MYAXn2SArgMEjAXG7ygxPl3YQjY85e0yeq6WbIQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/141] rtc: fsl-ftm-alarm: add MODULE_TABLE()
Date:   Mon, 17 May 2021 16:01:55 +0200
Message-Id: <20210517140244.884444912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 7fcb86185978661c9188397d474f90364745b8d9 ]

The module doesn't load automatically. Fix it by adding the missing
MODULE_TABLE().

Fixes: 7b0b551dbc1e ("rtc: fsl-ftm-alarm: add FTM alarm driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210414084006.17933-1-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-fsl-ftm-alarm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-fsl-ftm-alarm.c b/drivers/rtc/rtc-fsl-ftm-alarm.c
index 8df2075af9a2..835695bedaac 100644
--- a/drivers/rtc/rtc-fsl-ftm-alarm.c
+++ b/drivers/rtc/rtc-fsl-ftm-alarm.c
@@ -316,6 +316,7 @@ static const struct of_device_id ftm_rtc_match[] = {
 	{ .compatible = "fsl,lx2160a-ftm-alarm", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ftm_rtc_match);
 
 static struct platform_driver ftm_rtc_driver = {
 	.probe		= ftm_rtc_probe,
-- 
2.30.2



