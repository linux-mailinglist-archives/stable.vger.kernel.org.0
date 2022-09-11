Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F75B4E6D
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 13:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiIKLc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 07:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiIKLc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 07:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC6A11817;
        Sun, 11 Sep 2022 04:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D84C60FD1;
        Sun, 11 Sep 2022 11:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D14C433C1;
        Sun, 11 Sep 2022 11:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662895947;
        bh=Z4JQK67EFTzrZ4+jCg9MLmg2mEMmfRNCRBBHDGbWzac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HQZKJiLMSycxQKjF2CynqfJ7cdf9uJ+KHfMnIGH3rT+DRNOARTLmYhOByZ1dkSG+y
         O8rVLsOWPIB+yhm2xmGjCD9E1Cyhb9stfcAnlIfVP/hkz+S+bXazMuozWei9ZrLXAK
         LgSHBSOnooNiW8fwQoAMICohDs1yT/XvtHzGyMEw=
Date:   Sun, 11 Sep 2022 13:32:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.19 0/4] USB: backports to 4.19
Message-ID: <Yx3HYBalQ85xosns@kroah.com>
References: <20220906134915.19225-1-johan@kernel.org>
 <Yx11oB0C3h7D6I2H@kroah.com>
 <Yx24o3VLE7bv0spk@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yx24o3VLE7bv0spk@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 11, 2022 at 12:29:55PM +0200, Johan Hovold wrote:
> On Sun, Sep 11, 2022 at 07:44:00AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Sep 06, 2022 at 03:49:11PM +0200, Johan Hovold wrote:
> > > And here are the corresponding backports to 4.19.
> > > 
> > > Johan
> > > 
> > > 
> > > Johan Hovold (4):
> > >   usb: dwc3: fix PHY disable sequence
> > >   usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
> > >   USB: serial: ch341: fix lost character on LCR updates
> > >   USB: serial: ch341: fix disabled rx timer on older devices
> > > 
> > >  drivers/usb/dwc3/core.c      | 19 ++++++++++---------
> > >  drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
> > >  drivers/usb/dwc3/host.c      |  1 +
> > >  drivers/usb/serial/ch341.c   | 15 +++++++++++++--
> > >  4 files changed, 37 insertions(+), 12 deletions(-)
> > 
> > All backports now queued up, many thanks for doing these.
> 
> I believe you can apply the two ch341 backports also to 4.14.

Thanks, now added.

greg k-h
