Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089343C60C1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhGLQsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 12:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhGLQsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 12:48:41 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E747C0613DD;
        Mon, 12 Jul 2021 09:45:52 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s18so3556306pgq.3;
        Mon, 12 Jul 2021 09:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7pq8R6jRwoZPf2bIjitckxvVEVRXcdFqf06sAGGo4XY=;
        b=GnfptJYNzvvv8z4T7dwkBoDY0+CwmkwYvVvtTvzfaXJWPph3neX0/RinotcGljQ4LB
         LDsw3xZJ5ZY6ZYsyvVmdozDlfMGoeNn8YVIlH17gKlBVXAVSrdfIGJG8HGbb5RaSq7eJ
         MOCaKTYOBQrXcjm+LdqoH2BH/LO+DGnqCdM+RuR17C+QsVgVknrbs0ATj99cCG/oNhOl
         pY1yTsT56qHPFFHTGgsTUi1TysZGw2o5SYxkZImZmx69iuqqOBe5FPqtkNcrUvBAuqK7
         eqAIq4aRXt0AX6dE5FpJr4MF3y+LBm+upRP0jy9WUCPxRRklAlEKrQSerU3Bf+xhuPRl
         t+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7pq8R6jRwoZPf2bIjitckxvVEVRXcdFqf06sAGGo4XY=;
        b=hanzWjp5fue0eCndAEJwlLVkcX6PYdjOfy81xj2+hfccy1cY+aSGPOQ8Ci5UqsBxuX
         kbl8iaifvy46pva4+YqCLlx8bvHvgGOVe47qhRdZaGGE+jmDsBwFvU8rnvf8F6vHsbpj
         OVKBEhZGkwM2UhEpfdRu8+u4/dZvn+IRNyFZSWxgMuvgg5U833+dUvw4Vad+EV0L/Y9l
         WQcZTUWAH5IeK8BUAxn7U4TDR8dXZHMu/uxjvDimpCGVxQRiyBYXO4SiABbdyhDIyAxD
         8k6xGwMdVcvQsnxf71HtymDOrluSK7Fxc9OJkhDQNIKvUwadiG3GAaLm6mMO1v0CHOBK
         dq6g==
X-Gm-Message-State: AOAM5307iqTcc05PiEYZ6/7rF7+kgUw22GF+o8NrAaG/+YKNw13Trjux
        XW17yCoH0/zFj5/HXh1JGPBVWkOcAx6tBSIg3KMFvQ==
X-Google-Smtp-Source: ABdhPJz2h8XNjHUN2/WOX5r876bCIaF6ybvj6TCwY7kk0O7inb5xWZSxphYxkQ0pwugrd1uwL75dlg==
X-Received: by 2002:aa7:8d5a:0:b029:302:e2cb:6d79 with SMTP id s26-20020aa78d5a0000b0290302e2cb6d79mr53490837pfe.71.1626108351527;
        Mon, 12 Jul 2021 09:45:51 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id j13sm386550pjl.1.2021.07.12.09.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 09:45:51 -0700 (PDT)
Message-ID: <60ec71bf.1c69fb81.8aba0.1865@mx.google.com>
Date:   Mon, 12 Jul 2021 09:45:51 -0700 (PDT)
X-Google-Original-Date: Mon, 12 Jul 2021 16:45:44 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/800] 5.13.2-rc1 review
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

On Mon, 12 Jul 2021 08:00:23 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.2-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

