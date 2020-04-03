Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E6519CEC9
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 05:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbgDCDGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 23:06:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46268 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCDGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 23:06:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id s23so2132169plq.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 20:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=01o0JPxavZjGRENmJGB3CzWNqi8LBW1u8PmW2SjCttQ=;
        b=EKf3r2XUeHCovl/9sqTUQLxneanThvakIbSeOL/lF7cRdPt8xkPtuHmMFsOiMHqTnE
         BKj/Aq73ciNXoy19t6ZfoJHmDVWEhYFPrYnhccNNERHdKG7jWf7QuB4U64KsXTx85l/G
         bixxEl9BPB16mver4/J4aTBDZZHdeDbdwoLXCZtudX/Ju4R3EP52r8uuqV090oGDXRJT
         rHT+WWlWD6C2UPboUadg3SA6SnTC5xyMXVX1NuWWkAWbG05joI3TRto+jKGfxR//Rws0
         +TYkk8QT2/EvPPxBrWIM9Wni6zSZ/Mg6+YyvmQrPrVvWBhv3ocwQFMHy7exY/jrmq3LU
         WT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=01o0JPxavZjGRENmJGB3CzWNqi8LBW1u8PmW2SjCttQ=;
        b=ErrbpR37MAUcAgY5TsKUDNdPfNxJtmjfxYUUnVPMYc43UYv6VNB/5vRj3pegd/cdjY
         4H/W35WEpt9nzcv4HIlRDlsyqUZcGIuoyV5zAQvgQ51gB02C6wO+4jjgrRDM31HL21YT
         2pU0hT4NIh+K/uFMv4dcXZ4uM5vM+bpnoQ7S5GC/J9MHbB0MIeD7xKhk2U31BMEvqDxa
         RP1ZpmREfZsSRTlij1yp7khEzdVdDk5/+bUWmhORxz6ncglBqm4k5GjxHvp6eXjsf3m1
         kwqHqEYyYT1zPXy5X9eIXtexw9pLu8KJskOaUgxIdKbBKDO6Hc+OMzfZ/LuW5iZI0CMq
         I59Q==
X-Gm-Message-State: AGi0PubtQjR3O7/Ej+1pHOc61RRerZm9JLUoHIBdAYAKFT0aa14ZkjXB
        giUjOg0f/WRSamVBmEVfwdy9CNXobs4=
X-Google-Smtp-Source: APiQypLxzbntzPvnAAoY3Sq0CVLUlL19s7GqJvjFs8ur9r+64A/1T4lIbfvS85aENnVVTYFh8QKkTQ==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr5914302pld.21.1585883208324;
        Thu, 02 Apr 2020 20:06:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3sm4296929pgj.13.2020.04.02.20.06.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 20:06:47 -0700 (PDT)
Message-ID: <5e86a847.1c69fb81.e343.3464@mx.google.com>
Date:   Thu, 02 Apr 2020 20:06:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 89 passed with 2 offline, 4 untried/unknown (v4.4.218)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 89 passed with 2 offline, 4=
 untried/unknown (v4.4.218)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218
Git Commit: c4f11a973295ba9ecfe1881ede91025b59d43916
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 7 days (last pass: v4.4.216-127-g=
955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
