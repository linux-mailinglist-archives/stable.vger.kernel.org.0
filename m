Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0C927AE15
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 14:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgI1Mn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 08:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1Mn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 08:43:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF8A21D7F;
        Mon, 28 Sep 2020 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601297008;
        bh=6KyhBwb/aSJfmfnz+mXUp9mTdvf0xGoGcCgm0UN1s80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ue/dS9VDkZQLZYpP2dFaB7LTMyG1uvV6xcZQjrhqlDjACADK/B3fXgL76UW+7wrz3
         Xg71Uhl1Q6TDc60vL78qFRmKp62QvgUs57fslWu+StBtu2B4ngCSVpy+hyQ0nxvPDd
         3r2ddp/ayxKRUFuBARxnXst8Rt79rqQLaDur5tjc=
Date:   Mon, 28 Sep 2020 14:43:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Iago Toral <itoral@igalia.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, eric@anholt.net
Subject: Re: Patch "drm/v3d: don't leak bin job if v3d_job_init fails." has
 been added to the 5.4-stable tree
Message-ID: <20200928124335.GA1395923@kroah.com>
References: <20200927175225.BA1DE23976@mail.kernel.org>
 <919c3c23bd220b283dbff8f60c56a63175f6c788.camel@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <919c3c23bd220b283dbff8f60c56a63175f6c788.camel@igalia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 07:51:17AM +0200, Iago Toral wrote:
> As Eric pointed out, this patch should not be applied. There were 2
> patches addressing the very same leak and it seems one of them already
> landed and this one is being applied on top of it, so in practice, this
> patch is producing a double free.

Now dropped, thanks.

greg k-h
