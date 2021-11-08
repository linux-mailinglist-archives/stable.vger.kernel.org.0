Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F08447B9D
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhKHINh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:13:37 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:54571 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237864AbhKHINb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 03:13:31 -0500
Received: from [192.168.0.2] (ip5f5aef86.dynamic.kabel-deutschland.de [95.90.239.134])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9875361E5FE00;
        Mon,  8 Nov 2021 09:10:46 +0100 (CET)
Message-ID: <75e1d301-f92f-3237-8bf8-5f0ab308b9a4@molgen.mpg.de>
Date:   Mon, 8 Nov 2021 09:10:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
References: <20211028142144.210568-1-alexander.deucher@amd.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211028142144.210568-1-alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linux stable folks,


Am 28.10.21 um 16:21 schrieb Alex Deucher:
> The DMA mask on SI parts is 40 bits not 44.  Copy
> paste typo.
> 
> Fixes: 244511f386ccb9 ("drm/amdgpu: simplify and cleanup setting the dma mask")
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1762
> Acked-by: Christian König <christian.koenig@amd.com>
> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

This is commit 403475be6d8b122c3e6b8a47e075926d7299e5ef in Linus’ master 
branch. Could you please apply it to the stable series (5.4+)?


Kind regards,

Paul
