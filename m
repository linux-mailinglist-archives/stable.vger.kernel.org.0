Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F79765CCA1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 06:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjADFhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 00:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjADFhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 00:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38099E90
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 21:37:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C26D76119F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52F9C433EF;
        Wed,  4 Jan 2023 05:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672810621;
        bh=stSb3Xxcvtk3gQtCKhflvW6n4ttUM6Ty3E6jv+9MWz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HcetwlSgc3Sqev9OoYGrUfSAjBY54SBasdNSq1kWOC0a0pRUUIOOJ6OwynPeiyCXM
         WimO5dgpWdbz1D7ioEpFN3kQ1j2cWABDT0mADfhyodLydrgdsuMFEb5MZE4oNJdPoZ
         G7he+Jxp6nzBiLSOT1qzfcssbadS3gB5AH4YJ3dQ=
Date:   Wed, 4 Jan 2023 06:36:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Missing 6.0/6.1 stable patch
Message-ID: <Y7UQetSAU0FM9F37@kroah.com>
References: <MN0PR12MB6101EB028DE354FAE5C1444DE2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101EB028DE354FAE5C1444DE2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 03:43:48AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> This below patch from 6.2-rc1 was Cc to stable 6.0/6.1:
> 
> afa6646b1c5d ("drm/amdgpu: skip MES for S0ix as well since it's part of GFX")
> 
> However It didn't get picked up for 6.0.16 or 6.1.2.  I also didn't see it in stable-queue.git/tree/queue-6.0 or stable-queue.git/tree/queue-6.1.
> 
> I double checked and it works on both 6.0.y and 6.1.y, and It fixes a bad suspend problem, so I wanted to double check it didn't get missed with the holiday shuffle.

It is still in my "to apply" queue.  Due to everyone loving to sneak in
fixes into -rc1 instead of getting them to Linus sooner for -final, the
queue is huge at this point in time with over 200+ remaining for me to
go through.  Add to that the general mess of the DRM tree when it comes
to stable patches for -rc1 (most are duplicates of what is already in
older stable releases), I wait until I have processed _EVERYTHING_ else
before even looking at DRM patches for stable during this time period.

So don't worry, it's not lost, just give us a week or two more to catch
up and please work to try to get fixes into -final whenever possible and
not wait for the huge -rc1 merge for issues that are more urgent.

thanks,

greg k-jh
