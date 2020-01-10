Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C18B136FA2
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 15:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgAJOl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 09:41:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38494 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgAJOl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 09:41:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so2237166wmc.3
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 06:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lDXPCtMZaCixoRYTzEqhVZTppO1nmqxUQFYrA7uy8IA=;
        b=PHzfsjHYdkrPvSSR/yDI4l60xEBhT+N2J3TUoLZ9HrLWcv6gttrAyAz37F0XdyhuUZ
         +5ciZkk798Uw09+3FTShEWSfF3oeG4i9e2Uc+7JAYR3kA5QiwvWyfjxsdyDkWlH5Ep7s
         MDGlf1WOuiIIScp7EFjZbcqHRlN0d0HcMMtO0oRyGwGmfc4b3dQmYcKsi4yS558m8D0V
         qKX89TRHATLJzigVi8ZuKnCMihDi53xrt81+nou9bxlucDyfsCAgbsXlRQSb3ELECOmw
         jcRxTP8LW2HDGa3UUYoAFQ+Z/JmZKILSrGNQ8nUtMlg/uVvz6PnKCz2chXNn0Vz8tvAa
         16HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lDXPCtMZaCixoRYTzEqhVZTppO1nmqxUQFYrA7uy8IA=;
        b=cz8dlyDDgGSjoOGYm1b+qQAO2UeibThtR5WVxwn8ZwHFz6gtI3pxXESUegwRvZwgOW
         pg8KRagomPddJxzPkF4yiwx+2pAHN0cus6WotzMmr6hYN3BfHTsZ7bgmg2hQjiyBGsVQ
         2an4NHw6ye4EXLObl3ZSD3n9keTICPRkbkn8gMkf27ijcERJck2HSDN7uD6e0VbkKNPC
         IwLAe/MBOYERvfnfZTHDzUkVP3CZlJW6/mPajPNZSR61onH+KqhLQ2MFfodoNbeQmhDt
         LXdPX4bi61ep9Jp0zfFPhFOcwS0eQvEftprjUVk67niA4oe0qQyy+hhH5J1oOFAB9sxu
         I/Pw==
X-Gm-Message-State: APjAAAUTfp8m/uPtSuRNTs8rwBA+XfG7HqmeaiSdiK/FwwKqa0qm42tI
        ipCJ4ml1zIZniVSAMcoQz8RNfgK8XKwoWQ==
X-Google-Smtp-Source: APXvYqz9cNdCtoKrGBomaPpuEgg7yrQy+NG9NwgN9vU64cc8VkPRj2/j/8MBzbxM92bBxM9l7tNYfw==
X-Received: by 2002:a1c:1b44:: with SMTP id b65mr4528976wmb.11.1578667286367;
        Fri, 10 Jan 2020 06:41:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w17sm2374928wrt.89.2020.01.10.06.41.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 06:41:25 -0800 (PST)
Message-ID: <5e188d15.1c69fb81.5d284.b2d8@mx.google.com>
Date:   Fri, 10 Jan 2020 06:41:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.94-64-gc6052d0e863f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 81 boots: 1 failed,
 79 passed with 1 untried/unknown (v4.19.94-64-gc6052d0e863f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 1 failed, 79 passed with 1 untried/u=
nknown (v4.19.94-64-gc6052d0e863f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.94-64-gc6052d0e863f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.94-64-gc6052d0e863f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.94-64-gc6052d0e863f
Git Commit: c6052d0e863f12d683c62e755a093b3805f3faf8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 15 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
