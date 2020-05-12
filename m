Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54AA1D0330
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 01:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELXqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 19:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 19:46:49 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD1CC061A0C
        for <stable@vger.kernel.org>; Tue, 12 May 2020 16:46:49 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f23so6251357pgj.4
        for <stable@vger.kernel.org>; Tue, 12 May 2020 16:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3ASjstSPB04PyF72HaIBB04t6rezu0ZfBRcxLUhkiO0=;
        b=XPcNcySXDGKpgmXS86qP4P9djLwDwUbkRM61gIvgMN+dhp6745CbETCp3QLBBvngVB
         JrfiCnkeFeqVCir5U6J+f7gZ94cpZl7sz+MaSz8nL8YUPBhVIMHFmo0zrPBziy09bf4V
         D7ZGoCsyvy4I52NLJ1/EZpnYwz0Im2piwxZ4b530DEabTb9q0FrlE08Rj2thQbOfR2iL
         mHpOGf9LaF4LRSEDFeMw2mOiQAa7qDUlnlxExY9fEdCb71QHzSAJAePBXWphi2UZ/pGK
         zeRA9xeypDn23ZYUeneFteCkFiXWMkZ0gWpxceu/OMk/e4yF8oStZzmfwku015UOw60s
         vs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3ASjstSPB04PyF72HaIBB04t6rezu0ZfBRcxLUhkiO0=;
        b=LOUeET2a+je1sdx228sOB63qsKCETRVRymUPGbuwnXfgKdik8zR24o58okfPg+LW/U
         9s1B+/sZz/1mT7nCStVTKnrdkloIvWljIGg6NnCUyWM3xwcei2EWEWVW+bqV8PmNTU9O
         JD4D2g+TICbEUUuLAbdRcz6t+NZnhfzd6p5qD97N8i34a+P2q4aezKmYWWez2KloDsRn
         gdiowmhDmRbiHlXdp56+2iiTQ0qXdaKa9gdIE8OkJw8vXLBoXda6xDQC9guBj+a/0WfZ
         dQTh+bGBJ9qx1bc3skJ5b9J3KQdEu7ON5v1zYAq6Z/819kRKsx3JKv9wvsXEF9zOagef
         HTlA==
X-Gm-Message-State: AGi0PuarneoaV1ZP1jqc3DjJqII8g0mXGvx9btXaFEG479lnYVVsZrw3
        kuYnlGLDNgCPUe4oI2BwpIkDf72wcx0=
X-Google-Smtp-Source: APiQypLYDp88NKrhWptkua5au6zDdQNOTSkKKoL1vVlY/Q3JW9mxjy3NM1UoWqtjIlPtv7cG0Sjm7g==
X-Received: by 2002:a63:f46:: with SMTP id 6mr21824237pgp.367.1589327208848;
        Tue, 12 May 2020 16:46:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gt8sm9716069pjb.39.2020.05.12.16.46.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 16:46:48 -0700 (PDT)
Message-ID: <5ebb3568.1c69fb81.8fee5.3563@mx.google.com>
Date:   Tue, 12 May 2020 16:46:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.40-87-g4fdbdad79626
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 164 boots: 1 failed,
 150 passed with 7 offline, 6 untried/unknown (v5.4.40-87-g4fdbdad79626)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 1 failed, 150 passed with 7 offline,=
 6 untried/unknown (v5.4.40-87-g4fdbdad79626)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.40-87-g4fdbdad79626/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.40-87-g4fdbdad79626/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.40-87-g4fdbdad79626
Git Commit: 4fdbdad79626096482a9a6f79dbcc6e1df35a589
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.40)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.40)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.40)

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v5.4.40)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 94 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

Boot Failure Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx7s-warp: 1 failed lab

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
