Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD2C379233
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbhEJPQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239238AbhEJPOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 11:14:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13679C056742;
        Mon, 10 May 2021 07:33:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so10447805pjb.3;
        Mon, 10 May 2021 07:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s1tWyxzz9JjqjMPNY7yR/hw/Ij3sEnqX1fLE1b8JmgY=;
        b=iWTB3NELPLLlyhP8hgRpUhb/I+x6zg+dJN2Lq5LzN8OAuFYR9dn9PRJFEVIU+IKICe
         rgRJx3ZkZoeKQXC5/N5dm3183sgRSehcbNOV8PURwiNdLIT7GC01eHBu7L2BhzHS0rXi
         NG5fAl1b7S/4y13szV35ZfNWOBJ+akryfxWSbN8cZgPwxx1DkEKTQxJEF7KoDsAlVgHo
         TtlHdj2zrimzKQamd8oTjQbSkoLDJ43Pwg8CkfMTJSvIWr837PKTLZl3h7FP1cSg5LYo
         7kk43vm8ofemsj0FseHWE1dybrOB6/DT+YpJQKSaV1DxjO+3k6kKee2VzAVNmNGV495q
         nAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s1tWyxzz9JjqjMPNY7yR/hw/Ij3sEnqX1fLE1b8JmgY=;
        b=b1w4AV/Z4/tgsQGxIBFDcN/TKvFU4DTHKOgYdLbNT6EwhTSeQIx8OYhYzkQEjDOGeH
         /4qqlPBHjgtdq0BWq+szjq549dwW1U4/Y4BiZ9wPDGk+VfMFPtuzbqHKEBk1fEGnehir
         +UNK52NbQiBuFzOcrgzcw377XXBRSWlHaKQrAGI0NMdVjN2BfbVQLmVCH+9VN0AX8cfD
         8P9ivq5A7WLBqKlHL4nMwD18rZbvrAeRPbWqmqa6Np+gvQ1Keg0JwZLzFodlXqcBP64V
         1QzNZAZhG3OQEFF+ZJua1ghzX0i7FOUSw1Vzs4mJeFyUmRoBaVAgKiOdNZnfdBc95VxD
         eWBQ==
X-Gm-Message-State: AOAM530XF/3Gk1umhWNXd8ObqLepcwRqXwYwuCBHvzz9mcOdEVtvgE39
        AJu1nE0qsGw3bs3/tmWAF1vm3Rjpu3rbFINtR7Q=
X-Google-Smtp-Source: ABdhPJw7hDWy1Uni/TYQ+pazRbAjsUL4JGRTwiXO19Xl0MGhb5qhamSNNYha9aExVOMfQTeOB6Lcmw==
X-Received: by 2002:a17:902:b209:b029:ed:10cd:859e with SMTP id t9-20020a170902b209b02900ed10cd859emr25030337plr.19.1620657182937;
        Mon, 10 May 2021 07:33:02 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 66sm11201450pfg.181.2021.05.10.07.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 07:33:02 -0700 (PDT)
Message-ID: <6099441e.1c69fb81.cd5c4.1aaa@mx.google.com>
Date:   Mon, 10 May 2021 07:33:02 -0700 (PDT)
X-Google-Original-Date: Mon, 10 May 2021 14:32:58 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
Subject: RE: [PATCH 5.11 000/342] 5.11.20-rc1 review
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

On Mon, 10 May 2021 12:16:30 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.20 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.20-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

