Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D9E51D03
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 23:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfFXVWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 17:22:05 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35257 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXVWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 17:22:05 -0400
Received: by mail-wm1-f47.google.com with SMTP id c6so769348wml.0
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 14:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tws9qiY5N/ZhY40MqCOTTppVMM9kBWmKVDNw3G1Npzc=;
        b=gTjG2BJoVwvO7nPV27f9OHo+1BJiMrYH7IV3LVcBlVtl1RPL70nlGgq3WyhNgBAGe1
         d+m9qM6GsVqgB3eyc3i8wIwzNGKK3/CS0jH+UfCx2LusdymiyB1RtCEPg8fjCP7zAlWd
         FWCcXfHrfEw2qILQCcsragfGocAzv1dEzkHDpGVc7mmsOlsnU99Ue+u+CCIn/ok3E2ra
         J7EVYUaJ0jb00thbXX2wbj3TqfG6EuWF/JcrJJFr1LwcVfGC+j/CBa3wRSUy0js7D3KD
         JAunBbg2p49VhiIcrWqO3PQ0ETxCWg4oWgAaBt5eD8xSzuszUlxY4ieKfb6AUkgqVFBd
         NZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tws9qiY5N/ZhY40MqCOTTppVMM9kBWmKVDNw3G1Npzc=;
        b=OfjH0ialM1/qmhadTdsAWdyC3JXXCY6mz5UAzYNG2+2rPcRlip+FfAW3ELYAsaugjn
         8AUYYDEBFag7Slir85Yeq3yOuZPq0I//hb/M5EgzD76kYb4+9QOmgIwV6l8XT/XkJPyB
         VeEZmJxUi+y56YtAUS8UfsI1550p7q4ZfNVtZI7CXcRBg9TTS+gR7xc1H8M2AFy9kvUl
         ksAHQcJFdBHCnbdspr8luByAwkUvMQHt3oP/pSZ+/A9KniH/VWf5wh2UUxWSlPZnRXXk
         5gGrmOYbf3CtdGgW9smiOo1yO30j2/TxcFzO+EQrsWniq/UegbyGP7hdMN8WQ1al8jsH
         ZuFg==
X-Gm-Message-State: APjAAAWfw7WlwBl2XkXPiNI8OQ+oY23xDSKscdKdXMj8cvJsp+izhZ9U
        jfhMB1VWtzeIzy3OT0r6QO6Neyr2F+fu3g==
X-Google-Smtp-Source: APXvYqxuwZ0Y9Q16LnXO2+InrM611sbYtuYSsi5Y7aTNrF0nF2Mj49yjNIDRZf7x63SVQY/HUzZDvA==
X-Received: by 2002:a1c:c145:: with SMTP id r66mr17020984wmf.139.1561411323074;
        Mon, 24 Jun 2019 14:22:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f190sm586082wmg.13.2019.06.24.14.22.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:22:02 -0700 (PDT)
Message-ID: <5d113efa.1c69fb81.511a6.394e@mx.google.com>
Date:   Mon, 24 Jun 2019 14:22:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-122-g815c105311e8
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 144 boots: 1 failed,
 136 passed with 7 offline (v5.1.14-122-g815c105311e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 144 boots: 1 failed, 136 passed with 7 offline =
(v5.1.14-122-g815c105311e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-122-g815c105311e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-122-g815c105311e8/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-122-g815c105311e8
Git Commit: 815c105311e8cdba0f84293235f6f043152808cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 25 SoC families, 16 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
