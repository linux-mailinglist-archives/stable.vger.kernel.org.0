Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C238ABBC
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbhETL12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241734AbhETLZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C606109F;
        Thu, 20 May 2021 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621506191;
        bh=Ne8XWBjCjC7wMEdXnGePN5BGuqE/9UQF0eMVmwjZmgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HtYjcM9VChqKKpPfgLDpUZn56MOoNCY1C3QUQdtMNbLH22/6n+YCYMPx/ZL5MgbCX
         zKFTBcw5DfH5Kdw0pP9Ces1FmRO8A9XdQ88MxPm8ipZGgNd6AGy6QPat4jS6JYVp4S
         zbMVw6yN9c9vrB+H89nqbDNyi9adLX1rVGzeAvaE=
Date:   Thu, 20 May 2021 12:02:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [regressions] ath11k: v5.12.3 mhi regression
Message-ID: <YKYzwBJNTy4Czd1A@kroah.com>
References: <87v97dhh2u.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v97dhh2u.fsf@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 12:47:53PM +0300, Kalle Valo wrote:
> Hi,
> 
> I got several reports that this mhi commit broke ath11k in v5.12.3:
> 
> commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
> Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Date:   Wed Feb 24 15:23:04 2021 -0800
> 
>     bus: mhi: core: Process execution environment changes serially
>     
>     [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]
> 
> Here are the reports:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213055
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=212187
> 
> https://bugs.archlinux.org/task/70849?project=1&string=linux
> 
> Interestingly v5.13-rc1 seems to work fine, at least for me, though I
> have not tested v5.12.3 myself. Can someone revert this commit in the
> stable release so that people get their wifi working again, please?

How does the mhi bus code relate to a ath11k driver?  What bus is that
on?

This seems odd...

greg k-h
