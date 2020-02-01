Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F6F14F82E
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 16:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBAPFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 10:05:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40049 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgBAPFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 10:05:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so12014693wmi.5
        for <stable@vger.kernel.org>; Sat, 01 Feb 2020 07:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dKyCb/slcxPhPpKUiFZfbmJhH+50E6FZog2Y05E1mP4=;
        b=SVLUy/762yipEV5sogiNgo8eGGFsCM641ChgdQWz3kdW9+MU8TZWL3bgnxfpCxkUyM
         g3gmdXfy8OXiRFj5JmY7x/icsjBrs7jyyQ5X5SURGDqn1LwmoCK5xLhXPgCwF52/xzjZ
         ut9ebXPpiDTz5gBYAOJvkw+KddEVVCkT2YsKjhH6pg5XcoryjxEGLJXuyxKRyt4hHiYm
         aBXzkAfSjZNGPh+C4CzCvSnsL1X8K4SqkFkPI4YhiYIQerfpQaVDSaxJ3Mu+ZncWx5QA
         ErMfWJThgyrZCfygbU/k8K0vuoIv4UhNPnhDOMpe7dXcu48t8tE1kpEhAXInSuix7EYS
         +TnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dKyCb/slcxPhPpKUiFZfbmJhH+50E6FZog2Y05E1mP4=;
        b=cdjPRCMhLUAqPblbv0A9ME6W/nL5ICSBRFh/v0wuX3v5kk0xtd6e4ecsuBNLQNIJfH
         dlWV14tSD6eKePbDCilb2qcOtXgCB3DhvES0z5qEnZ1VMHKzpeXknovuecUMJcde3+I4
         l4ekkCUAeUTZnYtr2K+3AUslJ+4XhxGAjui8ob25tFHY14R2quCx95hMpdB7KM2LUPZt
         ZKsFIexk4PIF0WAmJ2CBBU8i4j8pM1PVoTIJNoTjqOhYCX3WV/pjUczoHv5hmvU3UliN
         lo1JwcbaA1Z+g/W1j8/rUtylcgQeCkvIULYg9Wt+WdX9mJ7OtGYS7k3bHjAdrPH3xtSg
         xQ7Q==
X-Gm-Message-State: APjAAAXwynAVwkw7j6lk9jBSVFyj5TK438laDaHDValsMdz6BI1f4Kxc
        vjOm8gaYLZc0qGvrOCOaqq9kbvlBzE5Dxg==
X-Google-Smtp-Source: APXvYqyb2NW8aMHW6tK9T6rTswwkiyRg1++iYyQcOI+MTYFXDkNkfriklTdd4blqb1VJBhDjlkvjEA==
X-Received: by 2002:a7b:c109:: with SMTP id w9mr18120483wmi.14.1580569515679;
        Sat, 01 Feb 2020 07:05:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p5sm16454906wrt.79.2020.02.01.07.05.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 07:05:14 -0800 (PST)
Message-ID: <5e3593aa.1c69fb81.0cfc.8c36@mx.google.com>
Date:   Sat, 01 Feb 2020 07:05:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.17
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 68 boots: 4 failed,
 63 passed with 1 untried/unknown (v5.4.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 68 boots: 4 failed, 63 passed with 1 untried/unkno=
wn (v5.4.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.17/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.17/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.17
Git Commit: 313c8460cf0290fb1b9f71a20573fc32ac6c9cee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 15 SoC families, 12 builds out of 186

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.16)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.16)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab
            meson-gxm-q200: 1 failed lab
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
