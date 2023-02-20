Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A769D28E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjBTSJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjBTSJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:09:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E5B9EF1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C470B80D9F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD77C433EF;
        Mon, 20 Feb 2023 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676916564;
        bh=/EZaY05lgUVoxJqc6Q5f9RM5ufdAyYazR0hq5OC6oDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkEhjsw8dhcJ+ZDupeKQWVv5DsBDSmOxnTmYFHSFK4webWv3UD/2l94HV7NXnCD6z
         sQg1TDgv2SMjB73Fmp9R7a+keScz0mpUlM3BpoNtV9xoE5JJh584G40VAMvWQ5DtbQ
         EQ+F0IKa9CAT5XP94jgmnQrBupR4E0sKJhLRtXys=
Date:   Mon, 20 Feb 2023 19:09:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Janne Grunau <j@jannau.net>
Cc:     hch@lst.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nvme-apple: reset controller during
 shutdown" failed to apply to 6.1-stable tree
Message-ID: <Y/O3UtHiz4//9o6E@kroah.com>
References: <1676893225104207@kroah.com>
 <20230220164559.GA24656@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220164559.GA24656@jannau.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 05:45:59PM +0100, Janne Grunau wrote:
> Hej,
> 
> On 2023-02-20 12:40:25 +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Why was this patch even considered for the 6.1-stable tree? Its "Fixes:" 
> tag references a commit which only appeared in v6.2-rc1.
> 
> There is no need to backport this to any stable tree.
> 
> The message suggest that ignoring this would have been fine but it seems 
> worthwhile to report a potential bug or ommission in the stable backport 
> tooling.
> 
> > Possible dependencies:
> > 
> > c06ba7b892a5 ("nvme-apple: reset controller during shutdown")
> 
> certainly doesn't depend on itself
> 
> ...
> 
> > c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")

This is the commit that is now in the 6.1-stable queue, which is why I
sent the "FAILED" email for the commit that said this was a fix.

> commit from "Fixes:"
> 
> ...
> 
> If this is intended since "Fixes:" tags are in general not relieable 
> enough to decide to which trees regression fixes have to be applied to 
> that's acceptable

Should I just drop c76b8308e4c9 ("nvme-apple: fix controller shutdown in
apple_nvme_disable") instead?

thanks,

greg k-h
