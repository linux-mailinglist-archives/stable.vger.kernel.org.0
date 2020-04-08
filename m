Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07751A19E5
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 04:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDHCUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 22:20:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42419 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHCUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 22:20:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id g6so2633945pgs.9
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 19:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xe1hwpYbO9JHlWSHZ0nFsfMfERhkjRGVCSq3Avgt88E=;
        b=Cfyc3YPSDD0wY4h6LmgdWTj2slErGqNzopY/4vk67hSIeLMyvKu9wg5ntUdU31+KZ6
         NMN8/U7Q0RU5oOrXmjZEqjG0AyANk0Lv67MCJcei3fr+MI34VRQMIjBJmRW3eTLEbDi4
         fb1z3EAJkwaoSr/v3mnlROVa5gpZh4KriioUCdIu1l7TxiyQy+34GhWsnioYjlv9WkHA
         XVmSQonzrzlnQ5EJFvUVoV4jFFNu4U9ZUH4Z/yeDuPiyGyNu+POkzOUd+b1OC3vciLXP
         KQFfCf3cruwKySw1FBpwQjWsyDFNAoycMW6pkeRrEhKufbO94Mefmhh46DBLdbKZaGKQ
         9htQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xe1hwpYbO9JHlWSHZ0nFsfMfERhkjRGVCSq3Avgt88E=;
        b=I+qQ5lnIPfLDISL6ejgNvkV2XAcv3oO6H7JieCycL67vj0Q/y8BPrPWimH3cUUQGA7
         5i48LM86ncy5abNZch7AnCIBnc1ui2dCUJX2PdmUxwJ3ObLzDgul3msSo+NRpQktGJGs
         YkbFCtExgh1xkA50X4l6zY1JC5183mkc/IQXemt2I/j4qTiI2GBsMKbRt7eWbcqO5GCi
         SOE78rCJnCzHuiXna5EwdPqIp4qmYcDF8q3lZxy0IuDRA00vwiLMOM4a1HJLWoMcK4HN
         LmRTsRAtKNiGau+qM9SJ+a0BBJUe6WItqCjdRyHvs4eWXzbGAWmJC2ODHPuBPLmffuHe
         wqjw==
X-Gm-Message-State: AGi0PuYDn3CW0zJRtJnPw1fcrfV2xQHdWJE1k84VNaPjnjkly9a/BmaK
        bEzysBwZUHqZJbt3Z+m6flHkWyU8pJw=
X-Google-Smtp-Source: APiQypKdG+9U8lcLirF7/yvodVPpxzoQ+4k8icYuMv+LJn7raNjXENVefe7Yd6oVnnf66XhV1A52Aw==
X-Received: by 2002:a62:520a:: with SMTP id g10mr5259779pfb.271.1586312447699;
        Tue, 07 Apr 2020 19:20:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s65sm8438314pgs.30.2020.04.07.19.20.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 19:20:47 -0700 (PDT)
Message-ID: <5e8d34ff.1c69fb81.ab20d.4a6f@mx.google.com>
Date:   Tue, 07 Apr 2020 19:20:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-39-g23c04177b89f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 166 boots: 2 failed,
 155 passed with 3 offline, 6 untried/unknown (v5.4.30-39-g23c04177b89f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 166 boots: 2 failed, 155 passed with 3 offline,=
 6 untried/unknown (v5.4.30-39-g23c04177b89f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-39-g23c04177b89f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-39-g23c04177b89f/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-39-g23c04177b89f
Git Commit: 23c04177b89f23d80a3b5dfa54a4babfc32bea3b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v5.4.30-37-g40da5db79b5=
5)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.30-37-g40da5db79b=
55)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-37-g40d=
a5db79b55)
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.4.30-37-g40da5db79b55)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
