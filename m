Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43601A3DD4
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 03:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDJBuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 21:50:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38833 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDJBuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 21:50:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id p8so362167pgi.5
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 18:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+pPorZqj/jQfCH1qDoarSl4CcJohI91UiHlj9Wt3Zog=;
        b=OvM4IKj3L6LwSz6Rt7l141o18ZKYCCoYoZI/pYoPygqgOaTatDDzWAnyq8/Pv7b3Xg
         MfhE6Emv46VMwR6OP0ORcgHZ7l4N/OkuckVvMQo8LisI6yXsADWw7xIuHcsv23Nrlm4v
         FrnYaQwG7F4H/k0oow0e2YC1tUWdK1sFD5meFQZlM4yIgJtQr4yy93+wREzeEvMjTWq0
         DZetCMxC0hJurUiw7rJUZfytU91EkxHVKiyRrW0/bFEpk5oEXktdQmm+OECm7RkQg9Qh
         cjreRaQ5XTqRsXMeucHSof2CHLz57NMWoZSQbp3H+z9KTKBW9rfWUo5J17TwwFp+ac+b
         tm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+pPorZqj/jQfCH1qDoarSl4CcJohI91UiHlj9Wt3Zog=;
        b=htMaKrD0T5U2E0lnpbjz/o08XQZugPB4wqgOmhU8HJnEeA6m4PDzLG1eLiER00brIb
         0TLj/J5OyapZWiKj0aP24TEbLXkoJjbCrC4d4C/q8a/Ed3NMMb37K2W0RRAntG2/vcrL
         G6G/ugJ2RqjxTGrud97YBzTPq461wA4cLcF79G3e/wxFa39hyHkQFwu+CqRMjF15eMBd
         gZoH1qab8eqUdzPx3a3DySZvXXeiQxrmZlIjwU8zSPPy9F5/lnu8FecWKG4Y9i3nD0LY
         Qqk42nDoYgZGA2vMqQGL318qWb5+T8ePilNf0aaYdzFF1iZ/UeO9E+TOypXSDjwHtVKb
         sdKw==
X-Gm-Message-State: AGi0PuYby11Mp14N/IZFVXWr2k4ocbGluqReVdNVNsytcNGguILZJPA3
        lFWkpzzZ0utjcjNr0cS5z0HkbaHrxxY=
X-Google-Smtp-Source: APiQypLh73AIABm8Ef/eWhZUpRSZzNOimC1eLj8Hkwb/Ws5+W973xMdPvZVuJXDMcJNICMcB7Q06TQ==
X-Received: by 2002:a65:67c7:: with SMTP id b7mr2269520pgs.345.1586483412589;
        Thu, 09 Apr 2020 18:50:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h71sm341162pge.32.2020.04.09.18.50.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 18:50:11 -0700 (PDT)
Message-ID: <5e8fd0d3.1c69fb81.27c16.1467@mx.google.com>
Date:   Thu, 09 Apr 2020 18:50:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-54-g6f04e8ca5355
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 164 boots: 2 failed,
 153 passed with 3 offline, 6 untried/unknown (v5.4.30-54-g6f04e8ca5355)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 2 failed, 153 passed with 3 offline,=
 6 untried/unknown (v5.4.30-54-g6f04e8ca5355)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-54-g6f04e8ca5355/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-54-g6f04e8ca5355/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-54-g6f04e8ca5355
Git Commit: 6f04e8ca5355b84edfdd022f0bb4dc18200341ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 61 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 2 days (last pass: v5.4.30-37-g40=
da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.30-39-g23c04177b8=
9f)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-39-g23c=
04177b89f)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.30-39-g23c04177b89=
f)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
