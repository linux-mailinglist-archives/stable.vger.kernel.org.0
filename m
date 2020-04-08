Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D71A22BD
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 15:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgDHNNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 09:13:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41117 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbgDHNNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 09:13:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id d24so2484725pll.8
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 06:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CPbnvzHz9abav4Lh20MndzbocrD4d5seS6CXRNeVkpE=;
        b=YVDQQBON0c5YiEeYK8mndz2WOflOFY46nSrnW5dSJeBfWWtGx3BLfgYU99kbU8GlMR
         1friGB5ptvaGAT4Acm14XWzYp02Uo90CfykFivSLAY3aC+rgDLqFdcMjKPVpTLDiljzi
         Rwj/0PYIiDBd3Dz/7/ylBP8RpyoaRc6eP8TWUyE8gvS6LnowOgNcFRAAO1PFS0/n+mi5
         lN+8s1XjdYM24WcS60Kuk4U5y6Li62FZuB/t+Cqq/bqMTfC3l7peDEsYXb6GhLc3Bdsk
         QU0iNGRcT7BVzoWpdEEwo8WUZpxuJfmCTQJ4JGjzRJxC0tIUa88/iynFjjyTv+WIHZKm
         qK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CPbnvzHz9abav4Lh20MndzbocrD4d5seS6CXRNeVkpE=;
        b=Udqck5Kyw+QHzf+1hTdnwU9dS+bj62NQ7QnqLj6rp2Gl2v4NV8H3UPlPQxN1ShnVTA
         8gCQOopjbcm8knGgiJQ1xmvYRp8PbnhOlMM7yTsBrhuiKDN243GPKuUWv+0mdnXHUEaO
         gdD4jxFJRMzXjQwoMDxUL6nWfewjR5UMjOPBySh2TqZrd3fPBk8gwswObryMAP/suwfQ
         bp+8kSgGZC8oGmL/fQEuO9Soy0AIECw/zCPl3nP1tvBaUEiwrru0q6Am9Tj4bo9ktFjI
         6/eglW5jelqpR+jKWvPr31XBVMlqYM996EL9RNt/iS9l36IcN9MUijRCNkxHWcpBYDFk
         +Xmw==
X-Gm-Message-State: AGi0PuZ4/MyHw4IpYPyRHnE7syW/B8ydg3KKbjxtdDMczNC6SnRYiRdK
        AGs8UddQK3uQpyvYecTccNVQ2ppMz60=
X-Google-Smtp-Source: APiQypIcbp2Y98C9dK6WaaHgtQzpY2KN7QqhmaMz0Q7DRAAdOlxf/o35b1tiId4qIaOwzUc5JzXQ7A==
X-Received: by 2002:a17:902:fe81:: with SMTP id x1mr5128108plm.36.1586351603710;
        Wed, 08 Apr 2020 06:13:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm15605545pgi.86.2020.04.08.06.13.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 06:13:22 -0700 (PDT)
Message-ID: <5e8dcdf2.1c69fb81.7c60c.3a9a@mx.google.com>
Date:   Wed, 08 Apr 2020 06:13:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.31
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 75 boots: 1 failed,
 69 passed with 5 untried/unknown (v5.4.31)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 75 boots: 1 failed, 69 passed with 5 untried/unkno=
wn (v5.4.31)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.31/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.31/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.31
Git Commit: de850633a01fa06515a89a184d6e9769c160d932
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 15 SoC families, 16 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.30)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.4.30)
          meson-sm1-khadas-vim3l:
              lab-baylibre: new failure (last pass: v5.4.30)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
