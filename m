Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4DE6AB4
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfJ1CPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:15:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40288 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfJ1CPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:15:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id o28so8181072wro.7
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=38vfof48mbSMZzVEHVHHL6gvFaN/yZ0qq3phlAcJ00k=;
        b=D9D48vk/mYRWUwbGwreKxIgBC8zPNu1bgtj+QXZEtnhmU/L3FnAIfuZZlQup2fnYfa
         2nCRgSMrwqu7i27v+c2bMwCfzvPQO06bLISqWnie8N+SA/V47MN9Ws//c8jYPKlfROA6
         fmLCroA2cYrtUvC8egpGcmY7KM1PBeyc7GcNd755Dp1dc6silF68gzrfd6S0xEPHgIaB
         6YzIjxNYyCvfLEY8nC5LwVEocNFW2Ks97IR2th5xr39vyGCB1rFchwikjsXYDHpDym4d
         ivHqEnV1M4XAiaW+9iQbs7ub1hW2ASCKT7PIOg/07Hf8yaw6YW3Sk8tuM7PuoDSjdvFV
         YkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=38vfof48mbSMZzVEHVHHL6gvFaN/yZ0qq3phlAcJ00k=;
        b=rGDcpqpP4vNN4BhU7eQWZdg+W5VjrD2XrxJ8JQ4im0dOdA4Q5qfSsSFcQtKAu1jzj5
         o+nP5a7bHonwcjyPq+VbSwLmFtBF9e/3B9ubGFmlGWPr85nNRxkqA5y3m7JP5Y2DB+/g
         OX+qE3gvwB5kMeZ2RNye8v7QEsiJcAsxJpmdKr59DcwoBUn/QoAuH/7yFfc/speZZR8u
         Pnod0oqziFrHO5Wx5F9d4Y808jhiz76WLfoAciQ+B4dSvQnBmomW/jds2KXs2y88h8We
         aZ610UzUgCuOQOmM7hSiYt4c/W3/K5fCkx8e9H3HJKL659JE2Ju5O+9Na7FicSz/Qvk2
         3l2g==
X-Gm-Message-State: APjAAAWbxOs5OLgPtA6UsC8BZ4+X8yQKlleWtz4ymvE0cwgjnLcxvk39
        0+ReAweRgH7J7spDXtzXVMrwLA==
X-Google-Smtp-Source: APXvYqwJc+7AczbYWMJzufSKsgqqNP9zH5Pzs9gMkcNihEq0YWjSdUVX/Spn1Er2N4AyLEZpGsIPOA==
X-Received: by 2002:adf:ed02:: with SMTP id a2mr12671113wro.11.1572228938858;
        Sun, 27 Oct 2019 19:15:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p1sm9555994wmg.11.2019.10.27.19.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:15:38 -0700 (PDT)
Message-ID: <5db64f4a.1c69fb81.94b8b.04c6@mx.google.com>
Date:   Sun, 27 Oct 2019 19:15:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.80-94-gb74869f752bf
X-Kernelci-Report-Type: boot
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
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

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 119 passed with 7 offline=
 (v4.19.80-94-gb74869f752bf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.80-94-gb74869f752bf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.80-94-gb74869f752bf/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.80-94-gb74869f752bf
Git Commit: b74869f752bfa7ad50c55349ee2f0bbd61a45f0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
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
