Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B363FA9D6
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 09:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhH2HL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 03:11:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49808 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234777AbhH2HL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 03:11:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630221067; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kGWUkwWLSjglSCFuyo5qdWqvaikSa7L8lNlgZG4f8ms=;
 b=MrAfj29MZ1eiGPd29RQ6rphRltnLRe2kGk7SUR4Em5kte0LX4NcjLSQmpn/BHZnblq+2T1LG
 tF5ZZ+kVAxYOwfMU7nU4d55vqQEgG6bww8VW81W/RQLZBLz8N/cJ7TwoEzrFq6WQSzGZ89F7
 TbAA83QfJwp7TYiHhjStsLpDjP4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 612b3302cd680e89694dc60f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 07:10:58
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 53AE1C43616; Sun, 29 Aug 2021 07:10:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BE0DC4360C;
        Sun, 29 Aug 2021 07:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3BE0DC4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Ensure finish scan is not requested before start
 scan
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1629286303-13179-1-git-send-email-loic.poulain@linaro.org>
References: <1629286303-13179-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     bryan.odonoghue@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Joseph Gates <jgates@squareup.com>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210829071057.53AE1C43616@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 07:10:57 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> If the operating channel is the first in the scan list, it was seen that
> a finish scan request would be sent before a start scan request was
> sent, causing the firmware to fail all future scans. Track the current
> channel being scanned to avoid requesting the scan finish before it
> starts.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 5973a2947430 ("wcn36xx: Fix software-driven scan")
> Signed-off-by: Joseph Gates <jgates@squareup.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d195d7aac09b wcn36xx: Ensure finish scan is not requested before start scan

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1629286303-13179-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

