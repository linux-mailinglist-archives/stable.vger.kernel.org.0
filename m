Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34829023A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394663AbgJPJwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394639AbgJPJwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:52:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8262072C;
        Fri, 16 Oct 2020 09:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602841950;
        bh=WOTUV3JFWoQhT7mNElFwYVjKiFAz2m6u2T3T4Y6D4fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upTD0SC7ZVYfuRbcb5iPEN7Jv87LdbO9H+yKeQSDLeL7phOmetYhskYYNrE1AM4Si
         yB0CnGaLKXQ9aYwR5mp5Dv/6H4seKWlZc2Kap3C9PG7U09oRQgadA2P0zkhvjYB1Mq
         vp1h5Y395J0YJzoTPook2p31HvCK7Fx3Fq/SunYY=
Date:   Fri, 16 Oct 2020 11:53:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rui Salvaterra <rsalvaterra@gmail.com>
Cc:     stable@vger.kernel.org, jaedon.shin@gmail.com
Subject: Re: Backport request:
 arm-8987-1-vdso-fix-incorrect-clock_gettime64.patch
Message-ID: <20201016095300.GA1769500@kroah.com>
References: <CALjTZvZ_hesn5D34o7+X-gffN-POPzk49-ExB_r-sCpupdTtmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjTZvZ_hesn5D34o7+X-gffN-POPzk49-ExB_r-sCpupdTtmA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 10:39:50AM +0100, Rui Salvaterra wrote:
> Hi, Greg,
> 
> I see the arm-8987-1-vdso-fix-incorrect-clock_gettime64.patch ("ARM:
> 8987/1: VDSO: Fix incorrect clock_gettime64") has been applied to the
> 5.7-stable tree [1], but this should have been applied to 5.3+, since
> it's the first version to contain the commit this patch fixes [2].

But that's not what that commit says should happen, it says it fixes a
commit that showed up in the 5.5 release.

Is it incorrect?  Have you tested this on 5.4.y?

thanks,

greg k-h
