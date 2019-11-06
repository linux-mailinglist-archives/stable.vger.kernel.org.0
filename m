Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F0DF21AA
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 23:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKFW0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 17:26:54 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:35931 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfKFW0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 17:26:54 -0500
Received: by mail-wm1-f49.google.com with SMTP id c22so5608077wmd.1
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 14:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dQhRFLURbD/NN68vvM+Zi+jp6jYKQIKH0hKzW2DpzL8=;
        b=aJcrA60F67WlcgeeKAkhhBtfUlMGOkQZKV4G6twWjmLyl/khnIb6pNQGMlpb/QAYh/
         uEzLlWK4edyyPUYsE/xLOdIJ4yaSF9UeEPA/ks+Z13yh4AekDB77IEyUvp5ml2mmMZTE
         KvzOfc7k/UlJg2xnYWNaRJOeSbXkfoCZmqfCqD5aaSJvxb6BihfNn7XW1UstZzfCgwdc
         pNIe7RoWodNMfsHjiITbpJ05OpTD5KddEIlSc/U2YKhXMIFnPWWlWJsPWc6hHVkvI8gR
         s/VLut6lipR255lhJ3zrQKldNHaPhw20rYnCAy0ZFNEfuxo0C8KTFizxMPKdIFTuEAHG
         vpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dQhRFLURbD/NN68vvM+Zi+jp6jYKQIKH0hKzW2DpzL8=;
        b=kiKgODCYFQ/4ZVuGAm0pldMr83DnwdSS2MguPTXO2FwGM45mU0dTVy53JgbVJoNn/q
         AH6laNsuVISaApQVIA4sfrzbr6Wym5uOAS9GELlml10YnyYEVXyd4Rb8mntruYzZejnD
         pcEXSoH/VUTts2P6Ob1iuc589CLfwoE40QpeXFdaNoZ07P1Vpncz8znZQgDJ+1l/q2uw
         75VK9esxRpkyLe5dXvbUUJbbWKxbK8EObz+ig35PN3a5OSCp/CLnSePrSsGd5zQpSVb2
         CqR9y82mspSDuiqjesR3u2Hcz0a1HMdRKUvRtot1oRLOtrB5CxEL97nqujKHWwjXMtvM
         akVw==
X-Gm-Message-State: APjAAAXw+QUwg8Ek+Zmi7EwIlSZBFa6Yut8pvxu/g7QAjdLhKGzes/U/
        NqTmvFmcX2ssO2rvk9zV0jtr2j1eDLE=
X-Google-Smtp-Source: APXvYqx9YmGosEExyjOkyYsL/3e8hfBkz7wOaNm33pk9mjHmFLRIn26fAg0OQvZwhB5Iyoj5sRys8Q==
X-Received: by 2002:a7b:cb4a:: with SMTP id v10mr4386793wmj.106.1573079211721;
        Wed, 06 Nov 2019 14:26:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w19sm4081695wmk.36.2019.11.06.14.26.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 14:26:51 -0800 (PST)
Message-ID: <5dc348ab.1c69fb81.65606.7b48@mx.google.com>
Date:   Wed, 06 Nov 2019 14:26:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.199
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.199)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.199)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.199/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.199/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.199
Git Commit: 352b498db84420896ef3f7b2bb3b892093abbcbe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 20 SoC families, 14 builds out of 197

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

---
For more info write to <info@kernelci.org>
