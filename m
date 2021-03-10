Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3183A333D3B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCJNDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:03:03 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:58750 "EHLO
        nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhCJNCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 08:02:30 -0500
Received: from [192.168.15.1] (koleje-wifi-0044.koleje.cuni.cz [78.128.191.44])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ledoian)
        by nikam.ms.mff.cuni.cz (Postfix) with ESMTPSA id 78B622803F4;
        Wed, 10 Mar 2021 14:02:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kam.mff.cuni.cz;
        s=gen1; t=1615381344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=un/5UZjRn4gYkqxFK4G17AulEHU5k9ci4WXFFPWHjoQ=;
        b=K4xAU1iZrZNpABwJVPeCRAfO7zLa4L25NhBRbU/d/KmxS6Msg4kQ3TH3Lf3vYVjhcehID9
        ewnhwDrg7k7KEZ8msPyGjHfuomaJlOlsBZBxjQio5wjdnotpNgk/I9qvFoaNLi+DP1hM4t
        fSM7zLLhVmdvaLvZwDPPBU99vo0EOlg=
Subject: Re: [PATCH] drm/gem: add checks of drm_gem_object->funcs
To:     Alex Deucher <alexdeucher@gmail.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Alexander Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>
 <e7f0747c-cb10-692a-aa36-194efcab49ef@suse.de>
 <CAKMK7uEMgV=EN7EJh6tzpP6b0x4MX1on9Xoz_zACZVyMK-+QyA@mail.gmail.com>
 <5bd3c672-3277-69b5-27ca-898c8cb79f9e@gmail.com>
 <CADnq5_MyLatUasyU0W9_zQDSrkzfe96NP0YHkom6tthZzf3yvA@mail.gmail.com>
From:   =?UTF-8?Q?Pavel_Turinsk=c3=bd?= <ledoian@kam.mff.cuni.cz>
Message-ID: <d6e92dd9-4ffe-0e5e-2bc5-d424dc464e6f@kam.mff.cuni.cz>
Date:   Wed, 10 Mar 2021 14:02:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CADnq5_MyLatUasyU0W9_zQDSrkzfe96NP0YHkom6tthZzf3yvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: cs-CZ
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08. 03. 21 20:20, Alex Deucher wrote:
> Should be fixed here:
> https://patchwork.freedesktop.org/patch/423250/
> 
> Alex

Thanks, it works for me! I tried only the first patch from the series,
the rest didn't look relevant to me. I can try that too.

I didn't test it thoroughly (I don't know how), but the issue with being
unable to start X.org is gone now and the kernel doesn't complain.

Pavel
