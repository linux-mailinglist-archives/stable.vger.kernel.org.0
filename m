Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA44B3F000D
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhHRJLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 05:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231941AbhHRJLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 05:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4092F60FDA;
        Wed, 18 Aug 2021 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629277830;
        bh=PPTa4ZGPiX/cWmzK+A1mYmTwVJhs9k/3hFnHrqGBgJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IZ115SfELwmW+pyUhAYF1TRZ0NKaJmHtt5iT3rlOdhUe8qtLvry+aML/UwX278fFM
         8VffthE/aBzru2pqWM2SF7g9wtr4ULxpYfzmw1SfbqHUp+TPSz0EpUbhBkLSlzg4p+
         im7lGv64X9aIc81icNsUyb+p4ho80hHSyrnGGHzbw2ZdmBaPz12Y7FXWOO1rAnQdh3
         uW7ATKyi45FY/7uzN4XxYgtnuLgExHu/xkw83FsTTzYEDY7p1ytg1kmUFLdcTai4Qi
         Z/iyhKrTgpASO0dRkwVuGblNF6w3wZZ7tPyXi8H8FuniuRWgdgoIkDcsSNlnjEH7X7
         4u1QD5CBfG99g==
Received: by pali.im (Postfix)
        id 16B1968A; Wed, 18 Aug 2021 11:10:28 +0200 (CEST)
Date:   Wed, 18 Aug 2021 11:10:27 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210818091027.2mhqrhg5pcq2bagt@pali>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YRzMt53Ca/5irXc0@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 18 August 2021 11:02:47 Greg KH wrote:
> On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
> > Hello! I would like to request for backporting following ath9k commits
> > which are fixing CVE-2020-3702 issue.
> > 
> > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> > 
> > See also:
> > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> > 
> > This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
> > And due to this issue Qualcomm suggests to not use open source ath9k
> > driver and instead to use their proprietary driver which do not have
> > this issue.
> > 
> > Details about CVE-2020-3702 are described on the ESET blog post:
> > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> > 
> > Two months ago ESET tested above mentioned commits applied on top of
> > 4.14 stable tree and confirmed that issue cannot be reproduced anymore
> > with those patches. Commits were applied cleanly on top of 4.14 stable
> > tree without need to do any modification.
> 
> What stable tree(s) do you want to see these go into?

Commits were introduced in 5.12, so it should go to all stable trees << 5.12

> And what order are the above commits to be applied in, top-to-bottom or
> bottom-to-top?

Same order in which were applied in 5.12. So first commit to apply is
56c5485c9e44, then 73488cb2fa3b and so on... (from top of the email to
the bottom of email).

> thanks,
> 
> greg k-h
