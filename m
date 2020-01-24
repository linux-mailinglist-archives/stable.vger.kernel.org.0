Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1D14778A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 05:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgAXESi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 23:18:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35181 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbgAXESi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 23:18:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so394971wro.2
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 20:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+YT7/TLcy0wVFmmFlmTymZ5/Hzibenoh+IFb9qSXmTE=;
        b=gcbX2gN5Nozv9H6MSbArOsTKcmvGG8DZeNOk0SOfuvY6rEDokSl0jP+FNBVaZ2ffCD
         upw79b9U2Bp33KWjKMYsgBTwb8pdVwaFidXPWNNBf4pma7uFvQrjAuakzaoiOinJOWkY
         fBDNCGIoMSD5hveE8XuZxrj8OESEl703M9FmIBALB6dHQfmSEFf61D017kSuvOUl7J4e
         8WfspSQGR5Q+UNYC8NXt2CAjQdUbaiYaJAJPJlCfw7s4uMDSEf67D06A/4wJxVAMG7yt
         55gh0058ohZFonJTPDZ30/wfw86jzcxX8HKjjb+LA1kD8BdXmJF4EjQik+CO7mUA8IOa
         CHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+YT7/TLcy0wVFmmFlmTymZ5/Hzibenoh+IFb9qSXmTE=;
        b=dK7OrXLmm32/+nlpyG1/iw/wAcyHVn/1D6RgwxpjbDR3OVdOIYQ4cB1xst8wuG5Nrk
         Xn/6G8juabX1QovhZQ42ek60wAuQ62/8h1s8rVniM5J00aW6rpwMHnw7vhXjoAOpCJXy
         8CDr8V6RdOqiiLv1VpVy6zZP4tOAlH3M8eSkXsNR+j8SRmlNiBL5Aa73+vtN2M5JD+WW
         OpL5F+D1c2YH37fWRom09cn53c192FozvCs5VJY6hxc1MG2pbVnef5cxCJHmYQSclwMJ
         ugL5qs85pK5kGbGULJxHcbw31ily1hT8TQPFpHUpZhOPpr93BUvYJoW/mKHZ0WhXUGyL
         zxgQ==
X-Gm-Message-State: APjAAAW6Ut4KucuUJGtoamS83XcWl89kiVfBBmvauW3qUsq3t18zMwUN
        dEvU0PP7ggTfz/A4er92sjdt3WaTeaRjOg==
X-Google-Smtp-Source: APXvYqx2tS6goT82ht2OCeYH0ylvipCk/MPU2aJhp+c5NwYHnXUqPVpIZmwiYTAIkelsYGupaCXjCw==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr1724877wru.154.1579839516065;
        Thu, 23 Jan 2020 20:18:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m7sm5122495wma.39.2020.01.23.20.18.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 20:18:35 -0800 (PST)
Message-ID: <5e2a701b.1c69fb81.a08eb.527f@mx.google.com>
Date:   Thu, 23 Jan 2020 20:18:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.211-234-g33fcc657a28d
Subject: stable-rc/linux-4.9.y boot: 101 boots: 3 failed,
 91 passed with 5 offline, 1 untried/unknown,
 1 conflict (v4.9.211-234-g33fcc657a28d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 3 failed, 91 passed with 5 offline, =
1 untried/unknown, 1 conflict (v4.9.211-234-g33fcc657a28d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.211-234-g33fcc657a28d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.211-234-g33fcc657a28d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.211-234-g33fcc657a28d
Git Commit: 33fcc657a28dd3367ffd2334b194ceb1706c4230
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 20 SoC families, 16 builds out of 185

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.9.2=
10-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.9.2=
10-77-g2f9a91e62a20 - first fail: v4.9.210-81-g0f7725a1298b)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
