Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8C40183D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 10:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhIFIud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 04:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234535AbhIFIub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 04:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 518F360F21;
        Mon,  6 Sep 2021 08:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630918166;
        bh=nTiRIWyo6vWiXFt6cj1r9wmry54wZ+Lrq9MbqHCZs1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQraCh/5gSJYQz1OGzBgXQsHFuhZrSMUlmDWqxnnp8b/yx14Z+xtnh6iccjcZ86mW
         5gVJ3yOj+zH5ui3l3gCCqHP93skctBRPo7wBdQrhTnazfZZdsamEmJenG0qtsj8wmj
         EpMEBVu20MFoosivr8vf5AUczSGereRVGR8ZJXKI=
Date:   Mon, 6 Sep 2021 10:49:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     nobuhiro1.iwamatsu@toshiba.co.jp,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <YTXWDE4NStB8ZOf8@kroah.com>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210902114814.GA525@amd>
 <YTC9QBWPoulIhZYq@kroah.com>
 <20210903063440.GC9690@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903063440.GC9690@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 08:34:40AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > > > See also:
> > > > > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> > > ...
> > > > > > What stable tree(s) do you want to see these go into?
> > > > > 
> > > > > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
> > > 
> > > ...
> > > 
> > > > Great, all now queued up.  Sad that qcom didn't want to do this
> > > > themselves :(
> > > 
> > > Thanks for the fixes; I see them in 4.14 and newer stable trees.
> > > 
> > > But I don't see them in 4.4 and 4.9, nor can I see reason why they
> > > were not applied.
> > > 
> > > Can someone help?
> > 
> > Odd, I don't remember why I didn't even try to apply them to older
> > kernels.  I'll do that after this next round is released in a few days,
> > sorry about that.
> 
> Thank you! If there are problems, let me know and I'll try to help.

Now all queued up.

greg k-h
