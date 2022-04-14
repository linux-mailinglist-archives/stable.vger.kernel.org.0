Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ECC5006C9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 09:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiDNHTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 03:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239131AbiDNHTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 03:19:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BB34BBD
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 00:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F228761EF3
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 07:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BA4C385A1;
        Thu, 14 Apr 2022 07:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649920641;
        bh=5DbMcHE4uPn10gYxZe5xflgX/ofK/bcxJ0dhcrp6jSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZT2Hv+Koh/riVAod8CZMQzuuoO7r5JfiSRTuQDNDP14DwhZWvmXg9ZIIRIF0JZtT
         2bBNJYbG/WnXz6QcWpu0yHjwH9CuJfSwTO6IziOuOrh0P9MGIw8q80Q2k8TLy8kpoj
         +dRSq3+w+Z4N0FtcGAXCnUlYbW2V5vgNG4DjNyJE=
Date:   Thu, 14 Apr 2022 09:17:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     cam enih <nanericwang@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: stable 5.10: please revert
 c4dc584a2d4c8d74b054f09d67e0a076767bdee5
Message-ID: <YlfKfrisuU/BoBrd@kroah.com>
References: <beaf8136-1c97-a65f-e64b-a98f23f024d2@infradead.org>
 <YlI7xE0JFYZSqJUL@sashalap>
 <CAPB3MF52aRsiq8wxFmQfK+KO=AVEhD+ww2O-0hj1KW5ntf3LXw@mail.gmail.com>
 <Yle3vc10uHh7AC2k@kroah.com>
 <CAPB3MF7HGfbVtdAYrzsTtgw59tcVRpVk4qi3Nz4=WbsA73nn5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPB3MF7HGfbVtdAYrzsTtgw59tcVRpVk4qi3Nz4=WbsA73nn5w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 03:00:30PM +0800, cam enih wrote:
> sorry for confusion.

Again, please do not top-post.

> 1. MR=merge request;

We do not have merge requests in the kernel, so I do not understand what
you are saying we do differently here.

> 2. In this case, the change depends on a non-existing config option which I
> believe can be detected at compile time.

Specifically, please show us how we should have caught this so we can do
that in the future.  I do not see how this can be detected at compile
time as it is no different from a normal config option not being
selected.

thanks,

greg k-h
