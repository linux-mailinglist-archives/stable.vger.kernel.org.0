Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBA619B870
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgDAWbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 18:31:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45540 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgDAWbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 18:31:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id t4so537922plq.12
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 15:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=arnKeGX6h38cRc6khs3gd9r35sW1BzAf+pd2Gag2dbA=;
        b=nCTKlqrsxNZW6vTINjLin1gvOdMe+0DbcTSLVeVEjiTPAu4uhZagvsShGHgOmFYH//
         rY7j3RPB4dlujUHNpypnvVpRqFhQdXE7qwSZ60r1UJIJhpJGWWf5/JCSlsopieMFRtNW
         SwArXioJ02goeHLGFG469lmv7yzwU0RdrTPp6/UlrVS6ioNIZF3U65uaBjJ/Xg/pP5AT
         JSfl7RJY7mg+hp55cA0nY0Mt3mHY7BgF9QCY4Kiwg8S5bFlV8RhE7FQXsOsooeqD4T0F
         9jBtDfOYINio7UaOkyPF2TcMcH1PMXOA9dwmSPeeO+FcrR10KQgsCU9UbmUZ9HKG56D+
         pUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=arnKeGX6h38cRc6khs3gd9r35sW1BzAf+pd2Gag2dbA=;
        b=rYRhC11FD6nz9GD0fvNV2pixSEG1mYIMZhsLSacPqBmglMb6UspFEPT7mFm7v4zEmT
         jS5nntBJcHKyT6CeDGl8rzIHk8DqLPEfNS9rxRJaFlzkb5IAgmTiSmqDt1vSAPOAq3kx
         JiFfSennGVUytnkN01wqxqfeQPk+5SFQyfz0yjRgvtW7QKyJMiobtqmmt8AvhdG+8hYv
         AYXlyCQyPEsZ8SxcomnIm2qeSvMLH/+t66cw4iGZMIo6LCNe60fCUVTKpEn2htb0A5nT
         JrPsBJ/cchgnW7LlSZXzsZfhDLqguxTwwHZtSwyWpEvYSZXcwS1cMMI9dPIoB4mDnNgT
         fPOw==
X-Gm-Message-State: AGi0PuZ4wZx2DA2Wq9zefsMNuxH7XNP0GM4KTPPfRNORoP6pF8kMiUQr
        fOouG1xVUJ64cxxRrhDpzFiUYzCyIyc=
X-Google-Smtp-Source: APiQypKYswnG4k4mY6ljClRSLfaynzIZT5sz6snVEWfj9ZA71sYceWt6pXWoYEclXdU1KxtjwSV8CQ==
X-Received: by 2002:a17:90b:2397:: with SMTP id mr23mr275398pjb.88.1585780257212;
        Wed, 01 Apr 2020 15:30:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm2304177pfk.110.2020.04.01.15.30.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 15:30:56 -0700 (PDT)
Message-ID: <5e851620.1c69fb81.ba2f.b343@mx.google.com>
Date:   Wed, 01 Apr 2020 15:30:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217-103-g61ccfbbfe9f6
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 107 passed with 2 offline, 5 untried/unknown (v4.9.217-103-g61ccfbbfe9f6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 107 passed with 2 offline,=
 5 untried/unknown (v4.9.217-103-g61ccfbbfe9f6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.217-103-g61ccfbbfe9f6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217-103-g61ccfbbfe9f6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217-103-g61ccfbbfe9f6
Git Commit: 61ccfbbfe9f63b4a44ef11f9ad40d362970cc8fc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

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
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
