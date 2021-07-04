Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2773BAE79
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGDTFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 15:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhGDTFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 15:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CEE6613E2;
        Sun,  4 Jul 2021 19:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625425347;
        bh=C1S3o3r6K16gvr7br8hFJWysya72Q68pIr48FMzjAWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PRh+Mq0I2VF/0nNEoKBVMJ/BUU7x1RvdNnhdSz5PfWstKP85q7Rp/wu2TJ6q2Cy/o
         8LCQTJo6YichiCmsS+An8TCxoK7mXWz7VJusw/gL/sIdqUmA8Iep5LBI+m6tt8tCox
         TrNbT7cSwygQ9fEllp2vcMeXxGERkPwblrp+ECxI=
Date:   Sun, 4 Jul 2021 21:02:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Wood <john.wood@gmx.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        stable@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth/virtio_bt: Fix dereference null return value
Message-ID: <YOIFwdlqdEldzg6B@kroah.com>
References: <20210704145504.24756-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210704145504.24756-1-john.wood@gmx.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 04, 2021 at 04:55:04PM +0200, John Wood wrote:
> The alloc_skb function returns NULL on error. So, test this case and
> avoid a NULL dereference (skb->data).
> 
> Addresses-Coverity-ID: 1484718 ("Dereference null return value")
> Fixes: afd2daa26c7ab ("Bluetooth: Add support for virtio transport driver")
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  drivers/bluetooth/virtio_bt.c | 2 ++
>  1 file changed, 2 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
