Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB06144E7AF
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhKLNqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhKLNqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:46:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE15C60F46;
        Fri, 12 Nov 2021 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636724602;
        bh=TndXQF8eNYfxNvw0ePcsQ5tjzuc+YhY2I9M/NOjrCo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zwnv0S9hQRQrTQkEwpGSqxyyJKPfCzg7qyDRlT0PT9u45Pg0elkH8k1z3cAIVpyfi
         /EqBgED/CR6ExxNb/7cUhGQ4wy0UbLESS9kYPlAWoixhMG9Ccns41hM8w1wtRUp7Xm
         tp988LFtMh4/YLs0Qj2BkJiW+3vB0M/hxqOPqhAG7caJVQAA7SulUyX8dcHeaQYqVU
         cYWa/DJ2Coi8MZrlESMI8n+Gzqy+mloFO3OmNZzfTUXGsKCNXgUNEKaCsU9zh9B/td
         Wg9TmLF1SK0oq36spsL6dwpSRxy1eAaRFgI3TLAXS8jrALV9RDpLZ9Tt4sicRU0hw4
         I3sLNhTYaqApg==
Date:   Fri, 12 Nov 2021 08:43:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 73/82] arm64: dts: qcom: msm8916: Add CPU
 ACC and SAW/SPM
Message-ID: <YY5veYUpixJn9Q92@sashalap>
References: <20211109221641.1233217-1-sashal@kernel.org>
 <20211109221641.1233217-73-sashal@kernel.org>
 <YYuFcOrEXL0b8UEo@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YYuFcOrEXL0b8UEo@gerhold.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 09:40:16AM +0100, Stephan Gerhold wrote:
>Hi Sasha,
>
>On Tue, Nov 09, 2021 at 05:16:31PM -0500, Sasha Levin wrote:
>> From: Stephan Gerhold <stephan@gerhold.net>
>>
>> [ Upstream commit a22f9a766e1dc61f8f6ee2edfe83d4d23d78e059 ]
>>
>> Add the device tree nodes necessary for SMP bring-up and cpuidle
>> without PSCI on ARM32. The hardware is typically controlled by the
>> PSCI implementation in the TrustZone firmware and is therefore marked
>> as status = "reserved" by default (from the device tree specification):
>>
>>   "Indicates that the device is operational, but should not be used.
>>    Typically this is used for devices that are controlled by another
>>    software component, such as platform firmware."
>>
>> Since this is part of the MSM8916 SoC it should be added to msm8916.dtsi
>> but in practice these nodes should only get enabled via an extra include
>> on ARM32.
>>
>> This is necessary for some devices with signed firmware which is missing
>> both ARM64 and PSCI support and can therefore only boot ARM32 kernels.
>>
>> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Link: https://lore.kernel.org/r/20211004204955.21077-13-stephan@gerhold.net
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>
>This patch is not useful without other changes that landed in 5.16
>(in particular, the new device actually making use of these nodes).
>
>Can you drop this patch?

Yup, thanks!

-- 
Thanks,
Sasha
