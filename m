Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2A1507E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfEFPmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfEFPmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 11:42:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655BC2087F;
        Mon,  6 May 2019 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557157337;
        bh=ab6vxZ2ZuztsL+zONdbHamFuLiBrBSj1aNspFw3TDiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AnOojHHDqk9z0eY/XOioX5B2/GZzIOHMuCNWpKD0k1Q6sVMZHaE4nU6g3jzMvJKov
         TLJoWsgtVZyxZLsXWSV9X7yHzCAV9k21/Mq7Ya1flVzOQhiDZ5ZESo1u8CfGYKJOnA
         3BgbnTsI/UZZAa2/7+9htZhO6YPqrsEYHOKz3Pwo=
Date:   Mon, 6 May 2019 17:42:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.9 10/62] kasan: rework Kconfig settings
Message-ID: <20190506154215.GB14919@kroah.com>
References: <20190506143051.102535767@linuxfoundation.org>
 <20190506143051.984481239@linuxfoundation.org>
 <8bdd66ba-d6e8-ef65-47fd-cf18e18fcd3e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bdd66ba-d6e8-ef65-47fd-cf18e18fcd3e@virtuozzo.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 05:58:59PM +0300, Andrey Ryabinin wrote:
> 
> 
> On 5/6/19 5:32 PM, Greg Kroah-Hartman wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > commit e7c52b84fb18f08ce49b6067ae6285aca79084a8 upstream.
> > 
> 
> This is a fix/workaround for the previous patch c5caf21ab0cf "kasan: turn on -fsanitize-address-use-after-scope"
> which shouldn't be in the -stable. So without c5caf21ab0cf we don't need this one.

Great, will go drop this now as well!

greg k-h
