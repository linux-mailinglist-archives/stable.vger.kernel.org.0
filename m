Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3486138C363
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhEUJkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbhEUJkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 05:40:17 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FA9C061763;
        Fri, 21 May 2021 02:38:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so10691233plo.2;
        Fri, 21 May 2021 02:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=EkiQuoyo34HE9ENeuU8ekv0irucFjDvs39Ey7LGlUns=;
        b=ZlxArrIWqKd4ZPPMwIAWtw87GQTXq64LfRgLKk02s8qXAYNTGOyIN3bOswWa5YXETD
         q7UQnPEQ7pyFk7o1XL/mJqoMl3rrNsKmDs4aUIoYiZp0TRrveLM1p+j+e9EgcGK4v+BV
         dAnRdWXmurY+peaExIwJw4zR8q92G5NSxiEHzwpktKknL7wp5zP6+gTKYOzg2Fu26c/h
         G9rMtfCvAJ9Pr2zJJbICWd847FI5Ac55HO1GqblUEdrBdj3ibk41KS+zBvS1bDZZQDWs
         J56BtYrwZ8ftZxZt/p1KYQssY6aeU71BTnscoC2yz5hEW/cBA2JWg8TZlAClpwAZe8op
         LH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=EkiQuoyo34HE9ENeuU8ekv0irucFjDvs39Ey7LGlUns=;
        b=TFb11Pi1tvhSOleZGAZ7XtCz1MsmsqiL+MrsvwB/wKPUMhyix0lZyh6W+n0XTqdWVm
         HhbjtEhY3oKJOswAWT3pCeVwreVgUd70Pdvr5iAHRYyRJ+2NR2NulFzovNdXBGDA35RZ
         oj7h1KWAWT1UjezJIhA/ZT0qewud8rs5iZqzSD77Eh6WDqwgKqn+/YuWjl3W0qSEtT69
         435gy0xiOJUWZOkpqZTwneWBkaP+XxwiIw0Liogni37RippfmZMO0F0qQyTR7VcIF+J6
         DjINLQ27MTrNosJn6+KR+HlaZQ2l1lPfy09GXlftqdWZstfyePdHtQajeAuHjm1HQvT3
         B36A==
X-Gm-Message-State: AOAM533oo/DjISSB793j9UoO5WAtZyFWGq1pFDeXP3vRrf0MdsrIe5DA
        LfOtsbkiDNmTvGer6px5u22ltgNU0TqHZASZEP6rPg==
X-Google-Smtp-Source: ABdhPJwwhQhISOmGwipYeJlP5MoSnmzi2pxPP+J3qKqprMXVdAvxg4d6BZHKDoFZ9/aFVpqMMkSxFA==
X-Received: by 2002:a17:902:7795:b029:f2:63cb:ab16 with SMTP id o21-20020a1709027795b02900f263cbab16mr11109720pll.7.1621589933975;
        Fri, 21 May 2021 02:38:53 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g15sm3706047pfv.127.2021.05.21.02.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 02:38:53 -0700 (PDT)
Message-ID: <60a77fad.1c69fb81.829b5.d5ca@mx.google.com>
Date:   Fri, 21 May 2021 02:38:53 -0700 (PDT)
X-Google-Original-Date: Fri, 21 May 2021 09:38:51 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
Subject: RE: [PATCH 5.12 00/43] 5.12.6-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 17:23:29 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.6-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

