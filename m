Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1186024C4
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 08:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJRGwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 02:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJRGwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 02:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4A62DE3;
        Mon, 17 Oct 2022 23:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F6E61382;
        Tue, 18 Oct 2022 06:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C89C433D6;
        Tue, 18 Oct 2022 06:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666075973;
        bh=5kBdTUkiPs2hh+mrHHAI/779iU8Ym/D4iAWri5OaKv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMpJXucQPhkD5s93OX/roQZzy6oK9lvt05bJTK//E/xr4YeMPfUxj4GqV7nI+BfmK
         x4EcE1gP+5ah01yJ6ovRU3BaY09NSBLsPUZgG9Px/4SEZvY5+O/Fj3HZBMYprLyUJS
         u2wSRzIvHQiUg9pm28HiCbX3apbfEPRuJ9FtEj1A=
Date:   Tue, 18 Oct 2022 08:52:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     sashal@kernel.org, alexander.deucher@amd.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "drm/amdgpu: move nbio sdma_doorbell_range() into
 sdma code for vega"
Message-ID: <Y05NQkSmGneXt1gB@kroah.com>
References: <20221018010746.603662-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018010746.603662-1-skhan@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 07:07:45PM -0600, Shuah Khan wrote:
> This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> 
> This commit causes repeated WARN_ONs from
> 
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amd
> gpu_dm.c:7391 amdgpu_dm_atomic_commit_tail+0x23b9/0x2430 [amdgpu]
> 
> dmesg fills up with the following messages and drm initialization takes
> a very long time.
> 
> Cc: <stable@vger.kernel.org>    # 5.10
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  5 -----
>  drivers/gpu/drm/amd/amdgpu/soc15.c     | 25 +++++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 5 deletions(-)

Both reverts now queued up, thanks.

greg k-h
