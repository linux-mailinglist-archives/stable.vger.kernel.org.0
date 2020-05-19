Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D31D9137
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgESHmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgESHmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:42:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C00C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:42:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w19so3481805ply.11
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ygItpqwM2Ecsa4unzlkylMftC6tKo95T35NjMn1L80M=;
        b=gr0XaVwA9/2ZvO8gGviwIAezgoqNYxDjduH79mof5cVaIvpNAOYGGNuoMQq2QRryUh
         SoAFF31etviwdN4fR79v9fOrbwP2frIg168o/J9ojlH9ByU7fMmAD8FXbvnyXaPkC+ME
         cRazwT7TiDa7XHBYz5I+wnKsBG133rdWDzTs0ZCQJvIuKsrtUftbal1ND8+RNaeyp5mP
         pIyJxwSz+oq3bKmjkzeUojwqrdkB/YdPkINOqkbCKU9GNCTyAJXujozavMkdLL5Vr/qw
         8gzBH8Z8V5dHVDsyGvxrgjUWzSBJqeZove5P9J66SbSVBHj+dOfhaU+hx28jt2MIdGQ+
         LQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ygItpqwM2Ecsa4unzlkylMftC6tKo95T35NjMn1L80M=;
        b=nM/0wWBLbT/ActmWs5Vqy7RxHvwume0YXuI4wtOZlsUyLrXdjrSVpJLCNLUA/SmfBc
         hd7huTFhjN7scJFThDR+LOUUIchG7xv6Igfv5HgQQPgKoaC2g6SsJdD+3SvEof1Qa+lq
         iiJCcuWmulEzFlhh+ShDvKOQNt06SjDrpF36fSi0jEMFi20THTybin52hqIsDXpXqiZw
         fAC36rWJxViIj9nmbIJ1ICyamvTsqW8VAKzBG5h6e6c4q1PHT6E99qAYd+TbKAlbnJHk
         nhlA75OIsXGtmzY9RYgN7J0JSB3L3wKW9eM9K+hlaBOtFtROn9j2kv3+QbuNlRLrAaop
         lXmQ==
X-Gm-Message-State: AOAM5304uDccFFyihNLQF0UJHHLWywCvuFs4UgwiZLFPxNGdJaYOeQR/
        2AU8urzMQwNGfPDL9qc60IH7jdpjO0I=
X-Google-Smtp-Source: ABdhPJwZ/RZeZrLXB+ao0BF5R3sBLxrOPZSgE1PLxFZiqa83Lcbpwd3GACWU48aNKVKTMfgy7h/mqA==
X-Received: by 2002:a17:902:ea8a:: with SMTP id x10mr1588831plb.255.1589874123732;
        Tue, 19 May 2020 00:42:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6sm11075724pfn.189.2020.05.19.00.42.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:42:02 -0700 (PDT)
Message-ID: <5ec38dca.1c69fb81.cf78e.2df3@mx.google.com>
Date:   Tue, 19 May 2020 00:42:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.123-81-gff1170bc0ae9
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 118 boots: 1 failed,
 108 passed with 5 offline, 4 untried/unknown (v4.19.123-81-gff1170bc0ae9)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/kernel/v4.19.12=
3-81-gff1170bc0ae9/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 118 boots: 1 failed, 108 passed with 5 offline=
, 4 untried/unknown (v4.19.123-81-gff1170bc0ae9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.123-81-gff1170bc0ae9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.123-81-gff1170bc0ae9/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.123-81-gff1170bc0ae9
Git Commit: ff1170bc0ae95f29422b828165e36382a33b2dd3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 4 days (last pass: v4.19.122-49-g=
6d5c161fb73d - first fail: v4.19.123-2-gbed44563668d)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 66 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
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
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
