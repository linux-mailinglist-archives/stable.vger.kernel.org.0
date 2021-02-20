Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE9320453
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 08:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBTHST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 02:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhBTHST (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 02:18:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DE564EB8;
        Sat, 20 Feb 2021 07:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613805458;
        bh=Lt3rO2bZPH6C3Pf+blStfwrfjr+7KZ3+JrgQfCyLknM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EP5oq4fZ/iiTwKKPDtmeYHfH53oJmOn9oco/sf/qexnW+R3i3JSOXzfLWlDDdDyr7
         uvnvkDHHN4b/EtNvHIMHLHMfIiXyuKrGsr1FSiGp62wN5fXisiATTYaxLXTezMvtAF
         nYO/gPUgJTUDylSqiUGYeLklLuHnIL3gRseUgZ78=
Date:   Sat, 20 Feb 2021 08:17:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        jiaxun.yang@flygoat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: use FR=0 for FPXX binary
Message-ID: <YDC3jugm4PyojtVi@kroah.com>
References: <20210220063615.10271-1-yunqiang.su@cipunited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220063615.10271-1-yunqiang.su@cipunited.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 20, 2021 at 06:36:15AM +0000, YunQiang Su wrote:
> some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are still FP32.
> 
> Since FPXX binary can work with both FR=1 and FR=0, we force it to
> use FR=0 here.
> 
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
> 
> v1->v2:
> 	Fix bad commit message: in fact, we are switching to FR=0
> ---
>  arch/mips/kernel/elf.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
