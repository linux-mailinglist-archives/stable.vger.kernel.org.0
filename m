Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681174A8933
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352466AbiBCRDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBCRDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:03:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130C8C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 09:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8EC9615DB
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927F2C340E8;
        Thu,  3 Feb 2022 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643907787;
        bh=RZR8V1fc0dRGFMYgFvLa2BlM6M9eJacnKyntwuO9cj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vYtFl4dxfTI3XF86rXnLAPgrLc5xIXHEBuQeNHZEjGzxZhDusymR2S0sCH6mnf77j
         m0DCpyPKpCuyRroqGy/eB1/leIdr7jVUPzIkYEscWFF37IHqm0GNSS+DrO9OUW6ert
         kGV6GWCq7Dlh0cLSyMKsx/xsq7O6kYXVGBPdc9Ro=
Date:   Thu, 3 Feb 2022 18:03:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Kevin Hilman <khilman@baylibre.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "drivers: bus: simple-pm-bus: Add support for
 probing simple bus only devices"
Message-ID: <YfwKyKFi7hIzUUEE@kroah.com>
References: <20220202195705.3598798-1-khilman@baylibre.com>
 <CAGETcx-ynfBcrUMVWq2abgasMp1dgh=e9oTQY+A4dmVgrrQ4Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-ynfBcrUMVWq2abgasMp1dgh=e9oTQY+A4dmVgrrQ4Yg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 12:06:35PM -0800, Saravana Kannan wrote:
> On Wed, Feb 2, 2022 at 11:57 AM Kevin Hilman <khilman@baylibre.com> wrote:
> >
> > This reverts commit d5f13bbb51046537b2c2b9868177fb8fe8a6a6e9.
> >
> > This change related to fw_devlink was backported to v5.10 but has
> > severaly other dependencies that were not backported.  As discussed
> > with the original author, the best approach for v5.10 is to revert.
> >
> > Link: https://lore.kernel.org/linux-omap/7hk0efmfzo.fsf@baylibre.com
> > Cc: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> 
> Thanks for getting around to this Kevin. Sorry, I got caught up on
> some urgent issues on my end.
> 
> Acked-by: Saravana Kannan <saravanak@google.com>

Now queued up,t hanks.

greg k-h
