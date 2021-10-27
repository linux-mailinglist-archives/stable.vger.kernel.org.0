Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F33B43C43B
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhJ0Hql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 03:46:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:18914 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbhJ0Hqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 03:46:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635320656; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=17ABJtLs1ED7m4togkLZiX+xC/wqCO8bwNT6aDrq3Zs=;
 b=PSWckvLZ5fO6wBw3Z0GErDxEb0tiFxmJntzPKsqqiZ6tQMYQDeLQTx7SXBtDk+yt/Dd3Lkfr
 LNEpIcNKdzTr0rKUyCcK+MOVf0ehgagFmLKjHznep5FgDqnrdN67sWg7K+0F2wmvpscNfs4m
 cqom44vFs/YYAfr5pMLzWwP0WTU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 617903453416c2cb70ec8da3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:44:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 07CC2C4360D; Wed, 27 Oct 2021 07:44:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BB35C4338F;
        Wed, 27 Oct 2021 07:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3BB35C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix HT40 capability for 2Ghz band
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634737133-22336-1-git-send-email-loic.poulain@linaro.org>
References: <1634737133-22336-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163532064150.19793.14921041891786740920.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:44:04 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> All wcn36xx controllers are supposed to support HT40 (and SGI40),
> This doubles the maximum bitrate/throughput with compatible APs.
> 
> Tested with wcn3620 & wcn3680B.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

960ae77f2563 wcn36xx: Fix HT40 capability for 2Ghz band

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634737133-22336-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

