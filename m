Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212D03701BD
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhD3UFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbhD3UEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 16:04:34 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493B7C06174A;
        Fri, 30 Apr 2021 13:03:45 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id di13so1735608edb.2;
        Fri, 30 Apr 2021 13:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cxJex32rxR8tlFBq4aC7WOgpvksEFX8Dh4hj8ZAGP/s=;
        b=pdTmHLbBHxe61x0AS0thxY6cxVNLOcBOaM/c01aeyzaMQ+DytP2s2yOfI99Han+VKs
         eU7E/3gL3dLuzH3AZNsAWw9qLWt80K55qzFHGQCy9zENKFX6FoJMduaYygqVIIoj5Or4
         32KVXEFtPuEWzB6rggx/9TqeeRF734kbyFWHDwNNjUMUJu+BCj0B7w3QHz+ZgpPI0Qdj
         9A9FYOVccHFesq83lF8C4rcAYLTG3GzRQZuNr1v3uW8Z9sEvY7t/g8wGxWtWlpn81XIn
         eeuJ4/EDJ7SmWdCh2Re4nOffSue7muGQc/XL9Ol4wVI6+3fWU1naLIejaFxCoGntQpc9
         DJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cxJex32rxR8tlFBq4aC7WOgpvksEFX8Dh4hj8ZAGP/s=;
        b=Ls6WA1G1y4Lt6snudt1lud6/oo45rYaeUTYfVONNMY9/JsV+B8PCpH2LpRbnSSeK9x
         j1TPB6+FmU3hyS4keF8DvXov5jOk95a2zc9XEPeMR8nfiO9jfJFlI6g6tRGHNtZcuLWl
         mhovuyeDRG/OzaB9jG5IAmJtm2yLR2Wjqd3rrat4GY0MI9qh2yfhGeryXQSqzxMyZzQE
         enx14SGV0fVFrEZobp0eUdvqe/bkXz0S/pKjG/HFkOpUd/m5UZqFflUQUHOIgy8BI922
         0bhLhc3jwE4fTU17NZWH9QDFb3zLdls7zuxnjZI1CYWqCnTFXoOV+2wu/PKyR8oWgKne
         Afag==
X-Gm-Message-State: AOAM530AleYGtxHx6QNWQcXiEKZJYjIvzBQJivOq6MEjXENbrRWAEth2
        E2A4AxS56mtxWyHYDQ7yDiu2wqeVGp8OTfK995pjkw==
X-Google-Smtp-Source: ABdhPJynJ2wYuI00t6QwOXgJNzEFinQU4+myflAg93DSLs9hxV5wkiO89xACT0ooNBk9zUUh1B9TkA==
X-Received: by 2002:a05:6402:17d7:: with SMTP id s23mr8172325edy.66.1619813023763;
        Fri, 30 Apr 2021 13:03:43 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id l7sm2970724ejk.115.2021.04.30.13.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 13:03:43 -0700 (PDT)
Message-ID: <608c629f.1c69fb81.c28ce.8faa@mx.google.com>
Date:   Fri, 30 Apr 2021 13:03:43 -0700 (PDT)
X-Google-Original-Date: Fri, 30 Apr 2021 20:03:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
Subject: RE: [PATCH 5.11 0/3] 5.11.18-rc1 review
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

On Fri, 30 Apr 2021 16:20:49 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.18 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.18-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

