Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA036B8FF
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhDZSe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhDZSe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:34:28 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A5DC061574;
        Mon, 26 Apr 2021 11:33:46 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id i26so2021196oii.3;
        Mon, 26 Apr 2021 11:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vUaGJbHKkoWAmRWfNQvTfl4WwoF1jxmHR4dJv+CwWmw=;
        b=Aajlt0w2/UV1Y86xWLL55728f1WQ0qspAL7d34Iv9mH3tpoLjcoKQfK4FHNsZBVGT4
         0eaLQasubi8qoHJgVvfkaMfq9/SP2VsidtmpoPbrnKB561lKcANpPkgo+DjgDcmMbbd2
         dWcv7UQyC0L4joTGE9FNro9t5hmNsKLKygfhyVFKtvbsovQwyqbY+88VkDMqaxoDt9DJ
         QccdUkfv7B+7TEp/K+fpEcBgr8NQQqgzTSK2PdkYdz02YSKRnYJL3Al9Gi+uGWT10Yjc
         jNSep4LAjzynksa2SIPSDRwlNuJ74IsmfVJCxvxABgPel4z5JFEJnIH4VQId9+UK7YMC
         wVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vUaGJbHKkoWAmRWfNQvTfl4WwoF1jxmHR4dJv+CwWmw=;
        b=iSfSwrEnZ1nip9nLXu/lmCRMhE/5IJrnSpdr5UQu0Po6MdUEea3Q/oDDliXU7fsDP6
         dsku7EZtiT/a9b2ohBMKBtKFj7R4T//II0TSA+zF4zzxLJaGAdABsZI/i/zeDrO4GgiB
         JFIAPRlheEOfM6uLK/o8y/Lu3TfxDqdrm7mi+hoXBPN9fX2nN8aA6+JRy5puUKGghpxA
         b6ZGbnmprElmXTtvH5UG4FKaq+IxQf2EQTKaB9l5aQ8zilQAeEn7yzBUJscRk8SWfn6y
         FBysUUbeUCO7hwZcNtn6P9Oc12HQzwJnSV/EoQtnqROWe7qDxCltQzDE5t2fcO16gX/2
         +vBA==
X-Gm-Message-State: AOAM5325ndxR/nrW/vg1YD4lveiTPyLHOvWxN6rn9P3Hz5dcx1edkjLU
        hmaztGuKDER7hGo5MIOCr9uTf+/yOXY=
X-Google-Smtp-Source: ABdhPJw8Bg9rFhrkynZnWKkti/yt4hHeVt+7fVPlXNulVfw5Etqxg+ndFcyT8DkYzONt2w/uDyxbXg==
X-Received: by 2002:aca:39c1:: with SMTP id g184mr309963oia.120.1619462026302;
        Mon, 26 Apr 2021 11:33:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l17sm676873oig.20.2021.04.26.11.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:33:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:33:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.189-rc1 review
Message-ID: <20210426183344.GD204131@roeck-us.net>
References: <20210426072820.568997499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:28:57AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.189 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
