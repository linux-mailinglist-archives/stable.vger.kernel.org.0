Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3920DDAF
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgF2USO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732627AbgF2TZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05DE2558A;
        Mon, 29 Jun 2020 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593447352;
        bh=klIL3IOn+Sds26IUTL2F8EnYRJUx3am2hJ0RrpMsz0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f9oWsTBo0LTbV90r28cXpkf0rG6Cx+kBwQhW0WyK5V7LJACKMYaXrNxLEsrfrbqfN
         rttFp9EJzONsmvLLNJPGF4asPeiYLbxGyVKv3fe0PPtvUJH+5AuMaTzimvfWrLwNTa
         tlcJPsSbq9Ck5M+B1LWGLoCgQEUCKcFTg/VPSd+c=
Date:   Mon, 29 Jun 2020 18:15:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Upstream fixes not merged in 5.4.y
Message-ID: <20200629161542.GA683634@kroah.com>
References: <20200629142805.28013-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629142805.28013-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 04:28:05PM +0200, SeongJae Park wrote:
> Hello,
> 
> 
> With my little script, I found below commits in the mainline tree are more than
> 1 week old and fixing commits that back-ported in v5.4..v5.4.49, but not merged
> in the stable/linux-5.4.y tree.  Are those need to be merged in but missed or
> dealyed?
> 
> 9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")
> 9fecd13202f5 ("btrfs: fix a block group ref counter leak after failure to remove block group")
> 9d964e1b82d8 ("fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"")
> 8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
> 6e2f83884c09 ("bnxt_en: Fix AER reset logic on 57500 chips.")
> efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
> ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
> ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
> 8dbe4c5d5e40 ("net: dsa: bcm_sf2: Fix node reference count")
> ca8826095e4d ("selftests/net: report etf errors correctly")
> 5a8d7f126c97 ("of: of_mdio: Correct loop scanning logic")
> d35d3660e065 ("binder: fix null deref of proc->context")
> 
> The script found several more commits but I exclude those here, because those
> seems not applicable on 5.4.y or fixing trivial problems only.  If I'm not
> following a proper process for this kind of reports, please let me know.

For commits that only have a "Fixes:" tag, and not a "cc: stable..."
tag, wait a few weeks, or a month, for us to catch up with them.  We
usually get to them eventually, but it takes us a while as we have lots
more to deal with by developers and maintainers that are properly
tagging patches for this type of thing.

Some of the above commits are queued up already, but not all of them.
I'll take a look at the list after this next round of patches go out,
and will let you know.

And yes, we do want this type of list, it's greatly appreciated.

thanks,

greg k-h
