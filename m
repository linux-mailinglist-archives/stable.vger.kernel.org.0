Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69A43A642
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 23:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhJYWAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 18:00:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56120 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhJYWAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 18:00:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635199105; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=KW+I9GMZAi1lG5z3oeEGyUp+FupVx2vUmZxucChwSQc=; b=oxBOmmwJxk7WLU+TubaHbetWQmZLwjSlwqI9HSnloHZ2/rQf8WeOsKePPo5lLxjLDEQCqePy
 61nkdQloM0GDdPD/Ndc3kTfW2YzDbCRm76Va3gd8WpxxrFvKbn2YzwUX/gghnQE6BwFaYLrk
 3F6QuusE7TppBdnFBFHlMhD5LjI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 61772879c75c436a30d7ef23 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 21:58:17
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C5666C4338F; Mon, 25 Oct 2021 21:58:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.110.111.218] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3D9FC4338F;
        Mon, 25 Oct 2021 21:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B3D9FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] mhi: pci_generic: Graceful shutdown on freeze
To:     Loic Poulain <loic.poulain@linaro.org>, mani@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, bbhatt@codeaurora.org,
        stable@vger.kernel.org
References: <1635151940-22147-1-git-send-email-loic.poulain@linaro.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <28b205f7-f379-8f8c-5b1f-0446ad6f16ff@codeaurora.org>
Date:   Mon, 25 Oct 2021 14:58:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1635151940-22147-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Loic,

On 10/25/2021 1:52 AM, Loic Poulain wrote:
> There is no reason for shutting down MHI ungracefully on freeze,
> this causes the MHI host stack & device stack to not be aligned
> anymore since the proper MHI reset sequence is not performed for
> ungraceful shutdown.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>

do we need to add suggested by tag :)

Thanks,
Hemant

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
