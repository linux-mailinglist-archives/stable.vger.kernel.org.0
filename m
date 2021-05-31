Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8763959DF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhEaLrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhEaLrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AB7610A6;
        Mon, 31 May 2021 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622461566;
        bh=g5oty2gYfesCWaDdgy+XYzkAsq7/CBguYDeSUuMewns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLnYchXLNVWgmYYNxGjf9iA0AR/VwiC+taYYPCUxlTbnosN9qYOvrLBDX7GdwRev1
         sXS+oBM8FB8m3wgBz13gT/W+sTY8E3RvAOv5faU1GnNB5E3eGybhKc82qXjU/pZCeW
         EZXVYR/3e3cBvYMQlaxyzSwJT0eZikAQXDrcu10o=
Date:   Mon, 31 May 2021 13:46:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [stable-rc] 5.12 arch/arm64/kvm/arm.c:722:8: error: use of
 undeclared label 'out'
Message-ID: <YLTMe3O4NDZlsxpD@kroah.com>
References: <CA+G9fYtwjDoDr=hrSGLg4x5pv3Kq-MbCTzohy3=yLLN7P-Czqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtwjDoDr=hrSGLg4x5pv3Kq-MbCTzohy3=yLLN7P-Czqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 04:43:52PM +0530, Naresh Kamboju wrote:
> The Linux stable-rc 5.12 arm64 builds failed due to these warnings / errors.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> arch/arm64/kvm/arm.c:722:8: error: use of undeclared label 'out'
>                 goto out;
>                      ^
> arch/arm64/kvm/arm.c:918:1: warning: unused label 'out' [-Wunused-label]
> out:
> ^~~~
> 1 warning and 1 error generated.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

This will be fixed in a few minutes, it was reported right before you:
	https://lore.kernel.org/r/0d9f123c-e9f7-7481-143d-efd488873082@huawei.com
