Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383681CCDFA
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 22:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgEJUoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 16:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729276AbgEJUoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 16:44:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A35FC061A0C
        for <stable@vger.kernel.org>; Sun, 10 May 2020 13:44:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so3564295pgb.7
        for <stable@vger.kernel.org>; Sun, 10 May 2020 13:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=85roAfBLvKacm/ExSUSbpmSTNwNiXQnry5FvjsJk8+c=;
        b=i9NIwNAS6qwSErE4Lt0fkPDf83Zc/YO+hityqW8ECo6BexPqzDht11aRDXbkkCGHYN
         L5swy1+pOU7Fm/pciAIVXq1iB69o7kKfEFz8QKwPLHPAF6OqTIuC/F2oO9c+jI0nrfmu
         UEOLa83wwBfXtYaA8eCjdJNiUYYE2tyqaQQI1OYMAsyEK9frUhshbXEMadRu0oWdxbpg
         9XSnwKBy0fiVJSx/l3m4EuwyzkhvV936mtCa5WOWnWbSufrfR/Rek8F3QZ9ml1PuIEfZ
         SppXQ+POoUBcCsxVlVhWWGBMbLiO+QRLhY8wyYOlUjDkGgjB4D6lF68BtPXgEwOC5WPq
         ySKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=85roAfBLvKacm/ExSUSbpmSTNwNiXQnry5FvjsJk8+c=;
        b=BdEsMjLhzkmNc329amuzpGkoHCiTuYfb+Nyavi2/qcCcEyDPJex6oQuUUEHGGMFzRm
         YOEiAOdtWY4MGSpe7WhrH1+QHrSxY8pBocJVhbdZglIuF5UV4siu25KH4IdmSTXw4M4N
         7V7bYcx+wM8BUheeSPYyHu1UUFRDk1OaGuk/MTrtqKogWTKxgEBn9eqzlLyvdS5Cl6ur
         gru4QuK/pucbi4I3h8MaT23+IEdQJMR0G3VtG/C0efzLS8svoFIqP+pN1eqpaIZN3D4t
         Zw9mH2vXAgiNOSyQg4q0Kbh11/XqlYksdYxgBAyCMZAwVIzuGnR/I+IB51Xf2ZcZDCe4
         R6sQ==
X-Gm-Message-State: AOAM533ADeiTjYD+Ft/k7Y5/+vtugMIc5T+lhXL/HsE5SNUAb2tMl7YK
        UNKZnLNAdQFgkp6wImZmpC0F4BNbOIs=
X-Google-Smtp-Source: ABdhPJxmWHIqeaD9L9UsS12vmZsXWAnabR26ou7g0YRqsl/nL9FQcbMwOVUIi4RO59gQLvPzIqXPpg==
X-Received: by 2002:a63:f004:: with SMTP id k4mr790965pgh.17.1589143477205;
        Sun, 10 May 2020 13:44:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 36sm180559pgs.27.2020.05.10.13.44.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 13:44:36 -0700 (PDT)
Message-ID: <5eb867b4.1c69fb81.aa719.0947@mx.google.com>
Date:   Sun, 10 May 2020 13:44:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.40
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 115 boots: 1 failed,
 107 passed with 7 untried/unknown (v5.4.40)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 115 boots: 1 failed, 107 passed with 7 untried/unk=
nown (v5.4.40)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.40/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.40/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.40
Git Commit: f015b86259a520ad886523d9ec6fdb0ed80edc38
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 74 unique boards, 19 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v5.4.39)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.39)

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.39)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
