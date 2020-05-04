Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE51C49B9
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 00:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgEDWnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDWnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 18:43:10 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51415C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 15:43:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so51651pfn.3
        for <stable@vger.kernel.org>; Mon, 04 May 2020 15:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g1wTE8plm2ysVEvi2Anln3i9noO25q5FqFzMEFmsJZk=;
        b=FNtzIlue0oLw9pvuNrZ3PkppJpWkfHiIEFh58ss5cslSXs2j4r8LYfNqy36fEoVVcp
         IZm94J9ZiMeDkU1+tcM8KYaXdkhlBeCXNd6r0C/WLlQxnbIqGnN3abwTIjEqxEjpnVIT
         5ewVvDsgMNjjJQOg6tRcV0AP7NnlJ9lPSFZgnueK4QOCbtUPTg6UV9jn7Y+6rvFXqYT9
         Qj8oT01D2Heu1QWqxBQlEK8votCiug7IPV3aiwwLZWBoMXaqe4H8yyLGW7MI1lINb+PW
         qnrtEDXDnj6x84Onxp6Iy8he1ssouK5CREpXLZR7xMKL5SYgjg2O+7K4mQum/gRvxHsU
         4DSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g1wTE8plm2ysVEvi2Anln3i9noO25q5FqFzMEFmsJZk=;
        b=uWW3MIptyQkvslmQXwjOUkqmq/hhEq7d+dY5ojyp5c4J7nMYnv4fc93q7n0Vd64Vfd
         6EUmeZ5e76an50xTT0igoM+zV54iftsnFKcC0RvLAGCaelKoGUvNAGRiyZCga6tnD3vs
         kS9D3DSXXMWYqCIyg5OcMgoGYV531GEwCfuJpHpzG68nxoNrkFuQp9HD13GKIO5pFc2R
         J5O/2/W7nM2VDXaIAMPg6M+oWK1qYrSOY6QzQMfoLPPFFHlLFCbyXzV0bPOaUYXP+Ncx
         Xo/cIRL/wb7CaF6z5Szn+sYBQFImbjaChRgp2wC7KYy0zr+O3jeHyQ/kSdcag5GbSpJ0
         zShA==
X-Gm-Message-State: AGi0PuamBz/18mhCbcCZKvn6ktI3S3W5INaqInWK+FYhHSoTWYcW7G6e
        xtLLGAGtK3S1ROSHMWS+XzhLLeJOm/w=
X-Google-Smtp-Source: APiQypKN1NGbad3MUunMTwNYKC7x2j816ROL4I6+k1fmuu78xi63x4p2IDm+B7biHRVhBK4+Bg1ZTg==
X-Received: by 2002:a63:c644:: with SMTP id x4mr416070pgg.385.1588632188500;
        Mon, 04 May 2020 15:43:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10sm42876pju.34.2020.05.04.15.43.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 15:43:07 -0700 (PDT)
Message-ID: <5eb09a7b.1c69fb81.3c1a1.02d3@mx.google.com>
Date:   Mon, 04 May 2020 15:43:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.221-19-gf8abf65f20c5
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 107 boots: 0 failed,
 95 passed with 5 offline, 5 untried/unknown,
 2 conflicts (v4.9.221-19-gf8abf65f20c5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 0 failed, 95 passed with 5 offline, =
5 untried/unknown, 2 conflicts (v4.9.221-19-gf8abf65f20c5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.221-19-gf8abf65f20c5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.221-19-gf8abf65f20c5/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.221-19-gf8abf65f20c5
Git Commit: f8abf65f20c5e9296d6aeb69c452160ab639d8be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 19 SoC families, 17 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 86 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.221)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.9.221)

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
