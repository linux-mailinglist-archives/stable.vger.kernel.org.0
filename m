Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166155B6C52
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiIMLXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiIMLXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:23:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E625E652
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F62FB80E56
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8178C433D6;
        Tue, 13 Sep 2022 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068228;
        bh=3mVlVx0axNh3z6tNw4rZjzy7Bk/+M7QEO+rUSFK/Y/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oyse2zfRNQopKXkAxanGQ8KIBg3ZpasyCgazlnaAhG7+XOzRCaLX73nHcMjCznRx5
         1xY6YlWLTkq3tNGLYm0ySNZ1WNDcsg54XeR1CmHiW+1V7MgDyxDf0tycC3VZoNl1+x
         wGG0dCyi5blCbEt3oogFP6+N91rO+J7dHWPyEH8U=
Date:   Tue, 13 Sep 2022 13:24:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Subject: Re: Fix assertion introduced in 5.19
Message-ID: <YyBoXOgxgQLR0E5W@kroah.com>
References: <MN0PR12MB61011D906F85A56264007346E2449@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61011D906F85A56264007346E2449@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 09:00:27PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> There is a report on AMDGPU bug tracker [1] that a new kernel warning was introduced from 5.19rc-1 via c1b972a18d05.
> This is fixed in 6.0-rc1, and it had a Fixes tag but it didn't cleanly backport.  Please backport these two commits to 5.19.y to fix it.
> 
> 4b33b5ffcf68 ("drm/amd/display: Add SMU logging code")
> 149f6d1a6035 ("drm/amd/display: Removing assert statements for Linux")

Now queued up, thanks.

greg k-h
