Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB65B10CFE6
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 00:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfK1XCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 18:02:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39514 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfK1XCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 18:02:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so6326971wmh.4
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 15:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UIvWUbQ1kRdlAhreHWRCACQmNqj8P32J/P7DdXS0/Po=;
        b=0QZiba3wnmGg3pBWBUg8O6yO/q28VaqWSYEWU7wberF3NlRXC86OlLoU1bTIfMNudT
         77d0xA22tJ32xbWdWdDeL3e+JQCHPrXEVAxAg3SCcLmR4VkpDS5GnWH1SOkN8s7wu5Qb
         DSNZ5UaU//jz6ztsNJ7AzmPluF8RyxrOKPWtVsTjtZ4R66aSs8HE+rb3OwfKaupUKhJZ
         LRWYBG1EjwJzMjp8OysxycRVLFJUJQovD3yhb05SPjSpmZam1MFiovusV8R4yvSYxgU+
         K5a99j94z+DVwEFi3oYA0pJWiN2btdEJlNYIlov4MIv/25+phSIXmFvRNH/tVNu1wwQq
         BcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UIvWUbQ1kRdlAhreHWRCACQmNqj8P32J/P7DdXS0/Po=;
        b=P78sUMBVVTjCMH4lFdCkBGEteFq0LdwQ0hpuCOnuZHD0tul4SyNyNn8UviAhgJ7pI8
         qCQf20Bu3RJY9lr22Ry5myIoW8983ztcfXo+vtB2SzzeUaKhZ3IVVM70mVnkK+Lmn++z
         YpKojBDS79X4g7503rghAJHgt0eeu8z5XWw/m5tqV13f/u7FJ7Wm1x1O9GSvKIDheTAy
         D9c7maJra57eM2GzJI2GDbeNYFCqcXLmwIHEpFTNLQHkUBYes43sHpwo6uQaJszNpJ0/
         BOKNax3MwFJ2Uuv7X7yhCe74ThBsssw3t3v9+7LjAwY7cVo0NdxJGROp0kn2Y8LqiASZ
         gMvQ==
X-Gm-Message-State: APjAAAV6fZlrfTTcLzPbyJW8UrY3NFmxl5gGwVPuTS2VPcMf1gespG48
        XIW4Uyqg2KL4pg6orB3zjSy9KITttC67Ag==
X-Google-Smtp-Source: APXvYqxgzlvmA6yv5k38g9DvxXpTHf/mvTB/wif5uB2MgzHUii67U3S8ghrT3ATy+kmN3TnfA0kj4g==
X-Received: by 2002:a1c:2b82:: with SMTP id r124mr11832486wmr.112.1574982156448;
        Thu, 28 Nov 2019 15:02:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m13sm11963459wmc.41.2019.11.28.15.02.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 15:02:35 -0800 (PST)
Message-ID: <5de0520b.1c69fb81.1ffb7.dfcc@mx.google.com>
Date:   Thu, 28 Nov 2019 15:02:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.204
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 49 boots: 1 failed,
 46 passed with 2 conflicts (v4.4.204)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 49 boots: 1 failed, 46 passed with 2 conflicts (v4=
.4.204)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.204/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.204/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.204
Git Commit: 01bc6b5c550378f943720a628f1b0809ecc0969a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 10 SoC families, 8 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.203)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
