Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006314A9FC8
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 20:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiBDTL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 14:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiBDTL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 14:11:59 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AEDC061714;
        Fri,  4 Feb 2022 11:11:59 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id m185so299763iof.10;
        Fri, 04 Feb 2022 11:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1+NyZmvJ5imcvYz0mjqJyn7nLXDdeawn4nWcdKVYu3c=;
        b=M1BA9bwUbcXZ8g74zYTQmw3ZLqcsjD4lj3yPE8XU8d85lJFWzRQFo5HqDXV5e0w7vl
         2/9huNKBafJ2V6MwpOhybRwsKVWUTBA1HIN8cjsKEODWfvliJy8ogm3uKso9RUUbsm2P
         MrkFq2rAaqxF0O/lYm13y27I9/Q+DEz6dfAWI/w46IwbEAE1RAtsvxnvsNyVYpdVaOf7
         SqeX02W3rGaUxVTboYFUEqmiQDfnpfoKeH6KxuwffMUZdWT8tl9ebVYEXjr81cZo4unm
         AucNOABPvxI2jJeXGTrYeVsovczo7zAHwnoyAGGWNmnvw37/nsb1Im0ASxM4Yq/hYZMJ
         wSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1+NyZmvJ5imcvYz0mjqJyn7nLXDdeawn4nWcdKVYu3c=;
        b=rm9IvfOyIwFldWudf+lzwg7aeBX/+bRrMhEv0+uTwYnX/xuiXOtxVVku7q6DxuL02G
         Ba0hZQVGYpyKt+clKRwAa4rqOnHe6L4usZ6121kQuCCVat+/aRBH16U07EOI/9Z9QvY2
         IMbStIS9NNd4ursMiLDjgt2sMncY0qnTR+QSkdi0EiISYUDQyUdASr3oAEq21wIIKE5T
         P69vbbW6WoJbVF3+FqrfCgXin/UDR6m3bKCoBLTsUF/2P7QdqoeOzH2OLYqB+DpuA8TT
         rUQXlmv9XGL0dZWuiX7OD2YvNHPsa9zjiwjHb4MV/24AcCZ54QloV/HU+IUwSNdy1rmC
         s9+A==
X-Gm-Message-State: AOAM533kgJqJlidpFtS33GVmjVIUI1Did56eHtGaasxreJ64aZrmC3CW
        vc6lCUYF+5ZeU38CzZMDtAQG5NfvcqUyE5ndOhP+wQ==
X-Google-Smtp-Source: ABdhPJxl/Ch/r1JMlpIA7tMXijp7AdPbC3h2+8uPe1dtecM4U/6XZN6+dveiUDRn7gl0n98oZggiKA==
X-Received: by 2002:a02:7424:: with SMTP id o36mr287805jac.159.1644001918464;
        Fri, 04 Feb 2022 11:11:58 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o4sm1280666iou.42.2022.02.04.11.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:11:57 -0800 (PST)
Message-ID: <61fd7a7d.1c69fb81.8245f.7346@mx.google.com>
Date:   Fri, 04 Feb 2022 11:11:57 -0800 (PST)
X-Google-Original-Date: Fri, 04 Feb 2022 19:11:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/25] 5.10.97-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  4 Feb 2022 10:20:07 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.97-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

