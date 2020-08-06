Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A07023DBAD
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 18:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgHFQ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 12:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgHFQSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 12:18:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87C922CAE;
        Thu,  6 Aug 2020 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596712207;
        bh=1WpSJnuNFc/p+IV7b5/Rw2H5hTobgLK2vWiHD0QpyDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAIb7Zp3VDp9DCgW3ZXW9Lb2bdP2w0xDtTCvInT+jrytNKEkgfc0JkSFiobk1/5Ke
         fBSMHRzUqr+W5GAENk9W9sr9a1S9RtUCeR59uWJpcVoTmbLxiXH3g4Z1yz061OLeYj
         x2mOtvnOl+Dz++w9VaxAsRENciJL/d1YO71C48Fc=
Date:   Thu, 6 Aug 2020 09:01:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/amdgpu: fix ordering of psp suspend
Message-ID: <20200806070103.GC2582961@kroah.com>
References: <20200805215700.451808-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805215700.451808-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 05:57:00PM -0400, Alex Deucher wrote:
> The ordering of psp_tmr_terminate() and psp_asd_unload()
> got reversed when the patches were applied to stable.
> 
> Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
> Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 5.7.x
> Cc: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
