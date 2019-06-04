Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DA34582
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfFDLe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:34:56 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33695 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfFDLez (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 07:34:55 -0400
Received: by mail-wr1-f43.google.com with SMTP id n9so3006383wru.0
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 04:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2rZHWvyGqw1OojypI8vK5lzY+8EGOlkuPvFCu0lWm+Q=;
        b=Hd6QunM/1GKLKmm6ArpTVIgrCr0UzYiNvDH+FKGtmN829WBhzzPmn9P9KGKfBQPCmw
         XiPTjcHkARMABgsF38XbyfXe9PFSb537rT9Nxmml1zIefxhMFMKlSDkbCYd3Q4QmF7rz
         Z5b5I8nYzHpq28SI8BfnWJ8rBEwSzz9hTzVjg+Uv+kjOsT0jyZi5Gn9vmiucByPejGq/
         z6F7Jflu/554+3veEMkSwTqjT5GZ1IQOS/yS6ttw1rXc1petD3twgzAqde1Nql1irW/D
         S8Hc3FsF4msLYwFxOono7F5DSR3i3Tv66HuNVGoa6Ybqgg6ygvnbNh653ntg8uvHT3bR
         55tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2rZHWvyGqw1OojypI8vK5lzY+8EGOlkuPvFCu0lWm+Q=;
        b=Itjxwr6LkxStYuGtTEUKZli88/GDjiG7rmj7qBiFf4FZQJQb1gPcQXAJ93T15D/sq5
         l7tX5nZYZ1Fut8ZRJSv2yYpdzzTyBlC3tuo6HUvEYb1S2fW3VHm74lMfYZ84bNT6hOCV
         YvfeOtTJ+DbKkcauv33Yiz7WFKuRIYn4YL948VbTO9VUHlrrF0clYo/OzM6cxK7vTbSC
         /EDc7lKRoiZkFU68auKPqihDM3Ez6ul1LfwfwLNr9eP3QIfFAvyB5N5uF4EAqaWMB+28
         RPcSIFjABHQYyEFyaYjfgK300sB2ty5MyK/JABMW711b4CN9kb6rJeMArziUd6e6VfB4
         aPYw==
X-Gm-Message-State: APjAAAWUknpOuCA+i6W02Xa422HAWX9ojszr4kMhLwAxa9hxNQh8IJYZ
        /zKv+hF06rLe9n7oljSVAoyW6GZ78PCMRw==
X-Google-Smtp-Source: APXvYqwsZygX37tXS91ouGtVHPn5KiQHd3JDvF9uvoHCEQMX0YjE5gGMOei+E6M47TuFWzlif7Ojiw==
X-Received: by 2002:a5d:42ca:: with SMTP id t10mr1712147wrr.202.1559648093964;
        Tue, 04 Jun 2019 04:34:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s127sm13775182wmf.48.2019.06.04.04.34.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 04:34:53 -0700 (PDT)
Message-ID: <5cf6575d.1c69fb81.ccaf1.9c3c@mx.google.com>
Date:   Tue, 04 Jun 2019 04:34:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 134 boots: 1 failed,
 122 passed with 11 offline (v5.1.7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 134 boots: 1 failed, 122 passed with 11 offline=
 (v5.1.7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.7/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.7
Git Commit: 2f7d9d47575e61225bbab561bff9805f422604fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
