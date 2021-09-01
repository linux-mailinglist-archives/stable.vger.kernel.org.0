Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA73FE2B8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhIATFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhIATFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 15:05:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6AEC061575;
        Wed,  1 Sep 2021 12:04:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q3so255186plx.4;
        Wed, 01 Sep 2021 12:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=AxPYDeiJSv/dmbz8T28Qfe/Oj+46o1Bnyxjlz4pBDqc=;
        b=cjBW0IhpSYLggIxlnqAWsY9I1wm2UxdA/NKN67qvkMwoZG9ypsm8G71z8jDPFJgkm+
         q2yssThueXFVVgNJc4Kgdr1KMHQTG7UdR36y+xwxVUcnFRpUMOFAn/DA0JvQT1FIm8RM
         gi7ml0tVJXSpHcZqQOQyi4bAArsIgrDqHsJ6Pqt/ifIO652x7giNfUrFfy/p4SSA+w1Y
         8SX+RvA/uwe62aO88nnMiFxiTLvIhOdhHf5Yfu1HrL/rpr5Gmpe9vCa5Xu+svFU+ZN13
         Kgvst3oCI0LwENq7elJuBlKBtinUpj8V5vWKuFFXEE3ZcqRTZz8oUQ40CdIId4N1otLK
         +jJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=AxPYDeiJSv/dmbz8T28Qfe/Oj+46o1Bnyxjlz4pBDqc=;
        b=f9QSYxI1HzoAZpo2ruCFjb23woHM6apRj7OFN4/4gMtkOlZXOa0DYk4H1nG9RFGHyr
         QGdUSlsk4CRNaiGF5r3n8gpZkIiZ83D3ZAS1CvHfMfnfAZEWTQJ/Ugdcb6JqoyvIjgDW
         6BJs8sLZwfE2kdg7bFzdFhByHXJFd8Jt1iy5PFPjyVpDi+oAKzDSa1BIraJivvjztG0U
         ICxRO+lFaQNlUShIrk7MBW41Hf5NDqMx6o1byh0fRBmxChc3hh8EZOtWfiZ0KBuRGprL
         t0EbeHYtCi9OzLd/OakX1c0qdepZfOQp2D4HtaG1k2NnB4DsfvVBfF/3bCsUDkC7wVA+
         8A/w==
X-Gm-Message-State: AOAM533Cp6A103SKtqDkfOKQyD5+B2b/mHa7EishQZ9IWe92gxwzppZ2
        c5XD1f0X3b43f7/dcTwR+PaStuGFA8j6mqq3hPI=
X-Google-Smtp-Source: ABdhPJxrP/qMJlcQ2C3HaVuBal+S1tLQfyQ+FdOZhQ2Q8/3tezryw733droFDoVal4ZX8DGNhV6VCw==
X-Received: by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP id s8-20020a170902b188b029011b1549da31mr563725plr.7.1630523073228;
        Wed, 01 Sep 2021 12:04:33 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g19sm264050pjl.25.2021.09.01.12.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 12:04:32 -0700 (PDT)
Message-ID: <612fcec0.1c69fb81.13708.11f3@mx.google.com>
Date:   Wed, 01 Sep 2021 12:04:32 -0700 (PDT)
X-Google-Original-Date: Wed, 01 Sep 2021 19:04:31 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/11] 5.14.1-rc1 review
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

On Wed,  1 Sep 2021 14:29:08 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

