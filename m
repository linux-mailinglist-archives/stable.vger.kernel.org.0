Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31191EF979
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgFENno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 09:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFENno (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 09:43:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64DD2206E6;
        Fri,  5 Jun 2020 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591364623;
        bh=KBCcuTezSWxYTEPq9nG3ArfE3UjgerB234MqoT7vp+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2RAK/G3omLJ6JiTp5x1lly/Uk287EnuhWtlIn8LG62bsKCe9r031neVMYaaXqaLF
         4u+3q/rOQ7refZyi+XHuwtFvcxXblifMd0iuMHwyJud8GAH0wuE6RZ6+lKtgM2+W/U
         3PTUkVeQ6/SYZC8Z1Rh2feP8PZZyfUrA3MdcXTi0=
Date:   Fri, 5 Jun 2020 15:43:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de, nirranjan@chelsio.com, bharat@chelsio.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200605134340.GA3109673@kroah.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603091851.16957-1-dakshaja@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 02:48:51PM +0530, Dakshaja Uppalapati wrote:
> This reverts upstream 'commit 530436c45ef2
> ("nvme: Discard workaround for non-conformant devices")'
> 
> Since commit `530436c45ef2` introduced a regression due to which
> blk_update_request IO error is observed on formatting device, reverting it.
> 
> Fixes: 530436c45ef2 ("nvme: Discard workaround for non-conformant devices")
> Cc: stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
> ---
>  drivers/nvme/host/core.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)

This was only for stable?

Totally confused...

greg k-h
