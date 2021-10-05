Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F12423094
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJETN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 15:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhJETN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 15:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FD3A6101B;
        Tue,  5 Oct 2021 19:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633461098;
        bh=HRq9rIj1GmCl025MZY7neLlt7VXXCBDwJ3b80PIqi2Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CCaxwhI6ecMlE4jwtKYVcgoN6gNOSfLZTzbDUvXOUcnDy0AZa6YrT44eYgrLBe8I+
         yx6RV07nRCyjsnWtvO5bNIuxsWf/pMR6II6XDSog+GuXcpNrBKhJEVVENxlXehphPb
         7ksZmPUehRRJbR4DNSz8jIuUhBmmXnIDZko4a9+7j/Vg8OY0cIYHDD0QnfQJnXL1+x
         WpBS/JbWbjcuKRjBhU3TaLTP/5v4QeLuKOByJTBRkwNPg3d1m1iVj4NgGBYvmWDg46
         4jFbBfXSiJGIL0oNwBUjaOCycdFAdKC1H8ISkJTweCizjt1iCjAsc5mIIa3R8N54gZ
         89Jof1lT5n56g==
Message-ID: <0a7af294-095e-cac4-e20a-296de7bd59cb@kernel.org>
Date:   Tue, 5 Oct 2021 22:11:31 +0300
MIME-Version: 1.0
Subject: Re: [PATCH AUTOSEL 5.14 06/40] dt-bindings: interconnect: sdm660: Add
 missing a2noc qos clocks
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>, Rob Herring <robh@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org, kholk11@gmail.com,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20211005135020.214291-1-sashal@kernel.org>
 <20211005135020.214291-6-sashal@kernel.org>
From:   Georgi Djakov <djakov@kernel.org>
In-Reply-To: <20211005135020.214291-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 5.10.21 16:49, Sasha Levin wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> [ Upstream commit cf49e366020396ad83845c1c3bdbaa3c1406f5ce ]
> 
> It adds the missing a2noc clocks required for QoS registers programming
> per downstream kernel[1].
> 
> [1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> Link: https://lore.kernel.org/r/20210824043435.23190-2-shawn.guo@linaro.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

There is no benefit to backport these changes, as devices that
needed them, would not boot on v5.14 anyways. So please drop these:

[PATCH AUTOSEL 5.14 06/40] dt-bindings: interconnect: sdm660: Add 
missing a2noc qos clocks
[PATCH AUTOSEL 5.14 07/40] interconnect: qcom: sdm660: Add missing a2noc 
qos clocks

Thanks,
Georgi
