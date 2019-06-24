Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7C50FFE
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfFXPLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:11:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54873 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730548AbfFXPLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:11:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so13147326wme.4
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=5PTa33ogTni5Gg4Vr/ihQKZAkZXaPg7xdd3sdJLvL2w=;
        b=go8yCIhiT+F8iYHO99S9JLvCn555tSVkVtsqsbRIo1Smo4HKt+l2pfdIv7KLRWV/9N
         KZUEbe8hYzeE97E7uM7r80npmN6wVbSlXePnb9pT55qd2mQmqaN8fyd+8cwn9JlvRyYq
         MF6o6WUDzsv88wFDWtNolKPolCmhzlvofHa7Cyekvr86KAHcgmOZwmeyduY1eVaPQJHu
         lotN7+LmfGyG/9JUzcB1SU91p0PmugeYlEOaCSSbvce2fofpLnuNzKoOABAvZL8tpedw
         6w3MO45oncGBii8TVwcFtToKzWKlb1T6wBKnI/s8V8UTsbpKbskcHenOoK87S9bJiohQ
         svGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=5PTa33ogTni5Gg4Vr/ihQKZAkZXaPg7xdd3sdJLvL2w=;
        b=gQfARhsgOx+oQnEjCBivf6SdmuAyFsWacvZmGZTd0TmLw5T+guFR8wd3Xw4oPU+P3r
         Dnjyz7l0VmMRiZQPPIW+Tz6HNmAQvENIBG2T2z2lGH9mESFMqE8FxdigYpZgekcYE9rf
         +eVNVms9OySGfCvcvCGeTw7UVUMEWIUitAiCbAP53pQolOGvbXXqAE3u9nYiSODqzmp1
         di2YVDqyBizmN6voWQtJq//+U1TfECioLshoWDYcRPQ8aVDxlFa7fKBXl9NJIEBMpxnr
         r4UUfDEwiUHW5xWkHcKe3pP1KGbrBcc8O0rQyWO+4y2XZYn0ZRk2H5E89HGqL+kVGOp5
         74XA==
X-Gm-Message-State: APjAAAWc2V6G7JJEwFgQwrcyxmg7unSBa9GxLlY/SZ09cDEEl3X642IO
        Sdfda51ifEsi3jnsueM7/70xow==
X-Google-Smtp-Source: APXvYqxWH1u9dYR8WkExwLUHrK/JnHBW17hhIDnlg99V0BwnQUHz+BncoLXRYWYLKTn2enOO+ZBs6Q==
X-Received: by 2002:a1c:9c4d:: with SMTP id f74mr16216529wme.156.1561389081671;
        Mon, 24 Jun 2019 08:11:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u18sm8301486wmd.19.2019.06.24.08.11.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 08:11:21 -0700 (PDT)
Message-ID: <5d10e819.1c69fb81.27d2e.c262@mx.google.com>
Date:   Mon, 24 Jun 2019 08:11:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-91-gc491b02eb03a
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/90] 4.19.56-stable review
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

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 113 passed with 7 offline=
 (v4.19.55-91-gc491b02eb03a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-91-gc491b02eb03a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-91-gc491b02eb03a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-91-gc491b02eb03a
Git Commit: c491b02eb03a59e32d78bb8d4ee00c154a694267
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 15 builds out of 205

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
