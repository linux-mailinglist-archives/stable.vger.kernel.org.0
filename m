Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F5101E0
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfD3ViX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 17:38:23 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38626 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfD3ViX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 17:38:23 -0400
Received: by mail-wr1-f43.google.com with SMTP id k16so22697400wrn.5
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 14:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FqzVKekAxQdY6Xyyq2DBuEMo7/yZ8i8rhlsePMoqM5w=;
        b=te85KT1Ts+LK//cLAmpnfAjVoHu9jj6LcilUqzdf0Arb+aE4g3aGpo+QOtlA6z5uym
         sw1I4dIxGduiYG9TQziJEaRJ0TBM4UmqGeY2xU74RSE3HlgJ7Ui6lls+CvWzYNrVggi1
         zTOGaoB9kDEox1NowsYBPx/u0uzAIOYCo6NhaPl03vr2twtjMEv+LrH0twVp8KIT5cKl
         f616/jXVGvZVrLcS7CR29iO1E6D0KbBBKER0wFjKxEORscbOng/QnAVWEfezG7nqfAiR
         iGiYsSi1/mOiSU3zbRZi5ulEUWq1aSGv7TeTjbGyKV43qq+4ZIrzqn/rL2uRT1V9wIZq
         pL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FqzVKekAxQdY6Xyyq2DBuEMo7/yZ8i8rhlsePMoqM5w=;
        b=YKhC4TWVNHvoGGtXsDtwanSEjHKLpP63tSUBtSqnZyl0DxcJScgPUbT2khSFARAeeF
         MXTbReKgqyAwWO8zIdkTHJBEDtGRm9+NZ4IkILCq5M+58d6IA6fWmWOXIBsrUII1t3So
         GbzWZnjpo8RgmCaIFB6KWbDOc3xqPnT2V1XjFIm9pDT6NlSXb2dbHIyXrPDTZaIJO3hk
         X9XFNsc3qDt6/MYpsowsd17c1Pw8GzCvN9+KF3WCYqOAGX+TB1GzxQrT+jyzEF01nqlC
         9bgsHFlVWMFhfpra8Q/rOyZ7dS2nNvSfFs8obbJlDULdDKSuYZbA+P/PG8I3Kx5fdEpr
         OwXg==
X-Gm-Message-State: APjAAAUnNYGJPlpX+C8RHIhuIWdYIWj5JsZ2TC2l8ufE0l7fL6r1Ft1T
        Kbkq/oY0liBU+HAo5eeWvwxgkg/vcO9aNQ==
X-Google-Smtp-Source: APXvYqzyZKndUFlh1RrQAwTYGwwDEWtXLV3Ny2kCybJ+PGWhotHz/VwHNVRmAUGEWegxss9k+fEi8A==
X-Received: by 2002:adf:f3cb:: with SMTP id g11mr5900773wrp.47.1556660301823;
        Tue, 30 Apr 2019 14:38:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v17sm2457259wmc.30.2019.04.30.14.38.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 14:38:21 -0700 (PDT)
Message-ID: <5cc8c04d.1c69fb81.f9b59.d03e@mx.google.com>
Date:   Tue, 30 Apr 2019 14:38:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-85-g0eb41477d1a0
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 86 boots: 1 failed,
 83 passed with 2 offline (v4.4.179-85-g0eb41477d1a0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 1 failed, 83 passed with 2 offline (v=
4.4.179-85-g0eb41477d1a0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-85-g0eb41477d1a0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-85-g0eb41477d1a0/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-85-g0eb41477d1a0
Git Commit: 0eb41477d1a0f09c2a8c401ffab91b3c1b310672
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
