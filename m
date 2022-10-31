Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3A613045
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJaG1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJaG1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:27:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974297652
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C52B81128
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98607C433C1;
        Mon, 31 Oct 2022 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667197659;
        bh=2nu/g0Cx+IN0jLpaXGIaTFrE+fSFQlBqA96RzwCJQS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgwC9s8hgTNtSA6PQXRX6p/Ex7f7jZ6kVvonhcw8swV1SAtGBvFLJpfUo/7NOEthB
         srbzuDF4zhxguwYEULEQ8xttKA7lxxhOQx96WVvcOu8DzgyRx0KjNCuuyaasE+ipxf
         bRGnMVo82dAV09EoFBluEepZyKW1EV1boQdjoQ0Y=
Date:   Mon, 31 Oct 2022 07:28:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "post@davidak.de" <post@davidak.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: Fixes for amdgpu drm buddy allocator support
Message-ID: <Y19rEw0TJJAdSWPW@kroah.com>
References: <MN0PR12MB6101D368C4AE6F2A142F4C5AE2339@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101D368C4AE6F2A142F4C5AE2339@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 06:39:16PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> DRM buddy allocator support was introduced for amdgpu in 5.19.  These two fixes went into 6.1.
> 
> 312b4dc11d4f ("drm/amdgpu: Fix VRAM BO swap issue")
> 8273b4048664 ("drm/amdgpu: Fix for BO move issue")
> 
> They were tagged with "Fixes", but Sasha hasn't grabbed them yet and there are a bunch of issues cropping up lately that I believe will be fixed by them.

Note, patches tagged with "Fixes:" only, get applied "when we get around
to it and review them and think they might be relevant".  If you know
you want these in a stable kernel, as per the documentation, please put
a proper "Cc: stable@..." tag in the commit.

> I didn't see them in the queue yet, so can you please take them to 6.0.y?

I'll go queue them up now, thanks.

greg k-h
