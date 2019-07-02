Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22BE5CF7B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGBMcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:32:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37940 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGBMcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:32:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so820333wmj.3
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=e+9jO3EwOEXl25neut37mAgd7vjkxK0lA1LxJ9WXw+Y=;
        b=b1h+VHvQ886TGEE3gxTei91RlQDf6uDPdc2QQ8sEBOswMPiAEny8Cb1pfNT55/2qbr
         JfWzKyP8eg2X+A3THQNjbf70tDKG4baiVKxptDacqyXHg57RmmGQUv2FzghQp+U2Mi5I
         nkNhVXAVSd/DplaJ3ifReQplgl2atQVYAPPlwv+KUvMx6uGAxRdSpDKVhcdNtwDjMObK
         33M46/HoT/Md9nJchWwFwBZTLJGmR76irHCIA/DKZrT/ynWa+b1FE0s3cGnhkfpqSCbT
         k847NZfkTKxVC+Yk9MtVfYCFpMcUhaMROyiV6/a4JGmsOYLE4bUBNsLJ90pSX/EaFz1M
         Noxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=e+9jO3EwOEXl25neut37mAgd7vjkxK0lA1LxJ9WXw+Y=;
        b=i1ogZfKhCiQgrA1dcJgXiaJdAC+NcexW18GBVJmYDw7Y4CeMPEUVXCBTL7tzKBL/1i
         x8BlugvpI93J84fTwRBjYb/fefJD35/zITGgYrmBkrVJJwMzMlIfBHgOXAWgW+gWeNj3
         8jKWZ0i6ghrDFJVjrEAkvZh7Kz8uBzmU23j9atxa05zeI4B+pWbGFU/T8tbcIrkiZOLq
         2gZr3Pj1xijsxlypNrDpWgI6lSSbxyHeLOOedQV3uuftx7JzzmKNIHnUqBfOeYs/iLQf
         ovWbw79OtJiJW3vjGDl4lDRO1eeTtTkJ9xt2iYoU3zBSvHgp6SxqwmK5v0WKifjiNZ5S
         siYA==
X-Gm-Message-State: APjAAAUb9yZ9by7uGPVUZ1XsQq72lfe6fG6wpOng1g6RmSi+1UetswcM
        exNQU3QwcnDXy0uLdsIxk7AvXQ==
X-Google-Smtp-Source: APXvYqywUk8zBii4OiiT3yG3VzwJVaWRex6r6j4iXnW3YR6AdgtVeKBWMX0PtFROaZeISnuqkL8mFA==
X-Received: by 2002:a1c:f519:: with SMTP id t25mr3470326wmh.58.1562070727961;
        Tue, 02 Jul 2019 05:32:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v18sm13671226wrs.80.2019.07.02.05.32.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:32:07 -0700 (PDT)
Message-ID: <5d1b4ec7.1c69fb81.790c0.191b@mx.google.com>
Date:   Tue, 02 Jul 2019 05:32:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56-72-g828a73287676
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 2 failed, 128 passed with 1 offline=
 (v4.19.56-72-g828a73287676)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56-72-g828a73287676/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56-72-g828a73287676/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56-72-g828a73287676
Git Commit: 828a732876760accbd58e1c3ce70be8b6ae0c03f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 26 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
