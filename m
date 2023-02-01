Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA81F686DBA
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 19:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjBASQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 13:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBASQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 13:16:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6087EFDE;
        Wed,  1 Feb 2023 10:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B342C618F1;
        Wed,  1 Feb 2023 18:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC01AC433EF;
        Wed,  1 Feb 2023 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675275370;
        bh=GxMKMJ0YWgB5TH3psd7HVuknlPifEAgumSYi/Ju4nWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dcNpe9SX2F7/6MaSAFGCnpTaXNu6+y09tROiXqgd2e/rvCgfxc2MHe299/mhdh6yY
         w0TacSiMtiRb/57YfDP6F04u941mMP0x25zYM8Epd260TMFkwKpClIDYAaEHKnVVpd
         r0pZT5dQkJPPdOtEw+tCJ+1iuL/qWc4Z6fQCJxlI=
Date:   Wed, 1 Feb 2023 19:16:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "open list:USB XHCI DRIVER" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH stable 5.4] usb: host: xhci-plat: add wakeup entry at
 sysfs
Message-ID: <Y9qsZysFUFnq7VQW@kroah.com>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
 <20230201174404.32777-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201174404.32777-3-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 09:44:04AM -0800, Florian Fainelli wrote:
> From: Peter Chen <peter.chen@nxp.com>
> 
> commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream
> 
> With this change, there will be a wakeup entry at /sys/../power/wakeup,
> and the user could use this entry to choose whether enable xhci wakeup
> features (wake up system from suspend) or not.
> 
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/usb/host/xhci-plat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why is this new feature needed on these older kernels?  What does it fix
that is broken?

And why not just use a newer kernel release if you want to use this
feature?

thanks,

greg k-h
