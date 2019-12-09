Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE9117257
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 18:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfLIRC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 12:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfLIRC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 12:02:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806B12077B;
        Mon,  9 Dec 2019 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575910947;
        bh=LoouLsH0oetfusN6CYeyQC2RMX0FLyOWe7g6ISi5j7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Je9gyP4KUzsfH6rVbRcXhIK2nB0vPSji6gXHj2DgM7epKnJWKdbRGyN8RdrQlQ3n2
         FiP+mEOPUwGVK/H1j6Sornf/W195TjF/qLnI7x19osQJbSsRddLDPnHhELmI3Kuzwo
         MfvmsRhYP7QH401WpGjkfjyIJ07bzTsdQYU/NgWY=
Date:   Mon, 9 Dec 2019 18:02:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
Message-ID: <20191209170224.GD1290729@kroah.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> Hello Greg, all,
> 
> I've seen a few errors with 4.19.89-rc1 (5944fcdd).
> 
> 1)
> Config: arm64 defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484093#L267
> Probable culprit: 227b635dcae6 ("bpf, arm64: fix getting subprog addr from aux for calls")
> Issue log:
> 267 arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> 268 arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration of function 'bpf_jit_get_func_addr'; did you mean 'bpf_jit_binary_hdr'? [-Werror=implicit-function-declaration]
> 269    ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass,
> 270          ^~~~~~~~~~~~~~~~~~~~~
> 271          bpf_jit_binary_hdr

Now dropped, thanks.

greg k-h
