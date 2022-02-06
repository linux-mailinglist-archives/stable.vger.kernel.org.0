Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3B4AB0CB
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 18:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343505AbiBFRAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 12:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343516AbiBFRA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 12:00:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290AAC043184
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 09:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57894B80E08
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 17:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1692BC340E9;
        Sun,  6 Feb 2022 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644166825;
        bh=LSeI1k6uUu2ddPXYtJQSrQI5xWnGbR105VfsXTYPRGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yGqRM5UgoXPFBYIdG0wtk9ef2Lh38JKizrTDye0W4OmU/A1u9ynrvIORR27OV2brm
         KXC1qjWXcEXUKXJXzFkn8QklBh7G6QbQdb7FsvDfESJb5GdApZRWY8nNWHkrHUZK69
         o1/a1IWBlMnkfP3X0Yx4rg5uewHu5rZR5/HRpNdI=
Date:   Sun, 6 Feb 2022 18:00:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     MP <fromschoollaptop@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        tech.support@broadcom.com
Subject: Re: Asus Router Kernel Panics
Message-ID: <Yf/+npr9xV2HVg9k@kroah.com>
References: <4f5dccba-ab28-8007-bed8-f2594498c8c1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f5dccba-ab28-8007-bed8-f2594498c8c1@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 06, 2022 at 09:57:15AM -0500, MP wrote:
> 
> Hello all,
> 
>  Just looking for a bit of guidance here and a suggestion on proper next
> steps. I think there may be an issue within the below broadcom nand driver
> implementation.
> 
> I have an Asus GTE-AX11000 and it reboots\crashes multiple times a week,
> upon inspection of snmp logging you can see the below entries, when the
> kernel panic occurs the entire router locks up, and sometimes reboots.
> Sometimes it doesn't reboot and the router hangs completely and drops all
> network devices, and removes wireless SSIDs and all of your devices lose
> their connection.
> 
> Not sure who to turn to but Asus support has not grasped the gravity of this
> problem and I am thinking this can only really be resolved with a
> firmware\driver\linux update, so just hoping for some additional help or
> guidance from this group.

This is a very old, obsolete, and known buggy kernel version running any
number of unknown closed source kernel modules.  Only the manufacturer
can help you here, there is nothing the community can do at all, sorry.

Best of luck!

greg k-h
