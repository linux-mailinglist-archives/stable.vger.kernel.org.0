Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABAF240EE
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 21:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfETTJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 15:09:35 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:37704 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfETTJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 15:09:35 -0400
Received: by mail-wr1-f47.google.com with SMTP id e15so15845414wrs.4
        for <stable@vger.kernel.org>; Mon, 20 May 2019 12:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1w+fH/v8RBSWF87o1Wwaj3X+JwCU/nfmU+CgH+VdYgw=;
        b=z24MxLNRK2a01wOkcRB5TsTcF5Bde8MnVkUj1KQiu8GYBkHAEo2XscYdkawK8Gx4bp
         St0APBL7o3+Es1h99ZjfI3lIYhlC9fb93s0irPuNM0nX8Fi1byI2m2xksmgmOPlhSBTG
         Fz5zZD2EQKiNH/MPVoAzdGQAs1VjGJ1+oDGiMlq9fsuKUmzxNpVe80RSvCfS+lirf49a
         +37sBBZMp4LyaM9VIeITxOgmhm2NtrXrwzhncCkH8K6Pgh9CGJnXZM1XuxgTEYUFNB4h
         e+oKr2msehA/hgKhYAVFKwd8759QZKRiA+V5zdyUJRP9taXm/7ltHmyvUBdF0BPyvFGr
         V7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1w+fH/v8RBSWF87o1Wwaj3X+JwCU/nfmU+CgH+VdYgw=;
        b=XzDzS4mk/NIkQz4vcY6Ig5ajrRpT83E/nBKNfy6wJsSTq9BYjOGoV0Cc0ALZG64tIQ
         Pm9aNmB6BiR5P2Ym02DvPtDtYHEuyhOLgYaMAv6wpXY8yCdQBF3v7ytKH/cHutR0qXDS
         UvJ2OGUrUWOj9c0kOWuDITgUFm69iqFrCc5aft8PRYWLmPdb/VMsrvZrbWPa7iW335YX
         FxlgpKa/FGta3cogJugyvBNEoztYLgtpa4jaWQPat40qY786P8pTqIDAPOfxtjvqZRcd
         /pPQwWH6G3WyHgCuAHRBx4W1zBvMneQDYd9RdHlg8mCctUjaSURD8UK0nf7xgMpKwfAh
         3LgA==
X-Gm-Message-State: APjAAAU6Fm9l4UITV9MWnzJgqVqrkRoANuhzONKQN8btGEcWfj7dbEg6
        11mTjbaGTDChbvFCZdeA8O+O1RYNFejGtQ==
X-Google-Smtp-Source: APXvYqzKU3MUXIyhJUWyNUj3nO/rYeneYgFlKCYtY3tM63Cka+xNIbDvevPn4PcaxPWHnU17aYS6Ag==
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr19864002wrq.115.1558379373573;
        Mon, 20 May 2019 12:09:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t66sm446965wmf.39.2019.05.20.12.09.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 12:09:32 -0700 (PDT)
Message-ID: <5ce2fb6c.1c69fb81.189f5.21e3@mx.google.com>
Date:   Mon, 20 May 2019 12:09:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.177-45-g1a569b62b013
Subject: stable-rc/linux-4.9.y boot: 94 boots: 1 failed,
 91 passed with 1 offline, 1 conflict (v4.9.177-45-g1a569b62b013)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 94 boots: 1 failed, 91 passed with 1 offline, 1=
 conflict (v4.9.177-45-g1a569b62b013)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.177-45-g1a569b62b013/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.177-45-g1a569b62b013/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.177-45-g1a569b62b013
Git Commit: 1a569b62b013b75248598605647b0c077a399c5c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.177)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.177)

Boot Failure Detected:

arm:
    qcom_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
