Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9785A68A8E8
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 09:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbjBDIGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 03:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBDIGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 03:06:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD6C27D55
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 00:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8DCD601C3
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 08:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F378C433EF;
        Sat,  4 Feb 2023 08:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675497968;
        bh=lXQHT06I5mTNfgp8q9WY+J4pUSAmYpAlWQE4vglFmrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BLnUQpmPZ3fzySxyeKk3pOBGfYRJMWg09IvMX1QXYgKYaKF/JA+KV/wQHi2mPqyOz
         T9UsRg13Re5Vkp75aibSeZIOubIgTkOdY/aVAtlGAymIZsQoAUac+Ib4RIJPxVYvw1
         utT9z3WNsW04A50cyBR/uZ+rT5KE3pWlWI4aow4A=
Date:   Sat, 4 Feb 2023 09:06:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     dsahern@kernel.org, idosch@nvidia.com, kuba@kernel.org,
        patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 60/67] ipv4: Fix incorrect route flushing when source
 address is deleted
Message-ID: <Y94R65pvDM9d1v/I@kroah.com>
References: <20221212130920.482075438@linuxfoundation.org>
 <20230203184729.30269-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203184729.30269-1-shaoyi@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 06:47:29PM +0000, Shaoying Xu wrote:
> Hi Greg, 
> 
> It seems this patch deletes the whole fib_tests.sh that causes new
> failure in kselftests run. Looking at the upstream patch [1] and given the
> context that ipv4_del_addr test is not available to kernel 5.4, I
> updated the patch like attached below to resolve the potentail mistake.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f96a3d74554df537b6db5c99c27c80e7afadc8d1

I'm sorry, but what commit exactly are you referring to here?  There is
no context at all in this email message :(

And if something is already in a release, I need a fix-up patch to
resolve it, your patch was whitespace damaged and could not be applied
to anything, sorry.

thanks,

greg k-h
