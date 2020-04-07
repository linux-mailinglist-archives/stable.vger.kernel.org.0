Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75001A05CD
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 06:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgDGEhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 00:37:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40955 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgDGEhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 00:37:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id c20so223135pfi.7
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 21:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=301PQL45w/yvw/AkEMstye0p+D5O4kyb9rRGv159Sq8=;
        b=YkQ9qNDxmg9qf8TWZReNhNq6zqRBtIfRuc8rkZpqrM9SiYIAyJpaR3/IAkYP2Ec0i3
         vxImIBvS96+OWDOWtp4f5pCZ1RX30aR0W/Gz8slemcafp11pdqmfa/te6fGjUUYEylUE
         vwgONJdnHuDgW70IxRJkM3yRlJ4KYBqwnSepoSyT2JSNFxJwp9tSHaZt3cxQs3lkl9Tk
         0ExN1dFjBf9mx1GNxxfZNeA8AgRGnM2itLjLucMLlYtqWJO6BQbmIlQ5o6YF6/KYcAZT
         69yYiwapEPk8JqWT66EDNrhbNMknZs+bPrbfkv+myzMGoEVp0d/o3kI3WhOxRX8L5pln
         W3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=301PQL45w/yvw/AkEMstye0p+D5O4kyb9rRGv159Sq8=;
        b=Z9rXSqR0/byP1ttsoaXz+0tPsWFj+tD8WbxEk+qaIMeouwvnDLkyEmWZvnO93FK32h
         YAml/PDDvr/df48zR26+M0PbKLOtpdi+CU16PQiwgHuKdYLSmk1xqecX8anjldy21fTP
         C+b7M+TtXRGmJgT3q/BnrawqVBydIHsauKRLCzFHECN8albhTudhmkZf2BDCCND1ZIve
         UvlgDC1qR8/NH30B1lggKuckPkB/+RO8Rla59LucO3CCIvEPUor8taBGVBxHOY6AKNcP
         Xg2kOUVebNO6km2+x8d7L+ClJNdiVegI3/HYIqIUtVRjqWUiDvX76KM/gs3NsXhP0USA
         9QFg==
X-Gm-Message-State: AGi0PuY+Fgi+KI5QN9H+6OCJvOWnWZynB63s3zswu0kqh+dTjjQhw+CH
        E1CQ/7qDAYt01RZOGGKt/9hwwitukz0=
X-Google-Smtp-Source: APiQypJUIvBOROvVw3P4DbiFdnQZbykJDq1K+K16puSpHJGhnXEEbqtKuMyps9hb4pRe9T2r4XObag==
X-Received: by 2002:a62:501:: with SMTP id 1mr762018pff.309.1586234254369;
        Mon, 06 Apr 2020 21:37:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm12136734pgc.46.2020.04.06.21.37.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 21:37:33 -0700 (PDT)
Message-ID: <5e8c038d.1c69fb81.e5387.75e8@mx.google.com>
Date:   Mon, 06 Apr 2020 21:37:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2-29-g99950f10b1ac
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 152 boots: 2 failed,
 141 passed with 3 offline, 5 untried/unknown,
 1 conflict (v5.6.2-29-g99950f10b1ac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 152 boots: 2 failed, 141 passed with 3 offline,=
 5 untried/unknown, 1 conflict (v5.6.2-29-g99950f10b1ac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.2-29-g99950f10b1ac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.2-29-g99950f10b1ac/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.2-29-g99950f10b1ac
Git Commit: 99950f10b1acd1709f42e000156bee8adef3c66a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 25 SoC families, 18 builds out of 191

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
