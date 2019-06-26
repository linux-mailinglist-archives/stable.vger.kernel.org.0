Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C9656B7F
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 16:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFZOEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 10:04:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50686 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 10:04:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so2257071wmf.0
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 07:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KAA7L26aqSLCBAG9Xoq6ttW+odbPkhhHG+H1ROISMHs=;
        b=G7idYn2M0hnN//aXmaOwfU0RqWw0g7aQOcfi8OoBld5JgHJe6c8CCMYQq7qOyZoduq
         TQ9qoXGijcICOmCO8EOurpJxwJUHPfP0GaXJHkg/MorwR4WdA4U2cBbWZEa1Nzn0Hy0w
         guhuZegeynal+t5RcNpergYxSef5uxqvrIda4yC8ehDLw4YfQO/5ZX/vCXOVKKcg2Q/v
         jOvQ/9wCETYj3jXIb1LhO09yrqh2hJFvUxVhwIAGNZupxSP0NS4k/Zynm9uaVf8zJRd3
         BxnxIlKkvkzgP5kua/7P+rX06+tswRtP9sc8NzNVw396siANzM0okeCEJnbrs6y1DvO5
         3S5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KAA7L26aqSLCBAG9Xoq6ttW+odbPkhhHG+H1ROISMHs=;
        b=i94Y01HVfC7ejYrv6lx/Rh4qOjb1AOKXAviVYJIDKjarQbIXabwaUWQVuQ0TlmlVli
         5rwr9Nf0vqemJNojBdOQ19Gm+UmpMGGbEfYC6GHQZH6aYxgw1t0G4jZh5g/qbBiWNOhk
         2+658u5YTi+8jrkddVHS/oomrCUquxIUlrp50HUwEoKDt1xIHzoari0hNuFmzE0TKLAv
         +KncA/8+tp0ZB+1z7B53mVGfWRIFFMCewOpy5VwQJtThDIvk9RT/fgAikwR0RdAcq14L
         ylEQMbAsO08XMLPWxaTGFJdHddIfy1K0CTjsWdyc0swuP0SVM1tCdddzTFLbtddX+iJS
         1+Vg==
X-Gm-Message-State: APjAAAVeVnV4AOtokpBUlWv16UTEWhIV1KcuDRvvd1jtRVYPD6sDe9et
        bYKYYFUNx1Q6lG1YwT2d5YD3Q7iz42HBcQ==
X-Google-Smtp-Source: APXvYqw1j487b8sOOpAC3OLeIL/VjyGwLLD2SCebL3O+JsXcPBr/P1r0+PoW4lljpwrn8G8eCGX8sA==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr2804134wmm.108.1561557858824;
        Wed, 26 Jun 2019 07:04:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm18329868wrt.86.2019.06.26.07.04.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 07:04:17 -0700 (PDT)
Message-ID: <5d137b61.1c69fb81.8867.4c31@mx.google.com>
Date:   Wed, 26 Jun 2019 07:04:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-2-g493abc5bd149
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 112 boots: 2 failed,
 110 passed (v4.9.183-2-g493abc5bd149)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 2 failed, 110 passed (v4.9.183-2-g49=
3abc5bd149)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-2-g493abc5bd149/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-2-g493abc5bd149/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-2-g493abc5bd149
Git Commit: 493abc5bd1493261577ac0c23c94c9ca7ab7b435
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.183-36-gc4=
0261803d2e)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.183-36-gc4=
0261803d2e)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
