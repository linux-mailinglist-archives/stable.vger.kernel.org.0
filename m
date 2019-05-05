Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBE141DF
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 20:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEESiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 14:38:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51834 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEESiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 14:38:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id o189so2121949wmb.1
        for <stable@vger.kernel.org>; Sun, 05 May 2019 11:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0hJlSvfxRmu5yQE+vD1MBKRbsaElD3gNuWeHltQWShI=;
        b=q0NJc3VxNei8UKd8znqYswsjyv+hFJRvVnP9CIN4HS7BzF4Rfp12uClYHjMGYIPfAy
         mENztZ9ybGHLL0FaZEG1MbOdKx34lIO4v/aMrlnJSXKBBHbV2F2oGw4Ir+GY+zGfxPjd
         uv5R4oxhQgUvNU6iQuHft3S9i6+Afc1m1NvIst29Vj2eQ218nUI8fOru5Uoq5kqv/I45
         feX4+T+F0P10dk3vmuEV5xgYJ92yyNmDeuJr7bgancYCu4X2fguOt/H4GlN/7xkz65Rz
         j+whO25Q68t++z65XyxtB1JWIVDN6NcmncStryYQg7tguE0k74ykT3ybkQc1wbp04BLX
         0CMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0hJlSvfxRmu5yQE+vD1MBKRbsaElD3gNuWeHltQWShI=;
        b=fkPs9Vb97NNUEw5f6KcVGNQKJXnXWqnYDly55IBXrtIOsTwQpbUQudhvdmbbTBltor
         tlBQjrE2loQtSIEqftf/0GNwxKAgp7Wr4VchJviQumkFemy62X4MCNd0ZFedwqGO1D4S
         JYrIZh1cxA284eu00YJ+6IBFszgHHj4dgH2xVEX6ceglfvRey02ILqogJDwBF1xhKiQB
         lfC35b5w2lU3eW3Y08CWOwFLHSGQLh8Fbz2MfLFuUo5N8Vn4XuCHiieVCk7oYww89cGP
         LoA/wEQGgqVTILphF4LWUR6npCHoYw1o0WyxJ358AqdjfNmrZK33Pz0ocD8xlYt2kGo2
         NMQQ==
X-Gm-Message-State: APjAAAVNxTJ7kozEWdBdiTS2HvlpOsYKq9KtbuRd8qWS5lLWBOi+BRLo
        0ihjKShNJGWmi0CL8M/sRoSO/BBlNzo=
X-Google-Smtp-Source: APXvYqx7OQdO1+H7IQcDmTnEcU+zr3ZeOxLYbF23JqbMduyNkegLt1bMYPWjLKhVuoZsQhqGq9ionQ==
X-Received: by 2002:a1c:4302:: with SMTP id q2mr14061967wma.28.1557081498709;
        Sun, 05 May 2019 11:38:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a11sm6219012wmm.35.2019.05.05.11.38.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:38:18 -0700 (PDT)
Message-ID: <5ccf2d9a.1c69fb81.919cd.005c@mx.google.com>
Date:   Sun, 05 May 2019 11:38:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.13
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.0.y boot: 64 boots: 1 failed, 63 passed (v5.0.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 64 boots: 1 failed, 63 passed (v5.0.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.13/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.13/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.13
Git Commit: e5b9547b1aa39164a8df1d01f2996391c0356d71
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 10 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-7:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.0.12)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-7:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
