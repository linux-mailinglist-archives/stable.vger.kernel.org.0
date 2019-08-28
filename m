Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B649F7EC
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 03:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfH1Bhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 21:37:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44116 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfH1Bhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 21:37:32 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so679164wrf.11
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 18:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=q1/Ofde3eheBbpcLir1coN0/ebDNsE0zXOWBvpHEjoc=;
        b=vR1vjiSpPZW3JK12HEFirAYTniqoi1mK2LGqy1PpfTvduc+Kkzvqyh0isFzQXQOXvo
         M4+RlXD0or/R9nA6bwnjVW9ASbO9VLA7kMyEf+POqo2mlAG1sdz8sXuyQYU+CqJ9p5Y/
         muDGCrbgEbOstsBLOwlUyYC3mBbQHbbJQ3zqIXEGrYeFVxfYzs6MDQ5NTLbBG9FK/VXo
         CU3bEnBrxXhaIejcNDuHNCgkqrBLzWNkEpOY8RNGZzkHxCEqep6Of4IlxtjFn2QQrts+
         1TffnfOTqHF11BXPlRLIcXCaS1i6vNmuUSfn3Z2Q26rynFegtE/hW81g7LhY6FjUhAAl
         TTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=q1/Ofde3eheBbpcLir1coN0/ebDNsE0zXOWBvpHEjoc=;
        b=WDQUaPUR2Y+A5Pn8Z0I0BsTKRAykS3jy+zzoGEWhP43Kzs3MX1+un/Z4ioeRX8FlvJ
         NkAQo8P1FSh4KjSwhysufIXLqMDhSu+JvmqmSUAgQ9e/qjG88fQDkvXDJmJNi5yTmVfr
         Ft5JI3M5puFKaqVr12hmnIQHhyzOljG5wN/vVL9XYlnNHOcBWItHXBkoKvywbEkYY916
         x16znP1vrI+4qLU6A3n7i0vqleZNWknAfpEmwero8nUkqZYS7+J2cTxNY/S3B26qsZYf
         QH2cmloLN7qnXOXtEwqZL1OLTzN18Fuq5Y1Vl5LAT2Xxm+KvWecianu09u2eBn/C26jv
         mH7Q==
X-Gm-Message-State: APjAAAV9U/zc72o1hv2xAq63/ojotXMJj65LKeCBrCGfxRCDTY+Kl8BZ
        URj4sduA/39LWiYXnYS8p4hSVQ==
X-Google-Smtp-Source: APXvYqzOcrkTop8niK2BOhZlj58NIXhE/aazQQJ0kmq+Yu7VCSQCGE5B2qpAF5K5+PPUrOnSA3vUgQ==
X-Received: by 2002:adf:f54a:: with SMTP id j10mr1049430wrp.220.1566956250672;
        Tue, 27 Aug 2019 18:37:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c21sm648819wml.48.2019.08.27.18.37.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 18:37:30 -0700 (PDT)
Message-ID: <5d65dada.1c69fb81.3bc78.3732@mx.google.com>
Date:   Tue, 27 Aug 2019 18:37:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.68-99-ge944704d5a79
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/98] 4.19.69-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 133 boots: 2 failed, 122 passed with 9 offline=
 (v4.19.68-99-ge944704d5a79)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.68-99-ge944704d5a79/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.68-99-ge944704d5a79/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.68-99-ge944704d5a79
Git Commit: e944704d5a79f6d6506a872edebd16e2b93cb349
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 25 SoC families, 15 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
