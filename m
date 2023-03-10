Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC42D6B3927
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjCJIt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCJIse (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:48:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3307B7C3CC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 00:47:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E37AEB821F6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 08:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FFCC433D2;
        Fri, 10 Mar 2023 08:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678438055;
        bh=rrghWpQU4pyXQ9wdFJ/D+5gqcbwEEmx7bzDT21YlFvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JoDkiyinPfyqZPq/enK7Z/KHxRiCS1EWtfvB8z+rvauhIoslzSUp8w6o0yE7C2liU
         S02xZXOYozbghyXp/tDtPIR/yg/z0obxraRgZ0Cxe5gQL5f9j40Sc2Y7ivl1NY/eaJ
         lvlVf/PPfsPIv9Dwm1AN26/ql3O01fFn58XtLDrA=
Date:   Fri, 10 Mar 2023 09:18:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alan Stern <stern@rowland.harvard.edu>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6.2 0957/1001] scsi: core: Remove the
 /proc/scsi/${proc_name} directory earlier
Message-ID: <ZArnzI9eLhBBJSyF@kroah.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170103.699105440@linuxfoundation.org>
 <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 09:57:55AM -0800, Bart Van Assche wrote:
> On 3/7/23 09:02, Greg Kroah-Hartman wrote:
> > From: Bart Van Assche <bvanassche@acm.org>
> > 
> > commit fc663711b94468f4e1427ebe289c9f05669699c9 upstream.
> > 
> > Remove the /proc/scsi/${proc_name} directory earlier to fix a race
> > condition between unloading and reloading kernel modules. This fixes a bug
> > introduced in 2009 by commit 77c019768f06 ("[SCSI] fix /proc memory leak in
> > the SCSI core").
> 
> Hi Greg,
> 
> This patch introduces a new bug and the new bug is easier to trigger than
> the bug fixed by this patch. How about waiting with applying this patch on
> any stable branch until the fix for this patch has landed upstream?

Ok, now dropped from all queues, sorry for the delay.  Please let us
know when the fix has landed in Linus's tree so we can add this, and the
fix, back in.

thanks,

greg k-h
