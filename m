Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05581C4A99
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 01:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgEDXuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 19:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgEDXuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 19:50:50 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CE1C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 16:50:50 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 207so172653pgc.6
        for <stable@vger.kernel.org>; Mon, 04 May 2020 16:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BA4JbaJGo+sZnmLCaYR27neH2rpI7rmom8IMa+3x0GQ=;
        b=V9zJ8Rxo/1q4pl5rauFEITA6M8nRlaJ6FDpAR1JCUB9gqNI34/INmuNL9Q1K46baBY
         trVS0w50omGD2wVOo8Rg8Yki033xxRVzGk7CQR79Ht+vDj4QGJQuxpL2R1GmrkFQDJv0
         s/BHZpF4JdRA3z/qq0a9oM53REWZlbBuXBU/VkACsVAmmoTnWFUq3FnHBB7UBm4ASmfw
         7x/zs+1kO1fZKgOQUCRZ+7/poqfjaeh0tEz/JY1QK9ApwGCrtJcXo3n33YGWMooXEY4i
         9dL7v7WCNV5s9LruSxKMfS+Bs7N75Nfm1xlGQfQBD7k5Lv3IJWUAFwEAmTiFZ+KiEAXY
         QTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BA4JbaJGo+sZnmLCaYR27neH2rpI7rmom8IMa+3x0GQ=;
        b=cjDUK8sxVrULVFMPuYBYDhHob55wN0W6ftD3SD9QX2XVkdb93vJZzdpclnaPToRBKq
         B+OGLz9ow+MGimeEfkrdVj1JE4f7v338NK6tl23fjAo4Db8z7Pq1hHbIeOUx3YXNAKzQ
         ofe2KwCFthJs7iDJjR5jgjQAvMiw/LlXJybxLu/2zxJpGdbiNtFMdJa8bHrzX+8HaTNS
         SqxfvofCTn+1QBsC7/DMp+DqDpzgBDz8rKl95VimizPmMAQbLP7zk4abPuxvxZoBPEAY
         YMyszbRFaVI4i775c9mIJuToe5CqyGm2U1J7iDxY7mwHnCIGE+6VHfn45FUFu6/21rT4
         +qWQ==
X-Gm-Message-State: AGi0PuYIrtdpHLr5+lqRlwMHMXPkGGOw1bWSB/jI6ImeRo5OIxNL2dPM
        GY6FHnFlZ39WejCwh+Jy2yvT/ZYn/Bw=
X-Google-Smtp-Source: APiQypKoSGx2wZkW1vNYFSDpnP1lu8x4O1581hTepUBD6sYNijw6znLOH5FK93Qk7me/XJei0oVxaA==
X-Received: by 2002:aa7:9246:: with SMTP id 6mr396759pfp.131.1588636249187;
        Mon, 04 May 2020 16:50:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m63sm204702pfb.101.2020.05.04.16.50.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:50:48 -0700 (PDT)
Message-ID: <5eb0aa58.1c69fb81.e10ec.0f0f@mx.google.com>
Date:   Mon, 04 May 2020 16:50:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.10-74-g6cd4bcd666cd
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 156 boots: 1 failed,
 143 passed with 5 offline, 5 untried/unknown,
 2 conflicts (v5.6.10-74-g6cd4bcd666cd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 156 boots: 1 failed, 143 passed with 5 offline,=
 5 untried/unknown, 2 conflicts (v5.6.10-74-g6cd4bcd666cd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.10-74-g6cd4bcd666cd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.10-74-g6cd4bcd666cd/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.10-74-g6cd4bcd666cd
Git Commit: 6cd4bcd666cd831acf192bd7350b94121469ebcb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 97 unique boards, 25 SoC families, 21 builds out of 200

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
