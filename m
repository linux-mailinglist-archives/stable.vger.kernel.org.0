Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6874567EAF
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGFGgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGFGgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:36:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB65AE7F;
        Tue,  5 Jul 2022 23:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCAB561D06;
        Wed,  6 Jul 2022 06:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50AAC3411C;
        Wed,  6 Jul 2022 06:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657089396;
        bh=j32+zFM4zoacK2sBzNi6XW/mR6LtUSh2jG2cItIv5is=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QYIbHs71nTQAkacifa50oxmT6CpvOj8PiaJntckKrH34ybC5VUw/g8gGqX6SGUWgS
         92/ZeIzTGqNOUcrfKdi2HMopGeHvUdbL60PpwtDRizYN0EXhLvYsuKfllsQ5IQk9jH
         4HN8OHDkf6UcWPiYtYFpZ478QK3PSHbsgWtqultA=
Date:   Wed, 6 Jul 2022 08:36:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 05/29] usbnet: make sure no NULL pointer is passed
 through
Message-ID: <YsUtcQzPmNMk6H8u@kroah.com>
References: <20220705115605.742248854@linuxfoundation.org>
 <20220705115605.903898317@linuxfoundation.org>
 <20220705203601.GA3184@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705203601.GA3184@amd>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 10:36:02PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Oliver Neukum <oneukum@suse.com>
> > 
> > commit 6c22fce07c97f765af1808ec3be007847e0b47d1 upstream.
> > 
> > Coverity reports:
> > 
> > ** CID 751368:  Null pointer dereferences  (FORWARD_NULL)
> > /drivers/net/usb/usbnet.c: 1925 in __usbnet_read_cmd()
> > 
> > ________________________________________________________________________________________________________
> 
> There's something wrong here. Changelog is cut, so signed-offs are
> missing. It is wrong in git, too.
> 
> There's something wrong with the whitespace in the patch (indentation
> by 4 spaces instead of tab), too.

Looks like quilt messed this up and got confused about the patch header.
I'll go fix this up, thanks.

greg k-h
