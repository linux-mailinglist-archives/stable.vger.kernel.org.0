Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B771D44735D
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 15:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhKGOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 09:52:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235509AbhKGOwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 09:52:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE0CD6135E;
        Sun,  7 Nov 2021 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636296575;
        bh=QdPW8ZA6Ni0m2Qg2OzVwvJNJG+IRtx0xbVgs9x1AVDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8kPy+VQN6+bcZlGDeHVd+CwhUNF0zCi0jmu3m4dsKoG8ezIKwANGP0r/EynpQWqG
         SDAF79RzClEhxTI9QktYuwITKKYF/dLhL5oT2WeC787nMHAwtVSOzlwLo/8HGfgz5y
         ByKSQMqZZGodSXzSIYSKoiYEVS0F3/9xa2CzIBRU=
Date:   Sun, 7 Nov 2021 15:49:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 5.14.y-stable: Missing sound fixes from 5.15
Message-ID: <YYfnd9YojggYJTUf@kroah.com>
References: <s5hfssbgfa1.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfssbgfa1.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 09:47:34AM +0100, Takashi Iwai wrote:
> Hi Greg,
> 
> could you cherry-pick the following three commits to 5.14.y tree?
> The Cc-to-stable was missing on those, although they should have been
> picked up.
> 
> cbea6e5a7772b7a5b80baa8f98fd77853487fd2a
>     ALSA: pcm: Check mmap capability of runtime dma buffer at first
> 0899a7a23047f106c06888769d6cd6ff43d7395f
>     ALSA: pci: rme: Set up buffer type properly
> 4d9e9153f1c64d91a125c6967bc0bfb0bb653ea0
>     ALSA: pci: cs46xx: Fix set up buffer type properly
> 
> They are needed only for 5.14.y, not for older versions.
> 
> The relevant bug report is found at:
>   https://bugzilla.kernel.org/show_bug.cgi?id=214947

All now queued up, thanks.

greg k-h
