Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9954A69AFB8
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBQPn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBQPnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:43:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450685ECAA
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA7E61DB4
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 15:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA44C433D2;
        Fri, 17 Feb 2023 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676648634;
        bh=1dJeqLwO2vHQedz4makdcywqzwqWeoCNz9POALOfB9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nbEwu4yJzfztGLXo8XpjsQkYbgdb7BjbshpBV+7jgBW+lrEB6fIPciHxaTU/ZM8hS
         /lrHToe2mZBT3ShRGf5xPswabdrfZAoIJKdVjsNpZBXy3ToZGQBjNgW+pxaFd/N+ZL
         oUMgMUL7/8IogPDhd2DNASImsjuVa39dsScHL2eU=
Date:   Fri, 17 Feb 2023 16:43:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Khoa Vo <khoav@nvidia.com>, Meriton Tuli <meriton@nvidia.com>,
        Vladimir Sokolovsky <vlad@nvidia.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of
 GPIO chip irq members before initialization
Message-ID: <Y++gtz7DQc4x5UG6@kroah.com>
References: <20230217140744.20600-1-asmaa@nvidia.com>
 <20230217140744.20600-2-asmaa@nvidia.com>
 <Y++OlqihvPis7NK4@kroah.com>
 <CH2PR12MB3895AFD55DBF315028F72CF0D7A19@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895AFD55DBF315028F72CF0D7A19@CH2PR12MB3895.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 03:33:28PM +0000, Asmaa Mnebhi wrote:
> Hi Greg, 
> 
> Apologies, This is not meant for the Linux kernel. You got spammed because when I cherry-picked this change for canonical only (kernel-team@lists.ubuntu.com), this got added to the patches:
> > Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl> (backported from 
> > commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320)
> > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> 
> Which caused it to be sent to everyone.  
> Will talk to canonical on how to avoid this in the future.

If Canonical just took the normal upstream stable releases (which this
commit is already included in), this wouldn't be an issue at all.  Why
do they not do that?

thanks,

greg k-h
