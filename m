Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259A42D3BD2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 08:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgLIHBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 02:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgLIHBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 02:01:04 -0500
Date:   Wed, 9 Dec 2020 08:01:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607497224;
        bh=TqyzhuxMMqbKXc3bepx11P/TzDDSmev6GrXUVCluLxQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=gjcbisy06WGfvf/qczrQnN14hDiFS3Z066o/5tWUNGGXzpO+yd97noHYrenov7xz3
         gcgJCPQ4TfTeOnzi317CqFEr2ViZUajsVyfgPq5zWM7THvXPUfpWVG2J3YLZmL/HD8
         fhJqUy2Weg7//f47i1DBFFbeUzy2yerHlrmBErLY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Mathias Crombez <mathias.crombez@faurecia.com>
Subject: Re: [PATCH RESEND v2] virtio-input: add multi-touch support
Message-ID: <X9B2VRdXgwjxU15J@kroah.com>
References: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 11:01:50PM +0200, Vasyl Vavrychuk wrote:
> From: Mathias Crombez <mathias.crombez@faurecia.com>
> 
> Without multi-touch slots allocated, ABS_MT_SLOT events will be lost by
> input_handle_abs_event.
> 
> Signed-off-by: Mathias Crombez <mathias.crombez@faurecia.com>
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> Tested-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> ---
> v2: fix patch corrupted by corporate email server
> 
>  drivers/virtio/Kconfig        | 11 +++++++++++
>  drivers/virtio/virtio_input.c |  8 ++++++++
>  2 files changed, 19 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
