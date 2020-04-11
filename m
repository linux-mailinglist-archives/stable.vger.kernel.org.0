Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0658C1A53CE
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 23:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDKVhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 17:37:24 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52579 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgDKVhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 17:37:23 -0400
Received: by mail-pj1-f66.google.com with SMTP id ng8so2217575pjb.2
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fvtMeRxrwOKnTtF3beAPwO99cg1cjjI1HYUqwbOql/c=;
        b=RbLXM4/rThhJiRSAXjYyD3U4jUqQ7J2KRKRvkARBhHwXQLUAVksmDSmZwUQmDhrqVF
         RXv2FgqZGbeKqV5PC+PiJrKc9B5VaqURZPJXJANWspPGvly4HQ4s5yBMvNrFqu6H5LeV
         HYmNgckCX3ZSglsa4Z3f2vFsRsBoZ+8cLvqD4AsuRKUcDkjyGIPovF4GTdESZOXTl8XA
         n9+HYR9b5JtH5qJOQIexEvhQzQuP1TKmXH0IU01kYGHP5tNE4kDxFuwc595GlleTp2it
         Cdi55DdVugkMCa5LjD8JF8WvHMXmIcSyyZmb1XqfAzfJMD6jIIELMT1o7RBocvBLt/gS
         /Urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fvtMeRxrwOKnTtF3beAPwO99cg1cjjI1HYUqwbOql/c=;
        b=rsQsqZKiNRn2BizXa6KVXEFkdoDDNAGng8ZwzdSGrJPHuy8j7v+vG7dYctnnop4IZ2
         I3ilUkZ77ZEsnxcILh6qduLGdlCtKahGHe1Lg+cuJFSJyyiZTevS5aMhZiMy/vzrDksI
         lHsZIpRK3d0WlCbXRkM96eQ6kwn9t4kfYYf4cpm8ESE9510QnBW79o09mvCQW1fzlyDe
         dAc+qHt/FWo/d2NKPz3BE9FfR8KQt5steXQyguddav4gjbk8g2wUQEkUCS/2YrMzuFfp
         /Oogbvce5/T7RN5KNrBkS1Mp5UayQJg/1Hwzq+a6jBc1mc0GmV/KBvsUml1mbtLtBJ6I
         Fiuw==
X-Gm-Message-State: AGi0PuZ+3dUv3pYbab508PvFuq+p9598S0TNa8rd5Y9a05jS6MSYbHuj
        XAUk4VF/ygNRiBAIdyhepOYaRWFL4Ek=
X-Google-Smtp-Source: APiQypI399xAJBGjJEPtq6Gw1QSUlwoO9wPSssg4jrmd3gSj6AMLQv4eLd4vOyJbxcGKJKpel+a/8Q==
X-Received: by 2002:a17:90a:3767:: with SMTP id u94mr13448648pjb.23.1586641042929;
        Sat, 11 Apr 2020 14:37:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p1sm5036272pjr.40.2020.04.11.14.37.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 14:37:22 -0700 (PDT)
Message-ID: <5e923892.1c69fb81.e4990.02cb@mx.google.com>
Date:   Sat, 11 Apr 2020 14:37:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-81-gf163418797b9
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 160 boots: 2 failed,
 151 passed with 2 offline, 5 untried/unknown (v5.4.30-81-gf163418797b9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 160 boots: 2 failed, 151 passed with 2 offline,=
 5 untried/unknown (v5.4.30-81-gf163418797b9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-81-gf163418797b9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-81-gf163418797b9/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-81-gf163418797b9
Git Commit: f163418797b9310a9eb4a73c3d0214a7cb415a12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 63 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 3 days (last pass: v5.4.30-37-g40=
da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.30-54-g6f04e8ca535=
5)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
