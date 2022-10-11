Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5615FAFC9
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 11:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJKJ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 05:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJKJ6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 05:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702CB5467E
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 02:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD9D61163
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 09:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32E9C433D6;
        Tue, 11 Oct 2022 09:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665482279;
        bh=OhrnKCVrUVdB5u28gHCudkkT0Q5ks+r6YrcUPJv6JZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yNtDpam4UUF1iUoGwYaKh5a9MNGByqxMdAKaZbh03rYURpLXWlhBVYbKPwvG/Ghj0
         S0SWXDtHr2U84FgPVdRkcO1/94YapfaD42p/XMlX2hjgohf3GrbT2dmVcKwI+FEuGt
         EQ9MgYs6hIjddtKUWetZqX1BJpmA0epilg0VaZJU=
Date:   Tue, 11 Oct 2022 11:58:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <Y0U+UkLYiRzvgoF8@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <YzflXQMdGLsjPb70@kroah.com>
 <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
 <Yz21dn2vJPOVOffr@kroah.com>
 <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 05:48:26AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 10 Oct 2022, Greg KH wrote:
> 
> > Nope, these cause loads of breakages.  See
> > https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> > for one such example, and I know kbuild sent you other build problems.
> > I'll drop all of these from the stable trees now.  Please feel free to
> > resend them when you have the build issues worked out.
> > 
> > thanks,
> > 
> > greg k-h
> 
> I don't have cross compilers for all the architectures that Linux 
> supports. Is there some way how to have the patch compile-tested before I 
> send it to you?

You can download those compilers from kernel.org, they are all available
there.

> Or - would you accept this patch instead of the upstream patch? It fixes 
> the same bug as the upstream patch, but it's noticeably smaller and it 
> could be applied to the stable kernels 4.19 to 5.19.

We should stick with what is in Linus's tree so as to not cause new
bugs, and to make future backports easier.

thanks,

greg k-h
