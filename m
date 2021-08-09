Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AB33E46F4
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 15:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhHINzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 09:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhHINzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 09:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5998460F35;
        Mon,  9 Aug 2021 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628517289;
        bh=OUpQ5hc5EQep9+vlHp2Goh4Cfjhy17NkI3ZAmLKGJHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pue56fK3slnWWRZTpSo+MmyhX1EeTsx3I1S3wKXcHvDziX2MlijBI8qQL4uH45fYD
         XR/CcG8zgXY7EoO8/sJH2SLHk/S0yYukGnbQmSo49Nbw0tBKw8/q7GfX2t7BSXjqa/
         s5seRcPj610RqZJCDtOzfezEPJKLPfDeeq8ChqFE=
Date:   Mon, 9 Aug 2021 15:54:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Reinhard Speyerer <rspmn@arcor.de>
Cc:     stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14] qmi_wwan: add network device usage statistics for
 qmimux devices
Message-ID: <YREzpwQogCQA2Ot3@kroah.com>
References: <20210809131813.GA1009@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809131813.GA1009@arcor.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 03:18:14PM +0200, Reinhard Speyerer wrote:
> Commit 44f82312fe91 ("qmi_wwan: add network device usage statistics
> for qmimux devices") of the "qmi_wwan: fix QMAP handling" series
> https://lore.kernel.org/netdev/cover.1560287477.git.rspmn@arcor.de
> was not part of the AUTOSEL 4.14 patches.
> 
> This will introduce a regression for users of this longterm kernel when
> multiplexing gets enabled in the forthcoming ModemManager 1.18:
> https://lists.freedesktop.org/archives/modemmanager-devel/2021-August/008782.html
> 
> Avoid this by adding the missing patch from the series.
> 
> Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
> ---
>  drivers/net/usb/qmi_wwan.c | 76 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 71 insertions(+), 5 deletions(-)

Both now queued up, thanks!

greg k-h
