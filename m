Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF392F89E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfE3Ief (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:34:35 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:45973 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfE3Ief (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 04:34:35 -0400
Received: by mail-wr1-f49.google.com with SMTP id b18so3539649wrq.12
        for <stable@vger.kernel.org>; Thu, 30 May 2019 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+MHgJfTw9jbPMrlouWsEqKztLHc3x0xCLSd+1bcnirg=;
        b=nzhCzWNZ+INW7DFj9f0B1wrIfMG8zNnIxg7rej5h0XcbS5w73yauu5X5wNqtOERLpM
         FKQKdVaO6Gw/atEgRizNYHphOzBjfxa9UNQwz5oj2XAiuZc0+Vra63534f5gKee9sjZN
         j/GczEh5U6I66YVayVQCuhRws3D4HSv68mCPoVQeFjpCVfkRaue5YcSGU5LilgD902LB
         mLTTjiXgAKTRLXl5/UBdDN/mxNCotDOqSRWEwdPzviH8adzszRKs6tXdVPC7YlCbyCnh
         TmBzXPoq4ScPKVcuJ1s2NuGpUuST9zu97AnyUUmUOt/macrKyeHSXY9E9XxmMh5t/nTI
         eA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+MHgJfTw9jbPMrlouWsEqKztLHc3x0xCLSd+1bcnirg=;
        b=OUnZ8Q2V2nd+oeHgGBUY1hoUFK1+ls65N9MbXgSqHK+txea2+i1qsWCVm0lnG8X2l3
         UkLWtx7rIJuSjP8peefT0Dib0EiB4NbArGERljZ3AEImw3YaKfmdYMymjeBrnHagHl1/
         pvzcm3C6buAbqMu/tngfRIhx4tOjuXXN6UGOflrqpnSdoThZ6VvSzV1aE8zkg3eF0Dn6
         YX3sUo0caNWDIu/E64tq8MTrdfhROGQOK5pMgIPl+Trss/YL7crnnVCL6u1KNHWzadxt
         US/UbT3pu8vUqrE0aUKIHwIHlUBuqRM1b/QwZXGzE9fRxZKaudpKoPuXU67msQYYPoGK
         6O7A==
X-Gm-Message-State: APjAAAXWdnBUaJ3bIrfCo83jZTuZJO1pexHYJJPRbI97NF6PUhgRWYS8
        vEZxY/LqUg80LUVpFUsTDB2tlOlLbbRxFw==
X-Google-Smtp-Source: APXvYqzc/Y31FJgiBPyTB2qPZmSLhCuMbRU4nWmNQvaZ49LKIv9p7UPNE9H0rjX2nIJVFBh/wMtM2g==
X-Received: by 2002:a5d:6b90:: with SMTP id n16mr1725760wrx.206.1559205273820;
        Thu, 30 May 2019 01:34:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q14sm1497375wrw.60.2019.05.30.01.34.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:34:33 -0700 (PDT)
Message-ID: <5cef9599.1c69fb81.50c45.74dc@mx.google.com>
Date:   Thu, 30 May 2019 01:34:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180-180-g600dd7440a0c
Subject: stable-rc/linux-4.4.y boot: 92 boots: 1 failed,
 91 passed (v4.4.180-180-g600dd7440a0c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 91 passed (v4.4.180-180-g60=
0dd7440a0c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-180-g600dd7440a0c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-180-g600dd7440a0c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-180-g600dd7440a0c
Git Commit: 600dd7440a0c62c267bcc3a6a2493c36c29ce672
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 19 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
