Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64F7133A98
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 05:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgAHEjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 23:39:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36488 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgAHEjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 23:39:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so1937114wru.3
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 20:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IRvvtgYVb0QWB14LFCnugvmwjpX1U+wJ3UkNw3SsRbQ=;
        b=eas2DUh0Sa63JXavQLj7OF24rp3MhLCaY8P2lFKaZXnAi+txeR0SvcihFUhuH/2VaF
         U6zBDyI6ahISw3hXS3eDdowhypLFZbqJFtfSFseBeANZDKprAdzLEK7/EVUq75y8peys
         L89PCfg4MdsZVtoU7pT92q8f6hkMCt3ipLoBUgjQfkPzwV+BQnVczx2IuZPiwIZZnPNw
         V6lI12yzZrNKsUaWTGoOj6ZVMkw8qPqKf06sEkOPSF0dmvJZtzv9J2/dDhPRjjtjBFie
         HBy7Uo/4vHvXzjksdGlix572rtJ7/6QpbT22nHc83VJkdARVx5xZVxEfgUPG2JXNmQXH
         RjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IRvvtgYVb0QWB14LFCnugvmwjpX1U+wJ3UkNw3SsRbQ=;
        b=JymJQtaAd7L8GuBfAl5Esz4Y7w/fNwYWIkKWAXJEWSPpXChKH6IpGRHkj0oL0HpAKq
         c3zpDgTT+RJzi8zfTlqCavyISbH/lSs9m2HQ+TWGdyX2PliZ93EDkCHX2NgZCZBVSDtp
         H3I3Auyfe+HOpxZSnrcwnJd66Qo95l2gj7YRQMcclDAt1zKvf5RowP6uoIM7oR7x5yl1
         ZOHZSEcqkDVhm66xLynGXoZ8hvcDG67NH+7mG3r4w6meDxeYM43gLFpU96Zyaw2o0zyX
         1YircbOtvkKimgLzk0Ijg/T/bCVAgbpXIIwSEqpFT44Gb9AzUB3NXlT8rQ0vGuWQkSrq
         xngg==
X-Gm-Message-State: APjAAAXDhGKyNaVaQPvUvWf6VWe2yvS3glqAwUO+MER4GnB5PGODBhnL
        OywNIErXh+O/5x+cOMifFsPKCgHwHWnIMg==
X-Google-Smtp-Source: APXvYqxBW0oAssZMIHChEJGjloyWXHnNBVTDRVmoRSz/9bJYrw/FNrlePxL6MwFAdBct9wVkiDnthA==
X-Received: by 2002:a5d:4b4e:: with SMTP id w14mr2086589wrs.187.1578458379167;
        Tue, 07 Jan 2020 20:39:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm2542788wrv.39.2020.01.07.20.39.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 20:39:38 -0800 (PST)
Message-ID: <5e155d0a.1c69fb81.8a09.b6cd@mx.google.com>
Date:   Tue, 07 Jan 2020 20:39:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-165-g3cd31bc7c111
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 41 boots: 2 failed,
 37 passed with 2 untried/unknown (v4.14.161-165-g3cd31bc7c111)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 41 boots: 2 failed, 37 passed with 2 untried/u=
nknown (v4.14.161-165-g3cd31bc7c111)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-165-g3cd31bc7c111/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-165-g3cd31bc7c111/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-165-g3cd31bc7c111
Git Commit: 3cd31bc7c11110c86fbc548b1faa3731bb3959e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 8 SoC families, 10 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.14.161-141-ga62afa8e=
e549)

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.161-92-g6ddc8c5d3=
3cc)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.161-141-ga62afa8e=
e549)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

---
For more info write to <info@kernelci.org>
