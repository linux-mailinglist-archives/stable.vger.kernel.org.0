Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B113DDD82
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhHBQXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 12:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhHBQXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 12:23:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9090AC06175F;
        Mon,  2 Aug 2021 09:23:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e21so20227505pla.5;
        Mon, 02 Aug 2021 09:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=AhsNtCrWUIjxPE8wFi8Jra0QtdDGZE41bJVtx++GHro=;
        b=Vl278I3TfDjiWsHV5ItOpLtHG/bvLEu+omWVVfqQ/Ar0xclRgG6AS+3p9/JaAMuuUs
         hWBZXLu3fx5Z3H1Uf47nnhyPq3Bd/kAUTkAdKc8UlqsoMFl5mRX5dTFnlJ5ya1WfuxzG
         GuXPx5iOH78zFcRiYJ/niz7XnCLRebVVhZDfoUZoAjz+WnRC8Gfzr9KCGKSG4ngJzXSQ
         VS/7/mbCDNzC7mrw9uStnevOk0TkpqrnIMtlXm1RsnasRICEqmibST87rLgrJoVV/dyu
         7pK69E+Sy2w15bLJza1j7InifApeNPD2QvTJeldjEjAcozBnTaldBm9s4fgov2R+ITwj
         SG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=AhsNtCrWUIjxPE8wFi8Jra0QtdDGZE41bJVtx++GHro=;
        b=sUzN25vYgMyU+a3NR1zZGizvGFzm4Nez/GovjDlmk3P18Cf+MtYfiQOw28qXrSd+qN
         Pkt2TdAkBJyW7av0N6LzghqEwbNYjWOU4nlyK64nOdtHGF2FKAbKgb4VpYesiNTZvhBH
         t/Z/cRvEeRP4UvgzGYaLtwR1Idpb1mOU+CbBDJafKuvzhtFNDyiLXDKcGjwgPiHNYFDK
         q3VZyHHz9u2Dwl2p2pFXxixWl3Sg79XXMDmwe30LUyyRjzjwJXQ6fKrZFQuDIBOWg16N
         m3WCdnCABbVFjbJ6GcYn+2Sswx3/c32YTM1d6WcaFJiMGnh+RYTdqBxpSAH7pU4HWaWf
         qvgA==
X-Gm-Message-State: AOAM5303gC53cpPLgrH++lnq51hZEgYsRrax2XS2On/K5mQQ813i3aPT
        nVsycCfBZufgFX9L/57vsVAEmbUFBs98yc6TjEs=
X-Google-Smtp-Source: ABdhPJy8KzDteeghCHNeKT2uu7tqokgHugK1MK/V8k3nVKv/raqsze5tofEeiT6VaZzC+tWRed1JqQ==
X-Received: by 2002:a63:e250:: with SMTP id y16mr990597pgj.247.1627921383674;
        Mon, 02 Aug 2021 09:23:03 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id v25sm12092901pfm.202.2021.08.02.09.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:23:03 -0700 (PDT)
Message-ID: <61081be7.1c69fb81.90c2f.2486@mx.google.com>
Date:   Mon, 02 Aug 2021 09:23:03 -0700 (PDT)
X-Google-Original-Date: Mon, 02 Aug 2021 16:22:57 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/67] 5.10.56-rc1 review
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

On Mon,  2 Aug 2021 15:44:23 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.56-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

