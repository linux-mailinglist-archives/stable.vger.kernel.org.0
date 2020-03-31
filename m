Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3E19A234
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 01:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgCaXDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 19:03:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42428 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731325AbgCaXDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 19:03:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id e1so8754261plt.9
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 16:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RtFFH3hF/rUvh1Zu7+EABeP8ag/2RxcIXnhfFpbz6Ww=;
        b=TKJdOvF2fBeTZPZ+Th59AYjpLHlK8Vf491mrt+c1PyuuelbFVi8JBz8pbITVAP2BSi
         XnSRl/YQPp1QPkimML//0tgJ89nDPF9XhkdpTKMdWizsUIAbb2/7PPT3mFhPAQOqZu/t
         V2xzZPiO/Mq9s6bAT82cqh6gsw1rdV2ByA2F9WuA1TTxtMGlmKrURNYEEZWS1T3l0BjE
         O51fDyrHh7m4YUxrWv+J2yrHQ7Tr0pDWhs1IYyw1/azHgliA8OQ13MLE1jYjCnvRDqdA
         B0++ajUl0kLOfEPr/fK7dqYTOurEf+z8iodYGjSbVxk8VQjl+i7BYwr1qHYdzpPJ/1g0
         hm6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RtFFH3hF/rUvh1Zu7+EABeP8ag/2RxcIXnhfFpbz6Ww=;
        b=hTzGSJT/+SayVcHOQm1adToBKNkcwMm3KHfptKb33LT1fMfb256TPjysSDfsqkEm8a
         9GEJjA7IXWNB1O+km647uIy0h9oVpirDAAmg8LzSjOEONVr8+GqwkUrDjCPV0m5AZpPR
         qnqWRHltRgEAALTRktikoT39kSvDoD7xfPpNjyybkOo6jbgHKGQTLLNMA4XhbZJvnj8/
         S4VkqDytBGGZYfxBjD0od7PStzd3YOrINq/2WfVbo10lG8M+IOSmk4OrVI/litKR36i6
         I8BtBzmxbtUkiehRnL+Gz7Lt0Lj0pvuDq5NXO9cSCvNoQERbzqob8XrEK1vkyEUQqxsM
         QVjQ==
X-Gm-Message-State: AGi0PuabVHv0n1LN8klTRq8z55GX1l/MA2vMyzWo8WubfMU1khwiwqMw
        +rf8MSLauC0bil9HfEhVcIlgLbZPMJ0=
X-Google-Smtp-Source: APiQypKAx76xmfyfURe18oeNtVd5Z/NPLLzt6oKvPOORaYnJaK4JjqZ+E8fmMGzmtD3yjC1ztVbuPA==
X-Received: by 2002:a17:90b:3747:: with SMTP id ne7mr1260710pjb.181.1585695786836;
        Tue, 31 Mar 2020 16:03:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4sm156737pfb.169.2020.03.31.16.03.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 16:03:06 -0700 (PDT)
Message-ID: <5e83cc2a.1c69fb81.9e5a0.0f65@mx.google.com>
Date:   Tue, 31 Mar 2020 16:03:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28-157-gfae891585ecd
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 126 boots: 1 failed,
 119 passed with 3 offline, 3 untried/unknown (v5.4.28-157-gfae891585ecd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 126 boots: 1 failed, 119 passed with 3 offline,=
 3 untried/unknown (v5.4.28-157-gfae891585ecd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.28-157-gfae891585ecd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.28-157-gfae891585ecd/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.28-157-gfae891585ecd
Git Commit: fae891585ecda7f340d1b290d12a36152d913632
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 24 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.28)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 52 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 15 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
