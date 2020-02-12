Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8984015A943
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 13:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBLMid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 07:38:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43539 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBLMid (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 07:38:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so2116008wrq.10
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 04:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t3MxzC3IA1bH/TINSYR1OeLyGgnSW7ZHlACs3d+7eYE=;
        b=yBJfGXR+JAgIItmOCxH7TBXsHvJwBpnZEqH/85VTznSmvbz5PjsHRcTQH1OoEzRLDD
         z5m5q2uJ5QxBZhcbFdki4p/NONJ5bjvweSOvFBHIW3PvwNqrJi3muSzKbeWXeZddHFhX
         eXq8RF3Z0QPfLku3JWJg7wnHPRrhgIf0eL88vTVV3RVj9TW1DhhTAi+zJD3I6G4siv3R
         DGN1oS6nY/hTpfgkZ7TwUyWJlJFjGeyzbj8STgPI0iELaX5C/08zYQIbOdP6HSuTkSS7
         SmJbXH+HgfMFLb1gWlxpB8UlP9n7E+ZtiW/ixpii8WEb4hd98vlQZDNuUt+rWl9c5Y9A
         da5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t3MxzC3IA1bH/TINSYR1OeLyGgnSW7ZHlACs3d+7eYE=;
        b=auAPb2eP2SjUSavjQZq24JPxruC+UQgj5L6lYaDkcFlprFFncI9AUH8oQdlUF5sEuy
         RZMfFNxSuq2IfjAcjCxEw7OB0SRJbIbL1j0vOHx70K2mSQg3p6qJ2uf7TUviJTmx9UNs
         ih6Oy8AswRT/rYooJy77vZC4aUeWzXnDVfDQG/nzWoFLqoSijtH2/Zok86kd9WkeFHb1
         1qMsUkxUpjrZmPZxDA5ik+jqkQhnX7y8fMQSY+Hil5nGon3Hby62hpHlvlp3PARPJa0l
         gCx6zWAKTv9YtCVh1oyAe2UtLg8JpXoyBMR2ISwnGMe/m2s1RQ+K1QLGynRu4A+2xjcL
         sjzA==
X-Gm-Message-State: APjAAAXDgzKJHqP/oBk2TA01M6NuSQX/Nytmb8qKr15gM6fB5mVK5FQS
        c2jR4KvyloubYX2l21tB5TtuNXrWv2GhKw==
X-Google-Smtp-Source: APXvYqzWEFVxcZsiNlDdCiXWF6x28xRZ+jxD1WYoMj68BZ9/xfoFrgn78V9bFl+vt0EPF1q97jUT6w==
X-Received: by 2002:adf:fd43:: with SMTP id h3mr14901287wrs.169.1581511110744;
        Wed, 12 Feb 2020 04:38:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm430950wrx.94.2020.02.12.04.38.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 04:38:30 -0800 (PST)
Message-ID: <5e43f1c6.1c69fb81.39eb4.2893@mx.google.com>
Date:   Wed, 12 Feb 2020 04:38:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.103
Subject: stable-rc/linux-4.19.y boot: 85 boots: 2 failed,
 78 passed with 5 offline (v4.19.103)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 85 boots: 2 failed, 78 passed with 5 offline (=
v4.19.103)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.103/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.103/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.103
Git Commit: 357668399cf70ccdc0ee8967bff3448d0f4f9ae1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 21 SoC families, 14 builds out of 164

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.19.=
101 - first fail: v4.19.102-96-g0632821fe218)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.19.102-196-g=
f03ffd764aed)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.102-196-g=
f03ffd764aed)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
