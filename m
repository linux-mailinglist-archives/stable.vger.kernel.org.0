Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB032B43
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfFCJAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfFCJAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:00:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DA427DE1;
        Mon,  3 Jun 2019 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559552404;
        bh=YU/kGCvnHzGvuwgj2PIJXhxGrd1kecu0ZqYiqlXfByc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uvzBnwFiZ9giTdZRjiQ3spRxkYLiXo6TQfStvWeSMOgOpBdDuJwdbp3OLVAU2A5hN
         IW/PaqtMZSsVFxIjBBmZC9DyyHbrrrD2TPZ3XbamQXTJg+bTD73VMICqWm+DCEUism
         GHQQvqR9a1d4zuAShRBqoDWWqhevE7XVptPb3gWE=
Date:   Mon, 3 Jun 2019 11:00:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: "tipc: fix modprobe tipc failed after switch order of device
 registration" broke firefox
Message-ID: <20190603090002.GA8096@kroah.com>
References: <1b1dba03a69d70553827a972fa7058562dcd13be.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1dba03a69d70553827a972fa7058562dcd13be.camel@infinera.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 08:01:31AM +0000, Joakim Tjernlund wrote:
> Commit https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.14.y&id=af4af68df3e48f49a03c2213b8e438ac47143135 
> broke stable 4.14/4.19
> Upstream reverted that commit and replaced it with a new version:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/tipc/core.c?id=526f5b851a96566803ee4bee60d0a34df56c77f8

I have no idea how this broke firefox, odd.

Anyway, I think I've now fixed this all up, should be in the next stable
releases, thanks.

greg k-h
