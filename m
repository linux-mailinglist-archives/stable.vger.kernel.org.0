Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848121B34BB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 04:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVCBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 22:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgDVCBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 22:01:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93448C0610D6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 19:01:54 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j7so276649pgj.13
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 19:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=82VxeTJDv/2plcL+9E2PkKwJ8vva6WUTaiV/XYqsAdc=;
        b=CJr3CcU9Hj0/nm2b1BQY/P15jQKvu5cYjdVRjoR7t3lGI8gVcWQwF0QacoM7LJ7ZXb
         VaeNC633VR9hfE4ply+AUu7LC07LWOiCz1yRI9QK46mldCQUkBmXjsx6VEZSE6HC5yF5
         IGwUQyuKBnW9qjJhZhzCFGLNyhJ5+iUdtYgH3p96Awrvmv3IXCBYYPndsURJAhRCAaQc
         B0MWIti+xvSJZwHbM6LodJUsC8p+1jW58Ct4ve1ajxyQeXMaRlKlqb2FoNPX5Sjp6NE8
         lanbSOXd43HtD4BAwiQ0sbMBQ2cW4QsOQbNTZo/PhmIuApCtCZEGpwALgGzHJon+aaW6
         iRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=82VxeTJDv/2plcL+9E2PkKwJ8vva6WUTaiV/XYqsAdc=;
        b=OGEvtmCj1ia/UufSyk68aHsfVHYg08pzIpw+i/mBbMQutkG27rR3IoX0F3KIEGfthu
         13T2EEY3ZenZaWWeexAa3qVS+v/pJL7xQ+oICXgizhKHBMHhPm3K6GW4k1n31+mqfVif
         ko0D4AJLQLF0+i6fFBrhsMzjBJuJIfbG/2/X9f6YUff70LWCqUZcpTX2mywHZiBkLoyn
         UQxdYQiG2OnapRiU5pJrl5NfJ0/wYJWx6YitJN3fWDrwX68i5p7ab5W3FW9yAN3YCaSU
         k9XPwDRWv7IIL5mNoC2Aa5QyARK6nDUkjssHQ7woYswFvAVWG0S1PA0o8LaSh+M4GMtk
         vuIA==
X-Gm-Message-State: AGi0PuZnvCh//7odx1iBhBjWYrY/QT6IejpsREP6jBMIoMd6FESosu3o
        PATBNiHbE5BxhA2box6j1AV4G9/4jvI=
X-Google-Smtp-Source: APiQypIMRrN8XMXOVEsaYIfo8PdiHGYlrbXm1VNMQ34ouOBx5Fv3rAYjGh9F2VPSdHq5Nc2IXPrUcg==
X-Received: by 2002:aa7:9683:: with SMTP id f3mr25265462pfk.278.1587520913636;
        Tue, 21 Apr 2020 19:01:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm3757948pfq.177.2020.04.21.19.01.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 19:01:52 -0700 (PDT)
Message-ID: <5e9fa590.1c69fb81.a5633.d6b4@mx.google.com>
Date:   Tue, 21 Apr 2020 19:01:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219-83-g20fbd20eb91a
Subject: stable-rc/linux-4.4.y boot: 64 boots: 2 failed,
 58 passed with 2 offline, 2 untried/unknown (v4.4.219-83-g20fbd20eb91a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 64 boots: 2 failed, 58 passed with 2 offline, 2=
 untried/unknown (v4.4.219-83-g20fbd20eb91a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.219-83-g20fbd20eb91a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219-83-g20fbd20eb91a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219-83-g20fbd20eb91a
Git Commit: 20fbd20eb91a7d43c9c65075db14dca0bdd4253d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
