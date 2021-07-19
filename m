Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFED3CD52A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhGSMON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237056AbhGSMOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 08:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 966DC6100C;
        Mon, 19 Jul 2021 12:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626699291;
        bh=jtDGk6sLE9RLAnytS0wC8ZVYn475CYAu+wIqj0TfmLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCdUnxpFRJmXUsC2+zyt/DkE3iW58NJCZeM2aKR6a6mQrd4TnO65elvBwVow2zjbd
         V2IznUuqjeh9NfwKL+lHUey1QR8IV0RUtDIE3n2dEx+/YjQSgylQ7AA3Hyrs9Yv+K7
         yESialA7CHMGlGzDctqGrZEty1brxHZfkHElgjts=
Date:   Mon, 19 Jul 2021 14:54:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wayne Lin <Wayne.Lin@amd.com>
Cc:     stable@vger.kernel.org, lyude@redhat.com
Subject: Re: [PATCH 0/3] Backport patches for 5.13-stable tree
Message-ID: <YPV2GImArgoHlgYQ@kroah.com>
References: <20210716074201.28291-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210716074201.28291-1-Wayne.Lin@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 03:41:58PM +0800, Wayne Lin wrote:
> Patches below in Linus's tree failed to apply to 5.13-stable tree.
> Adjust them so we can apply them to 5.13-stable tree.
> 
> original git commit id:
> * 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
>   [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
> 
> * 35d3e8cb35e75450f87f87e3d314e2d418b6954b
>   [PATCH] drm/dp_mst: Do not set proposed vcpi directly
> 
> * 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
>   [PATCH] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
> 
> José Roberto de Souza (1):
>   drm/dp_mst: Add missing drm parameters to recently added call to
>     drm_dbg_kms()
> 
> Wayne Lin (2):
>   drm/dp_mst: Do not set proposed vcpi directly
>   drm/dp_mst: Avoid to mess up payload table by ports in stale topology
> 
>  drivers/gpu/drm/drm_dp_mst_topology.c | 68 +++++++++++++++++----------
>  1 file changed, 42 insertions(+), 26 deletions(-)
> 
> -- 
> 2.17.1
> 

All now queued up, thanks.

greg k-h
