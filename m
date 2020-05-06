Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852521C7613
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgEFQRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 12:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729239AbgEFQRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 12:17:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A37C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 09:17:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a32so1127055pje.5
        for <stable@vger.kernel.org>; Wed, 06 May 2020 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eF+REBENHkpG3sRW9aDInt5MLkhRS3TYxgwz9GIO1Vg=;
        b=ZXpdyJWtFxAaq6TFbKHODLAifMMHMS45c6mKCJXUf/HDwuhDem+sUuN+I/SGzGBIyE
         Yxln8aWAlwe3lmbo666rqna4LniLTjzuY44tx714uNZG43tLKGhhtmd2quBi+qS6fCp7
         mbadfwY/qKTNScNWH1ncMqecWKbpsYzYVOFo9h6MRzY+8Zue8zJVvBwPPvD1l7y/yJQD
         xa9fytWcqJfuGC0OU1nTieVfD4ft3B+PyjfO3TywM4wfmbV1XLwUhtzpd03MuCX7HEQv
         AjnRVg7zOOKLla1I1Gm7ls4UZYd/RcdzqU/grV0QTbZDDg+g03mw5LRb20dS2bUhJCu9
         HwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eF+REBENHkpG3sRW9aDInt5MLkhRS3TYxgwz9GIO1Vg=;
        b=HPZtx+V80QjP8q01PkphZ/QlQ0kA+NN/xdf/tnUgdnyEvtnk9D3Kgju59/TQDEHfLc
         x6lhxLxOpdLSiyp3/DSfYrZDC5utVGuXqaKqR+5k3r23DJ9H28VMHSLKEQUnbImKBS3y
         Dv71CfdH6bRNJsmH8pLkKNH+2QTLBLQBiD57cmsJ6+wd5K2NeZkZjaN+PCVOin768NaQ
         0cx+7/qyZog4ZKn4ZgMRMfiKu3jfpTa7Qsc3Y+kroMaHRpOVAZilkBjzmNCjadLlsdgi
         6m5dmKSy3Mfl/N1uYBLD5T25QdMYSGE27/MxHveBcSpFKvErLLkunuEfGvkGNw68q/zA
         HJtQ==
X-Gm-Message-State: AGi0PuZgWe40RrWHZttaFeD/RSlxmjizYXcEvMDtfE2Wt71Lzg16hbz0
        BDxIGP12EljaERgDXNUOebubMuWTBNDjMA==
X-Google-Smtp-Source: APiQypJS4quKMZ+0Bee/AkHmvc53bffPgBP168rPKWLcHJbWmtiY7yDgZPr29EFaXoIpBajRTtdoUw==
X-Received: by 2002:a17:90a:ee98:: with SMTP id i24mr7905585pjz.200.1588781870934;
        Wed, 06 May 2020 09:17:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm2077068pgn.90.2020.05.06.09.17.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 09:17:50 -0700 (PDT)
Message-ID: <5eb2e32e.1c69fb81.a3c5a.6e00@mx.google.com>
Date:   Wed, 06 May 2020 09:17:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.121
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 83 boots: 1 failed,
 79 passed with 3 untried/unknown (v4.19.121)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 83 boots: 1 failed, 79 passed with 3 untried/unkn=
own (v4.19.121)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.121/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.121/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.121
Git Commit: 84920cc7fbe10e838689e8e1437dfd18d6e54a2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 15 SoC families, 17 builds out of 205

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.120)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
