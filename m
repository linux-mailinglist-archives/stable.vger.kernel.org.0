Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9AD193D5A
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 11:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCZK4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 06:56:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40783 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZK4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 06:56:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id c20so27729pfi.7
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 03:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4XPaYXlWvmDWUxmss2zt1zp99FvjpJHl4B+5ybbY1s0=;
        b=f4Ms4/R9idrigi1CJxMlp+2f6SnPaDu9qurkrL6euuawExxyhiM11IOZPKXqgoDxHc
         RiejlerhV2beZ/q6B8GrShKkQVy+nFNuRpd9PinUQ0lTzdfElVKTmtZixfkuuZT4DTPd
         DuFMA2nFfUXZY7bOjMHKLqGLzzAUB9GizOso3BlINvW2oWOO9ureVBzWu4bYyKXHBPP5
         YOV0itIDPVRRPhbzjigCHWHdxUojGbQxqtVAn9M1SE3bPA2GdT8Sxz4i+P5xIoKoAVT5
         TYt2JsEQNSZBBMgikxpA9fgxz0240+5Lmel8qVBOA4Fu0xlAMdON5XBxcbGT94F4ZQ0f
         5rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4XPaYXlWvmDWUxmss2zt1zp99FvjpJHl4B+5ybbY1s0=;
        b=H9u2vZk2fE0hRzLl9yh5afb6KFPQS4zDMgNYMN6JYsrlRimAp8CzdXIB2ZKy8ga5Iv
         HDqKzGbo68nyQGMWjHyDYAvE+OykhFMntfxhjO84i8UrCHUfgHB4o0CrJxAkdgs/F7Cd
         jEu8XtRUgt7kUrUyRXfUCA47EPhyVdoWdqNtdt/REVDjdhfZpkRDlieCscluQiKaJkS0
         VIDFpzbFS0u4irsbOSSv9p2QL/++gfkN4GwC0bht2h13KiAxRmBuUxrevMdNguESmQpG
         vkPyw6oHwEhk6Okz9pRUzEgg/Yghlr/PIZ3K1sIU012ezKeb17/XTfmG9Ls7QRWx28s4
         5hFQ==
X-Gm-Message-State: ANhLgQ1ZC+PHRNvfr5+XdSKi1ywjgN8tZzwobWjSo83lyAnQlacWNQ03
        CTvWx9b//ybn1TWVV5fMkFU1vEC80cQ=
X-Google-Smtp-Source: ADFU+vtYJogarBsYOrQ0JBmzzW4S0e4knxdtX0EwFstYVzpNY1ZJttEfGEhEH5I3DfEzZzpvDkcM5g==
X-Received: by 2002:a63:b905:: with SMTP id z5mr7120538pge.402.1585220174054;
        Thu, 26 Mar 2020 03:56:14 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q185sm1385375pfb.154.2020.03.26.03.56.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 03:56:13 -0700 (PDT)
Message-ID: <5e7c8a4d.1c69fb81.2402c.531b@mx.google.com>
Date:   Thu, 26 Mar 2020 03:56:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 162 boots: 2 failed,
 152 passed with 3 offline, 5 untried/unknown (v5.4.28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 162 boots: 2 failed, 152 passed with 3 offline,=
 5 untried/unknown (v5.4.28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.28/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.28/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.28
Git Commit: 462afcd6e7ea94a7027a96a3bb12d0140b0b4216
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 10 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25-278-g14=
bb11f6495f)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.25-278-g14bb11f649=
5f)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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
