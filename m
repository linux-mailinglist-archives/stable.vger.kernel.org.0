Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0C6B3FED
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCJNGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCJNGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4142DE060D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C1661543
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF104C433D2;
        Fri, 10 Mar 2023 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678453570;
        bh=SoFroVICmv7Hasmo2CcerkdkcuagZxAJvW/1TRgmIig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZkkXJGxHw5aUtjznQzbiTniSmSfQzaWC3d5CZHvqE5Is1IYOb7NDxJ7DZW4OUxJp
         grSb2Z86i91GStlQJjAbB0+xGgyGuse+LSHNR5Cfdbhd4w7lfZlcydk8UttpeP4aPK
         wfHY22xBC8JCLjqZSyPFoI3UQXOkdbHa/obslflo=
Date:   Fri, 10 Mar 2023 14:05:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     laurent.pinchart@ideasonboard.com, yunkec@chromium.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: uvcvideo: Fix race condition with
 usb_kill_urb" failed to apply to 4.14-stable tree
Message-ID: <ZAsrKuE3DpOMxaeK@kroah.com>
References: <1678450464220237@kroah.com>
 <CANiDSCs47_90_=S+n5rbUr4az_VZ_86CRCKeXm_zoqRpRDdG1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiDSCs47_90_=S+n5rbUr4az_VZ_86CRCKeXm_zoqRpRDdG1Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 01:54:23PM +0100, Ricardo Ribalda wrote:
> Hi Greg
> 
> On Fri, 10 Mar 2023 at 13:14, <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Kernel 4.14 does not handle the control changes on the status urb. I
> believe that we are not affected by this race condition.
> 
> So we can ignore this patch on 4.14.

Great, thanks, all other fixes queued up now.

greg k-h
