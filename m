Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8B645A39A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 14:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhKWNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 08:23:32 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:30763 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbhKWNX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 08:23:27 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 08:23:26 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637673250;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=awRBfgBZ8ETDP+YqMyu0xW4JiwJasqSJ5EtHrR7j26k=;
    b=OImAF6ntXH6JXJHOatQrHsndz12rvCa1U2PVJ0G0GK5zKjwQxFEXiCq3NRU87B0e2/
    vLdn4O/cdJ6tDrn984NhtYNSUqPu+kxIVCUlkwN65cYz8TLzlFDA1uWwAnnGUKYoB/FE
    08RE4flX6bQt+V2VEf9WfAc1HnVmubsB+H+p6I6J3HENakT4FU/ghc7KbKhhnE6JBPsP
    eSf/0BySlaT7KMcUFMm3XwGH59KpZFdneNtBRSdsvaBBoTzMrpcX0W7d58wUNKdyYN9O
    l5iyi0izXGEQ4J1kXz7o9xOJ055toBubRxyr+2dUtBbgEgyp6f9WcrW8SIDyJshGJB3K
    DotQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLUrK88/6Y="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id x00478xANDEA9d4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 14:14:10 +0100 (CET)
Date:   Tue, 23 Nov 2021 14:14:04 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM" has
 been added to the 5.15-stable tree
Message-ID: <YZzpHOrS8IHE6mRm@gerhold.net>
References: <20211121230414.76410-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121230414.76410-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Nov 21, 2021 at 06:04:14PM -0500, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM
> 
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      arm64-dts-qcom-msm8916-add-cpu-acc-and-saw-spm.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

Did you forget to drop this patch? :)

You mentioned that you did [1] (since I replied that this patch is not
useful without other changes in 5.16), but apparently not. ;)

Thanks,
Stephan

[1]: https://lore.kernel.org/stable/YY5veYUpixJn9Q92@sashalap/

> 
> commit 4b41a4624fb79b1745e888594425ec592946fb80
> Author: Stephan Gerhold <stephan@gerhold.net>
> Date:   Mon Oct 4 22:49:53 2021 +0200
> 
>     arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM
>     
>     [ Upstream commit a22f9a766e1dc61f8f6ee2edfe83d4d23d78e059 ]
>     
>     Add the device tree nodes necessary for SMP bring-up and cpuidle
>     without PSCI on ARM32. The hardware is typically controlled by the
>     PSCI implementation in the TrustZone firmware and is therefore marked
>     as status = "reserved" by default (from the device tree specification):
>     
>       "Indicates that the device is operational, but should not be used.
>        Typically this is used for devices that are controlled by another
>        software component, such as platform firmware."
>     
>     Since this is part of the MSM8916 SoC it should be added to msm8916.dtsi
>     but in practice these nodes should only get enabled via an extra include
>     on ARM32.
>     
>     This is necessary for some devices with signed firmware which is missing
>     both ARM64 and PSCI support and can therefore only boot ARM32 kernels.
>     
>     Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
>     Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>     Link: https://lore.kernel.org/r/20211004204955.21077-13-stephan@gerhold.net
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> ...
