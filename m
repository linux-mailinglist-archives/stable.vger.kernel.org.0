Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE781808E8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJUQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:16:01 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43682 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgCJUQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:16:01 -0400
Received: by mail-pl1-f196.google.com with SMTP id f8so5872891plt.10
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dNxT4tjsnQWMPELBZ9Lu7BdGf9JQTLQ/MmoiT0u+NUw=;
        b=ZhWe0f43ul+3v6PTeR98oaSxKBzPAuybzaTWjzguNNpyXNA1qhsy+PZUpBD+nKPx23
         v3d4U6qobf9wqW5HCW5G00Nr+yyJ1hERJKCIxfHIr6R1KihFelE0YomBVb53J8nwuVwg
         lVlRufYQnhJMYgtcQZLIwWsGzBPKuWT0xrsvCJ9H+FBlqZ0+ZLdP7Yo6lL9EbTcCcayO
         T5BzFg2C/xh9UfqhuJJZ75mlBlHpFip2hzY5j20OvovJZtAOuKkR/fXQQ/3wlR0A+t71
         oJ3d/7V0XALvOllqkvbae7GcrPecpCsBuCJI66OqfC6QjsKpHMDCEFD9jLiofHV7j/lU
         f++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dNxT4tjsnQWMPELBZ9Lu7BdGf9JQTLQ/MmoiT0u+NUw=;
        b=JBhzIhQScEv2v1+MfBJjh3b7l1/ek8Lfz83JpPbLVfcr6Eep/Hr4korfqfVBSRXBH5
         T53fziq2cDDjMYrkTwn+tpL6IwI3AElzW3WC7SXqtTDjHvyrhG5BbYrcAYxY0W/J8JSm
         efnks5fv2EsdDSg0t5Y7rY3qYDcS07stlPZOQf3JTLQmrFEDHq3Eo7QTv0W1PUyFdjA+
         Tgv0aOskSq562GJEcghBvXNtrsQIH0NZP9ImxJ0djWc2GKSjhccDwQgggFsn1KTr80g8
         8rovTi8mW1b4reC7FYY7FH0jxulvSDXONqSIZVBFZrtsMXaubzWJj5fS9zhrspIYkNrv
         fmqA==
X-Gm-Message-State: ANhLgQ13Y6uFeAD3Q0zR2CoS0RswMn4kD/Nwg+fuQDAh6Q2HoddU3Qoh
        Gi9qxYX32YlMHKZiTtZuzOnKqxqkBTM=
X-Google-Smtp-Source: ADFU+vsx23ZDgJM595ke3NUtCDvbxAidHHHfLumcOd88tlnsSazzrD5UvcMI8Fu323Quy92hWJs/QA==
X-Received: by 2002:a17:902:b085:: with SMTP id p5mr22510204plr.218.1583871359892;
        Tue, 10 Mar 2020 13:15:59 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16sm21731471pfq.40.2020.03.10.13.15.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:15:59 -0700 (PDT)
Message-ID: <5e67f57f.1c69fb81.48831.c5c1@mx.google.com>
Date:   Tue, 10 Mar 2020 13:15:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.108-87-g624c124960e8
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 105 boots: 2 failed,
 99 passed with 2 offline, 2 untried/unknown (v4.19.108-87-g624c124960e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 105 boots: 2 failed, 99 passed with 2 offline,=
 2 untried/unknown (v4.19.108-87-g624c124960e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.108-87-g624c124960e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.108-87-g624c124960e8/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.108-87-g624c124960e8
Git Commit: 624c124960e89afb43869bce83b067d94cf661ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 22 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.19.=
107-88-g619f84afab6a - first fail: v4.19.108)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.108-64-gdd4b8602a=
cb3)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.108-64-gdd4b8602=
acb3)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
