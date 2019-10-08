Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD45CF00C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 02:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfJHA56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 20:57:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47031 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfJHA56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 20:57:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so17270084wrv.13
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 17:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vcx2znhFA7fNRFtWB4PnFWwsAnkGhsL1J7hP6Jz4W4w=;
        b=K92Jbdme7LnOL0zXgkw/FUEQt/cs9GQ39lPQsXAkW/S9W+0KQrUPK6M0+8J3kw3C7I
         C9PUQ6p6XcKhv2WqwAdPcW7vkb0A4W4f69sNo/exZdEc8nCnnvQ8exXNzp2ROpaEiXVt
         z7N5B7mN/40iUtW1x+CAFMRAFnTNbeSxd7e98CjwHR3eDsoHSr42x8wd6TpFYCsXokD3
         rgcSa86e+fa4PqPXZQaZMNz2EW7x//vVzsBMAczqy7VP2kX4gC44/zyOyjwdJzvS/b7R
         QjCO3USHW8HoXxWjrxCeuB/40BRbAEzffdfVmy2YvmJMehIyXbsxL009rZdLhnRA0NKU
         IAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vcx2znhFA7fNRFtWB4PnFWwsAnkGhsL1J7hP6Jz4W4w=;
        b=ScqnqPl9p0Df1zbEvO16qMsjNEdpXYKM5yanqBB2YDYB//CRAwfzH9rB5iK2aFuxjK
         /uFvn2msyNswR+ffRKv3muFxELElUpS6fnXKQySKRyWBKu/INzGLBJ6t9upAMWVgGl0Z
         Uv7lCyPzBW3A3HMZ/LFRMZgTkKhgAVyuLEMbNIdUqDDgCaNWSULprLsczjxbZYZEET8q
         V4vIQbVX9bZKhjSct6HR449WJfCkUU2Kj1K/H84SsboNxA8NM0rdKVfSj+ngE4lRZdzy
         qzUVDoOIu4c6fm3abUhz7Ryuo+oZMm6Wv9Gvk9mWP5PVwcromrOqzruyiRm3Lz0uVem6
         Nu1g==
X-Gm-Message-State: APjAAAX55EDkd/iGdQwpwtvBmg7fUQpvEaZWAgkdY0GNMhjYOLh+Oihm
        EW4LJygC6S5gxOLwrgzIKwau0VJge9O3rg==
X-Google-Smtp-Source: APXvYqxUxrp1VbtL5F10rs/JKDESmdG8w2smXrZKit1AdN0pbrx0XByVBTadE8DCIPcDLoza0G0cbQ==
X-Received: by 2002:a5d:6347:: with SMTP id b7mr19021331wrw.131.1570496275754;
        Mon, 07 Oct 2019 17:57:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm2205165wma.1.2019.10.07.17.57.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 17:57:55 -0700 (PDT)
Message-ID: <5d9bdf13.1c69fb81.c88a8.b917@mx.google.com>
Date:   Mon, 07 Oct 2019 17:57:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.195-36-g898f6e5cf82f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 48 boots: 3 failed,
 44 passed with 1 conflict (v4.4.195-36-g898f6e5cf82f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 48 boots: 3 failed, 44 passed with 1 conflict (=
v4.4.195-36-g898f6e5cf82f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.195-36-g898f6e5cf82f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.195-36-g898f6e5cf82f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.195-36-g898f6e5cf82f
Git Commit: 898f6e5cf82f30ecceeb81b0f2ec112f242e19fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 10 SoC families, 11 builds out of 190

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
