Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B043EFFD4
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 11:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhHRJDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 05:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhHRJDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 05:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917E161053;
        Wed, 18 Aug 2021 09:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629277370;
        bh=gHGb8aPOCFbTLtg2r0KhV1R6IEtwItwZ77US9YzwBlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ZDtVGFADL55+lK/kY/hZ22HfZMrJMYbcan5LZ5QwbTuHPro551R6MI+Uhj8THsYh
         OkOIk2dnu0GCK/zBkCgIE2xdraiAsGb7RMZga2k+QreNjdL+vfhDFzOrcszdWCcAjN
         VAt44/Tt54tHO0Ate/9kY8D/HeIp/tS4tbf6AtRw=
Date:   Wed, 18 Aug 2021 11:02:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <YRzMt53Ca/5irXc0@kroah.com>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210818084859.vcs4vs3yd6zetmyt@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
> Hello! I would like to request for backporting following ath9k commits
> which are fixing CVE-2020-3702 issue.
> 
> 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> 
> See also:
> https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> 
> This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
> And due to this issue Qualcomm suggests to not use open source ath9k
> driver and instead to use their proprietary driver which do not have
> this issue.
> 
> Details about CVE-2020-3702 are described on the ESET blog post:
> https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> 
> Two months ago ESET tested above mentioned commits applied on top of
> 4.14 stable tree and confirmed that issue cannot be reproduced anymore
> with those patches. Commits were applied cleanly on top of 4.14 stable
> tree without need to do any modification.

What stable tree(s) do you want to see these go into?

And what order are the above commits to be applied in, top-to-bottom or
bottom-to-top?

thanks,

greg k-h
