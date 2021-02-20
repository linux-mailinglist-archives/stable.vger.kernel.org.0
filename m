Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989AA320447
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 08:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhBTHAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 02:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhBTHAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 02:00:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2866660230;
        Sat, 20 Feb 2021 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613804381;
        bh=YNSvya26F+Jyb2qvu/JpH0D1vq779rz3e0bhTaa7jAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uUY9+OyJda99ePMOGQiiMqKCOu9rR67iVsKIJQUJnsbHyYnT6iixWKuHnfzELocx9
         VwMiJPKTBWm5MbBQGB3jIXctMskSVGEsNKqTCGkKkVcvnuXaxInloVRi/4ZPNS/lPq
         IwiEfyqFAk+IRFkP3w4UxKEZxHAOH6l7Xa7LEs0k=
Date:   Sat, 20 Feb 2021 07:59:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        jiaxun.yang@flygoat.com, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: use FR=1 for FPXX binary
Message-ID: <YDCzW0akEAHx5ZX1@kroah.com>
References: <20210220061635.9976-1-yunqiang.su@cipunited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220061635.9976-1-yunqiang.su@cipunited.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 20, 2021 at 06:16:35AM +0000, YunQiang Su wrote:
> some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are still FP32.
> 
> Since FPXX binary can work with both FR=1 and FR=0, we force it to
> use FR=1 here.
> 
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
> ---
>  arch/mips/kernel/elf.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

You also forgot to sign off on your patch :(
