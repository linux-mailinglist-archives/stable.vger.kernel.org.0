Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84D03C1840
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhGHRkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 13:40:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61874 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhGHRkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 13:40:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625765883; h=Content-Transfer-Encoding: Mime-Version:
 Content-Type: References: In-Reply-To: Date: Cc: To: From: Subject:
 Message-ID: Sender; bh=0YPDHu5VHY7aeahdyEoMBMxoMcH/XFFUwidZNslNpqg=; b=JV6WhTXdKAzvRgpXc/xs0ZzH5mVTAFoN4+ArLMzVgPS4hrDueiXnSUUHEhzOmF4PeX/4eouF
 c/QH6gW4m8zzFTtKvkEYJjV7TSvrNTp5QtBmXzy+MDMaBNBLfOGjHofYHcJJ2AWo7c90Zhsg
 5mILWY0fltPa1Y1cdECKnLZiIk4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60e737e601dd9a9431546fd8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Jul 2021 17:37:42
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 67562C4338A; Thu,  8 Jul 2021 17:37:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from hemantk-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FBDCC433F1;
        Thu,  8 Jul 2021 17:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FBDCC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Message-ID: <1625765856.10055.28.camel@codeaurora.org>
Subject: Re: [PATCH] mhi: pci_generic: Fix inbound IPCR channel
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>, mani@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 08 Jul 2021 10:37:36 -0700
In-Reply-To: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
References: <1625736749-24947-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.18.5.2-0ubuntu3.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-07-08 at 11:32 +0200, Loic Poulain wrote:
> The qrtr-mhi client driver assumes that inbound buffers are
> automatically allocated and queued by the MHI core, but this
> no happens for mhi pci devices since IPCR inbound channel is
does not happen for mhi pci devices since IPCR inbound channel is
> not flagged with auto_queue, causing unusable IPCR (qrtr)
> feature. Fix that.
> 
> Cc: stable@vger.kernel.org
> Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
With commit text update 

Reviewed-by: Hemant kumar <hemantk@codeaurora.org>
> [..]
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

