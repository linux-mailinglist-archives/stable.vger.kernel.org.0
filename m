Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB0C1B6E86
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 08:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgDXGxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 02:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725868AbgDXGxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 02:53:53 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04A0C09B045
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 23:53:52 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y25so4363355pfn.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 23:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mscg9w9Q6itD+GPR+DR3xE4GaX5O4CZs6FtB2tgOHU0=;
        b=w9+o6MQHSAzpmeSX3b4EqNUPqDquWZ5MGgKAhHY77dmVKbMc0PF9aeFmC3hyQLmTLm
         EM+V9ShS6A5PZEmeQTQG+G+Nw9VRxEIDdfRsm8YvrMWcD1vakxXFWu0WxW4v0zw739Vs
         WOjsJkLhyRbvXwvD6ni18/3y86AfA9fL+x21Rnp7gljaKoXXln7k6v076aPxiBe442Xu
         5lUyKaffewgp6OQQG+j+/Txw2Jjn7lwpikdpvg8xmYgp06tmeZfbz6QY3J+ge/O1BKhK
         15SB9zAQD4Tn8XtAUoqTvEmymq92PWbJlFprreFeRVtBNlgaB/jh9T63Xuq6sWJnUI6u
         Yo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mscg9w9Q6itD+GPR+DR3xE4GaX5O4CZs6FtB2tgOHU0=;
        b=CgcOo/CCmnJCkDY99GErynK1DwjbffC954RwOnZaRYnLTyAkEBhF0TaSyNhKxpLwFe
         hxLemLRqHIf7nt17kVYcDp+HxwFD+acssxLFDiUqTrpK9rwjRr+PyLQWjoBo3Q1/g4A9
         Ohhs4+JwhYIl5Bpazbzxo5gknmNs7ZHSXGXH7hsq6kehz1vWNJYgwuU7tZEUYLbB07tA
         ylbPvtO0UVIwTchxCe9drRzxOJf8SXY7XQfl936mWYkn2OpplAVXq6qQpyqZGbfxuwnb
         uB1ZsoS6QgYeg/SbaVowqtKTs1SFkRS1gxdDRkkJqnPV/40Dw6WQ8kaDZitUyR4w/jhP
         Mmjg==
X-Gm-Message-State: AGi0PubBWPSJE8R1Ty0tTzfs6/OkgTRj+PbJJ+n+DMf47PoeyySUNuVm
        K3CysKmjPwgkiGfORjmaHOF3aZh2ZQ0=
X-Google-Smtp-Source: APiQypI+YMNm0qlXdTzf2pGqksOdOR19CGcdxZH7SoyfhvgMR8d4Q/hxSjyWedGoh0myselOOXOc1g==
X-Received: by 2002:a63:e4a:: with SMTP id 10mr7613412pgo.90.1587711232078;
        Thu, 23 Apr 2020 23:53:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm4617950pfo.129.2020.04.23.23.53.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 23:53:50 -0700 (PDT)
Message-ID: <5ea28cfe.1c69fb81.15c02.015d@mx.google.com>
Date:   Thu, 23 Apr 2020 23:53:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.7
Subject: stable/linux-5.6.y boot: 27 boots: 1 failed,
 25 passed with 1 untried/unknown (v5.6.7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 27 boots: 1 failed, 25 passed with 1 untried/unkno=
wn (v5.6.7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.7/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.7/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.7
Git Commit: 55b2af1c23eb12663015998079992f79fdfa56c8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 5 SoC families, 7 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v5.6.6)

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.6.6)

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: failing since 2 days (last pass: v5.6.5 - first fa=
il: v5.6.6)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

---
For more info write to <info@kernelci.org>
