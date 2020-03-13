Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB2184178
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 08:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgCMHYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 03:24:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40567 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgCMHYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 03:24:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so4675216pfl.7
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 00:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oufwW3XcBRU42qQ1w3V54qSbQ/qGw9JaUFyUNjZ1ccE=;
        b=Ka1W2TRV9B5COK+tZwOXlXUTggLXSYVO8Q67tSXL4O81P8KAKSuAeJ32yZFv8qGXzH
         pwfeRpUgmTljEPPsnviScCcTUqcTwIJGWA2NA7EIoEiECQ31Atmcsulx2jujjO6WuXP9
         7LjBLUTZ8G0mqe2F3mORPOs1aaGOy76NYWpALzIZt3Pkrv1Xgg2nj3jZhwsYgqhcKMNB
         I9gculBCTq8ykq05efgm5AyDaAE8sjJ3NKMT6Uetm70g7k7Q+dpN167uQRc3VklYVjSG
         nwgC5jQM2ETtWUUYMR3tijA/9ZIR2GY0bX7SZC5HEqK0PCNpLa70/QlAZDUD9oyQ8ySS
         GYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oufwW3XcBRU42qQ1w3V54qSbQ/qGw9JaUFyUNjZ1ccE=;
        b=kEnsOOHrg5nDY8XESCWG6k66vS84EK6nOu3rm6E3vQg9s1pff8onLS6JL6ILbP5cpF
         DJE61G92zGLiM2pUl71CL0U1CI9vPgqT2oSL9p0Objwzust4MT20yutBF6XYr/R7wcAx
         /2Ar49tiVVrme3DYubVRphQtspvjHlBGL+Br6XMfDbSy3jgjp1HLWSAmVf3tTgax1SlM
         ecw3n8c8ShP/h9/j2PXSUFND2EAvgM9no1SkcSCCx/19LhE5rhI3hiflXbcf/pjSYrau
         o/ApHS+mY5Xkjb8Cw+gNJlqsbdWSVrmZwJrg7CqOri6o39yhAQmGlAiTuLw31qGSiFWq
         4Wfw==
X-Gm-Message-State: ANhLgQ1WwJkm176UHWRDfoYS4zXeSEW0EG/8CrGpTXVkJdd3qsRgSUGK
        uDxce7kuBPv1/YLWcBMhIue7kdcFt7Q=
X-Google-Smtp-Source: ADFU+vsF3vZZp74t3cBcqwBGyYLWX1pfrSXsWACjknJF6VvD3l8Vz64wxlmUMHdA2l+PTdMeKpssGw==
X-Received: by 2002:a63:4864:: with SMTP id x36mr10865528pgk.398.1584084248180;
        Fri, 13 Mar 2020 00:24:08 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm10392027pjs.44.2020.03.13.00.24.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 00:24:07 -0700 (PDT)
Message-ID: <5e6b3517.1c69fb81.c88ac.41cf@mx.google.com>
Date:   Fri, 13 Mar 2020 00:24:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 81 boots: 1 failed,
 77 passed with 3 offline (v4.19.109)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 1 failed, 77 passed with 3 offline (=
v4.19.109)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109
Git Commit: 5692097116094a4a7045abcc1dbc172dbdc5657e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 20 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 33 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.19.108-87-g624c12496=
0e8)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.108-87-g6=
24c124960e8)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
