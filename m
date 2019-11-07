Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B4CF2413
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfKGBM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:12:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55021 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfKGBM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 20:12:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id z26so484169wmi.4
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 17:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nSo2jWRQe1ZMXCfTJ8t1Q1vEIr3Wm9pgHoL6MDvcpVE=;
        b=Ay1XfdB2Ht5d89Xrf6mmqEefeiUBvrwCqCJXTwrtswNDyTWvPkEgLl2GO+zXZqDslr
         zvyT1yxQB2ROFbIRPkllkl4wmC6lfkG34fMGflCmRYLGz6znPSg/8c6rLZkCE5XIePEO
         8OVjuG2Qn1XkurlrGIajjqUuU9kxvDohM1RrLvFf6qRvp4VbQgSJR+t029hn6xt6L3Ww
         S5OxV+cM6d7mfOzlsAqyPTi699FgONZ8cepmHeZkS/eF5UdXYKvFdHm35fASJxaAaICT
         I/WSKQ6sluGxZZLfghxrQPGAVv6FX3rG9qBlcUTNoEHxLgNG9szis9jC38o7gVx3cblw
         5ccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nSo2jWRQe1ZMXCfTJ8t1Q1vEIr3Wm9pgHoL6MDvcpVE=;
        b=Jv5W6RIGBi7bUNf14ZT440Ow4CYhHjjp8KzHkXokldy2eH+su2E14R3yT8lXc+zZRq
         nKrvPG4oOLfGwHaWmlTyfxwVHiFP3fM0/2BJmV/zlhxZhXcQ/qOBjivh98a3wPQEjcuB
         l9EW/94slIeXQK8IygFwGjt2T9IvIZHf3TRtMduUXxeZBYBDDEY6oiGyMBGIC6/zO0vf
         cgFUo8EofObHdbuhzo+ordzh7uze7H+NIdqb374tfW876EJU8WyhXg7b6E3hQ7o+h3we
         4KrfaRp3fMJH8agZ8rx0bSMsIQn+dQW3xpQXHOHcB8q7rl5LHTkUApLdkVkElY1N5Bym
         eW8Q==
X-Gm-Message-State: APjAAAX0HrSJFy9siFKnjOLcKRk2GUWh6v8oew8FUjMPuuCa3TvhvNC9
        1MK3+ifA1zlof3ib3Gri8rtOnQlbP3k7lw==
X-Google-Smtp-Source: APXvYqwUmk8p6Y66Ybxo/bbX5PyepEzfDXFP6LIGVaWcDBRfDDRSwnDgiuGUzHksh/K0/fNv2pdkGg==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr371626wmg.45.1573089176674;
        Wed, 06 Nov 2019 17:12:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g5sm307002wma.43.2019.11.06.17.12.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 17:12:56 -0800 (PST)
Message-ID: <5dc36f98.1c69fb81.a150c.1611@mx.google.com>
Date:   Wed, 06 Nov 2019 17:12:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.152
Subject: stable-rc/linux-4.14.y boot: 111 boots: 0 failed,
 104 passed with 7 offline (v4.14.152)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 111 boots: 0 failed, 104 passed with 7 offline=
 (v4.14.152)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.152/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.152/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.152
Git Commit: c9fda4f22428e09728b611ec9100157199039bfe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 22 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.151-96-ga=
9ad8ad8b3ef)

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
