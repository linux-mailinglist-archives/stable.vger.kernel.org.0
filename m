Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118077236B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 02:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfGXA0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 20:26:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40060 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfGXA0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 20:26:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so44949175wrl.7
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 17:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oBVqD7dZZI/ONrR86fzHe4wWpuTSMQL0QBdrpHDdbCQ=;
        b=Dei/tHZiYO5/6StAVNWUU9MOPzARGwzTXHs8ce2u0PoSFkF1Abl9rz4in80PZ3LnFc
         ee3HFbhvevUm9T9/X2fWvc9e1erNvE8R7n/veI9Q1dEXcfQu6wu40LztPyOovX8za40D
         Y2Rt+4/U6wHNmiwdAOoVfoN+/ji72nEquXFpK80JdILf5X0d79Vw8jFhZy5OxH5deidQ
         Q9XwdvlFviGrzT/lB69lE5SL5zLmiYt3ZXK5E78UGlz5PzQ+BcyqLtRoRZ5NmmpkWxbO
         TVNTffCYcWS/6CzDo5S4t8zqWk6CQLobcVCAGmTUp++lAy1jL3gEVKlU/vl18MYFP9R9
         LmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oBVqD7dZZI/ONrR86fzHe4wWpuTSMQL0QBdrpHDdbCQ=;
        b=OyrAZuakW5CZ4PIOOhmRlRIUSPo0eRO80R+adbWsfMAjHUzhg2ftowACfnJ5Zhigf5
         TOuNxWxGVkFFre5m4qd0CWdMQnNHMYwg5FmI93I+8UdJdrQoO+X7LwwWMD9H3DlVHgXS
         zJAjsXekk2lpO1BisC9XtqvRw/6cv4XDxrQ2y14Nz+3SzeKcfAxGowX91A3FvkQhrgTJ
         yt7hOW+j3ccPfP1Mjk8MEDvT4ij5t6FRHyxBY7T9hFkULH+I5HlZ5VD42B9GerV8t1DX
         HBOrcvBs66v5i4MS+sIs7l+IPd2nzO0IH4+lGsSA39rT6u74IwhywDeHl3yoaWgXAoDv
         KlBA==
X-Gm-Message-State: APjAAAV6eEFXCOoOhg8V+RMsim7bDj2JUnuBPRpDrIRX6Sf3q9ouHwbG
        LEyYOU0vUz3bpXEjhed40GhzBSUuGYQ=
X-Google-Smtp-Source: APXvYqzK5o575kAu8XIooBTHZ37xMI9S0xTYdBCfvtST+dGcrMKfdGdu4xVxJhraUYfqkCtUxG2dLA==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr28658402wru.288.1563927989971;
        Tue, 23 Jul 2019 17:26:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 91sm92405151wrp.3.2019.07.23.17.26.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 17:26:29 -0700 (PDT)
Message-ID: <5d37a5b5.1c69fb81.f0936.2e2f@mx.google.com>
Date:   Tue, 23 Jul 2019 17:26:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.186-76-gf1f6aa1c598f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 90 boots: 2 failed,
 86 passed with 1 offline, 1 conflict (v4.4.186-76-gf1f6aa1c598f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 2 failed, 86 passed with 1 offline, 1=
 conflict (v4.4.186-76-gf1f6aa1c598f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-76-gf1f6aa1c598f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-76-gf1f6aa1c598f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-76-gf1f6aa1c598f
Git Commit: f1f6aa1c598f856dbcef9c32a8bc96b7e07b78ba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
