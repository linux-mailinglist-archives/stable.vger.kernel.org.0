Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA145B8F7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 12:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbhKXLS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 06:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234726AbhKXLS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 06:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 725C16044F;
        Wed, 24 Nov 2021 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637752517;
        bh=rSaSXizGZPZcNzjlH1FjaJShiDzYzEwTII6kPKS2z18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MuIg5BbjjGybfvlPrHs2u1Utu6KdTNzXNwknQ5iXZT1pwJW8qJGIe32iYkQPs6Zd0
         cLQ9oO2r0f7Jm2CO7Jq6kH7rMCBsy2CvAYrS4TEOWdU+eLPB6nHiuUGvQuzWcct2NV
         1LTrvilJ/ZlRMOaU5uP0mHjZ74khibygS4y3qqY8=
Date:   Wed, 24 Nov 2021 12:15:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Subject: Re: qcom: msm8916-longcheer-l8150.dts:191.1-14 Label or path
 pm8916_usbin not found
Message-ID: <YZ4euyQbxUGZNJVM@kroah.com>
References: <CA+G9fYuqTWxyKjWix6R2f9E7Y5q1PExm4wOvxBnDhqr-Uc26zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuqTWxyKjWix6R2f9E7Y5q1PExm4wOvxBnDhqr-Uc26zA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 03:38:40PM +0530, Naresh Kamboju wrote:
> Regression found on arm64 gcc-11 builds
> Following build warnings / errors reported on stable-rc 5.15.
> 
> metadata:
>     git_describe: v5.15.4-281-g6257dfb34612
>     git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>     git_short_log: 6257dfb34612 (\"Linux 5.15.5-rc1\")
>     target_arch: arm64
>     toolchain: gcc-11

Thanks for the report, I'll go drop the offending patch.

greg k-h
