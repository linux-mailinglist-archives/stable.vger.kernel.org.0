Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D741C2149
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 01:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgEAXil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAXil (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 19:38:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FBEC061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 16:38:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r4so5227412pgg.4
        for <stable@vger.kernel.org>; Fri, 01 May 2020 16:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWDcDNhNDi4AbD55yY+lNWerQ7i5wP5imGJ0OXAYqFA=;
        b=YpoPk/QTJdD/BDXloe2ZqMEGxqcve9x8WF1nupoJZnPeOauEFm9y9Uolb/9Uf3bSKm
         /1zPdxoT/sSxD4kimlg2Ztju3p8gtDjFCeKivf4nZJanmB1Y8fYi1JTq+Xv1C4w1cOBY
         t908o+u/ceb8Ejc9sbzm522+zVZb9qNas7IHGv4WLIop+BseRMLN7D85dzf4J4zFPyu5
         sGigqQsoI97NIZcuwn/ZgbdCEuuy+2RxdXBiJNvJuMrX1CtnQTqkssZ8rFsBgnXHe04M
         p3u34b8qKYTx4iAzUkcV8lq+wR0tFR4XPQJC4kgvWFCSx7KJNWzbnKomTFcYDaKsEory
         qs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWDcDNhNDi4AbD55yY+lNWerQ7i5wP5imGJ0OXAYqFA=;
        b=uQzxQ7+KEYIZf75zcm6+lta2+Ue0Q1bL8h9f49+IkA8rUeE1vGzDv+QFfv8GqHR88D
         UlJct/HPQ01qUFD5B+FeqF4VnZY1tX257dzyPTxXxHD4atFgVbFepxbXRbjdG+dQlURW
         VDgTT4OHXGfIsyT4buBTjeO1BVGumc8IoNb60eP8tgjnD7W1Ww1pKknz/V3DniQxjUkk
         tMVNcpthKYdOLmfHySBbaSyFydltD0Z075wo+h4kzXfu1ZB21d5+NBh58m13SM35lfiE
         +m0XyeD6nOypfGHGF/kmzgOntBwteRD9h/0cfcbvpIYfSxdYsovHLokKa8JzTE+7vDH9
         EY5Q==
X-Gm-Message-State: AGi0PuYsw8nzZIo6js+0KEH7s9E/pEWpc/R0Y4Mi8dmsRmjINKnCknot
        g2+y4CQxVVXUoyOIHqkvDdC/2Xa2bTg=
X-Google-Smtp-Source: APiQypIzw6BgwUZb+MwsNQUly0W+nWCpkY/tnFDt/AroZrZvOnakeNOFHIq4CFLermA0tkwIqXS7hA==
X-Received: by 2002:a63:175c:: with SMTP id 28mr5997665pgx.44.1588376318916;
        Fri, 01 May 2020 16:38:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z60sm688249pjj.14.2020.05.01.16.38.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 16:38:37 -0700 (PDT)
Message-ID: <5eacb2fd.1c69fb81.32ca6.2560@mx.google.com>
Date:   Fri, 01 May 2020 16:38:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220-81-gc0dc655ddaa6
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 112 boots: 1 failed,
 100 passed with 5 offline, 5 untried/unknown,
 1 conflict (v4.9.220-81-gc0dc655ddaa6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 1 failed, 100 passed with 5 offline,=
 5 untried/unknown, 1 conflict (v4.9.220-81-gc0dc655ddaa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220-81-gc0dc655ddaa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220-81-gc0dc655ddaa6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220-81-gc0dc655ddaa6
Git Commit: c0dc655ddaa63df35b8601af24a8b8b42bbd303a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 19 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 83 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.9.220-66-g764c88f8b=
2c2)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
