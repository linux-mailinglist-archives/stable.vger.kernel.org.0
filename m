Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6EC509ABA
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 10:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379008AbiDUIgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 04:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386696AbiDUIf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 04:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8711C128
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 01:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A65361B74
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 08:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20A4C385AE;
        Thu, 21 Apr 2022 08:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650529988;
        bh=KaF2f14o65JEISysJGlM785t7K+Zi4mQnsgXa+N+hd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZgGPLaEFUKr27QqcMk481Y4KmFjIYys4cR3S7My9/gdRy0W7AhFmi53A1f/eD3RJ
         S24YkRRXEt7O9majhVIgSDWgDoRWSAKhN5mcU8eagcsjN32FvXDUcfg1S12AUIrsGj
         WpAyZbBdNGGBK4/aZLTJ0cFdnWiqR6HFrzbvUKdo=
Date:   Thu, 21 Apr 2022 10:33:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport 2618a0dae and ca831f29f8f2 to stable tree
Message-ID: <YmEWwSojtx9O4xqw@kroah.com>
References: <afb441a5-97ca-1488-e1ab-c399fd4e254d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afb441a5-97ca-1488-e1ab-c399fd4e254d@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 10:01:58PM -0700, Khem Raj wrote:
> Hello Stable kernel maintainers,
> 
> I would like to request backport of below patches to linux-5.15-y branch in
> stable tree:
> 
> 2618a0dae09e etherdevice: Adjust ether_addr* prototypes to silence
> -Wstringop-overead
> 
> ca831f29f8f2 mm: page_alloc: fix building error on -Werror=array-compare
> 
> These two patches are required to fix build with GCC 12 for arm
> architectures. I have validated it on top of 5.15.34

They are also needed on all other branches, so I have queued them up
there as well.

thanks,

greg k-h
