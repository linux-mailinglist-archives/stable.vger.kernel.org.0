Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA8D3875
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfJKE1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfJKE1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 00:27:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2562089F;
        Fri, 11 Oct 2019 04:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570768056;
        bh=IOpF7ZT1uyATibpb2Q8pKZ9Sewq/srJyUPlT/L2oK6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XbnaD5r0fcvMpvRZM0Zf3goTuw2ba1ZmwkfN+TATNw4qu+0GMDLIFoFlV4C3uOOLp
         xM1/DIBDKZhdjZmcoC248wbeLFA44kWunCBVgLzzo2fxL6dmfdi9WbdT7uDx5MdVNd
         3TbT9EL4XQL8jLhBE+wE/E/OoOtstLWsYLMH2W78=
Date:   Fri, 11 Oct 2019 06:27:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Cc:     alexander.deucher@amd.com, stable@vger.kernel.org,
        amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH v3] drm/radeon: Fix EEH during kexec
Message-ID: <20191011042734.GA939089@kroah.com>
References: <1570736672-10644-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570736672-10644-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 02:44:29PM -0500, KyleMahlkuch wrote:
> During kexec some adapters hit an EEH since they are not properly
> shut down in the radeon_pci_shutdown() function. Adding
> radeon_suspend_kms() fixes this issue.
> Enabled only on PPC because this patch causes issues on some other
> boards.
> 
> Signed-off-by: Kyle Mahlkuch <Kyle.Mahlkuch at ibm.com>

Real email address please, with a '@' sign.

And your "From:" line did not match up with this :(

> ---
>  drivers/gpu/drm/radeon/radeon_drv.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
