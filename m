Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21385E5D8D
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiIVIct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 04:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIVIcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 04:32:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CB548EA8;
        Thu, 22 Sep 2022 01:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5199560AD7;
        Thu, 22 Sep 2022 08:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA76C43470;
        Thu, 22 Sep 2022 08:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663835562;
        bh=SWY50SPMYrQ9rKOjBPbGXTzfecN4RKVk8BYGba7UI4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k6+JwbVbL/3GxVfZwrn0D8UhOmQink/gUlUVmQbHptKUsQe0LSrFbdwR+1W7L/7fQ
         UVFjfExu/p1DbcMESH4UhRIReudLS1ibtSVkt5cjNx9yYaDbEtkgU3hp7N/ENviBq/
         qb73w/gTBlscXjSiOeEp7yClHUCgBkjA+OlghPLs=
Date:   Thu, 22 Sep 2022 10:32:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: Linux 4.14.294
Message-ID: <Yywdpyn814NkBJY8@kroah.com>
References: <1663669061118192@kroah.com>
 <1663669061138255@kroah.com>
 <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
 <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
 <YywGcg/Qgf8B8wEj@kroah.com>
 <e4852207ed36662a7c53e36fbbc31a71c5a3396e.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4852207ed36662a7c53e36fbbc31a71c5a3396e.camel@perches.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 01:26:59AM -0700, Joe Perches wrote:
> On Thu, 2022-09-22 at 08:53 +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 22, 2022 at 11:02:21AM +0700, Bagas Sanjaya wrote:
> > > On 9/22/22 01:03, Joe Perches wrote:
> > > > On Tue, 2022-09-20 at 12:17 +0200, Greg Kroah-Hartman wrote:
> > > > []
> > > > > diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
> > > > []
> > > > > @@ -118,7 +118,7 @@ struct report_list {
> > > > >   * @multi_packet_cnt:	Count of fragmented packet count
> > > > >   *
> > > > >   * This structure is used to store completion flags and per client data like
> > > > > - * like report description, number of HID devices etc.
> > > > > + * report description, number of HID devices etc.
> > > > >   */
> > > > >  struct ishtp_cl_data {
> > > > >  	/* completion flags */
> > > > 
> > > > Needless backporting of typo fixes reduces confidence in the
> > > > backport process.
> > > > 
> > > 
> > > The upstream commit 94553f8a218540 ("HID: ishtp-hid-clientHID: ishtp-hid-client:
> > > Fix comment typo") didn't Cc: stable, but got AUTOSELed [1].
> > > 
> > > I think we should only AUTOSEL patches that have explicit Cc: stable.
> > 
> > That's not how AUTOSEL works or why it is there at all, sorry.
> 
> Perhaps not, but why is AUTOSEL choosing this and why is
> this being applied without apparent human review?

We always appreciate more review, and welcome it.  Sometimes things slip
by us as well, like it did for this one.  The changelog makes it look
like a real fix that is needed.

thanks,

greg k-h
