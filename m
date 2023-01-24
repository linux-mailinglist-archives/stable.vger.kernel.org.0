Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E934679E69
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 17:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbjAXQSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 11:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjAXQSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 11:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B872C470AA;
        Tue, 24 Jan 2023 08:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50914612AC;
        Tue, 24 Jan 2023 16:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26777C433EF;
        Tue, 24 Jan 2023 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674577122;
        bh=M+QGd56sC2Y3maSrulTCOW2O6wtcJd+IgCpsdG+U1Xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwE21R9UiQCsPed4JcB2H2YTO9OLxPije9y0mU4BJnHy3bJHezZC9nuLfVgzdS4uc
         WqK8G5QnVK7oL/3IET2r5VOixzfofvyhXcVr+gh2aXnH208z+eFulO34p8ITh7yZF7
         2rMFLu9MnXMMSoxRa/li3pNcJ7S4AcaTHXY2nigo=
Date:   Tue, 24 Jan 2023 17:18:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Pearson <mpearson-lenovo@squebb.ca>
Cc:     hdegoede@redhat.com, markgross@kernel.org,
        mario.limonciello@amd.com, platform-driver-x86@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86: thinkpad_acpi: Fix profile modes on Intel
 platforms
Message-ID: <Y9AE3wuhbNYRDp6w@kroah.com>
References: <mpearson-lenovo@squebb.ca>
 <20230124153623.145188-1-mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124153623.145188-1-mpearson-lenovo@squebb.ca>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 10:36:23AM -0500, Mark Pearson wrote:
> My last commit to fix profile mode displays on AMD platforms caused
> an issue on Intel platforms - sorry!
> 
> In it I was reading the current functional mode (MMC, PSC, AMT) from
> the BIOS but didn't account for the fact that on some of our Intel
> platforms I use a different API which returns just the profile and not
> the functional mode.
> 
> This commit fixes it so that on Intel platforms it knows the functional
> mode is always MMC.
> 
> I also fixed a potential problem that a platform may try to set the mode
> for both MMC and PSC - which was incorrect.
> 
> Tested on X1 Carbon 9 (Intel) and Z13 (AMD).
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216963
> Fixes: fde5f74ccfc7 ("platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode")
> 
> Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
> ---
>  drivers/platform/x86/thinkpad_acpi.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
