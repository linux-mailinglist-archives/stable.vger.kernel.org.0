Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DABF4E678F
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 18:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352161AbiCXRQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 13:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiCXRQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 13:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30209633B
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 10:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5AC6619AC
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 17:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A760C340F4;
        Thu, 24 Mar 2022 17:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648142072;
        bh=DMG3FomnKMvKtFMkGHtFl1njrI+64mJeiVvy2hb1B4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUXdZ8eBmoiZQQCxCzL/5MUDTL9khpelFMz0DDy2glDpnPreuPbSOPgB4k9E+TBPk
         P3mDzSrkgcxv3tPnFks/Zo9dJ5XE9kNcmCF08SYK3jPDheget5oXUuR2G9etun1OcG
         c0fJrCY0O/iVX4ACiqmewTD+z1N7mLyXD7NhhAhY=
Date:   Thu, 24 Mar 2022 18:14:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     oliver.graute@kococonnector.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] staging: fbtft: fb_st7789v: reset display
 before" failed to apply to 5.10-stable tree
Message-ID: <Yjym9NAnPTEXpPlh@kroah.com>
References: <164603174124116@kroah.com>
 <YjuP6J0feY3S5kDD@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjuP6J0feY3S5kDD@debian>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 09:23:52PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Feb 28, 2022 at 08:02:21AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will also apply to all other stable trees.

All now queued up, thanks!

greg k-h
