Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD8528C06
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiEPRdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiEPRdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836E0DEF4
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C04D6129E
        for <stable@vger.kernel.org>; Mon, 16 May 2022 17:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234B7C385AA;
        Mon, 16 May 2022 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652722403;
        bh=BnyBzJk/ctMJjVDOltEAAZGxXVaqtek0jpGUpa89Id4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PifkEhfaT1KK05cBOWiq/j1YeWbTJlWscFpJbfdYZtewNAmirDXG+CJK/SVSo5HWp
         qTS13gvagBAe0/jM+rXCRvbsJ47iMeR5i0rBG/AUzh/VPrgndN4I9v6ETAReCq3TB+
         Q0Bn1rdj+DlXZFZPU2rK0+IYCkKkVY7Imds0EXBQ=
Date:   Mon, 16 May 2022 19:33:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: gadget: uvc: allow for application
 to cleanly shutdown" failed to apply to 5.10-stable tree
Message-ID: <YoKK4P5kC6440aB4@kroah.com>
References: <165268797312322@kroah.com>
 <YoKECFfK9zbgMvJn@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoKECFfK9zbgMvJn@p1g3>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 12:04:08PM -0500, Dan Vacura wrote:
> 
> Hi Greg,
> 
> On Mon, May 16, 2022 at 09:59:33AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Please cherry-pick e6bab2b66329b40462fb1bed6f98bc3fcf543a1c "usb:
> gadget: uvc: rename function to be more consistent" before applying the
> below patch.
> 
> I didn't realize it got tagged for stable. Ideally the submission (
> https://lore.kernel.org/r/20220503201039.71720-1-w36195@motorola.com )
> should've been:
> 
> Cc: <stable@vger.kernel.org> # 5.10+: e6bab2b66329: usb: gadget: uvc: rename function to be more consistent
> Cc: <stable@vger.kernel.org> # 5.10+
> 
> Earlier than 5.10 is a bit more complicated.

That worked, now queued up, thanks.

greg k-h
