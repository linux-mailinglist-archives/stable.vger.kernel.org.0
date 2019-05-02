Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9311AC8
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfEBOFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:05:11 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:34463 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfEBOFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 10:05:11 -0400
Received: by mail-wr1-f42.google.com with SMTP id e9so3589185wrc.1
        for <stable@vger.kernel.org>; Thu, 02 May 2019 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QXIjCM7xMT4roSB0tZJX68mAcygl1S4ffRMGoDg3QHg=;
        b=mCybpOllRrDhIyz2ClM5C1UeqQGlquYrVgircM7zxFKPEhR4L+FtvFTyOw/5DssoHs
         EfWhGu2cH1hAV+lbBBF7FNGwFQqNquK/alkVWot3/5wr/TqCFQgvM91nJeczOhhgZ6sF
         5ZW7VyqCBrUq90Hkm4N9YIGRCrOaLFXeqa1RPTPievN3BYAw7Wvg51tI2Fyb+zImLpYF
         Y/MbFDycMGPDYwjtN2Xn6RiYQnHqP6iWGnSy88OuUmvHx+exNE2tPR8y4B5X64WvGSrN
         OXpy6DywBuOKXfiVmZ8fC6f2O13XaP+sFF8dWGnXrld4T6iQ45y1LY1TlJlyQ+S9a0Uv
         hiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QXIjCM7xMT4roSB0tZJX68mAcygl1S4ffRMGoDg3QHg=;
        b=iL0aZBgU3ZjNVKx414yTjxGI4s8/7OPuNXxaV33W+x2MaZidWYj3wijrdkuKso3iNg
         ABP/yX83sgjdkfRk4+d4gMEw2p0Dt9zkZ3k3uyjH3sace8y4d4qnULg4z6YW3J3N7YxA
         785l9DPgc6VaDlFra5PKflrzAoYiJca/3sGWjUm7XrkAi+eEAUXMryp3nEISHyIxGYH0
         hMsh8hTdgqnLfNlREcSeTU/0opJEYnXta/1CV13Zue+Aj3daZjJ2sE1ZrXT9CIENL4mG
         eO8P93NMrAgvto8IKt/Q+7jXBOc/J84B9ug2J+BO/FB/4MfX/Gj6T0hXABbKll7D00hC
         zy3w==
X-Gm-Message-State: APjAAAUftm/XruC6SyuYLkCJgca5HmAKTT6ZdiEo0G8cSf3Irs88Kp4B
        K1TN7QnIHAV3Td6p6ifdwsAd9Las/bdSkQ==
X-Google-Smtp-Source: APXvYqz/VXQAqFoHN2j83PLVV05IYT5UgL/Ch6+Da8JeCyrdWlQ5eZZwpqgwm3SjRQnaDMSVKWRpcg==
X-Received: by 2002:adf:8bc5:: with SMTP id w5mr2891955wra.226.1556805909558;
        Thu, 02 May 2019 07:05:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g185sm7978840wmf.30.2019.05.02.07.05.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 07:05:08 -0700 (PDT)
Message-ID: <5ccaf914.1c69fb81.82047.b8ec@mx.google.com>
Date:   Thu, 02 May 2019 07:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.38
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 60 boots: 1 failed, 59 passed (v4.19.38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 60 boots: 1 failed, 59 passed (v4.19.38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.38/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.38/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.38
Git Commit: a03957ab0fd5d7d03b512a72ab9106a1749f556e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 10 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-7:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.36)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
