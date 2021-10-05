Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB080421F24
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhJEG4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhJEG4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 02:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD96A61372;
        Tue,  5 Oct 2021 06:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633416868;
        bh=/nImKm7xPYJQWhHFOJ+JbpNw8W2HFAJxackgmgi/QUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fud2o8Usa1h6ljTdQijn5AnqWa5xSdL1GKnvOceq3sw5PLBcjhkQX+Z2AzFmvwQCn
         OaSE2hvsVk9WiII+4BoApZHoIMwYsYrPYfzMcCFvc3CQ3KtQ/l/seWjCs5HZyw+qQA
         lGuOnVlRNarNnJdl4+rcEpjBg4Bsv590MCDpW3hw=
Date:   Tue, 5 Oct 2021 08:54:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 57/57] net: mdiobus: Fix memory leak in
 __mdiobus_register
Message-ID: <YVv2on9BQkfKvEAw@kroah.com>
References: <20211004125028.940212411@linuxfoundation.org>
 <20211004125030.751799483@linuxfoundation.org>
 <672dcc29-0650-222b-41fc-90a1939ac561@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <672dcc29-0650-222b-41fc-90a1939ac561@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 01:35:20PM -0700, Florian Fainelli wrote:
> On 10/4/21 5:52 AM, Greg Kroah-Hartman wrote:
> > From: Yanfei Xu <yanfei.xu@windriver.com>
> > 
> > commit ab609f25d19858513919369ff3d9a63c02cd9e2e upstream.
> > 
> > Once device_register() failed, we should call put_device() to
> > decrement reference count for cleanup. Or it will cause memory
> > leak.
> 
> This changed has since been reverted upstream, please drop this change:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=10eff1f5788b6ffac212c254e2f3666219576889

Now dropped from everywhere, thanks.

greg k-h
