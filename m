Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7356AED
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfFZNlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:41:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44164 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfFZNlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:41:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16so2774118wrl.11
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 06:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kybFaVS5y9z7QGzON6+B2oFKoi87TyJ6kwIBAFyUkww=;
        b=KwKyfAeOJKH1og1y4xv00MdVdnboK/eajouEYMXYIsaDtmPC4ARA//Z5Q4vBiRiQDD
         UItezt9TD97YH0TPAEClxcSBfjv00JMWPMMVsBpCXeutUVExN/NEJdgRqGLcfGZJlOcL
         WWMtsmUtCXWqijgsgIrDs0c0UETaNxB95vFdMEEOyFNT1mZ1f4z1fZ5bo3OF+XUdL4Jp
         s4Nm9+5r/XdaAD7Axz7b7YjT1d1m+ACEKLQRBFRg/dk8jJnIq6S4H12aPxwrD6vY5Ha8
         ha5LRpEEjVZLz7UPbYwwcm2K4weqwMj0p+atTXcE3faR2IHxQTkVBiKWHaRy59w9UrFh
         eDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kybFaVS5y9z7QGzON6+B2oFKoi87TyJ6kwIBAFyUkww=;
        b=OkV0aK7+XeIaBBNY/X1uxawXBbJbb0XCrXuUi6RmhFoV+1G095YbIxHwPtzBDP44er
         /AouUZP/lBUkONipy+LlqD7p1A93EqsNa7ZIcJNqaSbeUPbNl+cZmyRFzWk59/Ys+LDj
         oRl96Q2OnrjZQWhJrEzoJVddUFtLPhZr/Y95v+3rTapuV+4ylsch5eKcTGFfrN/HnRWB
         ZFHonOM2lJ/ICQ7yd9W3NCmgZ8ZXmC/FXTWTJj50nJW/jKOSwSsl8aFamVwoR9yRepPx
         PuqPU/N6BcWmuSsuETCR03prVrXsg/LenrYwVQp7X5kvt1urmEKOT4BsBG3JcR/G1uu9
         ml6A==
X-Gm-Message-State: APjAAAX/YQ7irov1D6+zYkB27Uu9aZrNoJJ35hvU178xCw0S6DlsV0Ky
        plBk7MejBxerOsB2cLdf7FuR2DvJw/+JTA==
X-Google-Smtp-Source: APXvYqzl9RVlyNNidqv7HY/7r3EbhAhUL96Zp4YSX0PckiSER9oZWuvqUSTZ9FgmY1d9jwyrulcupw==
X-Received: by 2002:adf:f246:: with SMTP id b6mr3900941wrp.92.1561556475464;
        Wed, 26 Jun 2019 06:41:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a12sm11969412wrr.70.2019.06.26.06.41.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:41:15 -0700 (PDT)
Message-ID: <5d1375fb.1c69fb81.1d28f.f194@mx.google.com>
Date:   Wed, 26 Jun 2019 06:41:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183-2-g5f1824292521
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 3 failed,
 97 passed (v4.4.183-2-g5f1824292521)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 3 failed, 97 passed (v4.4.183-2-g5f1=
824292521)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183-2-g5f1824292521/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-2-g5f1824292521/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-2-g5f1824292521
Git Commit: 5f1824292521531d662f05e2e24275767d18c0c4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.183-4-g393=
ba32583a8)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.183-4-g393=
ba32583a8)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
