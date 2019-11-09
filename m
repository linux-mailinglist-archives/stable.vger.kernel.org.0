Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32EAF5CA1
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 02:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKIBKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 20:10:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53754 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfKIBKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 20:10:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so277098wmc.3
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 17:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0dI0N760IiNitHImF/wM9ggQoHbHXE7osrTopRR5tok=;
        b=BMdtq1h768ZqhDgAcfIpKCmf3clLG5TcDIR2egJ++tvsld9WJ2HJuEKCcFwj8OpiSK
         ECv4wuAVoHr5yqOIl/vHj7SpMiI1zrk8ca9K6rfjyn8+UknDldeb9kZ/XHaD9YbIlbvu
         jdWsAb44cFmLDpU08AXOR3RMvSYaLkQIsW6hzqTCZEPgHSsSsmjtPhRjH5Z3pNkckizn
         5DXH86Ho4kTHpwGRpUXHWO/4mFilfRWvweassReYHf7DGnvqJLGRujVHJMvur0/ApFJj
         VNgzACLN1vzapNOWRSf9ARGHf4k21+2l4Kt2kfH/cS/JkQ54EuUj4O2z+yoc5yuOtZjA
         dgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0dI0N760IiNitHImF/wM9ggQoHbHXE7osrTopRR5tok=;
        b=tzkv4x/0Mi+kisRINhnV80WsPkKEpexEonIYtApAeIRG6+o6PsUb1sGnCjZg+ycOWO
         6LkXXjFYL1Re71G6ziZvc4Cc/30hhNmRSSpv/fjM8cjmq569yDfAwNsiyWu2wif8yFLW
         FmBAdDrpIxBTizW/kC5mXPybDzoTAxMFT7WPmo5bzu33aYsSKMjYF2FtThEJpDjJ8KIG
         U6c+PcsTKj/G9/ungLP7rNbX+fmOG2A/ooWyFzwL8k9+35mgIH/MYZ178kXSo9cmkDWS
         Ts8fW37HByHqftL0dn3/k3bSrOxepeTXP85Ew0/wM60ufDQyBdBQc21MA7gCplosibRV
         afUw==
X-Gm-Message-State: APjAAAU1CcB+BMEzxrjn4lTMohTrdoUVsN2X4jpRdiQJGmMly+q3X5dl
        h9ChQEsHMvtrBluAoypKozlsMrLp+CHIUg==
X-Google-Smtp-Source: APXvYqx/YATpTOS9U+iCySTcmX1Nuv3akxUPtKkI9NYDuhUFnWcYVsdiSvK7qlIHncZ0UH63QSPgkw==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr10277711wmh.20.1573261842044;
        Fri, 08 Nov 2019 17:10:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w132sm11294046wma.6.2019.11.08.17.10.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 17:10:40 -0800 (PST)
Message-ID: <5dc61210.1c69fb81.cb92a.ab8c@mx.google.com>
Date:   Fri, 08 Nov 2019 17:10:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.199-76-g6afbf4832d8a
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 72 passed with 7 offline, 1 conflict (v4.4.199-76-g6afbf4832d8a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 72 passed with 7 offline, 1=
 conflict (v4.4.199-76-g6afbf4832d8a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.199-76-g6afbf4832d8a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.199-76-g6afbf4832d8a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.199-76-g6afbf4832d8a
Git Commit: 6afbf4832d8a30149fdb36136e222f795f2e9ec9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
