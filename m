Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DF996BAE
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbfHTVpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:45:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33391 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbfHTVpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 17:45:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so75377wrr.0
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 14:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FagzhwCigtRxCO7EPozgnx4+t/t+GzOThf4qqOLWCCQ=;
        b=TO8rJKSsl2WVoWYPQD8/jU/jc6PPzupM7hBchGito/XWvmcPu/WFyXiPUtfsmFK/nQ
         b1j6rQYN0/lrgnGEwsmQ6PbY8lAPLpPHdZvELlnQ94JW9NFydxMAU8BXs3BRXJ4RixpH
         FQJxk4pxk1kkCUQWtsOM9/wUsaFiKcXd84FUDiwIq0zYGHhcBk5oP0qcCP8xq4XvbC9B
         58c1vmvwrMAb/83QiiIZJInC4oVcHK13x3FrpA5XHG1j5UzGSTuBMRmNa26GuQHMKeqw
         RqycxR+2w3r/VbCzMICn1mUrC1hpogi7V+j163I5unJ8Hy8h/gcVvrjxLJJZm1oqpAL4
         6Bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FagzhwCigtRxCO7EPozgnx4+t/t+GzOThf4qqOLWCCQ=;
        b=rKhHmccPMeLNknm0Cj1120663R7ClNmCFCHGZ9Htwtj+66J3mVwYrvBjGMXj4Fbvpd
         8tI7hJmBwtf8IHQz4Xrr8HoYJJcpChGa3THbirLmS9v3JD6oPs58KBSqFqP9DJq7omsO
         pqZoAg3oO9kf7PghpY1tOlfKi10z5TlZ8JagIRvw/tnR3NHnJaX1pbjFqrj/vEvT8OqW
         Qa80NP9yeqEwl0gemgrdFxZiwz393CveBerk0ykEoPn8MPX6G8JiJqQYDOYfoeMH1pmd
         ZHMXGEh9XZJXp205ll5FJ6XL71yHEuQ8ANyWR6KprVGV+FHQfY403ppS7OfJXkOBTM4g
         KzPA==
X-Gm-Message-State: APjAAAUALA/EVPaiulr7VqeMVPQzwbADJlqD7f0TRid2e0ch4OESBGSJ
        xkMWxfo2m1XXQOrrfo1d/YSE0VjgEbA0Hw==
X-Google-Smtp-Source: APXvYqx8n6XvuDyJdJC1SZt1uY3SxxjAhWeQKEFnhvGMTmxGExPkbYVognbEu35DI0cuBTrNx0tskQ==
X-Received: by 2002:adf:bace:: with SMTP id w14mr36863870wrg.283.1566337508103;
        Tue, 20 Aug 2019 14:45:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f6sm42832165wrh.30.2019.08.20.14.45.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 14:45:06 -0700 (PDT)
Message-ID: <5d5c69e2.1c69fb81.ce5b9.cf87@mx.google.com>
Date:   Tue, 20 Aug 2019 14:45:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-252-g0953e780f37b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 139 boots: 0 failed,
 131 passed with 8 offline (v5.2.8-252-g0953e780f37b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 139 boots: 0 failed, 131 passed with 8 offline =
(v5.2.8-252-g0953e780f37b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-252-g0953e780f37b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-252-g0953e780f37b/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-252-g0953e780f37b
Git Commit: 0953e780f37b870eb9ba08de10d6b1666cd39b76
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

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

---
For more info write to <info@kernelci.org>
