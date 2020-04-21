Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FED1B32AB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 00:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDUWjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgDUWjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 18:39:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796E4C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 15:39:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r14so46336pfg.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 15:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UZlEangIscKijpcIt79ugCM9yuGfkWeuyVJBPSji3no=;
        b=T+f9r2lKRkmNm0rsLBizwKLMQfaeWPMSVCi1h+2UCnFfueYAyCc+hsn7I19Zwc+Dyt
         fIawF0Ai3sDrWDfP4oCNv++lGGeAAX8pfPJmUui3KwOphY58mqInDaYhC3+HBqA8EEmT
         qrXQ+TcrsfycSgK9AuhwWzK3NIKw/Trpeo7PYwWmzUpjbG85Xo+ZcgdSrZCkn3Zu9dJP
         WYlwb/RkA96IIPKbnNj5jF66G1ytgHU2NmTsmRq1K3D1SCsKlojkfjz74+U6bQWTIXzz
         SXvOaf1bZi2yBEweMFBIRWWwrNBkE2wfwwjJO98680M0iFByV3CoDYYF9qlrmeQSJ8Gj
         iSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UZlEangIscKijpcIt79ugCM9yuGfkWeuyVJBPSji3no=;
        b=MAx8y5y4xiQGg7kTKZ7RGVEB3B8sKtjrkbtWCL2rOcXJAqMRZDdK4Hw6BLyPpNsrzf
         rzhlGshgUPp1N9CAQm8vAH3jLO3g7lK1J3NiYpydQ323ftgr6yK7eRBAFG6p9BGD7acE
         YBw1TVc3mf4vHOaKKx/ozKGKMGGJ3lqAm/6x3WkKIL5+rxKZmCYrjQtdIFfZXM1FMlbb
         c8iMCQDlphFhN++fILP6yin03lmb/FjgzHt31lpMED+dCcNbPwDwmxPDYx/ceP0Dlskm
         ZbVlqOvZPcROYD3/PmlHIkd7gcnnzXMG3dYtNH3qAzyBW3PUcotUoeZ4dnw0ZZwaNIl6
         5xTg==
X-Gm-Message-State: AGi0PuaD1YBIhbJdJ05qjixeXA+1prGLvDW7XKQ48vHrb3Is1ioDtNA+
        vG47/N8aOVI6vPO3FcX8jjRVmTmnI+o=
X-Google-Smtp-Source: APiQypIk7/6smXDjqVC28x3Ua8lcRuT3J+yEVIfh2tNoKLaDc1o3GvmpOt+Yslq7Kqwnosgo1FkDaw==
X-Received: by 2002:a63:602:: with SMTP id 2mr23522040pgg.383.1587508739511;
        Tue, 21 Apr 2020 15:38:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 62sm3485513pfu.181.2020.04.21.15.38.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 15:38:58 -0700 (PDT)
Message-ID: <5e9f7602.1c69fb81.d1dda.b502@mx.google.com>
Date:   Tue, 21 Apr 2020 15:38:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.34
Subject: stable-rc/linux-5.4.y boot: 97 boots: 0 failed,
 91 passed with 3 offline, 3 untried/unknown (v5.4.34)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 97 boots: 0 failed, 91 passed with 3 offline, 3=
 untried/unknown (v5.4.34)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.34/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.34/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.34
Git Commit: 6ccc74c083c0d472ac64f3733f5b7bf3f99f261e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 21 SoC families, 19 builds out of 196

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.33-61-gf969422316=
c7)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.33-61-gf96=
9422316c7)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
