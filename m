Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E118603D
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 23:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgCOW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 18:27:27 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55033 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbgCOW11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 18:27:27 -0400
Received: by mail-pj1-f68.google.com with SMTP id np9so492539pjb.4
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 15:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x1iUKXWbSmkYqTEQAIs/bQSHcihxio/Fk72L9Dmyw38=;
        b=LA4fQzYIEe1l3OW1++aN+OdiEW5owW3TxrfKzYsb9GFLJ1VCyJAjDVmPAZxqFh49+b
         jxrTZzyXYHYhnPqJJlF72v2OVboQ0d8+r827m4gDfDqUsonEINbkQCte9TixWDDYlQh3
         BlwbBioQp8QsmClukGKSDBqIMGQroL30FJqBM0wfDzCOnG6Zpq5awEUwYU39QZgUW9IP
         TXISpdsn0Rm8xa1akW3xe4pcmcIlIFHMKpg7GF5GEvBMhazn+VKr2+YLm/QNd9AWv1/p
         8pDYmp7AupqR8icjdYJdm0qvEDgsA/W+7LSBByKh//bBE0+Hdkix9WcNES9v2OJUjk7B
         b8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x1iUKXWbSmkYqTEQAIs/bQSHcihxio/Fk72L9Dmyw38=;
        b=QzcKsX19dWdYqvPUvea1DL77BHBN44pndtzbF7m7rhhEu1Z56VVLr7T5+MGCmshJmt
         FCWsT8Zm/yrlHRKzDS3WniVekcy0pNuwrbRl7D2P7BBabtODvG29VanL3VWKhSGS0RZo
         3au2BAZnV7NJs5+t8BE5rA1yoi1BMzgNVR/bxhZ4pEDS9AeMHYzCE2u759myuEFvn+p1
         NlUTtFpRrwQThn6AlIhuVXM2zNYEMxxtWke40S/l0K6gqkE25TMaVvPOSTdKeCYHpYia
         a71tOcfGRLYdXz1PbthZ/MbtNjw09MgOu0CA/9X3waTbrfD7Q2P/9tgMaOCu0W4ncOOg
         zXvQ==
X-Gm-Message-State: ANhLgQ1mPUfDMOcDTwqlv5P6MpkAwrCIaZpZ5Fdg3tz5PadRcUJA/wAt
        Q5STfgzgmTqFj1PYSy3DOnGAO1DpIa0=
X-Google-Smtp-Source: ADFU+vvva/C3dnJ4e5djdL+WFHiiVhS4lEcY1bu8AShNq4QFtPo9SB2s1NJie1c+ps5HoHUMDMPrJA==
X-Received: by 2002:a17:902:a701:: with SMTP id w1mr21663161plq.165.1584311246486;
        Sun, 15 Mar 2020 15:27:26 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm11456018pjc.42.2020.03.15.15.27.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 15:27:25 -0700 (PDT)
Message-ID: <5e6eabcd.1c69fb81.4835.9aa1@mx.google.com>
Date:   Sun, 15 Mar 2020 15:27:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-22-g0acb20f67a41
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 94 boots: 5 failed,
 81 passed with 4 offline, 4 untried/unknown (v4.4.216-22-g0acb20f67a41)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 5 failed, 81 passed with 4 offline, 4=
 untried/unknown (v4.4.216-22-g0acb20f67a41)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-22-g0acb20f67a41/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-22-g0acb20f67a41/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-22-g0acb20f67a41
Git Commit: 0acb20f67a41f4c490979b35dca983ad4b3c4881
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.2=
15-62-g1ef447a18aac - first fail: v4.4.215-73-g836f82655232)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.4.216)
              lab-baylibre: new failure (last pass: v4.4.216)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.4.216)
              lab-baylibre: new failure (last pass: v4.4.216)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
