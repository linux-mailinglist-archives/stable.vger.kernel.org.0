Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA73BC19C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGEQ0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhGEQ0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 12:26:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D68C061574;
        Mon,  5 Jul 2021 09:23:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l11so11972086pji.5;
        Mon, 05 Jul 2021 09:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WbUrP7Y0sRrdKlqhbUnIPWmq76CQq3wcNWXA/C3ACAQ=;
        b=SaQWmM/rnFUK9aEkYTzgnwU2wnGb50mKTXoxxslKsLDqQ6cECW5e1qFW5Lu0dC20AY
         NHSrrVetjfIdMjjcDleYrJozfCFSi6c8/3QWHPNdQ4fe/vr8DSSdy7JTJTXAnhjLPVVJ
         Ihs4tGDhzgqXuIG9cDviagqLWLggt3Ds1N6SP9604GTr5PMn/zbt5aV8rtq+ZOauSRM4
         w3XFsevpI+reRtuCr/Uy2en6/gVPQnlUx4G5y+pU9hdWW/YEo6KCotguyifnJX/dKnkJ
         rU4yk1CJXjIvlya3Trwgh7WbkFGr6LDrMprR1LdjFERaI6YL2l9Rq+4Ebodv/co8lERw
         a4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WbUrP7Y0sRrdKlqhbUnIPWmq76CQq3wcNWXA/C3ACAQ=;
        b=bTgtTGbFumt1U8F0nACaZaliEODmqwd0QneUtLOR4dkETQq2EmkCIHsTkIQ+1pW7Vs
         LQLk0Aoo2viUyqfBQTXShiIx4YuTUTCrYlwpHuSLcU8+SF8oH1iM1/Hd01w00Ed0d7jD
         Iog9XEKWp1kCm50o4+h3gG+CXciiGvM0G/c0Fn929eGntIlcDxma0WefbjK8+t4AMOCj
         eCnq9qMp08g6rpzHhWh/6ha1w8HnGOk8FvclxulijnUS4WungkBLtcO4uPJLX9tvEZAR
         8gH0yoW68EL2XMR9EHCChJxbgydoBS+ztrDgWva4t8PYAZSMKLZdhO1ers7ESnDQh4UD
         lMEQ==
X-Gm-Message-State: AOAM533Qsn4Nuh6w/fcReQmDVt3cHImRElsfNdEtvn76Fx/NhLmLYB08
        Zq7+c65Xy/hgVjfKsX3DjfhaVdHK1KhmOXES
X-Google-Smtp-Source: ABdhPJzq9GaAjTzYnd7kxHpg2zk+4U3+wITTit/YfGnLQpWA7tjWuiDbupPbXMV9dV08BUrM/Q3b+g==
X-Received: by 2002:a17:90a:9205:: with SMTP id m5mr16183192pjo.172.1625502237152;
        Mon, 05 Jul 2021 09:23:57 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id g1sm3066221pgs.23.2021.07.05.09.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:23:56 -0700 (PDT)
Message-ID: <60e3321c.1c69fb81.a5947.772f@mx.google.com>
Date:   Mon, 05 Jul 2021 09:23:56 -0700 (PDT)
X-Google-Original-Date: Mon, 05 Jul 2021 16:23:51 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
Subject: RE: [PATCH 5.10 0/7] 5.10.48-rc1 review
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  5 Jul 2021 06:59:50 -0400, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.47
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

5.10.48-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

