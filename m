Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694FC4D6D0C
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 07:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiCLGnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 01:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCLGng (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 01:43:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21DEF543A
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 22:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C08B82DC5
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 06:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F65DC340EB;
        Sat, 12 Mar 2022 06:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647067347;
        bh=Z0YLkePN1SfZi5AUn+n5p1E6dgjtkr+MXDn1bi5ox14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=doI/4wz4xeZhiLKA1V/HziGcwmgDTQ+GhqaJSUcyewi+YlioaX7LcKKM5/ueeJ6YJ
         e2P9ViduXUgx5Ro9kzmZBROlw9Pu+m0mNRz1wxxV/jpx+PzsLwZUoUpFK7O9WjMV9g
         u5HiXqzxotgAuhgyMojc5y0Yw8qZ3pA3QPkVY2l4=
Date:   Sat, 12 Mar 2022 07:42:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: request for 5.15-stable: b81e0c2372e6 ("block: drop unused
 includes in <linux/genhd.h>")
Message-ID: <YixAzAaU/r1fZghs@kroah.com>
References: <YiujvyEhyf72iG/i@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiujvyEhyf72iG/i@debian>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 07:32:15PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> As reported before, the mips failure for 5.15-stable will need two backports.
> I can see one of them in the queue, but looks like you have missed:
> b81e0c2372e6 ("block: drop unused includes in <linux/genhd.h>")

I purposfully dropped that commit, I didn't miss it :)

I said I would look at this issue again after the releases happened.
I'll do so next week.

thanks,

greg k-h
