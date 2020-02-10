Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F2156EED
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 06:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgBJFtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 00:49:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40872 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgBJFtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 00:49:53 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so8999473wmi.5
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 21:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8F8vkuWooLIAOvJVrTVp4I0j1/1XRjLwdcpluUSXio4=;
        b=QQFO+ImnZoFt9WPqgaFL/ROFbp2IQbQ0V03el/FMB2UqE3P52ScKviewfXxs3pWlm2
         UkM8SZBv2XMKRomhduQPJ9pkk5KvQXJ1hX0WrgNRpNi/zjLHgk32vNbQQQtEzLBg7EoC
         y4HR6l6WmcuQPtRTI/4glBCNo8RDvJ7T+p9ni6WQv/dcVNZ/AYy2OqgUTsMzNrjscwob
         n0NLBbek4nTCNy5xoNBM+5DSkkA0S3+zpsAQFC2qyAnv67CvsBrclFThvjgvaqOtMIQI
         hZZcE0gHl6KxhP5Osu4uIQvhU30qtEb2iPgpsntlbWBt/QVeofY5LK5pQWBIE7NnRgc/
         Elcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8F8vkuWooLIAOvJVrTVp4I0j1/1XRjLwdcpluUSXio4=;
        b=l7SWSEXb96pO6hxWXdle/VEOZqptsUiwNzfAOXmBbGp0LcGX8L5TziQPbxU2j49F33
         YcgyCWe2JQRqUqH0TUdbu3S2LXxv5QsBag1H4jo0XdiSDw3IyykkWbOPsv4VHN6vQ1MI
         2GkJu5rJmy+tbD27RfF5pZHHIRUsDPSZsOkHy1xNEd6DYSyduDkzzrt/DA+yJ2J+KSpS
         jVDdcWlhmFR3z47wFvo6RqD4UCDu05rz+I9sAkkDSmyRJ0mkyTBlWNgiWnNEu+jSyxEu
         LSbBNlpstycZDffjb7IRjeDL1h1WhsOejoa8bgdbHQIRA7JSBnI1XdjYUiE6MedTxl/F
         fTIw==
X-Gm-Message-State: APjAAAVkSFxliIgONBcsvkj7HS+PbIzwd7A6MBb73d9qfDJm8g1SDvlg
        kVPdvCIcLNPSCA6MfLhTUFRzTNvuC98=
X-Google-Smtp-Source: APXvYqxb3OMzCXnK4f4sgTQtmZe2JYjDymc6AgEU/i3QvUPbV7cuAnnl62DI/GMV3okqzU7Ulomvvg==
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr13027103wmf.75.1581313790937;
        Sun, 09 Feb 2020 21:49:50 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm13474097wmk.34.2020.02.09.21.49.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 21:49:50 -0800 (PST)
Message-ID: <5e40eefe.1c69fb81.1b429.a2db@mx.google.com>
Date:   Sun, 09 Feb 2020 21:49:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.18-307-gdb4707481a60
Subject: stable-rc/linux-5.4.y boot: 62 boots: 1 failed,
 59 passed with 2 offline (v5.4.18-307-gdb4707481a60)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 62 boots: 1 failed, 59 passed with 2 offline (v=
5.4.18-307-gdb4707481a60)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.18-307-gdb4707481a60/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.18-307-gdb4707481a60/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.18-307-gdb4707481a60
Git Commit: db4707481a6070d76e871be6339139c4af547dec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 15 SoC families, 7 builds out of 119

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.17=
-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.17-260-ge3=
082a4e02b8)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v5.4.17-260-ge3082a4e02b8)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
