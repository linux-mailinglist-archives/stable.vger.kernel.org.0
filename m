Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311473FED5B
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhIBMDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 08:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233831AbhIBMDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 08:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7DE2610CE;
        Thu,  2 Sep 2021 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630584131;
        bh=yQLzo95e2JPxvB8ZCf/wPPKVCI/DY3xCZdaS+IbDUm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7JkBEBeV61YhqaqdDdH3f8QGsteChshdkQWkLaWM82uOfjI9lihs8aXv61S2hbzh
         T4afSsPNQxyjPUoG68L+SF09c578HuM4IV8IEYIvAIKWQcoOEfT55uPkag0dYMOZer
         fP2gaQ466n+IoEMevOzUTEI9AT4OQTZ4uQBC3tBg=
Date:   Thu, 2 Sep 2021 14:02:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     nobuhiro1.iwamatsu@toshiba.co.jp,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <YTC9QBWPoulIhZYq@kroah.com>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210902114814.GA525@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902114814.GA525@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 01:48:14PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > Hello! I would like to request for backporting following ath9k commits
> > > > > which are fixing CVE-2020-3702 issue.
> > > > > 
> > > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> > > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> > > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> > > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> > > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> > > > > 
> > > > > See also:
> > > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> ...
> > > > What stable tree(s) do you want to see these go into?
> > > 
> > > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
> 
> ...
> 
> > Great, all now queued up.  Sad that qcom didn't want to do this
> > themselves :(
> 
> Thanks for the fixes; I see them in 4.14 and newer stable trees.
> 
> But I don't see them in 4.4 and 4.9, nor can I see reason why they
> were not applied.
> 
> Can someone help?

Odd, I don't remember why I didn't even try to apply them to older
kernels.  I'll do that after this next round is released in a few days,
sorry about that.

greg k-h
