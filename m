Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82EE1A7E1
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEKMo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 08:44:57 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:33639 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfEKMo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 08:44:57 -0400
Received: by mail-wr1-f51.google.com with SMTP id d9so2143097wrx.0
        for <stable@vger.kernel.org>; Sat, 11 May 2019 05:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LJvf8L+Kj20l+PldM852M5c/0a6JvBnhC+aaeAmThdo=;
        b=vKPTgd/TXlF2pMNitZ2d6DPPYdq3dT53F/sWsNCSf6mjS+VbQPsER6TbQFMLB8YbZv
         Yw3clojADxbk0GKwFTaIc7+oPA1dTmZemB54L5hSpBStogStI7RbS/JN8oDwxg8fF/II
         0wMJT5YdEhjzDIK1nZHebtT3S4Gl6BPm/tnfInrCyfTcaf61vRudj6QPptmRV7P7lVn7
         +m/JXDgmIpusQ18WbUgH4jD65sNOKyqOtfjlhysYz6TfHFZmEXFaDO5741ATve1opn7S
         rp2PdmZ/4uybghmOYQ98HLMKCKeSn+DARRff+mzyxZxiJ1XNwxRQGpxPk5YlTkN9lPJZ
         EF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LJvf8L+Kj20l+PldM852M5c/0a6JvBnhC+aaeAmThdo=;
        b=sYC7oPCsRs4rLHq1dQD9YZxD76DVkYKNcrwOyo/ZZZCxcuMYnpxvZSXjFs5sGcl1AF
         YV5qKwM7Yt+7yfUQJykL0vIbM/OfI4kAyzjxEQKNfqvwvuA3BbPRxZk3yFMkOqjQir1s
         5mIKlPRnSuipL3MJKnWkbDd+kXUgkz+ltY/9OCo+XRck4qiPW08qRlfZu0Pir+U7s0Lr
         B3FcEkZt9rAKmMNYnLZKo+ge7aUP/PGmNGoNy4dT8CVzCX1JISKl6vgrk5JQe0XGpn97
         d2pfRrlKifjEeXlnxi6SfYGTXa8hicuBdUG6KGpgxloT0F9MABTP8d+EacMTlmExS4jO
         0tvA==
X-Gm-Message-State: APjAAAW7Fqu1yx1MVKVBLj5A5/v+ZBJHEuZJwQlh6dpR/Pn/whpGhBo6
        7tDq/tG4FVgNKqxOkaS0TnmKpXaV9DlUpA==
X-Google-Smtp-Source: APXvYqwCq5T1S+ipBMxUjvs+S0e3dFtb5ecAjdoxVKmVj0XIQUhzQcYGYe3a7eiw2+K95N2SWYJA0g==
X-Received: by 2002:a05:6000:1250:: with SMTP id j16mr10950464wrx.200.1557578695808;
        Sat, 11 May 2019 05:44:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v184sm12336582wma.6.2019.05.11.05.44.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 05:44:55 -0700 (PDT)
Message-ID: <5cd6c3c7.1c69fb81.4a61b.0bbd@mx.google.com>
Date:   Sat, 11 May 2019 05:44:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.15
Subject: stable-rc/linux-5.0.y boot: 140 boots: 0 failed,
 134 passed with 5 offline, 1 conflict (v5.0.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 140 boots: 0 failed, 134 passed with 5 offline,=
 1 conflict (v5.0.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.15/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.15
Git Commit: 7b13756d2c328e35f0640d16b68541e6f72339b8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.14-96-gdf1376651d4=
9)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
