Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8F71ED5D5
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgFCSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 14:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 14:09:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E7FC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 11:09:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bg4so1090555plb.3
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 11:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IpnHL92tK+H6hx83HBpS6easRjKu2PmUZl1d4pvRhKA=;
        b=r/D+Qbu3j04cVucQjuWdsQXcxkXpPX78mbpCIMCJK/6FhZjh1JaFVO94id5aGU8DsD
         io0PWT8N4COpPNoCRV15pqOAOljGt504oz+AtPbL4+TDmXLH7HjA6n9wl2SSdFHeOEoH
         7Z6WcBKFAQgYUK+XaqF08LqhgsMOrvkJJyZiDFI+fXUX6di/JI/kuqtYTzBcbX07LOUr
         rGT/hLEwnUKpHhCqbR3+Mvm9LVA/AejWpewaIE74gfGWkeja2r3KzJ2tW0I/VQ5Pj41F
         4oFQqJpDZjhhxxkLF+7F/wxYJEDXG5HdOVyF4Iwsy+czrZXYxTTWp7SJar+FDe+pNrrq
         mfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IpnHL92tK+H6hx83HBpS6easRjKu2PmUZl1d4pvRhKA=;
        b=GPEF0MvvIT2fTx89grbBxvqmvc/8wzRKKGOlZdO6kBwQnSxCbI4xyWoRtoiJcH2tMF
         US1amueew+wGM0S/41ycIQArVtCCy2CyC2HPp/3XrYAJDnVDKNk5si3pJlKybnx/0m+9
         ehHhBvSv8AYqaHDJcrAtOceti41saey65Dvh80te5eq0wgpy8JPWcKBS8Z/D2gzHWNZO
         DuA8c73qB3+Tv8iDkX0HmViWKoVkGJT/GhpKXIdNGICyATIKj7tqcx/YR5YKxiJBsT4E
         lBfhv/DvDQRIfHzh2jyXA+uYw6Ko2QmM259rQ1mi0JD+rBPEy6v7nIT/PQa9dvlDXVEK
         UxbQ==
X-Gm-Message-State: AOAM532gLo9TmrWe8fH17EzT656Hr7u5PiH+XZJil2EV69AmPi0TfQWS
        E3x/k5nL/g9lS6aFI23K0i6yR52H1RI=
X-Google-Smtp-Source: ABdhPJzkTOyF8WISSVvczzYOTASjN71gY7SZVvZtLtKItBJDoHcB/CxCCCoS1jVzZiqnZZdXekCPxg==
X-Received: by 2002:a17:902:7609:: with SMTP id k9mr1056403pll.55.1591207752395;
        Wed, 03 Jun 2020 11:09:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm3443820pjf.32.2020.06.03.11.09.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 11:09:11 -0700 (PDT)
Message-ID: <5ed7e747.1c69fb81.4d220.8c3b@mx.google.com>
Date:   Wed, 03 Jun 2020 11:09:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.183
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 51 boots: 3 failed,
 46 passed with 2 untried/unknown (v4.14.183)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel/v4.14.183/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.14.y boot: 51 boots: 3 failed, 46 passed with 2 untried/unkn=
own (v4.14.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.183/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.183/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.183
Git Commit: c6db52a88798e5a0dfef80041ad4d33cc8cf04eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 43 unique boards, 12 SoC families, 12 builds out of 161

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 131 days (last pass: v4.14.166 - =
first fail: v4.14.167)

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

---
For more info write to <info@kernelci.org>
