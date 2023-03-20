Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C186C0C77
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 09:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCTIsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 04:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjCTIsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 04:48:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B9E55A0;
        Mon, 20 Mar 2023 01:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FA5461263;
        Mon, 20 Mar 2023 08:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA5BC433EF;
        Mon, 20 Mar 2023 08:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679302084;
        bh=ujA6Uw61/p6mzFCHl2TPNTrn3EeopZSQcSvdx284HS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoB1JsImlGki7ySeaRm7mmOXjE2Q7Pjj4iLMOA86bMnJH4CZaGmQd3JOhuSTrw9qL
         YzhHE79drltHGj1OyeQXqpWTmpi90mogbicQIxYTc3zA3dH4r9C3FKGkAyAWIvzDHD
         7oBBGHNQbxU2m0wWqENh0YqTxcqMbj5nUSuneiSo=
Date:   Mon, 20 Mar 2023 09:47:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: Consider picking up "scsi: core: Fix a procfs host directory
 removal regression" for stable
Message-ID: <ZBgdvX4hV3zmdZOc@kroah.com>
References: <472c53aa-4803-cde9-8f80-cbd7d33dc9c5@leemhuis.info>
 <e6314dd6-df75-fff8-1e3c-546b2b44be5b@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6314dd6-df75-fff8-1e3c-546b2b44be5b@leemhuis.info>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 07:45:04AM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 20.03.23 07:19, Linux regression tracking (Thorsten Leemhuis) wrote:
> > Hi Greg. From https://bugzilla.kernel.org/show_bug.cgi?id=217215 it
> > looks like you want to add be03df3d4bfe ("scsi: core: Fix a procfs host
> > directory removal regression") to your stable queue. It lacks a stable
> > tag, but fixes a bug in a commit that afaics was backported to all
> > stable series last week.
> > 
> > Side note: would you scripts have noticed this automatically and added
> > it to the queue today? (Just wondering if this mail actually makes any
> > difference.)
> 
> Sorry, ignore that, I noticed that fix is already in your queue (I
> looked at it before writing that mail, but it seems I somehow missed it
> and only noticed now; sorry for the noise).

It's not noise, verifying that we actually picked up known fixes is
good, I'd much rather a few "do you really have this fix" emails get
sent than not sent at all and we miss things.

And I just checked, yes, if Sasha hadn't picked this up with his
scripts, my scripts would have caught it as well, so it was a good test
that our independant processes are working.

thanks,

greg k-h
