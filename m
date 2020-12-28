Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EFF2E3EF6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505194AbgL1Oeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505060AbgL1Oeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:34:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1443D22D2A;
        Mon, 28 Dec 2020 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166045;
        bh=gxmlU0bpFqUYdqa+jry3cInMTffRLFfqvL3bTN/Rnv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z7JoU5FES6UUnBewtmTOwCKfVK2X1x/qI5CKokj2LPGijuT0CqkdhuRVtq+Rg1BYJ
         /AOMPi+ytAmW0zeB9LaC/9M+y90x8ThVAfh7NSP7H99kptWew3UuPDc+mH6kViiBsQ
         /lcnf1SX01d0UXmRg9Og00MHorShw3+fm+xC9wmE=
Date:   Mon, 28 Dec 2020 15:21:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilia Mirkin <imirkin@alum.mit.edu>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 3.9+" <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 064/717] drm/edid: Fix uninitialized variable in
 drm_cvt_modes()
Message-ID: <X+npzHDPRBReupyL@kroah.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125024.061845231@linuxfoundation.org>
 <CAKb7UvhvjW+q+FXKoNaWUYm1QqzZ_o6FNjJQbwBJ+Lo9ybBcKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvhvjW+q+FXKoNaWUYm1QqzZ_o6FNjJQbwBJ+Lo9ybBcKQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 09:09:59AM -0500, Ilia Mirkin wrote:
> Hi Greg,
> 
> Linus had to apply a fixup for this patch. Please ensure that it's in
> your patch list:
> 
> commit d652d5f1eeeb06046009f4fcb9b4542249526916
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Dec 17 09:27:57 2020 -0800
> 
>     drm/edid: fix objtool warning in drm_cvt_modes()
> 
> It does not appear to have a Fixes tag, so may not have been picked up
> by your automated tooling.

It was not, thanks, now queued up!

greg k-h
