Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C824167BF4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 12:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgBUL1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 06:27:01 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45279 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgBUL1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 06:27:01 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so713378pls.12
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 03:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WSlF2S/jKbQcArR3him41JwiyCJwloEsBdOWpNATzGE=;
        b=lUvqx/Bn5QknfFaeZdI9rXy0NSEpiz3UmoT+Bz5ExJmVzMGuMZxwOCL0gdN6hRHTyh
         O5awSyONgj5zkJ/RIw1cLf8SZs4u+XZmmcEU3gMJfugR39xgylZP5KEmsom5Rr5h7Smo
         O7aJ6RfWYRe/tK//eIkujLrnF9sAlI7o6XzHGzsGynnlhMDpHMX8UG9AEtbIBvzrrx5g
         NaIzvMJbh1F4L7e5DgQh7/RFG0s2avC8dSg6O6+WFqRMPSdxSqZ4kkgqnMbL9HxMeg/c
         n4KWsZ2iIGyIn6wg2OSwtjXqCyAXkZAhH35RFY2AFdOrTN3cvKs8tl+RR35/5dVj4krX
         zgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WSlF2S/jKbQcArR3him41JwiyCJwloEsBdOWpNATzGE=;
        b=crHS8Oqr9KC1jJidKoYP+OP/Mrf42FVDG79W6lI57vHjO/zlmtDMy2SWp0IU25FJ6R
         cKari5m9QtfGZUh/jYi0BJAhPHIdBgcF7is+QYmAAeSWOjFx0KDtFl/4kdVfcHFdtFDe
         6XERPDKCAKJwAeWIH+dalfgoe5nMCOeOmKr3mn1EVWZlgIRsd16OZBC/nEiywThGBgwq
         9eCsf1cIUPK10gb/pF0w2+eNKK9tT8wiEIq3roRSv5asdFRfUF65diXlS//crqLKIDHU
         2785d/2ZPRpK9pPE7pbUTrkmS+kFzZVCYcpW1ibWInjYxxpCvOzyeOHl7+7RTx80u3xJ
         agTQ==
X-Gm-Message-State: APjAAAUXT6luEdZdtjITCHNfkuBzkGlMbyJpbon+pP7+Zia3TkkhqRmY
        WsTBfbT+TBN+13wPda7e/yiq/+RFkWw=
X-Google-Smtp-Source: APXvYqzyp7Sxp4urddHEarbh6mPgR3IY0cgOAeT42wXH2wyADpWXg5Z1D4kGnTwLcNYrIL5MBSnApQ==
X-Received: by 2002:a17:90b:4396:: with SMTP id in22mr2520980pjb.83.1582284418715;
        Fri, 21 Feb 2020 03:26:58 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm2384677pjv.18.2020.02.21.03.26.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 03:26:58 -0800 (PST)
Message-ID: <5e4fbe82.1c69fb81.6096.7d79@mx.google.com>
Date:   Fri, 21 Feb 2020 03:26:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.171
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 29 boots: 2 failed, 27 passed (v4.14.171)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 29 boots: 2 failed, 27 passed (v4.14.171)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.171/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.171/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.171
Git Commit: 98db2bf27b9ed2d5ed0b6c9c8a4bfcb127a19796
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 12 SoC families, 7 builds out of 163

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 28 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
