Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9FFA5EB1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfICAvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:51:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33035 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfICAvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:51:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so15551144wrr.0
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 17:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=funYT63YcZCQodshKxXaWJZ130AS9mYvNRV/Z26BEYE=;
        b=MSW3CniLAwBa2MjKFI0mNhz0dDoHQmKbV7C/Xza9QUuvgKBz+rrvhbE0EQ2Oc+ZQkN
         wz3VzNKo2uk/WKaKeHQ5QVL4OHGyH2JUnit2CKHO7KinChLHRVlWROR2zHsFG5boSDqy
         ZYtheyoQ2KSk3+if418sWWPywULORX/eeNy2+iVME0kDVmK5yALZqhuDCriSUe66419n
         rt7ATa3+fji3TD7dkNEQO/RSloM07I+gq1ZkGcZfVxQ/Whf03IMxpo1b3xvhCvxUE5wT
         Ng6qAnnNABx3pmYqOOSUUwNIhmAuka50oq7ekqY4Fq8bvkRzWydpfUopY6519xJnIss+
         yiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=funYT63YcZCQodshKxXaWJZ130AS9mYvNRV/Z26BEYE=;
        b=a3IzFkge0yQFtffqcY4rw/1xJxLsqMrcTQZwJl0X54TPfQ2qWVzoBYA1QQWcQEf67x
         AQmRPKdGYcoZv3txq7VFlIbHGyPWFk1P3/gfxnvIJZk7TgbupTgKt4fm5Kc9VyBN3jY7
         bEW57VHZpMGNWFK6b9NWc3UOqonC+loz0/h1Y/N//PCkS2XgaKcNSopW7KyZR4Isnt6m
         7KDW1QLLr5oE4Stb0tRpOTkT1f4JvWpD2J6mhrhLDzL5Suzjsj7TF2aQRpmZpJy9+snB
         ZBAqshaIfugi4vzw9BruE/XdiRAsLJfd2WfG7ihD2iin8rs7h2pxJtazVvD6bHqErzep
         IvJg==
X-Gm-Message-State: APjAAAWBRIwUJlzC4MaUaiMROaiuCp2I+QDqIG+vMSJZJ6p7nW2sRoSN
        q/FGYCcLwYstAPc/BAW9QhfY6887d58FNg==
X-Google-Smtp-Source: APXvYqzwFp8hNroFaBaFqfUe7201zdjwKH8Vj5+erRV7n33+fINj8N/VtfFdvM5l0YBKZKC7WJVr4A==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr18531933wrv.206.1567471889708;
        Mon, 02 Sep 2019 17:51:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c6sm22697910wrb.60.2019.09.02.17.51.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 17:51:29 -0700 (PDT)
Message-ID: <5d6db911.1c69fb81.44f28.f7dd@mx.google.com>
Date:   Mon, 02 Sep 2019 17:51:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.190
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 5 failed,
 80 passed with 9 offline, 1 untried/unknown, 1 conflict (v4.4.190)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 5 failed, 80 passed with 9 offline, 1=
 untried/unknown, 1 conflict (v4.4.190)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.190/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.190/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.190
Git Commit: 5e9f4d704f8698b6d655afa7e9fac3509da253bc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
