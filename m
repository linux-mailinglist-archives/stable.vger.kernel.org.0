Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3748860CEC9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiJYOUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiJYOUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:20:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2352FE2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 07:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA906198D
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 14:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94813C433C1;
        Tue, 25 Oct 2022 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666707641;
        bh=JHDJkfalaV3gpnx44WzkTwfEJUAejzJKWX4Z/74fLNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ylTds2hQIvqWwzQJEOGkD0AeDMvLnQIXQ+5589Bo069VReXBZv4w68ooHaTlSlr+U
         vxVIwMpUI/IXPH/JfO2r1wEtVOKMP43vcdFkgaVvOpX5/OAWlV1WehGKycsuIGCLUl
         MCeGlPOgD2uY6Dk/JvQmapXvDjGVe3S0SN4V87nU=
Date:   Tue, 25 Oct 2022 16:20:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 2/2] Revert "drm/amdgpu: make sure to init common IP
 before gmc"
Message-ID: <Y1fwthEsxJsSqsu+@kroah.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <20221020153857.565160-2-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020153857.565160-2-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 11:38:57AM -0400, Alex Deucher wrote:
> This reverts commit 7b0db849ea030a70b8fb9c9afec67c81f955482e.
> 
> The patches that this patch depends on were not backported properly
> and the patch that caused the regression that this patch set fixed
> was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"").
> This isn't necessary and causes a regression so drop it.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: <stable@vger.kernel.org>    # 5.10
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)

Now queued up, thanks.

greg k-h
