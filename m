Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6244DD35
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 00:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFTWIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 18:08:15 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:39751 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfFTWIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 18:08:15 -0400
Received: by mail-wr1-f47.google.com with SMTP id x4so4559232wrt.6
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 15:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mbYFTh6bazxqWo9R2yJjJ1/62LryVwqMQHAl8inkfY8=;
        b=nH1iWg2/WZudP8irOTwS576i8o37D2+JHTvirrZ8mjqMlv9i/w6yu+KPqRP5lxFIwu
         1kpQxhep93zJLWfymp1ASOlS3EhOxH5C+d4CZKjEdr2M83+xqiI4DwOBCv1kL8PC5HPn
         etYWs7EOvHAvrdu5Qy0y1qI+PbqO1uzmxSW4V8/OZlvDi4kSgja4cPPwmXjvYfPG3h6S
         ykAyZjkLFVyugiAnY4Jo6KAoLHfI+s+ZoAMyGsSGlp9WyIskyYZ7fKwQ4yzuqmq2aOjo
         +1BegxEIxcE4QE3PHw2oRffcx+E+YpNil5EIDGkMmVPfw+UXpgl1DIsfWs4OpcfG6DEc
         LwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mbYFTh6bazxqWo9R2yJjJ1/62LryVwqMQHAl8inkfY8=;
        b=PsPO/dZ9pNsAtsGN6sg96iQ49sbeM160mmrNFgo7tdxbDmq3XfmQ4OcDvwjEgF4Fol
         Gmu4CkrYETCrOZxwQpz9XV5i0oKJ2ATwj0gK8gvSRkwVoNTyG/KaCiTRVJ+5C9o43aKo
         Xn3T1wWdAZqQ6i5z7/pk/O4wAvAsFlgkjumshL7gRRvpPwZAziOYSpYhtYYhqugnLK5P
         yom192mcaEZGg12/w29BZDjPIZI/B5DGPpdTA46zKBTqClaZb2LRsDSOaO5HRWp1vkxN
         AX92QCCmjqw+MHvvr4NACwJFdrdxdZDC+An9RseCkjxwPZ3axfcUAqf0HtnXTD/otHUa
         oUUA==
X-Gm-Message-State: APjAAAVTiN4gFgVOzy2wVbHBiRiHGCyhDepul+KxE5NJd77h25hCQ172
        sy80mMeZdIVBu6W/bf2+bRSPBU+MA7dqPw==
X-Google-Smtp-Source: APXvYqzgBKTUA/RBg0W9siIey3nrqdX/MAKw8GCSkZDug4Y3OVO0auGfFt4Yp46mxpve+BHdwt7Rtg==
X-Received: by 2002:adf:ec4c:: with SMTP id w12mr17142247wrn.160.1561068493053;
        Thu, 20 Jun 2019 15:08:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f204sm1118798wme.18.2019.06.20.15.08.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 15:08:12 -0700 (PDT)
Message-ID: <5d0c03cc.1c69fb81.ef269.6d2f@mx.google.com>
Date:   Thu, 20 Jun 2019 15:08:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182-85-g847c345985fd
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 90 boots: 2 failed,
 86 passed with 1 offline, 1 conflict (v4.4.182-85-g847c345985fd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 2 failed, 86 passed with 1 offline, 1=
 conflict (v4.4.182-85-g847c345985fd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.182-85-g847c345985fd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.182-85-g847c345985fd/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.182-85-g847c345985fd
Git Commit: 847c345985fd296caa81af3820e8185f0d716159
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.182)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.182)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
