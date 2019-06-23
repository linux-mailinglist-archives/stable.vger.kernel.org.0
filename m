Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEC14FB80
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 14:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfFWMPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 08:15:20 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55283 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWMPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 08:15:20 -0400
Received: by mail-wm1-f41.google.com with SMTP id g135so10176804wme.4
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XPKWOwIbzgsac43t3m4wv2me3z3lnFHPHnm+TNf/1/Q=;
        b=k6Ljp4OIcJGAi2afYLJK0FO3jwQSTFTfDzjA1dh4e6lufSQlZ+RacDHcRfC6OyKN7i
         c5Y4vCLirtuD7w4dMgzHN1DCnEKWx8/5/Rg4D1zhpc1hKxk8sDVxjfr3YVt6bq8rsH9i
         eY5oPrEnTVNjSi1gOACepCZWnpgNyhLaheVtGEaGD7IRmTpbCjEHOwF6UWelqapigZva
         fBkWQUlM+oIA3YWWiV86WzkomnYyspRDbH3uPlk57D05fO3XCxxYKjOEDM3YcHIqR0MY
         SkZcjoQIcX2bE8I1kB2qyfHW90vaqMWON5PNJwClnudKzrR+nOialp9n8Rm7pKxJ9QxY
         0N+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XPKWOwIbzgsac43t3m4wv2me3z3lnFHPHnm+TNf/1/Q=;
        b=tfg01R/7JAOActIBJ80VqclMVOcEZcEWjSWIrh7B1d9wMu+vKmT1c4kZTXfC6u5fjf
         LMjx6HbRV1JIEL/a7AYzzPha9d3LQnSrHji3RKhnwox6ftBDg70yBtygpx/Bi1XE5Pbl
         2aFzJwMYo5VyygnLiN8Q+sAkqniVmfwnnavzVHa+9igg6GprZijSxBqExPCT+1z9xzOg
         AfQKlRzV9rEdkpxX0iTHJZ88O/rOCTO83wk4tpYHq9/BcYNxmeypHmtxf7jN49nYtOvy
         l1aZHrbZN3jGmYCT3fVHm7ZS7TF1EdPb5SHgg5oFevjPu/d84WZv//EEec4Cw0a6A8as
         jO1g==
X-Gm-Message-State: APjAAAW8XqbqR4w5Cj/iNyAulDk8ANrPf1xBC0W/ykcmAECpuKheeMcB
        7p1xqn8LYkMgW1/oLXgDYGwnFXixHNY=
X-Google-Smtp-Source: APXvYqyi+L9kSsEds0NfGqu1rtgwkc//2PhzC2hj+1KKHdRdl9m3p5Oij+9DXMBV3cAd0ojmoaaAAA==
X-Received: by 2002:a1c:3942:: with SMTP id g63mr10660702wma.61.1561292117825;
        Sun, 23 Jun 2019 05:15:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y6sm8234347wrp.12.2019.06.23.05.15.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 05:15:16 -0700 (PDT)
Message-ID: <5d0f6d54.1c69fb81.faa17.c9e7@mx.google.com>
Date:   Sun, 23 Jun 2019 05:15:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129-5-g2357a38ae9b1
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.14.129-5-g2357a38ae9b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.14.129-5-g2357a38ae9b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129-5-g2357a38ae9b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-5-g2357a38ae9b1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-5-g2357a38ae9b1
Git Commit: 2357a38ae9b1367fc761c26c0710fd8960a55206
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

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

---
For more info write to <info@kernelci.org>
