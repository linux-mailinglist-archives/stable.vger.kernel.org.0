Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95C13F9A9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgAPTkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:40:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgAPTkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 14:40:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93E832053B;
        Thu, 16 Jan 2020 19:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579203598;
        bh=2QH66cHzT0C/CinQat/XtLfzDC7EF7lmOncaU0WpGTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CE11DwOsQIsNIGxHpP5wPgc1kNROytLkUB4A9giD+l31bMD3U1dyCWOID6YTfN5Nz
         fYyrLqrWXuRoKAm04pEa7eiIQAQVGvu+fXOqVxbGcsODjpITamL+XzlzgfPrAp63BL
         PcxMoOg3t7NOBOaYMcTtRQzHhkH1u2L43KF27z/8=
Date:   Thu, 16 Jan 2020 20:39:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alistair Delva <adelva@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Lingfeng Yang <lfy@google.com>, kraxel@redhat.com
Subject: Re: Please revert "drm/virtio: switch virtio_gpu_wait_ioctl() to gem
 helper." from 5.4-stable
Message-ID: <20200116193955.GA1024193@kroah.com>
References: <CANDihLFwsdpGmR5j++bLSaxGYuXOtykA-B2T0rWiXgzdfCPkJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANDihLFwsdpGmR5j++bLSaxGYuXOtykA-B2T0rWiXgzdfCPkJg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 08:20:11AM -0800, Alistair Delva wrote:
> (Sorry if this is noise and has already been reported)
> 
> After updating to 5.4.7 we noticed that virtio_gpu's wait ioctl
> stopped working correctly.
> 
> It looks like 29cf12394c05 ("drm/virtio: switch
> virtio_gpu_wait_ioctl() to gem helper.") was picked up automatically,
> but it depends on 889165ad6190 ("drm/virtio: pass gem reservation
> object to ttm init") from earlier in Gerd's series in Linus's tree,
> which was not picked up.
> 
> (This patch doesn't seem like compelling stable material so maybe we
> should revert it.)

Now reverted, thanks for the report.

greg k-h
