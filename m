Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7535EF50E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 06:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbfKEFgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 00:36:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35090 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfKEFgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 00:36:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id l10so19786738wrb.2
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 21:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Rwpy/hz+Y6vHPNiMzwH2wgQ/mze4+tUWqXAlT+MyOKw=;
        b=bBEoRg66YeF5eKw0P1uVJKumoLTohQUCQ519mcJa9j9LS70EGYohaDWnSVvwE1qqsx
         PEbEvjUZD7VHnSDFzfRJaf1EmpiE7XNjCd7dmDRaHjD7ali8mavIwNI9qxvTBUJkjFmx
         5aNXirXa1lP8+iS15u9DnCpk4vRwhe55V6ZKz6bVYhTNTAT1iHlyjT4ZsgcekwM9S1LA
         E3M1MWQt4q6IF8D4uutxisbFJKXjmKTO9nazTlarfqs2NkSDps/bkeBrL1SvGEg61aul
         K9/P97lS9cP7UDyhtlqMS5WynKHnhwhGIdlwvnMQLRZ+cW/R4khm/mh/rfJMB89p9V0p
         RfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Rwpy/hz+Y6vHPNiMzwH2wgQ/mze4+tUWqXAlT+MyOKw=;
        b=FsJZu8188VHnsvmMA8Q8Nlm5Sg7Fi73SYNW5SysrI/8k4oPRpvhtLxII4Frki57CYD
         ezYWeeK6xXKXba6ky4NXvEij4mtDNJFoy7Wqy/MgDVKMJiE4iWHjUjZrxO8ymByFGMr6
         uZXqSEc9bz0eeIfSS1acczRO2B4Fua73Yj2MV5gARhL0mizFHMDmpwETllIPg6JVR9IG
         0r4ntoIZQjokdsujNz6A9z33u5QK1AwLlSKl+fr0pesNKhhM6VDuX3WS+Or6xglJGvsp
         ytXScf2M2WVmfNuEZaQQANJGcW656yLjnacPLrIN6PuskQAx2fhFcwwkTtcgloZrSm6/
         Kekw==
X-Gm-Message-State: APjAAAX1I33hm/zri+Dj2qtCgdJhN68UTYoCiA0JACwkBaSCUdjSSk7+
        BmgO84pODNAx42JP+llxao89OWo/PVeFHQ==
X-Google-Smtp-Source: APXvYqxDmXErNUyk1flr5Hj6eM2YP4Xm3fp+Ce+trMm/2fx0YQ8ESNA8ynxDlubl6F3SyqCOj7dcmA==
X-Received: by 2002:a5d:678f:: with SMTP id v15mr7738360wru.242.1572932203584;
        Mon, 04 Nov 2019 21:36:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n17sm8711154wrp.40.2019.11.04.21.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 21:36:43 -0800 (PST)
Message-ID: <5dc10a6b.1c69fb81.398d5.32e5@mx.google.com>
Date:   Mon, 04 Nov 2019 21:36:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.81-150-g3d3728a67bfc
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/149] 4.19.82-stable review
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

stable-rc/linux-4.19.y boot: 118 boots: 0 failed, 111 passed with 7 offline=
 (v4.19.81-150-g3d3728a67bfc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81-150-g3d3728a67bfc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-150-g3d3728a67bfc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-150-g3d3728a67bfc
Git Commit: 3d3728a67bfcb7460a6f7c5417a2d9a4ff180c58
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 14 builds out of 206

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
