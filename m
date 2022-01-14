Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC248E3EA
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 06:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiANFr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 00:47:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43326 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiANFrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 00:47:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C676961CBA
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CF7C36AEA;
        Fri, 14 Jan 2022 05:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642139272;
        bh=eQXa6hAHJhyiYZJp5AEoSs2yfnLtUwwLOnpf5PkEyf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSabnljZJI7Nk0Z17Zx1vx7Yre+esB9FhNsBSVhu9/0bpZxxCXLtsUtbKxg9ZABLe
         At3jycpxjC+GMIhSZId+UCTm20ItALOrlexSthQB/FwuJlovgp9k5235qwzEZOs38b
         jjhcG2dncFJofqInUG7GKX474h6+FQVha1wCemoE=
Date:   Fri, 14 Jan 2022 06:47:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: Patches for clang and CONFIG_WERROR (arm64/x86_64)
Message-ID: <YeEOheVsAKHH0WQe@kroah.com>
References: <YeCpzLnfA+g+u3Id@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeCpzLnfA+g+u3Id@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 03:38:04PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please consider applying the following commits to allow arm64 and x86_64
> allmodconfig to compile with CONFIG_WERROR enabled with clang-11 through
> clang-14 (the currently supported releases upstream).
> 
> 502408a61f4b ("staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()") [5.15, 5.10, 5.4, 4.19, 4.14, 4.9]
> 2e70570656ad ("drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()") [5.16, 5.15, 5.10, 5.4, 4.19, 4.14, 4.9, 4.4]
> 144779edf598 ("staging: greybus: fix stack size warning with UBSAN") [5.16, 5.15, 5.10, 5.4]
> 
> I primarily care about 5.16 and 5.15, as those are the releases that
> have CONFIG_WERROR, but I included all the versions that those patches
> should apply cleanly to, as they do fix warnings in the build that
> people might see, although I don't think they are worth backporting
> further manually until someone complains. 502408a61f4b is already in
> 5.16.

All now queued up, thanks.

greg k-h
