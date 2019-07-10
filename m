Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0DB646DE
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfGJNSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 09:18:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38370 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 09:18:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so2443454wrr.5
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 06:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X+aKegVaepT4RhBhqpuqIQef6izLuKyav1nJyfo5wUY=;
        b=Laj6kH19Aw0OTQLb+mRnSYFLeinyZRaabqBL5r3j4aL5z7kVF6b8d6UdjKOOMtzX0H
         MiunFKAWntgXm7CEA2DEFMIqeRBYPnLnii7hv/YLkmyeX8vxjZW9diN2mcKcB5fAj4P/
         UcoE7KnegHdi1IP4WySIt/PVROBKCsU+vehj7C+ugrLhFVtQ6iXCQQPN+KyJ+x5C8bmR
         7EXeH+rJ2mtGST5iiHGN4xJNMtS3OA+PmsDrP3oU4hVozeX5bYTM+c177S8UoEEOAfRd
         eXRpBwtAw/nQgH/qW6GdFvdsNHu6iuH6SH+sqQTIhAud0MdOaN5TE+iuiwhjK6scNcSU
         akUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X+aKegVaepT4RhBhqpuqIQef6izLuKyav1nJyfo5wUY=;
        b=F0WlVnGe0SWW4CjZrEephe8MPg7BwqEEAK2NObz4NUWEhQV6HSGVg/ER8/O4zKe3Ct
         bHjzB7B0y7YKCPCp1/tNHHlBH8LrKMbIW3QDNMf91gEMFvyS9PFvRnITmHTBNSNp+/54
         Mtardwf6goSYlAxltY46wOlM+9n3u2T0+bhXky8paBp4Lnr4XnVd5K/4k1O4tL8dSbp1
         SEDFZHIE4lmskO4Hr93Qand//pJ8hMihJmB/S+4UgdPPaHKMcmLJipAJhaXhBXC2K1IA
         MeVcGh03HwuoRCjnvPSLnd02peq24tVD5xbackUk9/s8zm2IFyxaktTM90ZK+RVURcH9
         9EvQ==
X-Gm-Message-State: APjAAAXfgp1adnDoLJ3LA3sf3kziqFH/lLrRG2fL/nKadKFBS6EWNtx3
        v/9yKm5Zu3im1Ww7898aI+hKbONY0Ywb/w==
X-Google-Smtp-Source: APXvYqzhlWGBLFRv0vjRlZhXBO3c6Lmbscif/6Bq36yZroTY0tH8FNCrIpvvMWJ2mlwHHdFBOnr6+A==
X-Received: by 2002:adf:a341:: with SMTP id d1mr10723795wrb.260.1562764700332;
        Wed, 10 Jul 2019 06:18:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u6sm2771882wml.9.2019.07.10.06.18.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 06:18:19 -0700 (PDT)
Message-ID: <5d25e59b.1c69fb81.d2d83.0018@mx.google.com>
Date:   Wed, 10 Jul 2019 06:18:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.185
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 54 boots: 3 failed,
 49 passed with 2 untried/unknown (v4.4.185)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 54 boots: 3 failed, 49 passed with 2 untried/unkno=
wn (v4.4.185)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.185/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.185/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.185
Git Commit: 7bbf48947605d6ccef21a896c4b44dc356dc8726
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 10 SoC families, 9 builds out of 190

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
