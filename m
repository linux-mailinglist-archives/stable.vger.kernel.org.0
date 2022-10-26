Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB71F60DBA1
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiJZG6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJZG6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:58:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2710972EE5;
        Tue, 25 Oct 2022 23:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB4661AB3;
        Wed, 26 Oct 2022 06:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CD7C433D6;
        Wed, 26 Oct 2022 06:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666767511;
        bh=UCpThysZO4vGCokU5Eu4C2W0+9CY4DujSYSPpQw0s98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZnyXXwIRwC51t6Y7i0EPmt+vkupR/q/AZ0uJ8GH/EgqMHg9tZs+GB+fBK2AJTHz5
         Z/2xb3lZ9VrrBNMIc1w5wELCO9dKQ75YmrL5iVTwmVrK5R8ryUfmmDtP9UqnwP3oi+
         sjJIpQpxoKZDoSFu1+e774jl0m3g0WBzoU0uiTxA=
Date:   Wed, 26 Oct 2022 08:59:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ernst Herzberg <earny@net4u.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Message-ID: <Y1jazFPSmpD9Eic/@kroah.com>
References: <20221024112934.415391158@linuxfoundation.org>
 <f6aa6991-4c52-787c-a9c6-75f91e40548e@net4u.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6aa6991-4c52-787c-a9c6-75f91e40548e@net4u.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 08:36:55AM +0200, Ernst Herzberg wrote:
> Missed a patch?
> 
> Problematic patch in v6.0.3 :
> 
> > commit 3ea7c50339859394dd667184b5b16eee1ebb53bc
> > Author: Josef Bacik <josef@toxicpanda.com>
> > Date:   Mon Aug 8 16:10:26 2022 -0400
> > 
> >     btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
> >     [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]
> >     Now that lockdep is staying enabled through our entire CI runs I started
> >     seeing the following stack in generic/475
> 
> 
> See:
> 
> https://lore.kernel.org/stable/Y1aeWdHd4%2FluzhAu@localhost.localdomain/

That will be resolved in the next release, give us a chance to get this
one out first...

thanks,

greg k-h
