Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A7F24F664
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgHXI7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbgHXI7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:59:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C64A204FD;
        Mon, 24 Aug 2020 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259564;
        bh=Vqjvv0EIOi2U2s6t+0Q1CQ/3Q2B1knKJsv8HWv4/b7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC9uclQcI+xfmyA0tytJMAz6h+WcavQVvf+IgdXjo7ei64BR9302c9yfFxXVqkKBl
         ACD9DLqnKm9gK1okGw9Byuy1Ve6AXbld5fu4WruKcksBRQ5+JtQrS5M/AoGTCAzquK
         OeFGLZnnbq1f4En3cwiFlIxk5e47K9N4PMDb9Et4=
Date:   Mon, 24 Aug 2020 10:59:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 137/232] USB: serial: ftdi_sio: fix break and sysrq
 handling
Message-ID: <20200824085905.GA405532@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091619.460392380@linuxfoundation.org>
 <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
 <20200820095652.GA1266907@kroah.com>
 <20200824085424.GB21288@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824085424.GB21288@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:24AM +0200, Johan Hovold wrote:
> On Thu, Aug 20, 2020 at 11:56:52AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 20, 2020 at 11:51:56AM +0200, Johan Hovold wrote:
> > > This was never intended for stable as it is not a critical fix and has
> > > never worked properly in the first place. Please drop this one and the
> > > preparatory clean ups from all stable trees.
> > 
> > Ok, but the "fix this thing" and the "Fixes:" tag really did imply this
> > was actually fixing something :)
> 
> Sure and it is indeed a fix, just not for a regression or something
> critical (oops, etc), and therefore the stable-cc tag was omitted.
> 
> > I'll drop it from everywhere, thanks.
> 
> Looks like you never dropped the preparatory clean ups. Should be ok.

Ah, sorry about that, shouldn't be a problem :)
