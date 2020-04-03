Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9219D599
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 13:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgDCLOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 07:14:51 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54515 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgDCLOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 07:14:51 -0400
Received: by mail-pj1-f65.google.com with SMTP id np9so2853296pjb.4
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 04:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k36+MI0AOEVjyYJZcFmsXTeTcwuregAAp6ml2N6DZcg=;
        b=cE9jNMSN3q5LXZ2XUHHeaeA75lu0XiMhnejrXO5lqBnY3jKRb5GlhQtGtqBfFE20km
         mvBvjWZCY+38Ae7FW49yAydlkY+iyeRPOUaM7Jfbo0LiQeirIyrScud+6EouinFtBMRV
         nmpKsTJELWiiQ/FR1haE08HirF2um89aIp5OQW51GAvgSL/IEIegMjKk4RMbGyu/hVV2
         QCnhz0e3bMvXlSG9tzL03vLYObKRmlzUHw58QS+hsLDb73ZA9RxTE+HtVEn3kQw7Krke
         wqNuj2eAjS+jDkjoRCwL92hQNNyJHPpJRdSGE8EvyMjqP91HjopuoL+WxM4OnAspRtcY
         JVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k36+MI0AOEVjyYJZcFmsXTeTcwuregAAp6ml2N6DZcg=;
        b=N0KIHj8JiwgdhwAPx3Ejxy2vf90JPRY94/FlSIVENnbkTcwc3CfyRQiAMijILbSJk9
         88wpg9XAjkPN+nwn1JmdzUJBFSKgsqz9TONO6FjGHIWe5D1asHKeI63ObY4nL6Sey+iz
         3u/QE1/KMbayBwsK2bQZSSyZck35qa+lx1HPasB0puA/ZYaZM0S6UKk1V0Ha+TNrdOl0
         Z2KBwPaLsArNGKhKcdrGA2xh3QPj2l+Js+todhcnPeSNM5+GMuTd8av+05GmVSZC5FKP
         jaad9p9bwRlyCXxJpGLCO7Z4LVIKXybIq5+3yD+Pyo/ekbuNo8Yofu8GnsGDWYCC3crR
         X9OA==
X-Gm-Message-State: AGi0Pua2S2gZ5FIHQ5k1llGyPVVQyIO1rYPCQCb7eg8qNo1pKIXdm+Td
        k2LZJUlPNMMtCzutyWeg5GQK8WiTq9o=
X-Google-Smtp-Source: APiQypLxjVQzNIq1Bp/bTquzYTv+Lfeo576OVYnj4jt4eqy0dLdrz2Fds0aFqASTCI3ukkCa9KkO1w==
X-Received: by 2002:a17:902:9a08:: with SMTP id v8mr6731592plp.251.1585912489291;
        Fri, 03 Apr 2020 04:14:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2sm5524329pjl.21.2020.04.03.04.14.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 04:14:48 -0700 (PDT)
Message-ID: <5e871aa8.1c69fb81.8f235.9a20@mx.google.com>
Date:   Fri, 03 Apr 2020 04:14:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 59 boots: 3 failed,
 52 passed with 4 untried/unknown (v4.4.218)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 59 boots: 3 failed, 52 passed with 4 untried/unkno=
wn (v4.4.218)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.218/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.218/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.218
Git Commit: c4f11a973295ba9ecfe1881ede91025b59d43916
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 11 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca9:
              lab-baylibre: failing since 13 days (last pass: v4.4.216 - fi=
rst fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
