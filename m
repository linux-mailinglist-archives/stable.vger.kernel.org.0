Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD868912B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 08:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjBCHpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjBCHo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:44:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F33486633;
        Thu,  2 Feb 2023 23:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EB0B61E0A;
        Fri,  3 Feb 2023 07:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40D7C433EF;
        Fri,  3 Feb 2023 07:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675410295;
        bh=wCh2JtT1hnlyPyKIQeLhL0A3QxEDlkOPqjPKmOWfza0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WdZhXUum9M345iODIrU3+6XAwMkME7Yi4gVRuqODebzx30q9s2jAdqWaCOJLJH/PE
         ttqIszdRn8+bERw2cV21kXaXLiftFTLK1mc1UGyCiO1oR1z5o+x635pQlSezjYN0OO
         Y2qiLazVxsZTMxVKyHZC863/Tn5xD77TSKtqEGag=
Date:   Fri, 3 Feb 2023 08:44:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        paul@paul-moore.com, luhuaxin1@huawei.com
Subject: Re: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure
 to 4.19
Message-ID: <Y9y7c5sEX5phLybE@kroah.com>
References: <20230201023952.30247-1-guozihua@huawei.com>
 <Y9vw6RhQ6KJ5+E1I@sashalap>
 <02723ce8-0ad4-7860-b76c-7d2b30710dcf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02723ce8-0ad4-7860-b76c-7d2b30710dcf@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 09:10:13AM +0800, Guozihua (Scott) wrote:
> On 2023/2/3 1:20, Sasha Levin wrote:
> > On Wed, Feb 01, 2023 at 10:39:49AM +0800, GUO Zihua wrote:
> >> This series backports patches in order to resolve the issue discussed
> >> here:
> >> https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/
> >>
> >> This required backporting the non-blocking LSM policy update mechanism
> >> prerequisite patches.
> > 
> > Do we not need this on newer kernels? Why only 4.19?
> > 
> Hi Sasha.
> 
> The issue mentioned in this patch was fixed already in the newer kernel.
> All three patches here are backports from mainline.

Ok, now queued up, thanks.

greg k-h
