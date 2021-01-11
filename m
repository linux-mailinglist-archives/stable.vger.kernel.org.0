Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3212F18CA
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbhAKOyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbhAKOyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 09:54:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD40C225AB;
        Mon, 11 Jan 2021 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610376802;
        bh=qluharLiwyl2e8eu98B+5o/EBRmfdenTmZ6KLl8eGxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m8pl6tBIpGZMPkvrtl/FpgnWW614lt19eeo+sH0l70FY1nG6CN/wVrYZ2vdgo9CRX
         Vj7grS2483TNXO3fSxjv2bXDCJe8UURXGSnAni2F8vKEyjjo1erNwX+HQvpAqe5iED
         /70sICR2BF05mua9Whn5gDt7GfX/N1l7acFfGyVM=
Date:   Mon, 11 Jan 2021 15:54:33 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "andre@tomt.net" <andre@tomt.net>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
 in S3 resume"" failed to apply to 5.10-stable tree
Message-ID: <X/xmqd8ehJVpxFnx@kroah.com>
References: <1610355550144178@kroah.com>
 <MN2PR12MB4488ECF24D89C1874B3E9087F7AB0@MN2PR12MB4488.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4488ECF24D89C1874B3E9087F7AB0@MN2PR12MB4488.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:40:27PM +0000, Deucher, Alexander wrote:
> [AMD Public Use]
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Monday, January 11, 2021 3:59 AM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>; andre@tomt.net;
> > Wentland, Harry <Harry.Wentland@amd.com>; Kazlauskas, Nicholas
> > <Nicholas.Kazlauskas@amd.com>; oleksandr@natalenko.name; Wang,
> > Chao-kai (Stylon) <Stylon.Wang@amd.com>
> > Cc: stable@vger.kernel.org
> > Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
> > in S3 resume"" failed to apply to 5.10-stable tree
> > 
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm tree,
> > then please email the backport, including the original git commit id to
> > <stable@vger.kernel.org>.
> > 
> 
> This patch is already in 5.10.  The revert ended up going to stable and upstream at the same time.  Sorry for the confusion.

Ah, I thought I had seen this go by, too many patches...

thanks for letting me know.

greg k-h
