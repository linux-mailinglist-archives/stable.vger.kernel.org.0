Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DD2181700
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 12:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgCKLll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 07:41:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33115 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgCKLlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 07:41:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id m5so1074570pgg.0
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 04:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uPjYut8SZE+rf3uJQybSa+0+kSZVPe4++3fF8N54kyw=;
        b=WmMrGbsTojKkKRjIAzVHbToR+BkxRls4K7ZEajYBLSp8k8a994BkvRzHPj3aB+sZhr
         vm1aCbgD/6eiU5pMAPYRyCZZtZz2wPQBv4iyhzfP0qGtbvNeg8c5hXwyg74BsIDcdKNr
         qKy/5q2WQ/pvetHIVR6P//yOrDK48m0lvtwR2CckNnHQEH3Lcg96fSzifDeVpq7N9drQ
         V83cc40Jhk78i6QGrb3+mskoU4QmVtqm+fiRJfhILIsD4m1XHJbHIjPWLriU6rPq8L8m
         EgfcO7yCxbZ2hMzbg3LF4ujrRt/LqZ2P+9KoJifGBj1pKJDD1J+gtY3XRMr9TnDUVtLi
         bRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uPjYut8SZE+rf3uJQybSa+0+kSZVPe4++3fF8N54kyw=;
        b=Yn1JpL508iGdo/kAd//HJ+z8p/hV5GmrBo4oEZgV14uc8aesNwsHONNPPCws8uVFvc
         TIznSTngpHH4fiWSsexLO3fbSdDyGWG+ttW/pd+rIdwwoH7zxFHi/eHLCu3iLTTyAJKm
         TMD+oIen+KT63OtMyo8gXp86ft7ZCY/SDjIdV16d6TBFA8qjrioMzKVuvQrg4AP75Mb+
         lIQeKcrvv185R0Y2Ta15tE4RELsHybOCYB6H9Y/jAu/oZlxefcOlLfjbYkWzBJvupVK8
         Mem0nYEL8DwdNrK19Zgb2z8AK+HNH+Ge8rFclG7+itKKbxaV3zJin9QlOtFo5TtS3u7S
         uaFA==
X-Gm-Message-State: ANhLgQ2ihAAmDGQv44b8YXW3piBZi3KrZBVApFBehpTBi1fYVBytkfN2
        568t74Ymq/56EzjvlN4QBCO+AWihcAs=
X-Google-Smtp-Source: ADFU+vtiwIyEj6w8N3GOPFuHaYySiJsffqKZouolO/+QIfo6BUdyrnjI3fifVCZOSbRtqccQbnmRUA==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr2379342pfn.13.1583926899155;
        Wed, 11 Mar 2020 04:41:39 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bb13sm5453578pjb.43.2020.03.11.04.41.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:41:38 -0700 (PDT)
Message-ID: <5e68ce72.1c69fb81.6b5e8.1c2e@mx.google.com>
Date:   Wed, 11 Mar 2020 04:41:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.216
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 20 boots: 2 failed,
 17 passed with 1 untried/unknown (v4.9.216)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 20 boots: 2 failed, 17 passed with 1 untried/unkno=
wn (v4.9.216)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.216/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.216/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.216
Git Commit: 19c646f01e4ace1e5e5b3de2749de25bc86b79a1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 9 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 10 days (last pass: v4.9.213 - fi=
rst fail: v4.9.215)

arm64:

    defconfig:
        gcc-8:
          r8a7795-salvator-x:
              lab-baylibre: new failure (last pass: v4.9.215)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            r8a7795-salvator-x: 1 failed lab

---
For more info write to <info@kernelci.org>
