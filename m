Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420BC4FDDF
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 21:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFWTpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 15:45:13 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43315 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfFWTpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 15:45:13 -0400
Received: by mail-wr1-f42.google.com with SMTP id p13so11555256wru.10
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 12:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6uMsQgYRT1cJ+otJRvxQ1h/1NThfugGSqoY8qPQQNWg=;
        b=RKRtyywkZHMaPhHvVFfNJZgmCq+k0ZK572OwGBFwA2egRq1E7RVMNaicS9mKdnBC/2
         V7fanFqFRhbcaLOU94cotfqwcdV59hBQtS5VyKVsJ/uXagkbEHrrGQrkn7xFFXjxPxhT
         FuIT8mS3sNN03bU6oyHfwBzPV1I4em3AZVr50UeUGPx0gOfZBaw5KUGBfIHCqTlKiOLL
         g4ZPg+V5LLWgy2urqi3f9Ww8+i0eCbaMfCUDZsG71+6PLzhIlYsF7IffuMQbTm1YyTwE
         xVGZ1hvjPv9i/TdbpcJX4zccGktk1mwKPQ+D7+yCTThH9PSkFYRZrQ2Oe66pxchWJnOt
         65Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6uMsQgYRT1cJ+otJRvxQ1h/1NThfugGSqoY8qPQQNWg=;
        b=fmGie7uAGXidEzZvz17e7Fk19WsyFvZySYb/5e4gWiDkaCcK7p00eg53cJI29bcD2E
         u03F+fmivCAwSzdhwnTl8S0lpvqbvWZUWV1FqJVxW7GPX3Cr+mqrztb//jt3J4EqfP4J
         OzhfaX9JTVc0UYHS+CwHAMwJ0Kcjc4ozNJh/O1Om+1Z+VUjog1n20cs77JtV9iVmPnv2
         ZTQF0pZsGsmqdtMXQ8gSb0FZnkB/rqOwgDnNg+YhPsEBX5rEX8AscDtN+DL4nCmtN7LE
         MhihRRfdvgEWsTMBw9QNR+baqFQZi3fPj4hIp+gmbyO/4A+d4Wtg87Ui+uaMElHEzfvY
         wJXA==
X-Gm-Message-State: APjAAAWSTA1/ieC1udY78psJxj8LiGw9TgLxx7V9SwMdX1yVr6Z1T9rp
        l3L43f50eiMSiNl/OIpfCZjoJSBpwHc=
X-Google-Smtp-Source: APXvYqznPdrg8MAz2yqPU7Psr8i3ItFPcRIIhyaB+AK0yriCQklMuKtDtfT1gGGQi4OMoWjIyYD92g==
X-Received: by 2002:adf:e843:: with SMTP id d3mr28390270wrn.249.1561319110911;
        Sun, 23 Jun 2019 12:45:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm16919880wrh.1.2019.06.23.12.45.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 12:45:10 -0700 (PDT)
Message-ID: <5d0fd6c6.1c69fb81.d0a4a.d66d@mx.google.com>
Date:   Sun, 23 Jun 2019 12:45:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183-4-g393ba32583a8
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 91 boots: 1 failed,
 82 passed with 7 offline, 1 conflict (v4.4.183-4-g393ba32583a8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 1 failed, 82 passed with 7 offline, 1=
 conflict (v4.4.183-4-g393ba32583a8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183-4-g393ba32583a8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-4-g393ba32583a8/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-4-g393ba32583a8
Git Commit: 393ba32583a8a49464ae900619cfd7f5b878e0a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 19 SoC families, 13 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 2 days (last pass: v4.4.182 - fir=
st fail: v4.4.182-85-g847c345985fd)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
