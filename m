Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E855A998E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiIAN6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbiIAN5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:57:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7258DFCD;
        Thu,  1 Sep 2022 06:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C39F2CE26FD;
        Thu,  1 Sep 2022 13:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6400EC433C1;
        Thu,  1 Sep 2022 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662040661;
        bh=QBC8hgn3Uh4LWbzhomfiidckwgVSHFTaGAyD7HabjF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cAhL7zUQxYyr2e9d/HDUsGkqYiLSN1RyQcBUWcJKO8PmX74sM9rxsEjnhVcNPzbdf
         uaRQnAGD+HJKaiP1Rk90O9+O/+dSdX9GOocn4qUfKnwglyi+WBQuIFSVEmNEBStKp+
         sFCE0C1YPUFfqvYTnCvxbMDOv5lAjRovAHCr8egc=
Date:   Thu, 1 Sep 2022 15:57:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel-team@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] driver core: Don't probe devices after
 bus_type.match() probe deferral
Message-ID: <YxC6U7kKRLmMSH9W@kroah.com>
References: <20220817184026.3468620-1-isaacmanjarres@google.com>
 <Yw/CyRFr1bYNlNGh@shell.armlinux.org.uk>
 <YxBDG9ebNDwEni2j@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxBDG9ebNDwEni2j@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 07:28:59AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 31, 2022 at 09:21:29PM +0100, Russell King (Oracle) wrote:
> > Greg,
> > 
> > Are you happy for me to pick up this patch as part of the fixes for the
> > AMBA changes? The original patch that it is fixing is a patch that was
> > part of a series that was merged through my tree.
> > 
> > It's fixing a problem that has been noticed by several people and the
> > fix is now a few weeks old.
> 
> Sorry, I'm behind in driver core stuff.  I'll pick it up later today.

Now queued up, thanks.

greg k-h
