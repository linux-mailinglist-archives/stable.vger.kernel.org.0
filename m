Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE222F655
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgG0RN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729991AbgG0RNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCC72074F;
        Mon, 27 Jul 2020 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595870025;
        bh=DzMvaEZ2c8PRGNGNoXy8zUYsCmrHhqwpQRTnJDQLDUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ta4V/TlHAZL7GlZvS59gW5IPtECdtMnZt2+tatrDJyqnWz1O6zwUr/fjbiyRZzCUq
         jbQwi39X/aeKjmSakvqPkNV8my08NF3uxhR/Zx6p1bH1iAMVpOzamiGemiMOa0FQnw
         H5LnEhMnt0XB5o29YPiUmoxLPKtR1O7dM4ibE91o=
Date:   Mon, 27 Jul 2020 16:38:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kieran Bingham <kbingham@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 42/86] scripts/gdb: fix lx-symbols gdb.error while
 loading modules
Message-ID: <20200727143847.GA189341@kroah.com>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134916.556617777@linuxfoundation.org>
 <7675dec9-7b66-b785-5034-22e8ede0b597@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7675dec9-7b66-b785-5034-22e8ede0b597@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 03:26:42PM +0100, Kieran Bingham wrote:
> Hi Greg, Sasha,
> 
> On 27/07/2020 15:04, Greg Kroah-Hartman wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > [ Upstream commit 7359608a271ce81803de148befefd309baf88c76 ]
> > 
> > Commit ed66f991bb19 ("module: Refactor section attr into bin attribute")
> > removed the 'name' field from 'struct module_sect_attr' triggering the
> > following error when invoking lx-symbols:
> 
> 
> Has ed66f991bb19 ("module: Refactor section attr into bin attribute")
> been backported to 4.19? It doesn't /sound/ like something that would
> require backporting unless something else depended up on it,  but if it
> hasn't been ... then *this* patch shouldn't be either...

It was released in 4.19.133, 5.4.52, and 5.7.9.

> Same for 5.4, and 5.7 that's just come in.
> 
> This patch will 'apply' cleanly, and not hit any compilation errors, as
> it only changes python code... so my reason to highlight is in case some
> automated system picked it up based on those assumptions.
> 
> If ed66f991bb19 has also been backported, then I'm sorry for the noise ;-)

It was, but thanks for the review!

greg k-h
