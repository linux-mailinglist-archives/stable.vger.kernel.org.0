Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BA110D864
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 17:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfK2Q0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 11:26:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34265 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK2Q0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 11:26:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so35845833wrr.1
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 08:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ieUMHSd1zPYYfaUKkn6DqkAclLmylt6F76ziEIKkeYU=;
        b=knEP4OfNyJYD0H96zd6gvw9a6yjaNhlo/6iBI4uS6NvrNgl8LT2HmBdIXgzevVnRlZ
         FE2Kvr0SOrC4ubvsrMjg/PKheCH4lcmxoT5SFovNuP8+8HyCk4zZ0k0syi5IfxA2DMWI
         Frk2al9nSeGBgNOe2Pme+E0h7OfyRRx/Mj2xFODt5fy4n/WPcgbpZJ0Ln6m/N9slyOxq
         A5saQ0t/H2NV9Y+hK9pn8GNZbqIfyj5+9McYr79ZY2yA6Kavwzvb6UoDB/fpCJnXdSyP
         8ogb88FlvuJdbO3QVn0HM1Fm8YzDmVjzQCO8KcKnMWc13rEtSl6/IB8m3zR6xpebZla8
         uShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ieUMHSd1zPYYfaUKkn6DqkAclLmylt6F76ziEIKkeYU=;
        b=ANqnLouMmFTXC9FS2HEj84THkvj93bAPhxHRBGNOevL1Eju7LaO0TRa/KQjuTzSa9i
         63bsEeBk30emCjISv1LNPgAP1OH2XKZ6x3oMXGBRYpyKJzsv1we70qoeMFn8rL/KsCai
         qR9nTAkVwvi10d7964VeWFBZHhm3KPo5V7VjCGE8ezuF4D+/KTCnA6wNtPaediSQL945
         /sxsIP5ps0OMX3r4yb8TbFuJqp/cixisJqEYHT+fUs8QYb0qHNHUq9d9Cj5ThRlJ7nsb
         bZRjgKaldXbvQNzEje6EhIUZEwiP1xMs9ow5n3aLmX8XHHK+Y5XxKEbNT5ZGuRTs3w9m
         Z4Iw==
X-Gm-Message-State: APjAAAWxM8VRDHhPI/OYWBHtJmyql8H+7IJtckAybxZNw2jSHkNJwSkI
        +P36DBCvcoq6tz7OVaYppINdc06SDjxtvQ==
X-Google-Smtp-Source: APXvYqzXQkZp6dZ3xBeFJZ3k+VyXGQ9snckrnG2NCcBds2jNx04spfwHBcPTkVgEv7GFFtbujqanNg==
X-Received: by 2002:a5d:4204:: with SMTP id n4mr48018557wrq.123.1575044764336;
        Fri, 29 Nov 2019 08:26:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm28033676wrp.64.2019.11.29.08.26.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 08:26:03 -0800 (PST)
Message-ID: <5de1469b.1c69fb81.546a9.1231@mx.google.com>
Date:   Fri, 29 Nov 2019 08:26:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.3.14
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.3.y boot: 91 boots: 1 failed,
 88 passed with 2 untried/unknown (v5.3.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 91 boots: 1 failed, 88 passed with 2 untried/unkno=
wn (v5.3.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.14/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.14/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.14
Git Commit: b8e167066e85c9e1e9c5d27b82a858d96e6ba22c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 58 unique boards, 18 SoC families, 13 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.3.13)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v5.3.13)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.3.13)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
