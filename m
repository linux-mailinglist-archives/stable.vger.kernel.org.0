Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47088121C70
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 23:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfLPWIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 17:08:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42164 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLPWIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 17:08:53 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so9116345wro.9
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 14:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9TChlZ9TR1L0DOaBhr4tZD1MtAF7R2q3tL9xTSs91Rs=;
        b=qTbiaYtWmeO4sw1AtD73UlWojaaggMmMi5k90eSJ5Wl/I5oB7v17R8LD8UehrmpZ5g
         A+VJ9+WPRedzm8ITgmxkEuTKkywxjmFTJ9uJDul17tw3OCfPpWtISjuSNkVSAAi8d059
         /+5ozbkSpo6Lvgqq3+9QPUj/JcYhhd+pfCvYLbzVtU4bXe2H8zbBdg4xs177u9ALdaMv
         2WxRocSL0c8jRkXHUFZf2BbrL33JCQcgJqUBi3aETGYyK+mTjpLSRQN+rCRpEtl9Xzh8
         Aso9yRHps/8t3W4Vg1II/t8GFvxrIvT01oUxSwN6Yn4U0ZgfsUyO+Av7pjw9TA/h4HDt
         Xevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9TChlZ9TR1L0DOaBhr4tZD1MtAF7R2q3tL9xTSs91Rs=;
        b=pZ1jxzitYkxL8SJkA5pBEGh5focCF2DblnfvXk/CC5noQF3zleipLj3CphGKJ04jSC
         PPFFWGUNQ/vQ45tiD5QD+EpH27ni+1VXCCJM6lZWO8i7LBogre7myllQmfAGaO+YfMgg
         RuMnMdByOVIOf6XDsaJDPW1Ukf6Mj6iiBbjPiaQ0qGOMjT/jYpZ/Mn7UdrS7HeJEUIfm
         aEQTJMEeqP4WGXZp8sC1ZnyzRgf92t2O3Ye2PHsUWSVs0EbS2P+5sZd9ftcg0g7heCVA
         NOxQ1fK7zCG/Ok0J/lddhN90ddENZV46rIBoteygNb5cnexZj/7nB5w462XY+abO9RWI
         ewAg==
X-Gm-Message-State: APjAAAW/ioaV23mKFBp02sFjAWpsoa5nA2sU6Wz0T6szybbMRFqUUVq9
        uRmPNB5s1gp05/AJ71bIozEnhdAU2Ac=
X-Google-Smtp-Source: APXvYqxr4Eav6l8YEd61JQfhPifOrqOUBFlO07svI0QIV7WPcyK9QvTK5+N/J7fW9WUhqAqrek2yEQ==
X-Received: by 2002:a5d:6a52:: with SMTP id t18mr31705595wrw.391.1576534132359;
        Mon, 16 Dec 2019 14:08:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n10sm23222039wrt.14.2019.12.16.14.08.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 14:08:51 -0800 (PST)
Message-ID: <5df80073.1c69fb81.85225.9174@mx.google.com>
Date:   Mon, 16 Dec 2019 14:08:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16-182-ge12e0a991de7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 43 boots: 2 failed,
 41 passed (v5.3.16-182-ge12e0a991de7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 43 boots: 2 failed, 41 passed (v5.3.16-182-ge12=
e0a991de7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.16-182-ge12e0a991de7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.16-182-ge12e0a991de7/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.16-182-ge12e0a991de7
Git Commit: e12e0a991de737260ca6e43045c99826d9ab5825
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 13 SoC families, 10 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v5.3.16)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

---
For more info write to <info@kernelci.org>
