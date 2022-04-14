Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900C3500B64
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbiDNKrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242449AbiDNKrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:47:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941173AC
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB6BB82910
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9448BC385A8;
        Thu, 14 Apr 2022 10:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933056;
        bh=Mz94gdoUDNEkJ85Gh/in1p/zmuHeIqMJnDLSXV/KynE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QGj2p6iDaSHx+PqsENx5PQ5oERzG81jT5Ta95i5OYiBm/YzhQdDE0WnuP29/4c+KN
         clTwqpVZedAwK/N+/3Wa2XIkOMTmlLxgYZmjSNsDMxHv9EedbyHHKzO3PiNk/El1Tz
         mMqmZ+ZaSfYeHG8rvA+YKociRQlSKaPWrAxZ+IaE=
Date:   Thu, 14 Apr 2022 12:44:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4.19 1/2] drm/amdgpu: Check if fd really is an amdgpu fd.
Message-ID: <Ylf6/aejnw+FWZUc@kroah.com>
References: <20220412153529.1173412-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220412153529.1173412-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 04:35:28PM +0100, Lee Jones wrote:
> From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> 
> [ Upstream commit 021830d24ba55a578f602979274965344c8e6284 ]
> 
> Otherwise we interpret the file private data as drm & amdgpu data
> while it might not be, possibly allowing one to get memory corruption.
> 
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: amd-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu.h       |  2 ++
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   | 16 ++++++++++++++++
>  drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 10 +++++++---
>  3 files changed, 25 insertions(+), 3 deletions(-)

Both now queued up, thanks.

greg k-h
