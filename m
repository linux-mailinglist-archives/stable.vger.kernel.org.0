Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359525D1C7
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 16:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfGBOcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 10:32:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54711 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGBOcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 10:32:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so1073693wme.4
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 07:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=hghNClm75/4KZJdIxJf4/GmQX4sIhC6S5l42nPPIEdY=;
        b=UDQaw2pC9Yvpb5EmLZHdi4Vk9UmEj7TaX9z2sRU0D3m1XI+adn4AaE7othU/fr/irf
         pVb1uAbu17oRwmwQvn7vFmAoEDKS5CVLn93PyV1BtGJxzWuH4BIlLLLPjVmUjfUCfnfZ
         ktO1hNTF2M7xK137+EX4blHLUg9jG5UiEgpVBTqZZ8oGG/0A7e/KmtZcdNd0fDOpVbDK
         pGOvc0JN03N7vgOJVDqH/SFbkwUFlXQcOz5fZGZX6gfrZf39Pt5fBuXkfg3r2wBLPKAC
         +mFDEDXumr36cxumNtRUHZmi/dgRWRBx7fvGYuzN3ewsuW0cBRORx2pQdTNtI77lvEa6
         WNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=hghNClm75/4KZJdIxJf4/GmQX4sIhC6S5l42nPPIEdY=;
        b=UbWL5Os/x/sdoEt5O1vaOEk0fBUSk5sqeVi/GDVnw6cBAg2GNaIqHi+PABEd7TRy7z
         57+KmzXDC8xwTf2VvTH0j+QbQ4FfI622+EwgBvX8fSNv8xZYNJXsyPk1oEvWUTM+dFYW
         M/D9tjIpmK6kUg6mQXe4ud1hu23KT5sfsM1hElpHyIyx6Agqdx243ibeUol6HPXoiirC
         0rY1FbSBPpm+a9fVRBuXX5TPkiiM5+iulFS+uCack5qCMpIeZE92loflOy4C3DQmPmZK
         MlN6oNI5w3H6JDEQaLGRoIMz93CQokwN9MJuAIRC7BENS/dBgwSmGvzOhNmWVgjoyDHO
         gL6g==
X-Gm-Message-State: APjAAAVsDMRBBZ5bRwePJhTujK2UijuzVGaeH/TcGzI5bHIuh4ilIuk8
        ZKBGCPnnulkiRzwU5Lms6zeSoA==
X-Google-Smtp-Source: APXvYqxrmuHjs14f/iLRZFoH+LaZHidltMqWmA8xOe3Xd9IOraAZ13IzBAHkuCLhrTgEIZApovcEww==
X-Received: by 2002:a05:600c:303:: with SMTP id q3mr3801577wmd.130.1562077928722;
        Tue, 02 Jul 2019 07:32:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g131sm1779291wmf.37.2019.07.02.07.32.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 07:32:08 -0700 (PDT)
Message-ID: <5d1b6ae8.1c69fb81.7c837.a037@mx.google.com>
Date:   Tue, 02 Jul 2019 07:32:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15-56-gbe6a5acaf4fb
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
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

stable-rc/linux-5.1.y boot: 135 boots: 4 failed, 131 passed (v5.1.15-56-gbe=
6a5acaf4fb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15-56-gbe6a5acaf4fb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15-56-gbe6a5acaf4fb/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15-56-gbe6a5acaf4fb
Git Commit: be6a5acaf4fb84829cc456c77af78ef981fb6db2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
