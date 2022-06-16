Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DF154E16E
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiFPNFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiFPNFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:05:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D4AAE73
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 06:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D35F2B823AB
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 13:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC80C34114;
        Thu, 16 Jun 2022 13:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655384735;
        bh=VhO1r3wdQ8piNr1EF13pR8yDlLfsgJ4rPVRGE2ZImrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1wMnMWThrYVXw7YD0/cX8AnLQ54FCcR1aJuL5W+ixBMtjT2Bm58tRb7LNw8WgC/jn
         WeklLGB7ay89JaoFdn5+uvkPEUih1G3+VukkyYNq3jsepDM79xYYYwISknA7uWMikf
         cDCkbHJHeb493NyHQsty1Gz5O12/2AUZUf+Bu5wU=
Date:   Thu, 16 Jun 2022 15:05:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix multiple USB-C displays on Ryzen 6000
Message-ID: <YqsqnHsr8owkqDJZ@kroah.com>
References: <MN0PR12MB6101AF53F2455B1B46F4F3C8E2AB9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101AF53F2455B1B46F4F3C8E2AB9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 06:30:20PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> The following revert commit went into 5.19:
> 
> commit 1039188806d4 ("Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping")
> 
> The original commit was mistaken and causes USB-C monitors and monitors behind docks to not light up properly.
> Can you please bring this into 5.15.y and later?

Now queued up, thanks.

greg k-h
