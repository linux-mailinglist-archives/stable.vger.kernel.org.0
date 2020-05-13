Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30801D1A95
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgEMQFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 12:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgEMQFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 12:05:51 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC8DC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 09:05:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l73so1835456pjb.1
        for <stable@vger.kernel.org>; Wed, 13 May 2020 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6vWy5+3An4VDgjK+n1Qfq9M/6QlEqV1u+E2mKR1vqzI=;
        b=Jrk7jtlsNuQUxUvbHK/dN3vSkYB3haWLZdEFwi+F2SsEhBB+DgJSbTcsq3y3lgxgCZ
         P84GLKWBsg8zj+1q4kQX9MumvHQrrD06BzxXF8FFvNOgharXXWs0XJPIShpe2btf9JYO
         mCthR1IWXtSW3oK0/xS/bjcdF4q9hE41JzTKht3tnFcTEBdg+j9eqSA7tgvoUkch2Ryn
         REm4Tp3lve2s2oBicBdGmclbfI/TeoO10cRYvoxGVp3/913eTGmBy3j5520ZjVxBzTib
         Dzz6xfSQ3DKcI3WB18GYafxmSkdN/R4S0z2Z8tLLSUMz0/8Wr11kg0dU7mRYI3ikJue8
         42mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6vWy5+3An4VDgjK+n1Qfq9M/6QlEqV1u+E2mKR1vqzI=;
        b=pSlmoAUZMcxns5OvaBuoO3mueSrncrR0su1JP8CezpPA3xuj251wmB88AI/KZiSgik
         8bkvTiEL7fb+PEGsSD1UBsJlX2PvbiTaqI1V7SkxZQLRZzJrUI5PAfYKwqWZ2qw4kkvo
         STwtHdETWARAXh5WcqHaqKkf8iyMBscN8LP/GU4Q9k+8Gomm+lhk4x8v/dUYsoXHkKEO
         vHike9u6/RZph1tIb2cT78rH5lgMUn41nAm5Jm93RwbXTRqp/hcaIEEdN9axYXJu0ia2
         3zgtMslNPBCFhqJE1vYKa5Fi7PXudtD6D8lo9ogAk14qpNSRI+IR/N2ONAAUvFbqUApK
         MyzA==
X-Gm-Message-State: AGi0PuZgovId55pWxt2iiEdEzcNRlMH+0l7tIsPIhMvNXBe8RnlZ8Y91
        3xtNPqdhi7kixkZultHOQoT1tA3Wp8I=
X-Google-Smtp-Source: APiQypI0Am/Yjiva5fXrKinTX+uak5A0ClaHcKIDHC/6J+mnvnNvITF3ThpV/ken331D/33zNtD4wA==
X-Received: by 2002:a17:902:9693:: with SMTP id n19mr25713880plp.277.1589385950078;
        Wed, 13 May 2020 09:05:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2sm10094pfp.118.2020.05.13.09.05.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 09:05:48 -0700 (PDT)
Message-ID: <5ebc1adc.1c69fb81.518e8.0071@mx.google.com>
Date:   Wed, 13 May 2020 09:05:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.223-41-g2d1298010c4a
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 111 boots: 0 failed,
 100 passed with 5 offline, 5 untried/unknown,
 1 conflict (v4.9.223-41-g2d1298010c4a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 0 failed, 100 passed with 5 offline,=
 5 untried/unknown, 1 conflict (v4.9.223-41-g2d1298010c4a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.223-41-g2d1298010c4a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.223-41-g2d1298010c4a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.223-41-g2d1298010c4a
Git Commit: 2d1298010c4ab7b3126d9f16512eabe3c632c258
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 19 SoC families, 18 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.22=
3 - first fail: v4.9.223-25-g6dfb25040a46)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.223-25-g6dfb25040=
a46)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.9.223-25-g6dfb25040a=
46)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
