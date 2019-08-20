Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3362996635
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfHTQX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTQX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 12:23:27 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E092322CE3;
        Tue, 20 Aug 2019 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318206;
        bh=RH7qOcHp/IW4wG14fcdhpt2BAemQ/ZyxsJxyL8qNrdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ets7EHTexT3m9SrSn6Up38mCsD1NwHrz6LAzq2oKCJiCNAiCYPeHPV+uyWBGgU6BP
         SF77wrm99ICpTnZHVsx+KqFHzOam8rWzclDv85lAa3yZzQcR0NUNbWu7lislgqcEWu
         KK2YyxWcNvoVLUlN9nKpP7rxFyehZjGEdQ1sTFMk=
Date:   Tue, 20 Aug 2019 09:23:25 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>,
        David Jeffery <djeffery@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Message-ID: <20190820162325.GB8214@kroah.com>
References: <20190818155941.GA26766@eldamar.local>
 <20190818183305.GA1181@kroah.com>
 <20190818204436.GA27437@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818204436.GA27437@eldamar.local>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 10:44:36PM +0200, Salvatore Bonaccorso wrote:
> hi Greg,
> 
> On Sun, Aug 18, 2019 at 08:33:05PM +0200, Greg Kroah-Hartman wrote:
> > On Sun, Aug 18, 2019 at 05:59:41PM +0200, Salvatore Bonaccorso wrote:
> > > Hi
> > > 
> > > In Debian bug https://bugs.debian.org/934331 ran into issues which
> > > match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
> > > underlying storage no longer supports it").
> > > 
> > > This commit was CC'ed to stable, but only got applied in v5.0.8 (and
> > > later on backported by Ben Hutchings to v3.16.72).
> > > 
> > > Mike, I have not checked how easily that would be for older stable
> > > versions, but can the backport be considered for versions down to 4.9?
> > > Apparently Ben did succeed with some changes needed. To 4.19 it should
> > > apply with a small conflict in drivers/md/dm-core.h AFAICS.
> > 
> > If someone sends the backports to the list, I will be glad to queue them
> > up.
> 
> Here is the one for 4.19 on top of 4.19.67. It's my first contribution
> on this regard. Given the change to be applied was only about the
> context change in drivers/md/dm-core.h I'm unsure if the Signed-off-by
> is the right addition to do as well.

Yes it is!

Now queued up, thanks.

greg k-h
