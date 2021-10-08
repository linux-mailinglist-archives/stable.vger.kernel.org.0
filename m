Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD94D426CC0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhJHOav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 10:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhJHOau (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 10:30:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA07AC061570;
        Fri,  8 Oct 2021 07:28:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so9541448pjb.1;
        Fri, 08 Oct 2021 07:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9m//ScOjc2+foBtqzngu6sUkQumvQWbj21pUrbR6Er8=;
        b=q6CUAt0JDFYaVJg7KC0gXgX5EmO5El1avZ/uKy1ZenwMUG3o+G7/oMNcAz7IyW/GZp
         VTaWBH7OlQDqYsiCXFBlUBP3R3SCmQnrlGY1ihhB9vY/7rJmVnm+CqjzcNMloDNovkgY
         FHmQN3wipQU167nZFe9QxptvO/yWMs1bcYcqva8qcpbnOghHNfQzNGFKsJKem3Qgo321
         lNBaQD1OqdNvi7N8dZ6qOi4MgEM8HSYZE4yqyg04k4sAQeY6IHVAqeYoJ1Gyjsh/ba07
         2kQCYKDDhrVQywwZYJyGBMtRL1KHK88WmnHHy8w+v6zxNGqXijO+UaSKF/Cb/vSgoj2R
         JbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9m//ScOjc2+foBtqzngu6sUkQumvQWbj21pUrbR6Er8=;
        b=YSEiKzf6XRXTHnDkF+S6ZNATD6F0hHc58J4IBjmpXAVwyObhyRpIZVsaFI1yQ/9Wn2
         cTHzSWM6CL9kc0OEgRH2F6s3wjU5iBnhB64lvx8f89cY+Kwz5ShWXKqj7PFHCa4rniBJ
         dZygr2rbeg+WJQIBxHvx6OR8jEEOvlTaSlMmYtpXhmfD/RMgjCBKloW1Zb9KOFgZqkok
         XiGWAHn0p1COBMC2cKUSpIBFawei9DcT/KZsmbFv79tv2ZVYa0lUYMQet7wFFYzQODHP
         1SZGoX/aodesVhUhi5c7BFTWo1OF6GAndn2FkQnOCXm9AJgCIZUycwRSZ6zWgp8sT3C4
         sctw==
X-Gm-Message-State: AOAM5318i3uv8SX7INC6zeyzkR88QSI93oVA9UN6CWbQs2+F/8N443Nc
        3mf0JXdrEfadpah7pYV5i7lqWnIIQ6xs5Gw/lYE=
X-Google-Smtp-Source: ABdhPJxhwTSPJsqkXGicBNnSLU8g3R02UsXrqwv84ITVFyPOrnLwSILzFsI0pBtwT3WTGHvFG+NKvA==
X-Received: by 2002:a17:902:8b83:b029:12c:cbce:a52f with SMTP id ay3-20020a1709028b83b029012ccbcea52fmr9849047plb.9.1633703334741;
        Fri, 08 Oct 2021 07:28:54 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id y23sm11663726pje.34.2021.10.08.07.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 07:28:54 -0700 (PDT)
Message-ID: <616055a6.1c69fb81.2d36b.1609@mx.google.com>
Date:   Fri, 08 Oct 2021 07:28:54 -0700 (PDT)
X-Google-Original-Date: Fri, 08 Oct 2021 14:28:52 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/29] 5.10.72-rc1 review
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

On Fri,  8 Oct 2021 13:27:47 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.72 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.72-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

