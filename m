Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90659F92A
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiHXMOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiHXMOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D2B6F27C
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FDEFB823B5
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 12:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA497C433C1;
        Wed, 24 Aug 2022 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661343268;
        bh=QPr62EQ7EGe77uqh4hHgP6i7LSouiXkdo1huf5kouKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=blC1MRhDCJP0o9tUuVelvstcOnLks2JE02+lFHTsg/g5h9cOy3BLloxPthhhw3B39
         b202hvWIcGwnuXRF0ihDo92rWJGRMVYBxk1NJ//PA8Ah6guK3fxqutFtCKzs2k3ZRU
         J0uAEwwAGkHPKfcFfpO2ZmXBc8GHsX1aSzxCDBmE=
Date:   Wed, 24 Aug 2022 14:14:24 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore
 interrupt status and wake" failed to apply to 5.10-stable tree
Message-ID: <YwYWIKtSpT+XUYQ7@kroah.com>
References: <166115772810989@kroah.com>
 <MN0PR12MB610100C31BEDC1E3C46264C6E2709@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YwXLPecNOtqcy1NI@kroah.com>
 <6ce41d24-5eed-5ffc-d4ee-3dd702833347@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ce41d24-5eed-5ffc-d4ee-3dd702833347@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 07:05:25AM -0500, Mario Limonciello wrote:
> On 8/24/22 01:54, gregkh@linuxfoundation.org wrote:
> > On Tue, Aug 23, 2022 at 08:36:20PM +0000, Limonciello, Mario wrote:
> > > [Public]
> > > 
> > > > -----Original Message-----
> > > > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > > > Sent: Monday, August 22, 2022 03:42
> > > > To: Natikar, Basavaraj <Basavaraj.Natikar@amd.com>;
> > > > linus.walleij@linaro.org; Limonciello, Mario <Mario.Limonciello@amd.com>
> > > > Cc: stable@vger.kernel.org
> > > > Subject: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrupt
> > > > status and wake" failed to apply to 5.10-stable tree
> > > > 
> > > > 
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > I had a look at this and the other ones that failed to apply.  I tried to apply this commit
> > > ( commit b8c824a869f220c6b46df724f85794349bafbf23 ) to all of them and then built it.
> > > 
> > > 5.10.y: success
> > 
> > $ patch -p1 < ../pinctrl-amd-don-t-save-restore-interrupt-status-and-wake-status-bits.patch
> > patching file drivers/pinctrl/pinctrl-amd.c
> > Hunk #1 succeeded at 833 (offset -85 lines).
> > Hunk #2 FAILED at 927.
> > Hunk #3 FAILED at 937.
> > Hunk #4 succeeded at 842 (offset -103 lines).
> > 2 out of 4 hunks FAILED -- saving rejects to file drivers/pinctrl/pinctrl-amd.c.rej
> > 
> > Doesn't work for me, how did you apply it?
> 
> I checked out the different branches mentioned and did "git cherry-pick -x
> b8c824a869f220c6b46df724f85794349bafbf23" followed by building.

That's great, can you send me that patch?  We don't use git for the
stable queue as it does not work at all for our development workflow.
We export the commits as patches and then apply them using quilt.  git
must be doing some "magic fuzzing" here that patch can not detect.

thanks,

greg k-h
