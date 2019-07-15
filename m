Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC0868717
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 12:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfGOKdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 06:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729544AbfGOKdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 06:33:11 -0400
Received: from localhost (unknown [89.248.140.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9829120665;
        Mon, 15 Jul 2019 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563186790;
        bh=rs9NML0SberdxWC3c8MDU435XVW9XNHLbfbj+CaqLFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rlg9jyFKue+lnaD3w39xMqTM3acZbzQLSJIpJS1IZEXJqmI6cAXpKEF6t6/Pu3ubC
         NrVIl3tQVntNL6vQsqDQCRyi+d6B5FaP4P5ntQXhvLz+c9uVP4evXgdT0DPfLdvDGR
         2Dg/QoWtjhnvmVf1uGYXdUcVFUZhIrC9kdnIEr9Y=
Date:   Mon, 15 Jul 2019 12:33:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Stable <stable@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: drivers/e1000e revert and proper fix
Message-ID: <20190715103306.GA10682@kroah.com>
References: <667a1815-df93-3072-8042-c4efb37bc81a@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667a1815-df93-3072-8042-c4efb37bc81a@yandex-team.ru>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 12:14:11PM +0300, Konstantin Khlebnikov wrote:
> Please pick revert-commit
> 
> commit caff422ea81e144842bc44bab408d85ac449377b
> ("Revert "e1000e: fix cyclic resets at link up with active tx"")
> 
> and (optionally) proper fix
> 
> commit d17ba0f616a08f597d9348c372d89b8c0405ccf3
> ("e1000e: start network tx queue only when link is up")
> 
> into 4.9, 4.14, 4.19, 5.1, 5.2
> 
> buggy commit 0f9e980bf5ee1a97e2e401c846b2af989eb21c61
> ("e1000e: fix cyclic resets at link up with active tx")
> commited in 5.0 and was picked into 4.9, 4.14, 4.19
> 
> It generates annoying false-positive hung-hardware warnings
> https://bugzilla.kernel.org/show_bug.cgi?id=203175
> 
> Original problem isn't so severe so feel free to skip second commit if it doesn't apply clearly.

It applied cleanly, so all now queued up, thanks.

greg k-h
