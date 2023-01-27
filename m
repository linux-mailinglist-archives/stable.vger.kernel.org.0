Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC8467DE88
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjA0Hcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjA0Hcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:32:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1594319F01
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 23:32:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C68B81F83
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 07:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F115C433D2;
        Fri, 27 Jan 2023 07:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804758;
        bh=s+ZCrSza//tlZF1OCmZDmbLe7ZW7CreqHwmvqV56yyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P21IUWbuA82S4Bgmak3tYLhSsj2r7ERstR7Iosz4c9LRe466AmIBNRydW4gaeK1BY
         hPRYV7ePmoo5aAUuLh+Si1PhvA5g1bqc25iJCbe/+zbiBCxhTqsioeJskUCaKZWnI5
         c8YhOmJ+0N0JqXtbgRXQ2CrmCYN8XRjFaZ1ltGAU=
Date:   Fri, 27 Jan 2023 08:32:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: amdgpu suspend improvement
Message-ID: <Y9N+E+uTtAmZl9sr@kroah.com>
References: <MN0PR12MB61019A97F740FBF9780C0874E2CF9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61019A97F740FBF9780C0874E2CF9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 09:10:56PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> This commit that went into 6.2 has been shown to help timing corner cases with suspend problems.
> 
> 4b31b92b143f ("drm/amdgpu: complete gfxoff allow signal during suspend without delay")
> 
> Can you please take it to 6.1.y and 5.15.y?

Now queued up, thanks.

greg k-h
