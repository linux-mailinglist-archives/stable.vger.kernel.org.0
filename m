Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71A74C4497
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiBYM0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240641AbiBYM0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:26:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B503214FAB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0197F61B14
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 12:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0577DC340E7;
        Fri, 25 Feb 2022 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645791972;
        bh=2kD6zliF/7kpkBm/5wMqRwywS1WwMXEfs4HMp8GpC6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kppJ9gMQV+vY55dSSD9PWUQvK/zB0P0ugbjgmKJdQhVcGwNhlVrndufPXwnPHq/Fd
         FKzxpRJj8dkB8YNZKYJaRgeekFxv0KgK1Hs1i+bmbswT7ICAhTUEYUIsqymjMu6V++
         if4kVIIKhUWy8Crw79os4Df+sTiSuuif2nht+u+Y=
Date:   Fri, 25 Feb 2022 13:26:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Messaging verbosity backport
Message-ID: <YhjK4RMbHjFc6xal@kroah.com>
References: <BL1PR12MB51572C542F61E7C087C729D5E23C9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51572C542F61E7C087C729D5E23C9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 11:06:47PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> By default some laptops show this on every boot.  It's not useful and was degraded to debug in a future kernel.
> 
> [drm:dp_retrieve_lttpr_cap [amdgpu]] *ERROR* dp_retrieve_lttpr_cap: Read LTTPR caps data failed.
> 
> Please backport
> 
> commit 1d925758ba1a5d2716a847903e2fd04efcbd9862 ("drm/amd/display: Reduce dmesg error to a debug print") to decrease verbosity.

Now queued up, thanks.

greg k-h
