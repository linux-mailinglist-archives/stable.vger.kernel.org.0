Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767E59A417
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfHVXxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:53:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50298 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfHVXxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:53:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so7221703wml.0
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0flOzF7eu+o0VADXd24ZnL/3ar8LkYMGHyQkaclCu2o=;
        b=PjsxNsW/4FvjPBLRrcK+YFF03lDd5kOG6lv/fKk2XF8wNNxCQ9ETwjWO0HoqCLla4i
         x/mIPWmh2cHX2NuJAs9NgNRzL9kz9FWxXcf15ShCsP/PfZpNm1TMR6+so0vHLSOMGJVg
         6pnplGWzM18sX5+UebVOvfwZBXqMl1+lJpYKI/lSEAyedv7YqKLqmgvQdbhD7r+bqW4a
         YUMjNbj2HJgkjmfz63GijIzmq90tcw22EtS0mpmzXYNG1IhZ3ddUj/E4Bobsu0C/lnSl
         CqzPtqDS6sTXaSpgsZ2qoPA2DzEGgfE2GKkElxpudlECpta16vQBS+gKUwkOrnIKwkIc
         TPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0flOzF7eu+o0VADXd24ZnL/3ar8LkYMGHyQkaclCu2o=;
        b=FXQklyyiFWqdqacIXJ9K5eh+nB4iBMKNYUQP3QcaUT7/pLZGLJPTP4WLXTEhX3ikPN
         59dqVsCyK8HSbMcSBScVveYFSUtEF1jcm0837zshzBPhe974bgolf92O3uVE2po5OU7B
         MvSjvGnHy/CAT3l0KgmWNZsxBysNZWoKp2iT1EPfw1IYqywtyda6b+s/XAa+LYDVn38s
         BQwFCN1QUP1v6glHhlnwBN4SAq8OFmUIa3VYl6ZwkwPqAffqBuEch9JHzIISgp5ghQyJ
         cHXia/pIy67egV3PLclsNEIgEMYbgtV148nXehwQBuJ0aiM7Td+xGxU8X3bsKoT7a3Uo
         ggpg==
X-Gm-Message-State: APjAAAVpxIApYWwdzox4BygPiiHS2glpgCs2VwOIc5gWBQhE9zsaR7GE
        6B/y20M9PLXezCLSAq5kbtte52LLq8NJ4w==
X-Google-Smtp-Source: APXvYqxQHAf6HoBiKnr0y7exMhy1elzix68OKmWh9J/sGki1bqFcbqNoO+CKZQLPdq980lG7YtqPcQ==
X-Received: by 2002:a1c:2015:: with SMTP id g21mr1374876wmg.33.1566518023064;
        Thu, 22 Aug 2019 16:53:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r11sm830580wrt.84.2019.08.22.16.53.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:53:42 -0700 (PDT)
Message-ID: <5d5f2b06.1c69fb81.9c0d5.3da3@mx.google.com>
Date:   Thu, 22 Aug 2019 16:53:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-79-gf607b8c5ce70
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 101 boots: 2 failed,
 91 passed with 7 offline, 1 conflict (v4.4.189-79-gf607b8c5ce70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 91 passed with 7 offline, =
1 conflict (v4.4.189-79-gf607b8c5ce70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-79-gf607b8c5ce70/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-79-gf607b8c5ce70/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-79-gf607b8c5ce70
Git Commit: f607b8c5ce70dfa9966f5f1f560bc7888aacbb63
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
