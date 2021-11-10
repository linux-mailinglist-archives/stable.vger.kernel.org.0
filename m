Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF744BD51
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhKJIzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 03:55:12 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:18055 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKJIzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 03:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1636533623;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=EoxcSaG1zS8onhMLinZTy9RSATOglCLjfc+GAPA1hs4=;
    b=QsEw7VZu85INtby5O1t1mYNCFSg21OBHBj7ipeYdOBesZ5OdeloR3chtnr/TgorEtu
    RZdP8SOTcvmcPsajfcaFu3ucQOs2bizqOWV6OreIaLMh9wSFjWB8aJL5A3jZv+Hkabcg
    92uhU+tXBgn2TGR3BlDGAzkaMFrh+DE9qx1WgBQVj2s3rOBufkCX6uuMUCPYT/Fk+iT/
    C6BLJnDRNboNkLAdVJqszS/7ccs6LOFiDVL/BIt+ZEzfiZQX4ncUh4/IWnzda52kjqhn
    vpT0bTgTo+sxB4vXpak56IsfrjoSWxGyvdbRR8qV334zY6P53Jf6hG767bVZhy2TIti3
    vNgg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLVrK8+86Y="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.34.5 AUTH)
    with ESMTPSA id j05669xAA8eM2gU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 10 Nov 2021 09:40:22 +0100 (CET)
Date:   Wed, 10 Nov 2021 09:40:16 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 73/82] arm64: dts: qcom: msm8916: Add CPU
 ACC and SAW/SPM
Message-ID: <YYuFcOrEXL0b8UEo@gerhold.net>
References: <20211109221641.1233217-1-sashal@kernel.org>
 <20211109221641.1233217-73-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109221641.1233217-73-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Nov 09, 2021 at 05:16:31PM -0500, Sasha Levin wrote:
> From: Stephan Gerhold <stephan@gerhold.net>
> 
> [ Upstream commit a22f9a766e1dc61f8f6ee2edfe83d4d23d78e059 ]
> 
> Add the device tree nodes necessary for SMP bring-up and cpuidle
> without PSCI on ARM32. The hardware is typically controlled by the
> PSCI implementation in the TrustZone firmware and is therefore marked
> as status = "reserved" by default (from the device tree specification):
> 
>   "Indicates that the device is operational, but should not be used.
>    Typically this is used for devices that are controlled by another
>    software component, such as platform firmware."
> 
> Since this is part of the MSM8916 SoC it should be added to msm8916.dtsi
> but in practice these nodes should only get enabled via an extra include
> on ARM32.
> 
> This is necessary for some devices with signed firmware which is missing
> both ARM64 and PSCI support and can therefore only boot ARM32 kernels.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Link: https://lore.kernel.org/r/20211004204955.21077-13-stephan@gerhold.net
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 

This patch is not useful without other changes that landed in 5.16
(in particular, the new device actually making use of these nodes).

Can you drop this patch?

Thanks,
Stephan
