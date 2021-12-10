Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4646FAAA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 07:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhLJGhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 01:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbhLJGhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 01:37:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D87C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 22:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1FEB82674
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 06:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD5FC00446;
        Fri, 10 Dec 2021 06:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639118002;
        bh=SAmRJyNL27/MAOUlcDmn9gN8G4627rEFiE+NiAPqi/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lnS2+r+EM/7CXKFgUgGrLvRkk9IBWXnTbogpi+7QrZtUybePMFRhMyYAhlwo0xblz
         N4umlff28pW2/r50nntJXNDp1YDorbvrJmwApjCcHatTr0FTD6vcy1SyU1ULMF3yWG
         XFtsiY62DzzKpBuo2vXb5c6zXQc7YXlNaz3VF3sw=
Date:   Fri, 10 Dec 2021 07:33:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de
Subject: Re: [PATCH 0/6] Bug:211277 fix backport for 5.10 stable
Message-ID: <YbL0qYEI6YkBRPLT@kroah.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209220956.3466442-1-James.Zhu@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 05:09:50PM -0500, James Zhu wrote:
> These patches are back port for 5.10 stable.
> They are cherry-picked from 5.14 stable.
> 
> BugFix: https://bugzilla.kernel.org/show_bug.cgi?id=211277
> 
> James Zhu (3):
>   drm/amdkfd: separate kfd_iommu_resume from kfd_resume
>   drm/amdgpu: add amdgpu_amdkfd_resume_iommu
>   drm/amdgpu: move iommu_resume before ip init/resume
> 
> Lang Yu (1):
>   drm/amd/amdkfd: adjust dummy functions' placement
> 
> Yifan Zhang (2):
>   drm/amdgpu: init iommu after amdkfd device init
>   drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

What has changed from the last time this series was submitted?

thanks,

greg k-h
