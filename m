Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F5E1366FF
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 06:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgAJF72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 00:59:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40388 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgAJF72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 00:59:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so595012wrn.7
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 21:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CEFkkZz0U5RpKjz7d8HpR6gHotBTayrTp7ZenO75Xck=;
        b=ehto3FgXoSz5qDBPJJ+bNWQwA1ZlIseVoHGXRliPpogsZt5nHRMr5xsKdWA5jja70W
         z8lRwBjLJqBm0wXFjfy11eBx3pZCnCzVkY4evVImczLZuJJr/tiQN+trhJNXjq2Y5N2M
         cXkxrPkEmPRt6gy2tHLLXrodWEIH4iiLDC4gKEEEmjBiD/w9eIKISlPQTUoN+/DZ7SDf
         jSK2B7Av9gJ84hyPQ/Qe1HRDefK+vk5VM0/xPSek1Xnp66txlzKZETIs2VZnw8FBs6AK
         r3FQHviH0/S8IshlkXuQfaShxKbJ46Q5w2gIrMjgvTax1dZE+oXyvSNqspqRJ62VGMwH
         mTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CEFkkZz0U5RpKjz7d8HpR6gHotBTayrTp7ZenO75Xck=;
        b=msStzA2UVBHvTQ0x124pBFKqsQ4hacsE9K3BEWnjDtxjtxhHrnwwiJ+KYQ/Fg+NQJh
         l6F5OasDIYUc0HzmA30d9pQ0lSAC2uUrnSUP2cqAoa6s2VYvIYdFsVUBfg9xQ0fxes1q
         hOgpxekyI3Rcov8352p16RnIxYrNX6DyJ29MoTLlNS4iiaAbnZiTjG8TVCdPkYzkvih/
         KiWjGzOfa64LSwQiJLC2MZKZeAM0cjJHCaeAzCgve4gzwTso+XLdRzrzgZJ/qD6oe+fV
         pASKJGvI1+gIyKtUrg6kTwwgcMvadmAopS6pj3NE6EdCBSh3rT454ZYv0iFkREqpc2cX
         2O8A==
X-Gm-Message-State: APjAAAV+yD3NIo9i3MSQ8D8G0Vq7f14onDJKsZbS2QNSnPLryPgNYcw0
        UFOu6PRW6exYapX/sbysk09L4Elrc96WiQ==
X-Google-Smtp-Source: APXvYqyL3cgkYeIobf3llVssXtSllCqUuVGRI4LqGg0mipKpwS/pz8H4nfhEqzu1wM84+/gtuSS0iw==
X-Received: by 2002:a5d:4d0e:: with SMTP id z14mr1381422wrt.208.1578635965974;
        Thu, 09 Jan 2020 21:59:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x7sm957525wrq.41.2020.01.09.21.59.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 21:59:25 -0800 (PST)
Message-ID: <5e1812bd.1c69fb81.20fe5.393a@mx.google.com>
Date:   Thu, 09 Jan 2020 21:59:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.208-50-g8ff01da61a3f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 30 boots: 2 failed,
 27 passed with 1 conflict (v4.4.208-50-g8ff01da61a3f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 30 boots: 2 failed, 27 passed with 1 conflict (=
v4.4.208-50-g8ff01da61a3f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.208-50-g8ff01da61a3f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.208-50-g8ff01da61a3f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.208-50-g8ff01da61a3f
Git Commit: 8ff01da61a3f8815dbf7ef0b6b5b75b5776095f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 7 SoC families, 9 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.207)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
