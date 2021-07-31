Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429133DC38E
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 07:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhGaFcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 01:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhGaFcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 01:32:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C6060E93;
        Sat, 31 Jul 2021 05:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627709564;
        bh=PdiS919jdJcrQxFZ3b9hL9O2hqulR6yO+wI4K0xj8mw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkqYND6271CyTeqzlb+4uXYH2w+sBJORaBCXBihpVHZVg6kc2MI205x7iZbrGaOuU
         UMZaLr9lC+5zPklYOJck4NxbMofpmsb8G/n0OAfXPRBKc5YeGMq7V9menLuoEu4IwB
         d8pJYGUyJpcYDSlxR5zptPX56ybXCzdCTWito7sM=
Date:   Sat, 31 Jul 2021 07:32:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sandeep Patil <sspatil@android.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 1/1] fs: pipe: wakeup readers everytime new data written
 is to pipe
Message-ID: <YQTgeSUwqC5/8i88@kroah.com>
References: <20210729222635.2937453-1-sspatil@android.com>
 <20210729222635.2937453-2-sspatil@android.com>
 <CAHk-=wh-DWvsFykwAy6uwyv24nasJ39d7SHT+15x+xEXBtSm_Q@mail.gmail.com>
 <cee514d6-8551-8838-6d61-098d04e226ca@android.com>
 <CAHk-=wjStQurUzSAPVajL6Rj=CaPuSSgwaMO=0FJzFvSD66ACw@mail.gmail.com>
 <CAHk-=wjrfasYJUaZ-rJmYt9xa=DqmJ5-sVRG7cJ2X8nNcSXp9g@mail.gmail.com>
 <CAHk-=wgw7hh5+E6P2YYpHH51YNnkpro5tzSdXEmL9Xpk5Bh9Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgw7hh5+E6P2YYpHH51YNnkpro5tzSdXEmL9Xpk5Bh9Dg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 03:55:17PM -0700, Linus Torvalds wrote:
> On Fri, Jul 30, 2021 at 3:53 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I've pushed it out as commit 3a34b13a88ca ("pipe: make pipe writes
> > always wake up readers"). Holler if you notice anything odd remaining.
> 
> .. and as I wrote that, I realized that I had forgotten to mark it for
> stable even though that was the intent.
> 
> So stable team, please consider this the "that commit should probably
> be added to your queue" notification,

Will do so, thanks!

greg k-h
