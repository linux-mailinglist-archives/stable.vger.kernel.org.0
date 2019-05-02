Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EAC122AC
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfEBTqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 15:46:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35203 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfEBTqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 15:46:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id f7so5033683wrs.2
        for <stable@vger.kernel.org>; Thu, 02 May 2019 12:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=PPKlM6ilF+RkuSDVJ6SNKmbFhrwgZfo86vIcplrjIGs=;
        b=STP47j7HepJrq5qfRhipbbid6HfvYjzUCDuJcAIILX41LHI+xjdk6K0wo3HXdkRCBs
         OHkq0ljl+VlIv3r94Ba3rUI0vZMcge/amtHsGcDlrBh2tAwqDZ1VZVYjvTlKQ+/AiR6v
         FPWWa0mjK3LTf3JOqjwp1wbWvuVZlm6/UlkI0W1G0HYh1PRuXAPfPsQzoMhTkAf63Huh
         030xSj4/LYs8YysWuvp9euWI9KEPNyWmMa4LNTDyn6Z+kUbxlZjDAup+rqTkQq/Bp40l
         6jsWkexImXi3uS2jhYaLg1BnBa4Vr3Eo+Xpfeqobq0i+Xy5ah3VyL0r7ud1BiH8KxTW1
         vmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=PPKlM6ilF+RkuSDVJ6SNKmbFhrwgZfo86vIcplrjIGs=;
        b=lOJP6/Ck7rwPkmA+Hsz/MtT5l7cmU1ry/W9DYwlzmki+rxmk59UDFGoZ48gtJFCTk6
         5Ov0xLZW9jHdjMGLTmV6hCxUtKsHEXq76xQ3b69p3sfU+wyFy+pVgZkJ/1G1GAFI5lW3
         fa45ZsdDuNuMa5PTD/dKnNpTCiMb6RH0LUathhdl/0t11Xo9R3sjMCQb/YXHZVrE0YPq
         0PVPzqO0aBvti9pdzwiWFsuBCZneRptV0jYrbRl4r+CpjQqhlASkIo6LdXtu5MlIs+1n
         7AVkzVfEQc9v0pMn/vB0FsmAfcY4CmSGhKpLii+wEZdliuDg+NcRuaCAdPlvo/63SCUR
         4oxg==
X-Gm-Message-State: APjAAAWupKmOHOWKU/95IPf4/SJfm+XvRmJNu13gf/iwCpcxhU2pTIv/
        DnAssp2FQPs0SJJepwheCeXmoA==
X-Google-Smtp-Source: APXvYqyMHUSSVqgm9gT9+BCN718D5XJraPqR9H8SNJ1JKGaMYWhGx9TQ3dWcLx2S6YDwFfKYUdSdiA==
X-Received: by 2002:adf:eb87:: with SMTP id t7mr794403wrn.39.1556826389212;
        Thu, 02 May 2019 12:46:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s12sm81242wmj.42.2019.05.02.12.46.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 12:46:28 -0700 (PDT)
Message-ID: <5ccb4914.1c69fb81.e4b8b.084c@mx.google.com>
Date:   Thu, 02 May 2019 12:46:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.11-102-g17f93022a8c9
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
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

stable-rc/linux-5.0.y boot: 129 boots: 4 failed, 121 passed with 3 offline,=
 1 untried/unknown (v5.0.11-102-g17f93022a8c9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.11-102-g17f93022a8c9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.11-102-g17f93022a8c9/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.11-102-g17f93022a8c9
Git Commit: 17f93022a8c96d740be0f8dfc01e1ccaa70eea5f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.0.11)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
