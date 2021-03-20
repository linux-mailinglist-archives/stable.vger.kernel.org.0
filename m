Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25725342C27
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhCTL3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCTL2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C71161997;
        Sat, 20 Mar 2021 07:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616226159;
        bh=Oz/zz2ZoDsJtU4FYUHJJ/SX/Zxc7sy6UyLq4iqcFJco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUq7SOqQmb4a3etXoJSruufKl345QMLC2tDDws+8RlBAjJn33i3KJORvfpES0BtKy
         NsyKt6hdYxdwzXu3eTbT2nQzr78yodWT4tLTieeBgjRtrpBqHCm6ITF7B/7gE72214
         PdMeg7IjYmPzTjlXmcwESCpIzbIwt1rN18m4sFi8=
Date:   Sat, 20 Mar 2021 08:42:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Piotr Krysiuk <piotras@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org
Subject: Re: bpf speculative execution fixes for 4.14.y
Message-ID: <YFWnbE7sBoSU52R0@kroah.com>
References: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 11:56:18PM +0000, Piotr Krysiuk wrote:
> I noticed that bpf speculative execution fixes are already queued for
> 4.14.y except for f232326f6966 ("bpf: Prohibit alu ops for pointer
> types not defining ptr_limit").
> 
> It is important that for all patches from this series to be applied
> together, so we avoid introducing a new vulnerability.
> 
> For the missing patch, I see conflicting lines in the context diffs
> due to API change that apparently caused import to fail.
> 
> I'm attaching a copy of the patch that is backported to 4.14.y. The
> only change comparing with version queued for newer version is that
> "verbose" API does not take "env" parameter.
> 
> Please queue or let me know how to proceed.

Thank you for the updates.  I had not looked into them further as I was
not going to do a 4.14.y release this week, but was waiting to next week
and would dig into it then, but you have saved me that effort, thanks!

I'll queue these up in a day or so, and if I've missed anything else
here, please let me know.

greg k-h
