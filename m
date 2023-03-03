Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B346A9B3E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjCCPxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjCCPxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:53:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762E910ABF
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 07:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B97961796
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 15:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261B6C433D2;
        Fri,  3 Mar 2023 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677858827;
        bh=vG19iKnY54oMTPnAqjNeteAsHyso9ldjII0PJ8x7BsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HpMvb4HsESVmRH7eLMp+uJXz8xSR2VTIMWrK5V0Z9afXx6kqpGFcB3NQaj6ej184J
         1e8kPrdLVOmSDTr78Jiusqup0uCWoeNtUY8b7sCuVk0XVmBi38RZOr5xNxmpWDd9s+
         p2km/+SwOkL8iWo5JlcfecYLukE9u2A0zn8Sm94g=
Date:   Fri, 3 Mar 2023 16:53:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "matt.fagnani@bell.net" <matt.fagnani@bell.net>
Subject: Re: Fix for AMD IOMMU issue in 6.2-rc1
Message-ID: <ZAIYCQ42Q0oic8L3@kroah.com>
References: <MN0PR12MB610172C57B91DC97C5D7D6F8E2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610172C57B91DC97C5D7D6F8E2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 10:43:03PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> There was a regression in 6.2-rc1 that caused amdgpu to not be able to load when IOMMU domain isn't set up properly
> It was fixed by these four patches in 6.3.
> 
> 080920e52148 ("iommu/amd: Fix error handling for pdev_pri_ats_enable()")
> f451c7a5a3b8 ("iommu/amd: Skip attach device domain is same as new domain")
> 996d120b4de2 ("iommu/amd: Improve page fault error reporting")
> 2cc73c5712f9 ("iommu: Attach device group to old domain in error path")
> 
> Can you please bring them to 6.2.y?
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216865
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2319
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2156691

All now queued up, thanks.

greg k-h
