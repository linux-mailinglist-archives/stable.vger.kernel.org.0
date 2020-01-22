Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E961145823
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVOrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:47:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36690 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVOrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:47:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so7600576wru.3
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 06:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uIgGAEh12AyDzZcbE65v2+9oPOz7DYk9s8GxblJMYNE=;
        b=cmaLSkFz54c5k/jul/JQ3dp/hk/ol1TT0/QubEJ7spS9ZRf+YsC8+PM51x/PsLuzkU
         4U0K+8ZtOETip07aZNqdGJg/ah5ADTaIUo65J8pUWnqRek2S/lMOQW63pg7Eh8xHvZfd
         8rxmtLcUd7m7soqbmFzrMbnbSAgEBrRYyWFRs2NchoSvFbCBFbkMQEVo8wAm5B/Qf2t4
         62LUSNiROrl55dGy8ezC5BD/Kh4ejZW5K1PXz8Ub61xEQcJej1rn6u/1rcnw3Owp4jCG
         VGWfCIkdoBjx0cWUTclaGJSL58Ahn3g6XdmFWGq78WhDp9qDNWZSPRHI2HkjmNphvEnX
         M0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uIgGAEh12AyDzZcbE65v2+9oPOz7DYk9s8GxblJMYNE=;
        b=gauFOSMj8XHEEFGrNMv8ZHdg/Ir9NFtbGxykMpzCfVApFRwyNOMqKuU7ITJAGYmPSr
         WUQHxBnEOwYoTss6VQZuTkaLrFH+wOLIXTm1wPchq0A7AR/IODXglKDbbyo9wuOChOtG
         Yh3MiRwwO1UJ9gjjYn7jRMsuJ8sTrM/9JZvxM4kR5Vp+XbcSWjHVff6LMTiyFPLWWGW8
         cAPQGkuLQCQ6JbqpMlKsIQ8D5baOxxhqoEdz/zEmfIA+goSdL1ZGozmNHvYST8hjtfJB
         7s7VA7fKs7bgKSsl+5bWAeFfxi7bfd83t2xztVJmP+apsM1/Gyz3tE3bP9GfkUOJIRCv
         zHmA==
X-Gm-Message-State: APjAAAXxgkvGOBzHHQ6DDSzIapXpgDz/WJ5Ynjy/orWh8Sw8yanrjZjN
        JPoGiwsu/F6IqolWHHRkOq/h3IajYo8MmA==
X-Google-Smtp-Source: APXvYqx8Ll7QB4/0ny0Wn6f2eRAyRYcQOA78ZmwpsuBj/caAGovyzQU8FiAvq6vYEH8u/ZpmcFd1Ew==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr11325530wrt.367.1579704464019;
        Wed, 22 Jan 2020 06:47:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm58555617wrv.34.2020.01.22.06.47.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 06:47:43 -0800 (PST)
Message-ID: <5e28608f.1c69fb81.7cbc6.a3aa@mx.google.com>
Date:   Wed, 22 Jan 2020 06:47:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-98-gc10529b210d1
Subject: stable-rc/linux-4.9.y boot: 74 boots: 1 failed,
 64 passed with 9 offline (v4.9.210-98-gc10529b210d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 74 boots: 1 failed, 64 passed with 9 offline (v=
4.9.210-98-gc10529b210d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-98-gc10529b210d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-98-gc10529b210d1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-98-gc10529b210d1
Git Commit: c10529b210d19bdf8fca0385b4e1e6374401dd5a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 16 SoC families, 16 builds out of 182

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.21=
0-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.21=
0-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
