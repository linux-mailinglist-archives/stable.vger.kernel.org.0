Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C01403FB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 07:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAQG1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 01:27:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35129 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgAQG1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 01:27:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so21477823wro.2
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 22:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nw1afzmRiFOoA2thotuZklDYvyFLE+aX5TlpbZzY8VE=;
        b=Ypmp639vi3RmzEjAfvo1dngwB1RrxUR41mlRnHebUBJ7geSIMMSfjhzSt+U9+TMVFu
         q7izGv2sVpRhTiePSZZfTRpfZyB9e39QcI3SZ45JNxR+lLuPUVZoja1Ozur9StFBCOo1
         OuWnb5mCnexKa5dC7tVGIWEz5/8jjX3niYFmJStawmFtBuEA68XPUbypeEe/090wCsPN
         howdKSQJ0oZ08nhbT3nQPT+xBpW+boSBw27WycpYJVucxAMQeh++CFTvGSFW3TeesdMk
         XST36Vensp+5xZDx7na5UDYb55qnvlPIlspQXjORgJyGsmculeW+2BRjgebGPV0gPTRh
         sk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nw1afzmRiFOoA2thotuZklDYvyFLE+aX5TlpbZzY8VE=;
        b=Afprg9WrYBWI2aVQQTwNu89ti6CVNF2bsBwN9QkVFpdZkL4tPayg1fKugtkWNchcX0
         6x1wkLkozcuvrLSFyl/TgzivRnGZjqX+bNWbZcEAFt6wlAxUm1CBXDgbvhkpsH56mp5h
         gaDJIcXDck0jnyNAHaTiiksURRFwjRxd6J+DMDmXyq7IC8TaRom6Xl76TgAzutZ02aC+
         Wi1vMTri0oLDcs9/NQbvJVhHenJKaqI0D2IYXUr2P+ThFufqeDqkH345hlU99q9SDElm
         WSIl7AvWrJpDaiq0g8fbKMFtdxbBFqRAHBLyqQ4tYW5OyLADgisrDJKq+YjaudIAxAch
         jvHg==
X-Gm-Message-State: APjAAAVlP8Wt7gDicM5rkR9O2pM0WLOJEeFwUVMvGj357yeb21BEj1D9
        05C3sbN1/LTTH1bmMV4C7fbU8clDVIQV3w==
X-Google-Smtp-Source: APXvYqxye45w8sexrOtKh6nNy3mlVy9J9Q7s+V4q0uDFr9i1TuNVsL6t2Fo4rSaaqmtInaDTraTE4w==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr1296661wrj.357.1579242450629;
        Thu, 16 Jan 2020 22:27:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l18sm7820705wme.30.2020.01.16.22.27.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 22:27:30 -0800 (PST)
Message-ID: <5e2153d2.1c69fb81.e7e0.e772@mx.google.com>
Date:   Thu, 16 Jan 2020 22:27:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.96-85-ge301315724e2
Subject: stable-rc/linux-4.19.y boot: 62 boots: 1 failed,
 60 passed with 1 untried/unknown (v4.19.96-85-ge301315724e2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 62 boots: 1 failed, 60 passed with 1 untried/u=
nknown (v4.19.96-85-ge301315724e2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.96-85-ge301315724e2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.96-85-ge301315724e2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.96-85-ge301315724e2
Git Commit: e301315724e25ac136c78f10a08928c03bdf7466
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 13 SoC families, 13 builds out of 202

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.19.96-50-g3904aafeda=
38)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

---
For more info write to <info@kernelci.org>
