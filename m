Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2183557EFCE
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiGWOrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiGWOrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:47:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FC31EC5E
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 07:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C682ACE0A54
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 14:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE55FC341C0;
        Sat, 23 Jul 2022 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658587637;
        bh=8L+vLZIet+NK8Gkh38HXSN8M02nMMTa6Nv+9/PU229Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IkjNFFjrK9UzJ6+wh0tMnzzLDo98ypXIY7uzY1B9RoQ3ONlOx1qjjf/iHxs2O5cHC
         zrReCODWWHkqfWMZfKF64HEHQl+0I2WoMlNDCEnSbSQKe6cTDFWyh6gA2tykvUaSf5
         HFPblu1aYwWqZ8j+EfkewcWKu55I79oNXbsytAhY=
Date:   Sat, 23 Jul 2022 16:47:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 1/1] security,selinux,smack: kill security_task_wait
 hook
Message-ID: <YtwJ8WvRl0TolEAs@kroah.com>
References: <20220711095608.4723-1-theflamefire89@gmail.com>
 <20220711095608.4723-2-theflamefire89@gmail.com>
 <f5b1e4e6-28bb-9c92-8939-e49db8cba0dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b1e4e6-28bb-9c92-8939-e49db8cba0dd@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Jul 23, 2022 at 10:37:10AM +0200, Alexander Grund wrote:
> Hi Greg,
> 
> after the previous discussion about what kind of patches are acceptable for stable
> and your hints on how to send them to the ML in https://lore.kernel.org/all/YsrfDfe3urGkepvJ@kroah.com/
> I'd like to know if this patch meets the requirements and if it can be considered.

Yes, it is now queued up.  It was delayed due to the RETBLEED mess.

> I do have a few more similar ones which I think meet the stable requirements
> and finally the init-cleanup patch
> (upstream 3dfc9b02864bt "LSM: Initialize security_hook_heads upon registration.")
> which I'd like to backport to 4.9. But first I want to know whether I now got
> the formal requirements right before sending further patches.

Let's see what the other patches look like, I can't guarantee anything
without reviewing them first.

thanks,

greg k-h
