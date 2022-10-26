Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA460E602
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiJZRBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 13:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiJZRBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 13:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6650C7D1E4
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 10:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB53761DA3
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 17:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0E2C433D6;
        Wed, 26 Oct 2022 17:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666803665;
        bh=SBSmtghuTZOPnCnRsA7mvD0wy2RMZPB6lZUogrhCws4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cb6AtTfB0cNFgyQNF4AsmaS6b9CRjSgR31s9hU2oSnUKt0Iuf2sq+vYid83OsypYq
         /zmXwKvpdE6pec1b2/5bwhB74/QOxCt6FxG3hvs8Bo4E+dDnD7mh3vcc+igGMpR5lK
         ipLVOUX5rT4qkblUEyFMNzvrsDv1UzjXJTxVm9V4=
Date:   Wed, 26 Oct 2022 19:01:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <Y1lnzkSUjuH7acSf@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <YzflXQMdGLsjPb70@kroah.com>
 <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
 <Yz21dn2vJPOVOffr@kroah.com>
 <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com>
 <Y0U+UkLYiRzvgoF8@kroah.com>
 <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 07:36:22AM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 11 Oct 2022, Greg KH wrote:
> 
> > On Tue, Oct 11, 2022 at 05:48:26AM -0400, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 10 Oct 2022, Greg KH wrote:
> > > 
> > > > Nope, these cause loads of breakages.  See
> > > > https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> > > > for one such example, and I know kbuild sent you other build problems.
> > > > I'll drop all of these from the stable trees now.  Please feel free to
> > > > resend them when you have the build issues worked out.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > I don't have cross compilers for all the architectures that Linux 
> > > supports. Is there some way how to have the patch compile-tested before I 
> > > send it to you?
> > 
> > You can download those compilers from kernel.org, they are all available
> > there.
> 
> OK. I downloaded cross compilers from 
> https://mirrors.edge.kernel.org/pub/tools/crosstool/ and compile-tested 
> the patches with all possible architectures.
> 
> Here I'm sending new versions.

But don't you need 2 patches, not just 1, to be applied?

Please resend a set of series, one series per stable kernel branch, to
make it more obvious what to do.  Your thread here is very confusing.

See the stable mailing list archives for lots of examples of how to do
this properly, here are 2 good examples:
	https://lore.kernel.org/r/20221019125303.2845522-1-conor.dooley@microchip.com
	https://lore.kernel.org/r/20221019125209.2844943-1-conor.dooley@microchip.com

thanks,

greg k-h
