Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDFF19857
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 08:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfEJGYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 02:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfEJGYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 02:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE97217D6;
        Fri, 10 May 2019 06:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557469449;
        bh=xu8TYbSUvj0cpZUkZO+A419xmeSK8E8mlZMqfrLrDF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ai9rMFd2kNp9yIL0M+yaqk2hDhPfpZDVffNsOGWZGbqLPlDbaySpchzrpaLb45BTW
         bDXnOs+LP7yPp8G9h+0w0CwvdjSDt8ORXpPlNROstFRzRP3UMtI/hSxhDvENx8D0nk
         c2pnYGnkRlS3LtZHrlV7YnMT52+gIQ7yNK2qajMk=
Date:   Fri, 10 May 2019 08:24:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 32/66] xtensa: fix initialization of
 pt_regs::syscall in start_thread
Message-ID: <20190510062407.GB18014@kroah.com>
References: <20190509181301.719249738@linuxfoundation.org>
 <20190509181305.327667203@linuxfoundation.org>
 <CAMo8Bf+TZ_ptRjDVuKLZ2M6Bjo83ckuvj=6hCpiZ2ufJrnu80A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMo8Bf+TZ_ptRjDVuKLZ2M6Bjo83ckuvj=6hCpiZ2ufJrnu80A@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 11:55:31AM -0700, Max Filippov wrote:
> Hello,
> 
> On Thu, May 9, 2019 at 11:48 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > [ Upstream commit 2663147dc7465cb29040a05cc4286fdd839978b5 ]
> >
> > New pt_regs should indicate that there's no syscall, not that there's
> > syscall #0. While at it wrap macro body in do/while and parenthesize
> > macro arguments.
> >
> > Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/xtensa/include/asm/processor.h | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> This patch should not be taken to any of the stable trees, except maybe
> 5.0.y, because NO_SYSCALL was introduced to arch/xtensa in 5.0.

Now dropped from everywhere except 5.0.y, thanks.

> This patch doesn't have any cc:stable tags, I'm curious why was it chosen
> for stable and what can I do to prevent that in the future?

Sasha's tools picked this up and you should have been cc:ed on it when
it was selected a few weeks ago.

thanks,

greg k-h
