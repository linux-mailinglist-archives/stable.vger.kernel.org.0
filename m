Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B56B3FBA
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 19:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfIPRrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 13:47:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33648 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfIPRrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 13:47:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so399889wrs.0
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 10:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IZkMDxveEoFaOasGpsOWsiIEf9PR+DMxs3JoKXXXB64=;
        b=Bt115adnzsjGQqgkgrKnxRwCBVp81Acv4PYaXTF8+7R33omXw6MAsHHDgezpOGNcnY
         j8R5wZCeC9USi6r1/ZgtM6IR9H1xs/e3SzOaU2fluCfAUg01HeN4SbZYS8NOp9LUzZtq
         LnhjXM5RdbGofzq+6qe+dFJFLpELcKI3lw19sRXmxGxUM5Xh8DHMHfegQOtrqEn/rC8O
         i+9lyblkHBXwskBOZ42DLW5wnAERJMR3VwcMxUzx/oeZcGwrsWkWan5WSx69uSbWmY9p
         J5zxGTYTitkVpV24dg+6dmOM2kZ+hyEEye2pDp2yQX67HgnMRaf9cr1RX7yPxQX5YUol
         U7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IZkMDxveEoFaOasGpsOWsiIEf9PR+DMxs3JoKXXXB64=;
        b=P6mbbh3VqBQcJVdLvk2hCyI9jOHDsqyiS+9dI46yct+jf+IbMAuR7pod5puZUUXEmo
         /En9+wxtEUEpSXhxDDhAdL/eN7Id5d4MEOaDcHhGhkR0YlPLjBIMwXZU3HMQpnh0FR4r
         J+PTmRZpU1lZs2OFs/+Pym5X11mHS8hXdG+AcROsz3bv0Ifoe6HnqZP8Bcxb28GzHLSS
         rKULZo0y6TDKDwk40crcI9OERe4kBmeX8gUiEDdbmYm6WK6R08akq6zBQS8KQTH41vta
         uI5OQcL+LVrATU6IpgZkrQBID2fwTJrcd47unDKCyanaJwQkAyRvaAln7AoeO/aew5kC
         qkWQ==
X-Gm-Message-State: APjAAAV/4TxlYQrlpQk+VsLhE7BB8imKfHy9mc9UZbJE5+5T44sQRJiO
        eMWsG4uw0L0AaL87X9VC3F4wZlbCyitW7A==
X-Google-Smtp-Source: APXvYqyUnC7JTX8XfYgmrgNl36omKEpZDkgyIDrdAsc0AxsXUnT3IahwIoVdIc1e3GSQiYcevu0G/w==
X-Received: by 2002:adf:e951:: with SMTP id m17mr812528wrn.154.1568656058111;
        Mon, 16 Sep 2019 10:47:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a6sm29247193wrr.85.2019.09.16.10.47.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 10:47:37 -0700 (PDT)
Message-ID: <5d7fcab9.1c69fb81.3c129.7d99@mx.google.com>
Date:   Mon, 16 Sep 2019 10:47:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 136 boots: 1 failed,
 126 passed with 9 offline (v4.19.73)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 1 failed, 126 passed with 9 offline=
 (v4.19.73)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.73/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.73/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.73
Git Commit: db2d0b7c1dde59b93045a6d011f392fb04b276af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
