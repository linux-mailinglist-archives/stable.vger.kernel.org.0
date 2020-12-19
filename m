Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2D12DEEDC
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLSMrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgLSMrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:47:43 -0500
Date:   Sat, 19 Dec 2020 13:48:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608382023;
        bh=sXHh8YMEc6km5Vh66x3zSvVovkOJgqGBFJfigK5rLjc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ObghyOSWC+ZtQZ8FvbO8UMcjy0aK3FEIIE8MdKecK8Z93WP2dRiG2ke8DRCMXehv
         byGJ3YrPQ1LsQktMOF5dNui5mNxDArb9zuvlPzoeGQvk8ZhcELUAOLTdh/Hl+LRY7j
         kG93mIriJa58oFf4hVggpkxAgXsbHD9XQMuk7Azk=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     xiaochen.shen@intel.com, bp@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: FAILED: patch "[PATCH] x86/resctrl: Fix incorrect local
 bandwidth when mba_sc is" failed to apply to 5.9-stable tree
Message-ID: <X932lwaBBGsn2dAa@kroah.com>
References: <160795595120091@kroah.com>
 <20201214191946.4ui7hza2eqtirzad@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214191946.4ui7hza2eqtirzad@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 07:19:46PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 14, 2020 at 03:25:51PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport with abe8f12b4425 ("x86/resctrl: Remove unused struct mbm_state::chunks_bw")
> which makes the backport easy.

Thanks for these, now queued up.

greg k-h
