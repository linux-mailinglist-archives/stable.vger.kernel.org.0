Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F281424106
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhJFPPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 11:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239249AbhJFPO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 11:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A132760F6D;
        Wed,  6 Oct 2021 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633533155;
        bh=n66tkchc4XioC797+ZaRTmljx8w2JSrZg0u+2YT9yP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tj2i74+kSScWGUPwg9XGfcPcwA6u1sN0NaosnVHyjb801WCcn/99Xirx+Z/Tgcf4V
         yvQ3eOyeUPaZxshaDJRMQCqEP/TOoyvsHlSqRypyg0YlqDi5YPny49/+sfb8CHLSDQ
         ifXfnwQgz5vHZymPdlTty2JbOnP36utoKW+7pORuuQdm6awk7QazBP+6thcF47n1RS
         Dhk/ytiL6Xw1SMyDWN14tBeqdpzysERZ9BlCTdCFUdlRKgq6XXey8gJ71OnTxPqe/+
         ttABcuz21nRK+Y8MJKdyeUzahGdJrwXcdXQEooPPvHmcUZYkjnRAKvZcmYCyIrrJAy
         /Jvqa4USrsDfQ==
Date:   Wed, 6 Oct 2021 11:12:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Rob Herring <robh@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org, kholk11@gmail.com,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 06/40] dt-bindings: interconnect: sdm660:
 Add missing a2noc qos clocks
Message-ID: <YV284nZX4BoE+TYj@sashalap>
References: <20211005135020.214291-1-sashal@kernel.org>
 <20211005135020.214291-6-sashal@kernel.org>
 <0a7af294-095e-cac4-e20a-296de7bd59cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0a7af294-095e-cac4-e20a-296de7bd59cb@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:11:31PM +0300, Georgi Djakov wrote:
>Hi Sasha,
>
>On 5.10.21 16:49, Sasha Levin wrote:
>>From: Shawn Guo <shawn.guo@linaro.org>
>>
>>[ Upstream commit cf49e366020396ad83845c1c3bdbaa3c1406f5ce ]
>>
>>It adds the missing a2noc clocks required for QoS registers programming
>>per downstream kernel[1].
>>
>>[1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43
>>
>>Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>Reviewed-by: Rob Herring <robh@kernel.org>
>>Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
>>Link: https://lore.kernel.org/r/20210824043435.23190-2-shawn.guo@linaro.org
>>Signed-off-by: Georgi Djakov <djakov@kernel.org>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>There is no benefit to backport these changes, as devices that
>needed them, would not boot on v5.14 anyways. So please drop these:
>
>[PATCH AUTOSEL 5.14 06/40] dt-bindings: interconnect: sdm660: Add 
>missing a2noc qos clocks
>[PATCH AUTOSEL 5.14 07/40] interconnect: qcom: sdm660: Add missing 
>a2noc qos clocks

I'll drop it, thanks!

-- 
Thanks,
Sasha
