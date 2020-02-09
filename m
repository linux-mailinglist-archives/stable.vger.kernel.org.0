Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30BA1569F5
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 12:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgBILR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 06:17:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39331 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgBILR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 06:17:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so7373676wme.4
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 03:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DbZikye2tZ1iH4WKr8XNF2Wx5DOqr9p+I8F438mYB+Q=;
        b=ijyjOEOu3G721EUoL/Jaih9+zEAfhKTWt8pZ1E5D98vOrxvdW4tnzuAFcC8i1vYrSE
         Lofu87IcewhhtMozEpZG4ux+d7Zz73KHRzTOt9+vYvMRROKtZ/wYZhmEKwiOPMMnu4/2
         bQzzeA57qgJm4jx5s5uwTpHEZA9rRk6/+TZ9TARlax7pUg85js+jvlNQ5lSuv3AOCDY8
         QGT3H+ZqDjWKD9rvHbH4lMOk/s9ETpkkNPxaq8RbcqWPC9kJmYbXFow2IO/GQjqcbDQQ
         /1MZyiF9+q3S1J7pGgcbo0bpaWzNYOd3uBF4I1dAuDi/F55jZ8WweRGh5fWZO892q4uJ
         hLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DbZikye2tZ1iH4WKr8XNF2Wx5DOqr9p+I8F438mYB+Q=;
        b=c1DxZP/y1fPqZxir9TpSfg4l41uLYEj0rKt+SJ+2zUqSOSlCSYxJEqPMaVnVse4C1d
         MKqfRL9aI0+Qw5YDbQZZ3VIk40AFn+91eEtuheGrd0Q0FngT5/EvhP5KDvxvwAbx4DSk
         RZifF32jpXnYL5opOHzfquz0FzoJw6CWH4dEWuhEH9YvryYcrrFQJMZVrWbhg2o4+co2
         8vo54aBdLCzU5S6Z2bRXkMHekWcwN47w39Es4p0r+s3e+u8yCzYxxLrYBI/T6QWfrdFG
         GHgGuTxkUrjYshdYPxQGCmueOZFWj+bjuUo9fkoM/JKUN2UrqDvLYslutAzVJyEiEHvy
         iO3A==
X-Gm-Message-State: APjAAAUcojRVHNlpCNw/+Og7c+mtisfIno1wvBax5Be9E+9gHDMBXvyg
        h9oCe5DpR8mwV4PkfS9xgmP9pN931yo=
X-Google-Smtp-Source: APXvYqw6efR7Dz/QkfYpiQhNDpVAFtbtUanJwJklitWV87VnO2JpUmMMaxnQOjgYobedCejy3jumpg==
X-Received: by 2002:a7b:c8d7:: with SMTP id f23mr9167134wml.173.1581247076453;
        Sun, 09 Feb 2020 03:17:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w7sm10380287wmi.9.2020.02.09.03.17.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 03:17:55 -0800 (PST)
Message-ID: <5e3fea63.1c69fb81.c2836.ca3a@mx.google.com>
Date:   Sun, 09 Feb 2020 03:17:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213-31-g79b2eedaa46f
Subject: stable-rc/linux-4.4.y boot: 51 boots: 2 failed,
 46 passed with 3 offline (v4.4.213-31-g79b2eedaa46f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 51 boots: 2 failed, 46 passed with 3 offline (v=
4.4.213-31-g79b2eedaa46f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213-31-g79b2eedaa46f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213-31-g79b2eedaa46f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213-31-g79b2eedaa46f
Git Commit: 79b2eedaa46f955611171f42b7b321b2a7fd2868
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 15 SoC families, 10 builds out of 143

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.21=
2-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.2=
12 - first fail: v4.4.212-54-gb514f5a16f0b)

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

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
