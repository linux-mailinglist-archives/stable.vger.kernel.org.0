Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696836D847C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDERFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbjDERFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F13D5FD8
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 10:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51A662961
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 17:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A64FC433D2;
        Wed,  5 Apr 2023 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680714278;
        bh=9XZaACGA8FEx/xawf4gzfj0QBSYDuFw19q/kCaTroBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4VTVAKIlzv23U87D5TYG7fhsx8AhXzWs5HSkIS3HaLutWQ4ktBaeXtqBeuLEXTKZ
         7pGoqWaeEqXnp45FgilVfDJleRC5mDakhYQrDROHsAPxkiVyaF/aFNL2Yrrezjbc/v
         jFvLe/g7uJuotDXTVKqCKCcjzy7iH2wl0eIsmPVY=
Date:   Wed, 5 Apr 2023 19:04:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] smb3: fix problem with null cifs super block with
 previous patch
Message-ID: <2023040514-ravishing-problem-9302@gregkh>
References: <20230405135709.100174-1-ptyadav@amazon.de>
 <2023040523-delusion-corrode-f466@gregkh>
 <mafs0fs9egzzb.fsf_-_@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0fs9egzzb.fsf_-_@amazon.de>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 04:34:00PM +0200, Pratyush Yadav wrote:
> On Wed, Apr 05 2023, Greg Kroah-Hartman wrote:
> 
> > On Wed, Apr 05, 2023 at 03:57:09PM +0200, Pratyush Yadav wrote:
> >> From: Steve French <stfrench@microsoft.com>
> >>
> >> [ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]
> >>
> >> Add check for null cifs_sb to create_options helper
> >>
> >> Signed-off-by: Steve French <stfrench@microsoft.com>
> >> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> >> ---
> >>
> >> Only compile-tested. This was discovered by our static code analysis
> >> tool. I do not use CIFS and do not know how to actually reproduce the
> >> NULL dereference.
> >>
> >> Follow up from [0]. Original patch is at [1].
> >>
> >> Mandatory text due to licensing terms:
> >>
> >> This bug was discovered and resolved using Coverity Static Analysis
> >> Security Testing (SAST) by Synopsys, Inc.
> >
> > What?  That's funny.  And nothing I'm going to be adding to the
> > changelog text, sorry, as that's not what is upstream.
> 
> That is fine by me. I placed this text below the 3 dashed lines so it
> does _not_ end up in the commit message, but still discloses this
> information.
> 
> > Please go poke your lawyers, that's not ok.
> 
> Yes, perhaps I should. But let's go forward with this patch since it
> keeps the original commit message?

It's already been queued up, you should have gotten an email saying
that, right?

thanks,

greg k-h
