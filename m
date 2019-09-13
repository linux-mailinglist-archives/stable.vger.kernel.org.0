Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B059B262F
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbfIMTjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 15:39:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52435 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388736AbfIMTjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 15:39:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id x2so3896539wmj.2
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 12:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=pd40vG/uG/GzoenlJau3I2g3PG44k2MY+K/oA0okfbI=;
        b=QiTbP9vbxqR9iG4x0RDtHjGnRLDGXPgJH1o+4z9yT4hm8SoJ1Z7LnsO9UyXiF2EYLa
         M8+xvuAMJvNQr9sStTElsNef2TaF8DbHslRQ13HqIXUVgJI6SG7y5K1s3EVB0bBfQHK8
         qGorccgUONznrcRZM7kecOFphfnoEY5a6XXx98KJZilUHKt8ptirh2+oNwSzyxkwX6Mn
         GuYN7Kjw2SNG53chvt8TiUPuurCjipJy88+97jwxkUilRybQwl1/hiqnVyB952KlJqQx
         RnXJg8rThycSCxUwLoTMTkUlyztpRKAngPJXt+AxWorRM3sgwtONLKl6BU5WNnXVWozg
         kzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=pd40vG/uG/GzoenlJau3I2g3PG44k2MY+K/oA0okfbI=;
        b=DLCimsRTg+Hbxi8pSMWceKtLYPVEje101iBv6M+InNRTYuUzOFuoECuG1mi6ktR84Y
         FWV+ElQMKhPJk3WfbJZb0hY4gROclAwdrwAPT2tRrkj2BNEbxOZAmwEKGiemsJgoCRzj
         +6AvbHyaastjA8rzpTHvXMRvzTijsO8Jum7a0LDIdSX9ixnIaYP009z7WsCLjUCRWNP/
         jTKiV78OcP8b/J6l9LVGT1DmKk8P5+I6biJ08BeP35ol2072Nm9/n2sGFzZynhNELY5P
         mkm+Hempfil0XX/QTf5z7l4Kbcrbwu3kHtpAYZr5a30iI45w0xj3JHjXJzQXwaczjta5
         IRtg==
X-Gm-Message-State: APjAAAUvxjlmOg8msU7hWfSvv+AR5gXh7hsPECx2YYeEqiP4cyDez3fe
        LS8mu7ZkH2gIa841hQNdZQRQcw==
X-Google-Smtp-Source: APXvYqxwiQMX3VbuvfmrdsrgYP5GETL7nbmMEjQqq8qoVLOYT2fXSNMsVruqoBQxs4SP2pXeJrTtbA==
X-Received: by 2002:a1c:ef09:: with SMTP id n9mr4397015wmh.23.1568403545199;
        Fri, 13 Sep 2019 12:39:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o11sm3949126wmc.7.2019.09.13.12.39.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:39:04 -0700 (PDT)
Message-ID: <5d7bf058.1c69fb81.4ca9e.38dd@mx.google.com>
Date:   Fri, 13 Sep 2019 12:39:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-191-g490747a3f68a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/190] 4.19.73-stable review
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

stable-rc/linux-4.19.y boot: 136 boots: 0 failed, 128 passed with 8 offline=
 (v4.19.72-191-g490747a3f68a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-191-g490747a3f68a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-191-g490747a3f68a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-191-g490747a3f68a
Git Commit: 490747a3f68a8ef2bba5b0cb5f29b896c02885c6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 15 builds out of 206

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
