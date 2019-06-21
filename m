Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139FB4E8E1
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 15:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfFUNWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 09:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfFUNWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 09:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F20A208C3;
        Fri, 21 Jun 2019 13:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561123363;
        bh=KeuBGoyqtWLkZ0dpNAnEYBwnJjXyrdfhDld4K6wo/qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nTGi4uI1y5XbxwFSshMgvoGUJ5ogb4t8jRt8fp50ZIZ9c5c6r0fAKUKYgSf9eQ7cI
         0CSyd2jJoHGuOAhPj7aQ3uHD0jSXJh3Ps6io05ywTZ+0bxFcJFZ+6ID5bgnudxhknW
         KjwGD5bDRAbERhQmN/dipIx+1uVCyjsAEBVKtWp8=
Date:   Fri, 21 Jun 2019 15:22:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     minghsiu.tsai@mediatek.com, houlong.wei@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [media] media: mtk-mdp: fix reference count on old
 device tree
Message-ID: <20190621132241.GC10459@kroah.com>
References: <20190621113250.4946-1-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621113250.4946-1-matthias.bgg@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 01:32:50PM +0200, Matthias Brugger wrote:
> of_get_next_child() increments the reference count of the returning
> device_node. Decrement it in the check if we are using the old or the
> new DTB.
> 
> Fixes: ba1f1f70c2c0 ("[media] media: mtk-mdp: Fix mdp device tree")
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
