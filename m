Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED52F3B64A2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhF1PMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237621AbhF1PKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D05261206;
        Mon, 28 Jun 2021 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624892853;
        bh=FwccOg7lWtm3GpmgF7Fn+80t3t2Y0enfuppOeDV+qe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpjs1s36JlyC1Vcouw20e/hfY0kJ36jszlb0hgTOHD4LurBqc2FVIAeidxhdWMKXD
         tfc5Ou1MTImgsHkPLfQaSTNDGV3mx4elWQpk/yZHwyXH+I/ibYLntUGlug7YndAxyJ
         UeJpIZcIl/fMRFXVbgC6eWpPhWQrR7c8kJL6gZ9s=
Date:   Mon, 28 Jun 2021 17:07:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Emil Velikov <emil.l.velikov@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "# 3.13+" <stable@vger.kernel.org>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 5.12 004/110] drm: add a locked version of
 drm_is_current_master
Message-ID: <YNnls/uN1bme5eud@kroah.com>
References: <20210628141828.31757-1-sashal@kernel.org>
 <20210628141828.31757-5-sashal@kernel.org>
 <CACvgo50q9NLRjo3XMN63wQJywiZ_Z=yUoQLuVfy-Ht1URYdO-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvgo50q9NLRjo3XMN63wQJywiZ_Z=yUoQLuVfy-Ht1URYdO-A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 04:01:46PM +0100, Emil Velikov wrote:
> Hi Sasha, Greg,
> 
> On Mon, 28 Jun 2021 at 15:18, Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> >
> > commit 1815d9c86e3090477fbde066ff314a7e9721ee0f upstream.
> >
> 
> Please drop this patch from all stable trees. See following drm-misc
> revert for details:
> https://cgit.freedesktop.org/drm/drm-misc/commit/?h=drm-misc-fixes&id=f54b3ca7ea1e5e02f481cf4ca54568e57bd66086

The revert is later in the series already :)

thanks,

greg k-h
