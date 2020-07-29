Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F132319AF
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 08:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgG2Gp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 02:45:26 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:53913 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgG2Gp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 02:45:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596005125; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=F8Dx2k2QTTUlJ3PVcw289iUoRDVJ4gqpdkDJN4dKpe8=; b=GazcNQmDsgNlb1oGZfSA68CIFH+HO+voGzCUuXNVCO76+6g7TEfyTFPjh7n9UwaMcXtU5v0i
 WUk1KRp4vOpznp8j6mfyk33YtWzAaRmK5jh3eZMpRfkQAUCnAKzueJ37JNHd/bGSiqsMoDZB
 lo71IpGnt4GB4jM0cE3fc392dlA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f211b0570ff737ddbb67b25 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 06:45:25
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6D9EDC4339C; Wed, 29 Jul 2020 06:45:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=2.0 tests=ALL_TRUSTED,NICE_REPLY_A,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.0.101] (unknown [49.204.127.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sivaprak)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 232CEC433C9;
        Wed, 29 Jul 2020 06:45:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 232CEC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sivaprak@codeaurora.org
Subject: Re: [PATCH 5/9] phy: qcom-qmp: use correct values for ipq8074 gen2
 pcie phy init
To:     Vinod Koul <vkoul@kernel.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, bhelgaas@google.com,
        robh+dt@kernel.org, kishon@ti.com, mturquette@baylibre.com,
        sboyd@kernel.org, svarbanov@mm-sol.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, mgautam@codeaurora.org,
        smuthayy@codeaurora.org, varada@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
References: <1593940680-2363-1-git-send-email-sivaprak@codeaurora.org>
 <1593940680-2363-6-git-send-email-sivaprak@codeaurora.org>
 <20200713055558.GB34333@vkoul-mobl>
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
Message-ID: <9988249f-53aa-e615-f64b-28c0c0641ab4@codeaurora.org>
Date:   Wed, 29 Jul 2020 12:15:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713055558.GB34333@vkoul-mobl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/13/2020 11:25 AM, Vinod Koul wrote:
> On 05-07-20, 14:47, Sivaprakash Murugesan wrote:
>> There were some problem in ipq8074 gen2 pcie phy init sequence, fix
> Can you please describe these problems, it would help review to
> understand the issues and also for future reference to you

Hi Vinod,

As you mentioned we are updating few register values

and also adding clocks and resets.

the register values are given by the Hardware team and there

is some fine tuning values are provided by Hardware team for the

issues we faced downstream.

Also, few register values are typos for example QSERDES_RX_SIGDET_CNTRL

is a rx register it was wrongly in serdes table.

I will try to mention these details in next patch.

