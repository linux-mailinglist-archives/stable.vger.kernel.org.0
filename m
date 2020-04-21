Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5135F1B3376
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 01:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDUXiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 19:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726358AbgDUXiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 19:38:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F3C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 16:38:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z6so148056plk.10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 16:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3qAgQB/2cTQ+8pckTt5JzpnePe/yQpC0vdtjwhJWI6I=;
        b=N/nYsMwYXvRjazWjHqFnDIMnADrqYTvpKy1gadrjAo8Yv98Ra4iGVLhg8MOuFwfnIz
         NL9axeiuugohv56iAQ4x2Adj7CobMqw91ZoYs2Sgm5PMmSbjsz+U4ao4jZAxdeY2ihWm
         gzrZjnjHNr16GpcmrtjMHN3jRhQjLC3xCIcF9I72AwU3Tgjoc6i+o88vv9It+WCLM0xs
         cJqLhl1J0GRTD/KrTdLNORSNTI2nULUEtynoG6pfqJbx7QNVUHq2e+VdzFJ3uvr+jkTx
         2eMB5QacLkkZNhpOrY0HFAvYbiJcoffZ7V5A/rMoiyzFti3d/gHPLimyan/+duwI9NSd
         45jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3qAgQB/2cTQ+8pckTt5JzpnePe/yQpC0vdtjwhJWI6I=;
        b=Q0o6YlGrcU22awoRNibQ55gwWmCfo7MQHlhJnvMji3SIJGgBJGjM5WwMug1I8U19Ep
         ESphTigaMN8GAY7cHRMdZ9i3E1yq8Bv/YSC2K+UW4sDI7AIacRluEbG7huMTK7DdNU4r
         nNFvEBrQ3vrSVqWtxSaa0E+DTXuohmfdPTum+g1nlaLQApa+FejDaMDXPKcHCj5603MB
         0Ye4DenNa1RszG266J0NctX88Pjkw/ndPjVCk41juHobEyEFG90yjBgejL8nGbS4ApfT
         nT3NoEtROAI3H30ycOdjy0DMPLb1EVJ0yoIC7DFOetUTsc5CYzSHLvbnZ1Z4vpCPf1Pn
         On1A==
X-Gm-Message-State: AGi0PuYGEHYQR2u72nuPJDCglNM9Wv7n458O5oseLRCiLsAewEM1mkfe
        TJQQKGxmDaRnvvJap5gO48VTmAXtGoM=
X-Google-Smtp-Source: APiQypIYuEWMtROElVIRTZU9hDfQ7RPQ+KffrAz0djbrolw313wiAWvshQlv79Z3l6fnLEXiuE8wyQ==
X-Received: by 2002:a17:90a:9e9:: with SMTP id 96mr8614881pjo.41.1587512331028;
        Tue, 21 Apr 2020 16:38:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y29sm3476370pfq.162.2020.04.21.16.38.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 16:38:50 -0700 (PDT)
Message-ID: <5e9f840a.1c69fb81.8b24a.c02d@mx.google.com>
Date:   Tue, 21 Apr 2020 16:38:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.117
Subject: stable-rc/linux-4.19.y boot: 47 boots: 1 failed,
 43 passed with 3 untried/unknown (v4.19.117)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 47 boots: 1 failed, 43 passed with 3 untried/u=
nknown (v4.19.117)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.117/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.117/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.117
Git Commit: 8e2406c851877516f12b7ab4e975d033a6d58ebb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 11 SoC families, 14 builds out of 205

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.116-41-gdf86600c=
e713)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.19.116-41-gdf86600c=
e713)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
