Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986886255C4
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiKKIxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiKKIxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:53:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A4DB1CC
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 00:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832CA61EBD
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 08:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F0CC433D6;
        Fri, 11 Nov 2022 08:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668156811;
        bh=qaxD32/FjiSYmfAEK8Ux/Ebou52qFvDftooI3umB1yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdimT+/vS16ZfrrnQ/+T0hEntfGkWmoev7s1YUi9MFR18Qm+Pbl6g8w/SQUxPF5P9
         0oDbxch5KEnaEM7yFMXcnklQ8A75K1bDs+gHF0PmaES2FMthp7BmE4YWQoLtMCY94u
         jc8rlRaNMqmNLjcw7xTReOzJudGmIPItMj1/1C6Q=
Date:   Fri, 11 Nov 2022 09:53:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: USB4 DP tunneling fix for 6.0.y/5.15.y
Message-ID: <Y24NiS1spQyDbEc0@kroah.com>
References: <MN0PR12MB610143CD05C1230BBE268FC5E2019@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610143CD05C1230BBE268FC5E2019@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 03:36:30PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> USB4 DP tunneling has a bug in 6.0.y and 5.15.y that was fixed in 6.1.
> Basically if the Pre-OS connection manager has set up USB4 DP tunnels they're ignored by the OS so you'll have a "working" display in firmware and once the Linux kernel boots up you use lose the display.
> Hot plugging works around the issue.
> 
> For 6.0.y can you please take this commit to fix it:
> b60e31bf18a7 ("thunderbolt: Add DP OUT resource when DP tunnel is discovered")
> 
> For 5.15.y can you please take these two commits to fix it:
> 43bddb26e20a ("thunderbolt: Tear down existing tunnels when resuming from hibernate")
> b60e31bf18a7 ("thunderbolt: Add DP OUT resource when DP tunnel is discovered")

Now queued up, thanks.

greg k-h
