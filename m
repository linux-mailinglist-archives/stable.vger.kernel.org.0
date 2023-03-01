Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F8B6A6810
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 08:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCAHW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 02:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCAHW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 02:22:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C855274;
        Tue, 28 Feb 2023 23:22:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAA916123B;
        Wed,  1 Mar 2023 07:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9645C433EF;
        Wed,  1 Mar 2023 07:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677655375;
        bh=x9qdTx2NO2SWfhnxzPSmKHSSdUWzp4uJPj2UI3dh0Hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXF7G89AA96g0Jfi1Nk/4EE1oevhzNwsRo1tf95fvchaYCXxE4AW3kSEm5xTkZEs0
         i/1JjPPPOQOoj7dxHD+sthNc3zY4IDWkomR+VRFOXEf4L3+ly96+ux2LV7NBBoM9q6
         iSZyu7WCQPjeZg9MlbfzEE4nfaa7k+k/nXcGss8HNDKI8pMLP0L6HkauXvAisMjXNl
         vZg4PZxZqklQ9MazIgg12ErnxnBRs5wtmchldA9TIRojubStWU2TK1tUtuAsUP+9I9
         7skGD+Aj7q/IMb8e8MpOmJ914zFBQwe3KfxkguENrzayGJXAZtvetR5KFLTIz8Qg9j
         h+/fxgB4EfTAA==
Date:   Tue, 28 Feb 2023 23:22:53 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/79Tfn5kFIItUDD@sol.localdomain>
References: <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7fFHv3dU6osd6x@sol.localdomain>
 <Y/7sLcCtsk9oqZH0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/7sLcCtsk9oqZH0@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:09:49AM +0100, Greg KH wrote:
> 
> Why would the FAILED emails want to go to a mailing list?  If the people
> that were part of making the patch don't want to respond to a FAILED
> email, why would anyone on the mailing list?

The same reason we use mailing lists for kernel development at all instead of
just sending patches directly to the MAINTAINERS.

> 
> But hey, I'll be glad to take a change to my script to add that
> functionality if you want to make it, it's here:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/scripts/bad_stable
> 

Ah, the classic "patches welcome".

Unfortunately, I don't think that can work very well for scripts that are only
ever used by at most two people -- you and Sasha.  Many even just by you,
apparently, as I see your name, email address, home directory, etc. hardcoded in
the scripts.  (BTW, where are the scripts Sasha uses for AUTOSEL?)

- Eric
