Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D95386B9B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243983AbhEQUrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:47:32 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60290 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbhEQUrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:47:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621284375; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=4SGrzUY934ekLMWc7G4RlWFCO0gM3MOAxtdWYLTL6i0=; b=iQwgtJUq8OJtyFDdRboNncA8+ABJAVIR9JkaffGMWkoHMT6qXrH2i2toGnh+t/0ek7m7Qwbw
 IX56pT/ZpDzpGK33tpBh6Ema54QEpMkh8lHWgWte4NBeab+lIjZlWWIvCnhqfUjm3ThyOB7B
 8/aKG4khePRnkCjU5RkEUkbgrzY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60a2d60d60c53c8c9dec132c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 May 2021 20:46:05
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8344CC4323A; Mon, 17 May 2021 20:46:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A7C4C433F1;
        Mon, 17 May 2021 20:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A7C4C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH 0/3] remoteproc: core: Fixes for rproc cdev and add
Date:   Mon, 17 May 2021 13:45:46 -0700
Message-Id: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series contains stability fixes and error handling for remoteproc.

The changes included in this series do the following:
Patch 1: Fixes the creation of the rproc character device.
Patch 2: Validates rproc as the first step of rproc_add().
Patch 3: Adds error handling in rproc_add().

Siddharth Gupta (3):
  remoteproc: core: Move cdev add before device add
  remoteproc: core: Move validate before device add
  remoteproc: core: Cleanup device in case of failure

 drivers/remoteproc/remoteproc_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

