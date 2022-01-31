Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D7B4A3F2F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 10:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiAaJZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiAaJZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 04:25:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0D5C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 01:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC7CFCE10AE
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 09:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0E5C340E8;
        Mon, 31 Jan 2022 09:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643621116;
        bh=QK10OpLXKOl5Zt7IQYUA/H9/LZJr1EhlL5I18RzZSMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f2NZ7+hUuH3ccvvXtSVbz7+xOwMivF1AGw/XPAmvdpXD9XAI/UZR8S9vfa2fI4JNZ
         eYRxbMHEEt7r65kRotbcRqWngLHPLjM6l4QrMR/SKa5SMMLDBUikWayXpuaspJg4nQ
         /kwMUBFqDDTFUnGmHAbxEb1Omy5XduCqTP+2nGBc=
Date:   Mon, 31 Jan 2022 10:25:13 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Patch "usb: dwc3: xilinx: Skip resets and USB3 register settings
 for USB2.0 mode" has been added to the 5.16-stable tree
Message-ID: <Yfeq+cJkG3oSrJaf@kroah.com>
References: <1643473458172238@kroah.com>
 <8e6827b335e07010ca97faf1c98657434ec8b341.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e6827b335e07010ca97faf1c98657434ec8b341.camel@calian.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 09:40:56PM +0000, Robert Hancock wrote:
> On Sat, 2022-01-29 at 17:24 +0100, gregkh@linuxfoundation.org wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode
> > 
> > to the 5.16-stable tree which can be found at:
> >     
> > https://urldefense.com/v3/__http://www.kernel.org/git/?p=linux*kernel*git*stable*stable-queue.git;a=summary__;Ly8vLw!!IOGos0k!zf9QJvY84EtqUpdi6VflkIp1CJqnnCaQoiGGvZ8KORysjiM44hQecYjVySxsuD6OjZA$
> >  
> > 
> > The filename of the patch is:
> >      usb-dwc3-xilinx-skip-resets-and-usb3-register-settings-for-usb2.0-
> > mode.patch
> > and it can be found in the queue-5.16 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Hi Greg,
> 
> This patch should likely only go into stable along with the follow-up patch I
> posted (or something equivalent):
> 
> https://patchwork.kernel.org/project/linux-usb/patch/20220127221500.177021-1-robert.hancock@calian.com/
> 
> Otherwise it will cause a regression.

Thanks for pointing this out, I'll take the fix too.

greg k-h
