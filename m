Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD719DD0F
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgDCRsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 13:48:18 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33453 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCRsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 13:48:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id d17so3864460pgo.0
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 10:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vzt6C6wJKih4+rBO5M//vgPQTxw+28YDUFv8dKyd8qo=;
        b=Xc+Kxzl709v8vdZ/apnPG238oJR72myxzD6rdupkD52toPMYZJibWGsH5E8Uo1HKe7
         Tejm1GKxyq7Q1hqwsyUtZ4QXB4RMjO4vzNfuEn0vfnmaat27Lmy14/jwMQnazHgOW0EE
         yP2zGRhmqdAF6pGOFkXqcwhLZtAqjDTgogPdI48ZqOxwMVGrz1nbYoWp8V9Y0i0fCa0A
         RR7SAbupvN5vC0900L7vI038dyOsVOalTe9k9xTebEP0Tk1fBwlmrgfvp6K6MMPpgvmK
         711IS/2/xdIHGVegzHmnj1+ZmjHdKKHc++0dk8uc4C9SaBwGzunjYYdUj/rrxpZT4A+e
         s6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vzt6C6wJKih4+rBO5M//vgPQTxw+28YDUFv8dKyd8qo=;
        b=gJO6Fw19lL8u59YyPlGzGSAG4t3pda80UGJ4+rHjpt0Y3cZhHcVqS9sZWLhSxxx7O6
         OV+sESD+bOefUkzYYRgZevAgj2P58GespIiae6t0Jrr3mcnY+lqBvkNRkNH9l+ak1Q/i
         ssmDmV3ugP+Bsw6XqdYkYIET0oD5XtKCycf+BJa0V+F11h2bH0sSUIuATDWgoAzsxmAn
         +gWRUa4qRB9bRejdCDAELqmLe2CmSZsW7iBzwHRbFzGjXjbM43uhoghu3W6H7U8ETBJl
         +pD35TIiK7KzpLTLG9zHiOHP1vx+ZZBiBUsxByXGVVa72V3vM88PjWRGMHcngxKj1B2i
         MiSg==
X-Gm-Message-State: AGi0PubiUZFVcZ4GclfpHcTGhNavxKUtbdPKX/JflhRH+Tz3OjyJKzDp
        NLcaUUihwCx12KaAWEF8YyUSqo6DE7I=
X-Google-Smtp-Source: APiQypLsGeF4gQKznVjOjsnIFkG3f1A22WJGqfFsmLJjfZaeREd0gI3IpvyDKHwhg1fhJ2iV8opRdQ==
X-Received: by 2002:a62:3784:: with SMTP id e126mr9373048pfa.50.1585936096948;
        Fri, 03 Apr 2020 10:48:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7sm6237476pfa.106.2020.04.03.10.48.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:48:16 -0700 (PDT)
Message-ID: <5e8776e0.1c69fb81.ffe92.d371@mx.google.com>
Date:   Fri, 03 Apr 2020 10:48:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-10-ge0066de56999
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 122 passed with 2 offline, 5 untried/unknown,
 1 conflict (v4.14.175-10-ge0066de56999)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 122 passed with 2 offline=
, 5 untried/unknown, 1 conflict (v4.14.175-10-ge0066de56999)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-10-ge0066de56999/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-10-ge0066de56999/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-10-ge0066de56999
Git Commit: e0066de56999ad01b6367b6a42064233ad8bc932
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 55 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 43 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.14.175)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
