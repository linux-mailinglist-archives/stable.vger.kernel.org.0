Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B432CE32
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhCDIOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236409AbhCDIOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 03:14:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457E964EE8;
        Thu,  4 Mar 2021 08:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614845643;
        bh=qvGKQQ/3gs/95luBMqaV03qAu1GRU8xELCFiFKOQ8FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gENbnEzFENFvBe0entO4I94ELoRrKDcJjAIBO+TFEET4yuN44RetcFa35FZjys9BN
         cNB7Z9dfYBP8WujtjvenNmN+8u/4AyPm9qbnxffTFeLagFQi+0gRIySEG/4ADPekvo
         cjajrlcunZT8h8k+bUBxjXg5/juCAHCMndVKBPGY=
Date:   Thu, 4 Mar 2021 09:14:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.19 209/247] staging/mt7621-dma:
 mtk-hsdma.c->hsdma-mt7621.c
Message-ID: <YECWyczIicq5Hl0X@kroah.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161041.907312533@linuxfoundation.org>
 <CALCv0x36mPwPwFpB8P6nc4kfu_PB=U81RoY9=q31Osx4sGtC3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCv0x36mPwPwFpB8P6nc4kfu_PB=U81RoY9=q31Osx4sGtC3g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 09:41:39AM -0800, Ilya Lipnitskiy wrote:
> Sorry, I should have been more clear in my original email, but we
> don't strictly need this in 4.19 as the check only became fatal in
> 5.10 (actually, before 5.10, but 5.10 is the first stable release with
> it). Feel free to take or omit this from 4.19.

I'll leave it in as having duplicate module names is not good no matter
what kernel tree it is in.

thanks for the review!

greg k-h
