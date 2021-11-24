Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD40445B8FC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 12:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240988AbhKXLUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 06:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:32974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240982AbhKXLUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 06:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E7D6044F;
        Wed, 24 Nov 2021 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637752648;
        bh=RnPHT5IJHhSkXqvzU98l957I/ebgRe3rQDhxsP7+h4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hg3TVgHmx7Hfm3IgT/BmYcyc97so0izhdk2s6ImnXq08uGxXA4RXdLVk78kZPhs/S
         J3rFR583py2SjCG57b+sairDHcxy8Icthvi0SHdIYCh5Xd9sCPbAgziHuSaL60qhHr
         H4e2zS36p7dKRAFXvl+TlHr7BJ7SohHY1zLwHIR0=
Date:   Wed, 24 Nov 2021 12:17:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: ipa_endpoint: ipa_endpoint.c:723:49: error: 'IPA_VERSION_4_5'
 undeclared
Message-ID: <YZ4fRXHWGeCi/Xu1@kroah.com>
References: <CA+G9fYuPTaOZ7Kbtvq=5gq7xrWdLsKRw_iBSxfmGORoRbesy_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuPTaOZ7Kbtvq=5gq7xrWdLsKRw_iBSxfmGORoRbesy_Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 03:52:24PM +0530, Naresh Kamboju wrote:
> Regression found on arm64 gcc-11 builds
> Following build warnings / errors reported on stable-rc 5.10.
> 
> metadata:
>     git_describe: v5.10.81-156-g7f9de6888cf8
>     git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>     git_short_log: 7f9de6888cf8 (\"Linux 5.10.82-rc1\")
>     target_arch: arm64
>     toolchain: gcc-11

Thanks, offending commit now dropped.

greg k-h
