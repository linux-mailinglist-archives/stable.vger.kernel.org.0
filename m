Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E46520230
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 18:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiEIQW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 12:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiEIQW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 12:22:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6EF1BE961
        for <stable@vger.kernel.org>; Mon,  9 May 2022 09:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37EF7B810B2
        for <stable@vger.kernel.org>; Mon,  9 May 2022 16:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A24EC385AC;
        Mon,  9 May 2022 16:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652113112;
        bh=WnjTaQZ2+a6ByEsHJxtSZKC7IpC4b88EEXo8wsaSgX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2G7VAcQb40B3RADgQs5PxoRM/xhDgJzC84mvIHtViMtnJb6743aarqGEDJC96A5W
         uvkOQqmu8AUWS5yA4dKVIApUnixU1IpSzl9ZTXfRgWhh18hZc6j2Ui8h222r0d060W
         wEJfhLn7aBaRSJd6GIon1c7ELdix1TZ5wHXlJpTI=
Date:   Mon, 9 May 2022 18:18:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fixes for amdgpu audio on dGPU suspend/resume
Message-ID: <Ynk+zcxY3bMYYgLW@kroah.com>
References: <BL1PR12MB5157776D00DAA747EF550CF1E2C69@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5157776D00DAA747EF550CF1E2C69@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 04:08:48PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> The following 4 commits can resolve an HDMI audio issue with suspend resume on AMD dGPUs.
> The last commit was already CC to stable, but couldn't apply to 5.15.y due to other changes that had to come first.
> The issue below link has some more detail:
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1968475
> 
> Can you please bring these to 5.15.y?
> 
> commit 58144d283712 ("drm/amdgpu: unify BO evicting method in amdgpu_ttm")
> commit e53d9665ab00 ("drm/amdgpu: explicitly check for s0ix when evicting resources")
> commit eac4c54bf7f17 ("drm/amdgpu: don't set s3 and s0ix at the same time")
> commit 887f75cfd0da4 ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset")

All now queued up, thanks.

greg k-h
