Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287C412E161
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgABAtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:49:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54911 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgABAtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 19:49:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so4362523wmj.4
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 16:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SD975LMxu0NnGhK7ROqIlYlYI5GS041Y+DywCzs6kdE=;
        b=ZZYGKOzYhaSwP1w/1NozSLhirKxT54USWzkPp8VabMwvgBCRJLv67TAuUH6IsU2Xyq
         rbQpsUyf9wA85FM8skAPWP02yRguQ2qYs+lrpVzDU5peOUrh8CB3C8T1423VqOQd6OvM
         oRvQG+CZAQvilT5fKQ0EOK3shtpJDt4BrEPspaDk9bEJTR8LwFpvP4hL9Hbsg/ZcugKZ
         EN7l+7TKeZMELTJLx28AkWDWNVGSjJX1AoF88acbmXxwFKWXvh43ZobWzp5Du0pGhRIW
         WiAmpgcryZlt6Y/fRKARuxdKS7skqN2c9kHjGmYUA7yVhN3TsyONZfL5Ks/YAH+6uLig
         WfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SD975LMxu0NnGhK7ROqIlYlYI5GS041Y+DywCzs6kdE=;
        b=HDr2mIG9r4aKLWba9z5YXW+87/4lxGNAVGeGfRgnbdgLLNnhOIYQFmx6FdS6cuW50m
         PfXYcWoLwrbudv/KJxcFfLI9qK1keFdVjv9m3TQDSXzm3jgeECtg0gkk/AvFG0UuJS0s
         MPNML+CUSOo7el6jyAjMqVLyfm60qvH/FfXcWvGSS/t8a9s/fJncd3DJ0ZMjlxoID02L
         ilw1AYo2eOGgy5bZYVHkbmyMdC6m5WNNR0MMk3d/tf6A55yrv7MYsbCzsTcB9pEOy4rn
         2Am6TBUEjHAugXLSn/EMDA6Xc3sre3HNYAsnosJ5BZTYbygxJnOYZuonCSXXekHaYykd
         uwaQ==
X-Gm-Message-State: APjAAAXWIUcTGG9oH5oTYjHAVfExP9RuilcMPkaqOuXHpnN0zb+rhKzV
        TqK/yz/aP+FpoHeOQm8F0EHYoi7YbSUuHw==
X-Google-Smtp-Source: APXvYqwEHhcsdTVHaPeXazGt/cBlr4/QCd8U88fGJtxeLFOP7ujCiZJrbFhyQKEC9/bQXhpwiCUEBQ==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr12218624wmi.101.1577926183890;
        Wed, 01 Jan 2020 16:49:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x132sm5973682wmg.0.2020.01.01.16.49.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 16:49:43 -0800 (PST)
Message-ID: <5e0d3e27.1c69fb81.3c5e5.b4eb@mx.google.com>
Date:   Wed, 01 Jan 2020 16:49:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-90-g04f3d64d2985
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 67 boots: 1 failed,
 65 passed with 1 untried/unknown (v4.19.92-90-g04f3d64d2985)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 67 boots: 1 failed, 65 passed with 1 untried/u=
nknown (v4.19.92-90-g04f3d64d2985)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-90-g04f3d64d2985/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-90-g04f3d64d2985/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-90-g04f3d64d2985
Git Commit: 04f3d64d298561ffd9f54738444781384adf53f8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 15 SoC families, 14 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

---
For more info write to <info@kernelci.org>
