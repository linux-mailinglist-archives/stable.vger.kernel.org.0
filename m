Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128204CE50D
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiCENsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:48:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECD03DA75
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4D56129E
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B575EC004E1;
        Sat,  5 Mar 2022 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646488060;
        bh=7jlNgcmuyWxeBh5kkK2vBGGfKJQaH6/N/UQjD2r2UoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1xA13kkeNcy+0+s6uzxl0YmGqBYb87S4CZ9dLAJqrJCPVsA8Z0jnJmUEbkzFBI6wG
         mIRS0a9L8VQkCuYExBD9l21RAQJ96UJyNe56h4w69p2Dvdn/90RMEORdjgT2oktGkf
         eSPDcvPMiAzPLOajgQ371xg/nxMqfoUtdTaeFyEg=
Date:   Sat, 5 Mar 2022 14:47:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     yebin10@huawei.com, axboe@kernel.dk, ming.lei@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] block: Fix fsync always failed if once
 failed" failed to apply to 4.19-stable tree
Message-ID: <YiNp+IE9LWVyRhem@kroah.com>
References: <164302349921124@kroah.com>
 <Yh/aGJzX72KtYa/8@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh/aGJzX72KtYa/8@debian>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 08:56:57PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 24, 2022 at 12:24:59PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Both queued up, thanks.

greg k-h
