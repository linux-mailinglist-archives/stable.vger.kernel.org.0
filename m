Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE63C2853
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhGIRek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGIRek (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 13:34:40 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1C4C0613DD;
        Fri,  9 Jul 2021 10:31:55 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b6so1616805iln.12;
        Fri, 09 Jul 2021 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7R/eXnDFe/uefGWsaEjBMEYCuOMTYCee6SzAAPxzjTY=;
        b=J4OcEIcILv/o2QC8UnjogomUhDr3n7+bb0dAUBN/A06bA4wbFydMCnXjTBoZMBI3fm
         BAQPuJx5ILcJHmwBdRziAB34+s8sZ2Zgsus3OCeJg1dDl5n6lGiSE+sxwXYJcC2uMybf
         dUpg7tclGfeREj7SeSUEvMdRA1yFqVrcF0i9G41t0thr1b7NLSJuF3ikMOqQRyFiqI50
         jFjGB6q/8J0mpaXI6TcSF3XOiZuwbrHCK4/KBiKyvcMeUvKt1VryVz++DMiPAEZyqBh4
         giVsxZomTeKGQ5vB58CEom5a4c9z423wmPR3d4SaACPnfobEoXKgPaDcSMl6GzEDjAM9
         y1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7R/eXnDFe/uefGWsaEjBMEYCuOMTYCee6SzAAPxzjTY=;
        b=AXRCdjPtxUBIussK/vv8P9YSrzqrPIOvgK5LRotrmNnASkCCzdTt8XEWnbPsLD6c9R
         njdrg1FNPjOoRQhHulfOthOlqUzWSMgjOUw1NcmBoNAyUKQBHxS1lRaDpKRcTkEIrlUs
         m1MJSoxb5RhOtm7QKPR6mHJKK4QkhC8k+yCysP3y7IDbEm3RRT/XyzXj8OVKKoEKZue0
         dd56hxkJUzI/ubZpP4amwTI1sTxi52KiGTQO0DVfBPOPxDGNH6uYZhnJOxlSu06juO/h
         zdsntTyjcWAM/DZuuJmm3czuyX64ojc6gxLC8SeJrbdUlAQXrG6vFZDJ2cR64OqBHen7
         30ug==
X-Gm-Message-State: AOAM532cx4mE1nnRFXWbPCKc39rWnj+ggEdhEUI1ngXZcXO2pRbxFarZ
        8NjqK8yRZjzzCi02xJOhhCyb/5VUFDHcGcDQQWNW2A==
X-Google-Smtp-Source: ABdhPJzpFYIdrOvUPFSwj5iMJH5ygxCzOBLpPJYgtahTtlleXWpB2EjoaIZXh19qHaZvcMWaP/sG5g==
X-Received: by 2002:a05:6e02:168b:: with SMTP id f11mr22901807ila.6.1625851914414;
        Fri, 09 Jul 2021 10:31:54 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x9sm3261106iol.2.2021.07.09.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 10:31:53 -0700 (PDT)
Message-ID: <60e88809.1c69fb81.65f70.51a0@mx.google.com>
Date:   Fri, 09 Jul 2021 10:31:53 -0700 (PDT)
X-Google-Original-Date: Fri, 09 Jul 2021 17:31:52 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
Subject: RE: [PATCH 5.12 00/11] 5.12.16-rc1 review
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

On Fri,  9 Jul 2021 15:21:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

