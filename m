Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1494C5E6007
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiIVKjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiIVKjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:39:42 -0400
Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459B0DF80
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 03:39:36 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 0721E10005D; Thu, 22 Sep 2022 11:39:27 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
        t=1663843168; bh=m+4wL7uEqJjMFXhenPU4NaUfw4oTcWjXeS7H+3eHpDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q953CckSEkYNz0GMFZ/kzWuNsYo8YVPnJLXRBsf5lvJMqp77P5mD2DLK4EM15UH+Q
         wBl5QHu9lYgWmljwo/4i8OELILipjhxdMiZcI5wbgJ9Rz1kgaE99qE5ExzJb9c+H1S
         oIC+fUCFUq4fZeao/WaHbVESED5es7WOpH/u8Vjj3blnsVvwhgsSRjP9GUrj97ozSt
         +Y+FleJFQf3e7zmXZfYfUxnoF/5NFoumvhx3LVz9KbOjP0ixrdCD9GZdt3qPLvNCrQ
         g4kt+Bqn0Jr/dnbkwpFL652e4j1wabHhmXFK31u5w5V+6abKZIVDGDLEBObv48xuQl
         eRVfnPEGdcfKw==
Date:   Thu, 22 Sep 2022 11:39:27 +0100
From:   Sean Young <sean@mess.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Message-ID: <Yyw7X2KkabBpPvIo@gofer.mess.org>
References: <20220822151027.27026-1-johan@kernel.org>
 <YymBM1wJLAsBDU4E@hovoldconsulting.com>
 <YywfxwBmdmvQ0i21@kroah.com>
 <Yyws4Pd4bAl3iq2e@hovoldconsulting.com>
 <Yyw1CJgv6nreCtB9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyw1CJgv6nreCtB9@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 12:12:24PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 22, 2022 at 11:37:36AM +0200, Johan Hovold wrote:
> > Thanks. These are the follow-up cleanups:
> > 
> > 	https://lore.kernel.org/lkml/20220822151456.27178-1-johan@kernel.org/
> 
> Thanks, I'll take them after the first one was merged into Linus's tree.
> 
> > Perhaps we should start taking USB related changes like this through the
> > USB tree by default. Posting patches to the media subsystem feels like
> > shooting patches at a black hole.
> 
> I agree, there's been a bunch of patches sent there (some with security
> fixes) that are not getting responded to :(

The patches were missed are all DVB related, which is Mauro's responsibility.

As far as I can see, other parts of the media subsystem are well looked after.


Sean
