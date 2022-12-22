Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91A4654523
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 17:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiLVQ1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 11:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiLVQ0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 11:26:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534AC3056D
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 08:26:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8D5261C27
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 16:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF98FC433F0;
        Thu, 22 Dec 2022 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671726397;
        bh=BIGPElRUJdoPkAaCUGBr8RgVLFHAfMFel+1CG1B9yag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fX6ns5ApyABR9Tww7UENQxKNtfEptE24ADUBWcthXScM6cNdw99ZD/lDkuS3zfNzl
         k8E2s5unCj+qCVVTrZ5m7nlYPr5QILIAgOvKiLCsa6rWTSq4zC0ZzpBa7WH5ispa+n
         rQFa3UwM6yul4yyAihdfqdLYu1VjkBykz5TfkrY8=
Date:   Thu, 22 Dec 2022 17:26:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix for W6400 hang
Message-ID: <Y6SFOnZKcGsmtvcP@kroah.com>
References: <5e38dcba-aba7-d461-6027-20cb346508bc@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e38dcba-aba7-d461-6027-20cb346508bc@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 09:08:48AM -0600, Mario Limonciello wrote:
> Hi,
> 
> It was reported that on 5.15.y there are problems with S3 suspend root
> caused to a W6400 problem. [1]
> 
> These are fixed by this commit:
> 
> a9a1ac44074f ("drm/amd/display: Manually adjust strobe for DCN303")
> 
> Can you please bring it to 5.15.y?

Now queued up, thanks.

greg k-h
