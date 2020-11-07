Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A52AA63B
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKGP3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGP3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 10:29:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0B0206DB;
        Sat,  7 Nov 2020 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604762983;
        bh=xnpkhtnQRUWkzeNgw/A6vZf09sbHLka5oSKxGkLpUO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cn8+tl/9Jkdg2oejKpe77JI3CuVzZ8iTQO9wyJr/nTaSh+DTbutjCf/EldQYGP7Ut
         cLTjSllROvEdNWrpUureJjuS30XRUTs2kYgXEVSu9tdI+7ZW0YMKuTLeS8z1JZXyMb
         Yqa1LKatSeOATaExgL/RgviU8BE9KgmJVcnA+s0o=
Date:   Sat, 7 Nov 2020 16:30:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     stable@vger.kernel.org, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/2] drm/nouveau: Stable backport of DP clock fixes for
 v5.9
Message-ID: <20201107153027.GB90705@kroah.com>
References: <160459060724988@kroah.com>
 <20201106233016.2481179-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106233016.2481179-1-lyude@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 06, 2020 at 06:30:13PM -0500, Lyude Paul wrote:
> Just a backport of the two patches for v5.9 that you'll want to apply.
> The first one was Cc'd to stable, but I forgot to Cc the second one as
> well.
> 
> Lyude Paul (2):
>   drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()
>   drm/nouveau/kms/nv50-: Fix clock checking algorithm in
>     nv50_dp_mode_valid()
> 
>  drivers/gpu/drm/nouveau/nouveau_connector.c | 36 ++++++---------------
>  drivers/gpu/drm/nouveau/nouveau_dp.c        | 21 ++++++++----
>  2 files changed, 24 insertions(+), 33 deletions(-)

Thanks for these, now queued up.

Next time if you could include what the upstream git commmit ids they
are in Linus's tree, that would help, as I have to list them.

thanks,

greg k-h
