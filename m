Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20CD4D3010
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 14:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiCINk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 08:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCINkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 08:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B484C796;
        Wed,  9 Mar 2022 05:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F282B82146;
        Wed,  9 Mar 2022 13:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0ECC340E8;
        Wed,  9 Mar 2022 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646833164;
        bh=dYcfbRDY7WDaZxWGbrx8yK5r0FHThy8rThS8nWyatwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7KzRcU8GlllCGfDlYEAXiFhIjdPzS9zvBIYiO9Oxc66Ej8/3lLJaNA8EbIROGOeW
         r7546N2kIrKXh3VoMykAOgsI6czpzh655cZ98j7322E+/R2NUBDirZ0sUQI3neBneU
         0l5ycVk6kIgzmzJaOAbyh4u3SQFshwZlhztVKhrs=
Date:   Wed, 9 Mar 2022 14:39:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     catalin.marinas@arm.com, james.morse@arm.com,
        rmk+kernel@armlinux.org.uk, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "arm64: entry.S: Add ventry overflow sanity checks" has
 been added to the 5.4-stable tree
Message-ID: <YiiuCMd/hLmQ7tfS@kroah.com>
References: <164683132243254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164683132243254@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 02:08:42PM +0100, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     arm64: entry.S: Add ventry overflow sanity checks
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      arm64-entry.s-add-ventry-overflow-sanity-checks.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Oops, no, sorry, I've dropped this whole series from the 5.4 queue
again.

James, I've emailed you about this, let's take the followup to the
stable list and work on this there.

thanks,

greg k-h
