Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280213FD6D0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243648AbhIAJdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243577AbhIAJdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:33:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 449D86109E;
        Wed,  1 Sep 2021 09:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630488756;
        bh=JI1uBs3rF4VKeZZKtGKlIcUTM/qvFGMKBMDP6/OB+u0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=On3QoAOToxdzdgqIJh7C4V2HCVsi75my8eker0KxFhCx3vYeubP2Lduqy79JcQODf
         SFWyG6bV4gxYtv71iYFjEvdWgKUVFiFALJjIVpLYl+IY2ow10c8nN3Z4VGrNxspo7A
         4DDmyZtcslsalkiiZkKtgxLwqY0hXImP3U/JGCks=
Date:   Wed, 1 Sep 2021 11:32:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Petr Vorel <pvorel@suse.cz>
Subject: Re: [PATCH 1/1] arm64: dts: qcom: msm8994-angler: Fix
 gpio-reserved-ranges 85-88
Message-ID: <YS9IsZe/HQqgfjgP@kroah.com>
References: <20210824190332.22657-1-petr.vorel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824190332.22657-1-petr.vorel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 09:03:31PM +0200, Petr Vorel wrote:
> commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 upstream.
> 
> Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
> application CPUs (causes reboot). Yet another fix similar to
> 9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
> 3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").
> 
> Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
> 
> [ pvorel: rebased for 5.4: tlmm -> msmgpio ]
> Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> For 5.4.y
> 
>  arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
>  1 file changed, 4 insertions(+)

All queued up, thanks.

greg k-h
