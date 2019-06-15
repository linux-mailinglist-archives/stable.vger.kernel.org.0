Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0347273
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFOWlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:41:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39747 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOWlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 18:41:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so6054964wrt.6
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 15:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FWqZcZxHbkQgTHFDlohckpZirBpYP29fvz4FUw+ERew=;
        b=WwWAY5PNtWCNnEvivXWzk+VcO5Vb5wB4tabxn8XuysHtkWusbCWtd/uu/fyLm/TJSj
         Vhf6u1osn8Hdc6vQyfHfA0CJnxZRq+diM/WTwDDOR4Ly9VmWvllTHaSjCCGi2m/rePGg
         hUpxa9f8jLhhvyX6u+J/rgCGHX5KZcmaMuLdGHo/3EtMo08NklZJcIKoXaZF2bI22+8i
         xz4xUVJRTMtVenDt1TUjeTBlHl5oPQYn1XozMaIzKLKrw8o7u9Yy5s46TZz+nVH17HM0
         +QeU4AhOYOI9dOSSgTHmEzcShJU8WqNr9M415G/gRFfDiL+Qmjq1+/85lOlMKYLtnRAs
         IHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FWqZcZxHbkQgTHFDlohckpZirBpYP29fvz4FUw+ERew=;
        b=Bv6Jm1u2EuPACyTOD8cuEOkGkvCFpprxaMESicHWM/NGhfPmpxp5us8BAejH2O3diH
         jiwMJS/hbvzpD2Qtg7RsY/SWrHdkwR7P7O/y1DF8Dewp5E9CivVzO2y8RxdBLcN8g4Ew
         8WpBphbrqzvR1eLh3LLMZD+Rpgvzxhs5RKELrKuYRGYKB+AEd/M+0JOqBCV9dtSuqpCQ
         2kZ/5hgKKuzjVCcAgJqE2MTHncSfnKttyBkoDCnEVyseOaH/y619oFta0Iy2ydN/pYnH
         j7vNyGlqRfwwJu5BsakkcIAkqTR7KEXBTeEwTG2N7cJXdFDK1vaMm3/dGvXUeJjPNkPW
         MhyA==
X-Gm-Message-State: APjAAAV0l6PhiGiGcvKEm3UE/cEwg5qyIdqje7du5FtaYiC9gyIlmTK+
        ChGIuuoD3Rkv9bAunkvuqNPETLbP1PzRyw==
X-Google-Smtp-Source: APXvYqxvx9yhEb5OhMZUdckcYkCZksIYKbQIKh+vVcNXuScx6y5MLzF+BZI4vugbx6YziOhw253kAw==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr36495670wrv.180.1560638494655;
        Sat, 15 Jun 2019 15:41:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o8sm7942933wrj.71.2019.06.15.15.41.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 15:41:34 -0700 (PDT)
Message-ID: <5d05741e.1c69fb81.cc107.b3e3@mx.google.com>
Date:   Sat, 15 Jun 2019 15:41:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.181-51-g3cb069b52684
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 81 boots: 1 failed,
 72 passed with 8 offline (v4.4.181-51-g3cb069b52684)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 81 boots: 1 failed, 72 passed with 8 offline (v=
4.4.181-51-g3cb069b52684)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.181-51-g3cb069b52684/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.181-51-g3cb069b52684/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.181-51-g3cb069b52684
Git Commit: 3cb069b52684a615947ba8af15e7c0866b9bb061
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
