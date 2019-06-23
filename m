Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735CE4FD3E
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfFWRQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 13:16:45 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40123 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWRQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 13:16:45 -0400
Received: by mail-wr1-f53.google.com with SMTP id p11so11341480wre.7
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 10:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=57uEjLTrlEz4/IOZQLIAq+MzSvKl3b2kRcXrIlwSP18=;
        b=MmaoDKpjgoA+isDqgywSd/0H1AEMTdKBon2usCzneHA0znJzAWuiUUhw7VY/peP0+c
         gcCTGsE958eQ3FRvZ+hwIGXB7tauqFWdl6ilv3vdqeFLZPinxMOJlUljip976QfccpGc
         Vx+Ff/2LA12NG7XaMmTyFrRK1sTRLE7Bi9CD6UaCDlB/0mXZfSreojy2Y5RczBtkBicR
         jXKrPUsuzoZHuTvgdunMKbKy0hgvdbFpQit1GTn3RVc3soT3drMnfYfZX8+nvY8GdI7n
         julJhmeiIUec3jFgum72j1cRUyY28LJQg1Yenbq0jLGm0gi8XwYJu9vyBcNAwx0GewTl
         Ym8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=57uEjLTrlEz4/IOZQLIAq+MzSvKl3b2kRcXrIlwSP18=;
        b=NXib4bVgBrG0QZKKJaL24F4p2uCOj8oVGlI3KwwJeOiFZC82KY64rDTwnLK+5Yz3/p
         id47v6nENZSPqkcHA2VS9S+zsPzb+K1Sfim453LU/qoFNA2uxJQRJ6ljrrK1E6VSdDiA
         lH+CF9YIueOsicHafFu72c+xddIeRcrdBots6y7TBiisCZCTNloQeX7aykhqmVwrkEth
         EDHcx9w00KQGh+aP6Cmp5hQAMkeWFWZDIzlmtS9t1GMihfTTJ/FbxR1EDZ3d2sNcoNk/
         bn5Rjh7UCTXk2xWFDE8CbX0nn64ZLosJf0TQ8juaTbHRoLFTk99053nl9skWpe1eSkC7
         Lkjg==
X-Gm-Message-State: APjAAAXjOc0yjL823hhjXYHxwQKKUR6RnuFEFTshDYRKcvXXJUegCKzw
        zbKBo/r1dL1ih62GoH9NRr7ElmmC9SA=
X-Google-Smtp-Source: APXvYqyEz5JSZT2cgdUDgpWu53S2RKn8JWEES7AtBDcaSHruKRQWaGWJFcC4uzGM1F40A/R0BTkN/A==
X-Received: by 2002:adf:ec8e:: with SMTP id z14mr20478326wrn.125.1561310203317;
        Sun, 23 Jun 2019 10:16:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b203sm10355259wmd.41.2019.06.23.10.16.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 10:16:42 -0700 (PDT)
Message-ID: <5d0fb3fa.1c69fb81.b7f06.90e7@mx.google.com>
Date:   Sun, 23 Jun 2019 10:16:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-13-gb8258e6be3bb
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 128 boots: 1 failed,
 120 passed with 7 offline (v5.1.14-13-gb8258e6be3bb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 120 passed with 7 offline =
(v5.1.14-13-gb8258e6be3bb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-13-gb8258e6be3bb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-13-gb8258e6be3bb/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-13-gb8258e6be3bb
Git Commit: b8258e6be3bba686216755616e8f8937826a5a0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
