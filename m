Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B0D5A8D52
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiIAF2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiIAF2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:28:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D895DF666;
        Wed, 31 Aug 2022 22:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4CAEB81619;
        Thu,  1 Sep 2022 05:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBB0C433C1;
        Thu,  1 Sep 2022 05:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662010123;
        bh=0e3zj4uy1iVmgegJwpAbXPvOJ9xzYtDAws9Y1UFGV+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ws9qL7Cdx72e0H/U5M7wVdw+RWUJM1gZZrdWFzBeOsX42IiOqzcN41d5y/9Wr6zQn
         I3CqPtrJtbSEyhU4QUTGMFBjF3mTtCvH28rGJbEoEBRd+kwi6qG9WN0gWFFHdMxW1t
         Bkb8ytx6T88AEB7v20TVcyue8h464F5WF+T+jqz0=
Date:   Thu, 1 Sep 2022 07:28:59 +0200
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
Message-ID: <YxBDG9ebNDwEni2j@kroah.com>
References: <20220817184026.3468620-1-isaacmanjarres@google.com>
 <Yw/CyRFr1bYNlNGh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw/CyRFr1bYNlNGh@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 09:21:29PM +0100, Russell King (Oracle) wrote:
> Greg,
> 
> Are you happy for me to pick up this patch as part of the fixes for the
> AMBA changes? The original patch that it is fixing is a patch that was
> part of a series that was merged through my tree.
> 
> It's fixing a problem that has been noticed by several people and the
> fix is now a few weeks old.

Sorry, I'm behind in driver core stuff.  I'll pick it up later today.

greg k-h
