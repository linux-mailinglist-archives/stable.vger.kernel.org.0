Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE6401F55
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 19:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244205AbhIFRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbhIFRwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 13:52:51 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD94C061575;
        Mon,  6 Sep 2021 10:51:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 18so6111385pfh.9;
        Mon, 06 Sep 2021 10:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TmhcwS8wOEsL1v9BedPAyJQ3YUHw5qlIGkj4YrqEQms=;
        b=nhpVoZu0dtHDgMHrT26QCw/NdU3SLGQBqQzvL/CRj28MqJtsfv8yDTj69AE+ua4UIp
         xIraOZRcuWTDdDDiOk/goQ1GK+HjxEAyE6kuFky5G9pd3Xq6UjrzI3nm+hrt78PLz5ov
         zlGb3d+BWMD6zDX2uxFMeQledH14DQ7xWKTd65xc7J1jk83zhRAijec2tomhD8CoIgWC
         SGcURpQky33hBImYjMLRVj/FNDIN6wB5B4Z+7WVW5T1OwlHjHi1WewXdv432le5sU0z5
         ReIti83hpo71Fr1AcRUnaDoI4AbJUPLs1nMpnyZh2VnqDPL34ASdNacsBHyDU3LCo50W
         usAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TmhcwS8wOEsL1v9BedPAyJQ3YUHw5qlIGkj4YrqEQms=;
        b=IeDli93wczlEaeOWXTtC6XEo+64d7N0pVZnuACTA9OMul+6vB5QE03o52u+WOcwCJB
         drGcCiXhOlqL4a5EckWQrVMpS+Kb4KeRhNh3wrt+f2HnmGHbKhqX4TdJxmWWAbgWrLnm
         KbcOCBMpJOZtoHM+cK/37H2KI/Of1OngaBMbwJMpcetbHNEAkiyF45vTViVU8QdRnRFD
         bXRi+gqJPONEAvsjRT36haQFxAAzNeDixzE39UgFys2W2sqD4WZz8iNXjCDPFKK1nrso
         aN2ueIb9GjfPuKub2EmI+RR+PognmuzfaHuVUqFDVBDRB2eFbttTqwRB5wGXgx5cIuDu
         3c/A==
X-Gm-Message-State: AOAM531MbfYKCYwuffJp+GpsVFGRqfMRPqjMpVvyg6ogEZywSWVO/G/4
        Lkmj0tgQf+Qn6f1u58991xtdW49qmEtjYrQlREY=
X-Google-Smtp-Source: ABdhPJxUgUfIp6pW8Zqch2plZ/5rwGkD2RdzP6SpKWIzfS960FNK6amnhGaQleng7EPfxH3LBdjyaA==
X-Received: by 2002:a63:4344:: with SMTP id q65mr13146665pga.364.1630950705325;
        Mon, 06 Sep 2021 10:51:45 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 31sm10029289pgy.26.2021.09.06.10.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 10:51:44 -0700 (PDT)
Message-ID: <61365530.1c69fb81.af917.c6a0@mx.google.com>
Date:   Mon, 06 Sep 2021 10:51:44 -0700 (PDT)
X-Google-Original-Date: Mon, 06 Sep 2021 17:51:43 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
Subject: RE: [PATCH 5.13 00/24] 5.13.15-rc1 review
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

On Mon,  6 Sep 2021 14:55:29 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.15-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

