Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474833A6896
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhFNOAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 10:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhFNOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F536120E;
        Mon, 14 Jun 2021 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623679101;
        bh=vr6RUwBhWqWJKE6xgP0FELDsoZf3I21l3sAjPQ6ipMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nj0m4H1NskiNjBcpZq/iRpddVI/wuHeQsJssTewDphx1WlFKaDcfvH2v2DqZobVgP
         jlVaf6/bXR1uClUtqL6fxQUmsi2hIDpToXqUzAwlfR2YVw9AV7qUGJM0+x2KiBB2th
         JVMwLJz+s6VztV/N/bIAxUvp0166ABD+FFOMwtak=
Date:   Mon, 14 Jun 2021 15:58:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     adel.ks@zegrapher.com
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Kernel 5.12.10 and 5.12.9 freezing after boot-up with while
 sound output is looping
Message-ID: <YMdgev1GDhmbAF4U@kroah.com>
References: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com>
 <YMbmeRH38Wp6BHPf@kroah.com>
 <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
 <f454b38b7987773caa72b656c4d2e3fb@zegrapher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f454b38b7987773caa72b656c4d2e3fb@zegrapher.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 01:47:46PM +0200, adel.ks@zegrapher.com wrote:
> Hello,
> 
> I decided to test first the ALSA changes, which happen to be the commits
> right after v5.12.8, and the very first commit of the series, `73d862c55
> ALSA: hda/realtek: the bass speaker can't output sound on Yoga 9i` made the
> freeze happen (although it took some time when compared to f3c23683d and
> 59ef5291f).
> 
> I am ready and willing to help further on the matter.

Thanks for testing!

So I am also guessing that 5.13-rc6 fails in this same way?

And you do have this specific hardware, for this specific patch, right?

thanks,

greg k-h
