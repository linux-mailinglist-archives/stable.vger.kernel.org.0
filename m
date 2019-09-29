Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A89C18EF
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfI2SWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:22:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36993 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfI2SWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:22:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so8536740wro.4
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iWdo2A/yj9K3gO2CytmPraC+Y9NF8pY5rQC3t7tZxA8=;
        b=hTjNynS43qgOYIm+hcXrAgAMGptZnr7EOwRTlRoPgWo0nCejvM4sz2c3lK0SwfT+fS
         qEiEt503fEWiMKipsYabFVStJqboFcwxSiasSJIdG4CMWiDEV0STDIOgoO5V1r9DzHFT
         AEBrz7YPTYWYz2EbNNNYPopRydo9IU9qtLgg/W7dMXSHgn+wqEbdh4oAfcuVBEbV0SK/
         uMePZ0N5x1J3/lXRS8BDtSIf9nL4C4Ng4jW2jjXlcG8lVrpU9RfXgEoo7p/r0yP1K7/m
         fwuY2m9jtCCmekLpvgpRhtc5WjXo1iKCCS5JatQH7fyqx63s868cn6qSybn3ap3pogBZ
         o8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iWdo2A/yj9K3gO2CytmPraC+Y9NF8pY5rQC3t7tZxA8=;
        b=lW2UCVkOtD3bXGFP1ohl5HjhbUJj8BEhrt+HXCypgDzUrRGFhDvzmZNkvM6EA7m4gd
         QsCEV+1kINhRjBPeH6iu4I4xxnybLnwOQWJd8VLtCygjNnG+4tP1L9z/BTJULQT/x2Cq
         3ljkYX6EpUKkL9Uka8Kl87cG6dLVn6r9vyYiuBfuonPFbMLK3a1Qbl4cT2Bu5AAJ33qD
         +J6JqfIycnS4dRHVJBUVJ4ZW4ett+ez9WUQ6HvzP230CoqKgcEVdvARey1MZ00/r//Kf
         GgqVUA90gNheOAWggyHCfyYTsVPCHfyuW6s4Q8miaH/gOY/fSnFC1J2RIBoYaIe7TVff
         uZpg==
X-Gm-Message-State: APjAAAV4wgi23oYmnqzgMtYWiQ09HvnWErhAtqybcxr7Uwv7yUZUSg3i
        WFcjrk1Qj4SaEyqmUGqBN4W1g6dR7PE=
X-Google-Smtp-Source: APXvYqzQ61DBpbW7qfsxA5PW/7dic1x658ZZxgaHqO047BT197xODCpU3Ws3Bf7ln3p/wV9ksC2PuA==
X-Received: by 2002:a05:6000:82:: with SMTP id m2mr1280777wrx.241.1569781319284;
        Sun, 29 Sep 2019 11:21:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y3sm29321809wmg.2.2019.09.29.11.21.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 11:21:58 -0700 (PDT)
Message-ID: <5d90f646.1c69fb81.b7385.156a@mx.google.com>
Date:   Sun, 29 Sep 2019 11:21:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.194-20-g3f17648f516c
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 57 boots: 3 failed,
 53 passed with 1 conflict (v4.4.194-20-g3f17648f516c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 57 boots: 3 failed, 53 passed with 1 conflict (=
v4.4.194-20-g3f17648f516c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-20-g3f17648f516c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-20-g3f17648f516c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-20-g3f17648f516c
Git Commit: 3f17648f516ce7e3019fb144952b97d9cd688da1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 10 SoC families, 10 builds out of 190

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
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
            lab-collabora: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
