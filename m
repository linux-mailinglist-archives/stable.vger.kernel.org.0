Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6815D9B6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 15:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgBNOsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 09:48:07 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41996 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgBNOsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 09:48:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so11183538wrd.9
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 06:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WWlyMfKUxbrh0MSGf/nvgfTLtc395x16YAtoeieMBZs=;
        b=ZMG6d7t9vj4i9nteljlpxaZRSkQ7phWV7kbDz9szFqPIhrwNCjnU0KXHSumtyOuW6O
         e10X44d5wZf/fhxLW0Ze3SixMqtO8YQFNOMAgnYPrMycL58LRJLfcHGjcpjj+djx5dXt
         Eqfv1GtOCXPeKb+fMGa0fCbeBwLVNnJnhel4GGN2dmXqJNyiE3iWozGgNTfVFXdIacDh
         otVi67flf9jXHWTzW/Jz6tv70VE48+wUkCno+DK8iRL3O8P27ve9xBU2icg0W/hTUJm8
         81a8ohratC5fTYEg23Pclp78treHLUk39YWQJJfl0f4JSEGgqQyk/SV1EFdNRx9d6lM0
         NUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WWlyMfKUxbrh0MSGf/nvgfTLtc395x16YAtoeieMBZs=;
        b=Q/ePTo+3bR1a0oKDLQut8QhZhfAlZ3HEK23wNelq/t5OaebmFDL7xS4634zul3/ODH
         RCDZdqgQgOubudzKzkzWWO4a2zrEJgeNa1njTeY3sdcUPnuY6hz3bR6UlwJjQuqv6d3b
         CKLSC4Q07GZXuw5MI13hgkwLBKbTmUGRMtVLqQzV39VvGv89kQz0uxlUUJDVN6ZKiSjZ
         L00nw6TWLhU9kRzVNTnJq+WMEe+CLaad+SLXm0KloJ+7PftD70yuA9qIDT0tKBLftXRo
         sRyu37k9HrcNT35tCsmmZnoNGfUAP+1jupquL6wN9+hdBYGXgWXNSrSzVc0ES7eGysk5
         TwuQ==
X-Gm-Message-State: APjAAAV0U28y+VjryyH+yGKA0qh1W41aEQ5A6n84itixNNHv7ZY4wJdg
        n0iMlWKYyaSL7RSjFcwMq7CEmAe9U1V/ew==
X-Google-Smtp-Source: APXvYqzCjn+Mj/2njt63G4s9jSZ9zTS30GK68UBkaVB0SC0oTcXDL+wNWdP9HqA1F5xnN2j0Zs7AUw==
X-Received: by 2002:a5d:674d:: with SMTP id l13mr4340024wrw.11.1581691684648;
        Fri, 14 Feb 2020 06:48:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t9sm7694605wrv.63.2020.02.14.06.48.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 06:48:04 -0800 (PST)
Message-ID: <5e46b324.1c69fb81.ef002.1a4f@mx.google.com>
Date:   Fri, 14 Feb 2020 06:48:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.103-54-g504347304f1a
Subject: stable-rc/linux-4.19.y boot: 117 boots: 1 failed,
 111 passed with 5 offline (v4.19.103-54-g504347304f1a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 117 boots: 1 failed, 111 passed with 5 offline=
 (v4.19.103-54-g504347304f1a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.103-54-g504347304f1a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.103-54-g504347304f1a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.103-54-g504347304f1a
Git Commit: 504347304f1afcbdf2e57fe310584284576989ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 22 SoC families, 13 builds out of 152

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.103)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.19.=
101 - first fail: v4.19.102-96-g0632821fe218)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.103)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
