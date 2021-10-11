Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE804294AF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhJKQpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 12:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJKQpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 12:45:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE57C061570;
        Mon, 11 Oct 2021 09:43:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h125so5339420pfe.0;
        Mon, 11 Oct 2021 09:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/0i5k6aKisDUE+9IIy4WbounRGjdngVpSCYlq3tcyfs=;
        b=F5g+k8CwuG0tYqeLQKpOObY+2GJe4s3fiI8e+wK4ym6Jfn7WcHt1xiHfUpcp9p/+ZS
         QRZt1kqtqFylzGFscDg5EOkwJdr0gH0GOWOanJRNYLIqD6/gxnC+OwFd1vItdk2AW5g4
         65zQ3WiK+SbkiJ7P0O/JEvv+sgBY2yYL859gokRHNGJd4M2h880psTdxO0pL3/rYitM9
         D1O4VQGaX0FHqRvxUypgH3zMg3btPoXis8bow3D52phUujmeIVvHhVy0QbmNvsvTTU/J
         q+lP2NGBQ7kNgHD0zt4F+oE37cxdGTcn1Wb9SuH/mbq6B7F08e6TI06SLhtgPYMvYXug
         q9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/0i5k6aKisDUE+9IIy4WbounRGjdngVpSCYlq3tcyfs=;
        b=74S9FGkNNPOBhFFy9BisfICzIZN+Kfc7v6y2Uki1y2nqpuztceF/9fIePgYVum6m72
         raAdn5nV3N3Pb651/j7bmLX0p/VkKx1I/T4TNd6jrIpktAecFtbVBn/hAW6kIoFIqPjT
         U3jE/FXUPpsOgFWdHOwtNNflwt8p+6tG2QOEI37p5eL16hh4j9itzmAPZCYl44YuT02f
         SyPtYg39EUKpN+P1eONbDRwxxj80wtJgMMhABAQgQ2cWHO1UjpSB1p+pkQPljo3MO53C
         bNLTks+3sb3J+4m00T/QuVyPmiARof6LLhK/gaveh3iFKJhyig1bEeIka1MgfQtz/cAw
         24Zg==
X-Gm-Message-State: AOAM532EIUOagMm0qL0voXSdlXKRoch9Vtr+TyBig9p2k7RwPTqEMUEb
        5r7myh/68nZLqn9N92jYh8/uhZ7b2x2NgaHNoVI=
X-Google-Smtp-Source: ABdhPJwwZ25lGQlqvdtL90uSW3R0bBR6XRixp7aC9KdMamTO6mbJQjuOpGF+YsJQ+foSGfC6BKTlog==
X-Received: by 2002:a63:b34a:: with SMTP id x10mr18966406pgt.473.1633970590618;
        Mon, 11 Oct 2021 09:43:10 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x7sm8378190pfj.164.2021.10.11.09.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 09:43:10 -0700 (PDT)
Message-ID: <6164699e.1c69fb81.170a2.6b79@mx.google.com>
Date:   Mon, 11 Oct 2021 09:43:10 -0700 (PDT)
X-Google-Original-Date: Mon, 11 Oct 2021 16:43:08 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/151] 5.14.12-rc1 review
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

On Mon, 11 Oct 2021 15:44:32 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.12-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

