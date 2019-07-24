Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5404741B9
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 00:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfGXWvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 18:51:25 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40467 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfGXWvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 18:51:25 -0400
Received: by mail-wr1-f53.google.com with SMTP id r1so48613444wrl.7
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 15:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XnVO4rSEOkReuXSX211OE6ecX9N6ut6EU0vpQTgSpnE=;
        b=PrqnP0AdUFZqolsMu6KExEOPexHIPkR0jV/cpVW+Pv3us3v4SMudHDd804n1F8cyR0
         BOJlb3KjAjeVWP5amr+bl3wt7LHCQn59JuIhmj0x9xEi8AiHlZnZNcfdQBeGHJNeRMRc
         ngHoaRybtjTKirUXycPsjBmEGgkDCEoEwZzKzqtHYJdtgkLckgDZsMrKtQKNoGrbtNxq
         WACbivxf5Zobpo7Ss0kR8+bDmoUiCDnIXSQeN7NPGrXB9XfYyH/ZKl/iMajY5cr1j3W0
         Us/fSnSVPOyCjIoj4db6L60k/aKARWVkMuZXU0hMQXzGMT386ukXOS4Ngpl3T5J8lhRy
         Nonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XnVO4rSEOkReuXSX211OE6ecX9N6ut6EU0vpQTgSpnE=;
        b=SGlX3PEp2und/FLV1RnmqsrzbILhZyfF4ChiHYYl0XbTPJjHUeUN9YFRdj5wc/3a3L
         K30jCYBuBDgrvNmFVcFzVy/2TMj8kGllxEDhdBszzzp5lk7B2+q9/D5923CQ6nB+Insg
         heu4S5fxrF6jH2sAoCL4MyCsfkZoScqPWT0ewmpJb7ahVENIVk929ffdjuJlco/FGQdE
         WW5UAjBPcR5oHHE52E7CXlWE8OdAft2xSLvSIL0cZnny+kSav42EaJIiSu4VHFpBdmeX
         1LoP10nbX6xZoZmAjGoAv6uGd4midrn5nmhdioqutJ1JhZ5xS3yA6o2KyVSypNvnPz0e
         dPXw==
X-Gm-Message-State: APjAAAVl1/oMVMoQU0IFMAKXcSH7atH8nTQmcmC5J6wf8auUgXRfhtO9
        LBCywH/pRR8ExHroBkW5S+1ipmrkDPk=
X-Google-Smtp-Source: APXvYqybQ/ZEJztwUtmJU/wWiZmrQMF0yKcnz51gyZ5g0MrmPLa5EqJgrtpG67oFCW2LNw5aJlkM5A==
X-Received: by 2002:adf:b612:: with SMTP id f18mr79559553wre.97.1564008682785;
        Wed, 24 Jul 2019 15:51:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l8sm84313902wrg.40.2019.07.24.15.51.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 15:51:21 -0700 (PDT)
Message-ID: <5d38e0e9.1c69fb81.939b7.d316@mx.google.com>
Date:   Wed, 24 Jul 2019 15:51:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.186-126-g97ad1fbc1478
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 103 passed with 1 offline (v4.9.186-126-g97ad1fbc1478)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 103 passed with 1 offline =
(v4.9.186-126-g97ad1fbc1478)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-126-g97ad1fbc1478/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-126-g97ad1fbc1478/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-126-g97ad1fbc1478
Git Commit: 97ad1fbc1478e2ca11c183c8a2070d9ccb697b6c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
