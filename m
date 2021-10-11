Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475A429724
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 20:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhJKSxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 14:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJKSxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 14:53:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BBBC061570;
        Mon, 11 Oct 2021 11:51:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q12so10924375pgq.12;
        Mon, 11 Oct 2021 11:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=71INiUyhWvoA2WMrc2l4AqiYkSvh3djM1g7dHtmJm8E=;
        b=gpxLQOGV3N0JsifWbFaYzoaWbN2UkxAD/TXIYF1U+F0I6i70PLvZCRMyfyyX/GjIsa
         xZzfxp++HIgX/bp3a5X0q53B0nZ2zkR3blyWF14MoPNDSrhxas/QyxkVTHRW/mFWwsg5
         pEAF5dz/pAaU0Am1Xns4za2SHFrQwnOE2cGSLjWl1gAk8FV03tglesp2ahjvtNOU3izk
         4416VKsiE4l1ayp7eUgOgmgEKFJP/8QdYhWst6mM8nmhesMjeszoDAi3akQ327xLjBzv
         nC2V1RyW3+dv0JLiNSiiHAVwu2ix2HPQHngKtzzuiXmLj8isA/GgpxDe7c5RWF42qlxw
         sr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=71INiUyhWvoA2WMrc2l4AqiYkSvh3djM1g7dHtmJm8E=;
        b=UGx3r6Ei0D3PBlSxjLagehzq6kD+OQWoJ5E0tdPBZDxhArpCT/u7n/Fw2FOSJrYRxB
         AGNNi7OCdW9kk2SvHswne+m7HrysnLml7S8Jc31QShormHsJcKdLl0FbEC2puD41mKtD
         pKShkINA/RJNCEnxPPv7jsnt7xanGwCyJrw3cv+DjCWW4rp2YmHlCSj7V1TNyVtYdvxo
         rbNo0rqb9g9kiJqqy5cmkXeprQp/m0gQcddX0XWqqNkY/ZNOahp2EaF5uOSTXBidixPR
         B0ikmAKAAR2cc+5vshLJgPA2AKf4y/HccjEKcEY2ET+zPou7TKVnKheJu1JXJqNVv21j
         QwqQ==
X-Gm-Message-State: AOAM531of7w0n6+2UxL60BKR7Er9WMEv4q0/AcZuEUdPkau10laVi/RF
        yIsM1ktwq0fhQfIVjwQw5jLCvQG0RCev1XtFY9Q=
X-Google-Smtp-Source: ABdhPJxXf3DNp1AvT3jMFAvcdd/qgIShlphFfsi4ojd3KmlwzYe/MFocMY35W4xknBw/5F/LPJgeSg==
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id l18-20020a056a0016d2b0290300200b6572mr27354855pfc.62.1633978307450;
        Mon, 11 Oct 2021 11:51:47 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id u2sm184868pji.30.2021.10.11.11.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 11:51:47 -0700 (PDT)
Message-ID: <616487c3.1c69fb81.b594e.0f26@mx.google.com>
Date:   Mon, 11 Oct 2021 11:51:47 -0700 (PDT)
X-Google-Original-Date: Mon, 11 Oct 2021 18:51:45 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211011153306.939942789@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/82] 5.10.73-rc2 review
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

On Mon, 11 Oct 2021 17:34:39 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.73-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

