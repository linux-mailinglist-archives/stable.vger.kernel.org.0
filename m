Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5034A61C2
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiBAQ7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiBAQ73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:59:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5B3C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 08:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0CCFCE1A2D
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 16:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD757C340EB;
        Tue,  1 Feb 2022 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643734766;
        bh=D16NnPhXWSDYsnigbCjrFCXgBO6Mw0u685rcys2tkvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WA/9HLUQ26tjSoZzVWteDBZui0SToE/Xdda2hPyGUHxvKO2sH140nPoXgRXCI/YwV
         Y/h5vWFVzXA/XlLAd5g+HRN7DSHLA8rM9gQzJDouSpCX9u2BDfFlNVunRKONysd9D6
         ZdM2eXsa/um8k/W8NK02tBS1wRGYZEFx+zKI+9NQ=
Date:   Tue, 1 Feb 2022 17:59:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.4] Bluetooth: MGMT: Fix misplaced BT_HS check
Message-ID: <Yflm69VL2yFHvrJf@kroah.com>
References: <YfUqikHXokp75E00@kroah.com>
 <1643725490-5917-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643725490-5917-1-git-send-email-guillaume.bertholon@ens.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 03:24:50PM +0100, Guillaume Bertholon wrote:
> The upstream commit b560a208cda0 ("Bluetooth: MGMT: Fix not checking if
> BT_HS is enabled") inserted a new check in the `set_hs` function.
> However, its backported version in stable (commit 5abe9f99f512
> ("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")),
> added the check in `set_link_security` instead.
> 
> This patch restores the intent of the upstream commit by moving back the
> BT_HS check to `set_hs`.
> 
> Fixes: 5abe9f99f512 ("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")
> Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
> ---
>  net/bluetooth/mgmt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Now queued up, thanks!

greg k-h
