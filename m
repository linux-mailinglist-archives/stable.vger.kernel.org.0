Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8218064C54F
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 09:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiLNIxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 03:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiLNIxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 03:53:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C582260D5
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 00:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6997961842
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36B2C433D2;
        Wed, 14 Dec 2022 08:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671007990;
        bh=rNc5Sald1fqqKAO7pTQOBr2HhhuxjmPqJKhTpdX1hqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WFbV2OvSmC1peBl0lcOcKNDN1e4dPil6Ojuii7T44o5wx1E5s9sN19X/NgBYqygWj
         xNNcppVkqzPC80/4tC9ER7ERObFzgh7+41rGIVXbTOXLtJLynDJLVJWIAWVO00s0Y9
         +mDXj5d2JeT4E4/sKCUAH/tpEHlHPogo2je//+ug=
Date:   Wed, 14 Dec 2022 09:53:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, jgross@suse.com
Subject: Re: [PATCH 5.15 0/1] Request to cherry-pick 74e7e1efdad4 to 5.15.y
Message-ID: <Y5mO81n3ocBeLOdR@kroah.com>
References: <20221213215339.3697182-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213215339.3697182-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 09:53:38PM +0000, Meena Shanmugam wrote:
> The commit 74e7e1efdad4 (xen/netback: don't call kfree_skb() with
> interrupts disabled) fixes deadlock in Linux netback driver. This seems
> to be a good candidate for the stable trees. This patch didn't apply
> cleanly in 5.15 kernel due to difference in function prototypes in
> drivers/net/xen-netback/common.h.
> 
> Juergen Gross (1):
>   xen/netback: don't call kfree_skb() with interrupts disabled
> 
>  drivers/net/xen-netback/common.h    | 2 +-
>  drivers/net/xen-netback/interface.c | 6 ++++--
>  drivers/net/xen-netback/rx.c        | 8 +++++---
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> -- 
> 2.39.0.rc1.256.g54fd8350bd-goog
> 

Can you just test the latest stable -rc releases that were announced a
few days ago instead?  It has this commit in it, right?

thanks,

greg k-h
