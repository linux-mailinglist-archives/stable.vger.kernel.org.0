Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB39115163F
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 08:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBDHF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 02:05:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53029 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDHF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 02:05:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so1964870wmc.2
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 23:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b+XoCXCFYHgrlatYLX5G6UI1NnNpmllw9gkCOKf8h9k=;
        b=zj+Og+ra1rqDg94BcvuWOQkfen9dqK9OxP9B3arO++LM0EtchNvgY0YiffyoP/zVog
         UlcR2jJFHiCaBkwsPlf+ZRxpYhMjnpvv3FuNTPubtgEM0ZBFL+S56bptoQZ1az7fh6X8
         wZo5gosPdO3d3ESYFgvHlduU2WcweIUfk53TFYPUxLiT5zq/eChOyFFd+SrTKEHtA9Jl
         VzxxGgSSxfBTHqEll8Jc/lhBQCwQdgKufXlZK7YE8f5S0ASv5/CI7fk+ZZra1fjpHV8D
         6VAyN5t26/kuT3ji4znHqAfPXaS91aP60l0Krmb68CsXoU6KAH78xsO1kUlEb7oTvVPP
         yLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b+XoCXCFYHgrlatYLX5G6UI1NnNpmllw9gkCOKf8h9k=;
        b=rl+5OM0deJ68Ghd0hoBT4xDXvjqMlIvXQAnnm5+EtW29uZJQRfU+tXEmjFWjsw//Pr
         QemzASAGOCcmTEyIXMFwskgZ6Np7RR5G5VvHJ4hUO3Y8Qgxg53r4DXIa4gv2/Y+Bezjv
         Mk0sTQ69UHIzgHlUyRpsCrdEPlR8izsUqYziz+LNqBKVzEAumnly/85flS8IZGWPYg90
         rdo+p43W/O21t9dS3F1QqoX8v/IQI6LvfMfOD3+V97i4lR0ogZDELpjnLn14KHFRb1HQ
         u4o81Qb2baUzv5L1bWJCZFFj315mi20xZQKIqgPgvaVwD8jGvAi7CoS374LAJ6ZAVg+a
         Areg==
X-Gm-Message-State: APjAAAVy8C6giEXbK7vVyB3/thsSc4vVL6oN5AAYUB2WFe9sKCkvaBu/
        pUZ0fCP6+Ksei4L51+pxZ1iat/01qP1rFw==
X-Google-Smtp-Source: APXvYqzeJCQcELzXSNaDj6WtnjuPWmGwIIuVRVK14+xMDiNZlVJ/aF0WKZW1mBIdk1iR9AbWc8wamw==
X-Received: by 2002:a7b:c147:: with SMTP id z7mr3806952wmi.168.1580799954931;
        Mon, 03 Feb 2020 23:05:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm13644854wrw.15.2020.02.03.23.05.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 23:05:54 -0800 (PST)
Message-ID: <5e3917d2.1c69fb81.c4f2c.98c3@mx.google.com>
Date:   Mon, 03 Feb 2020 23:05:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.17-102-g9028ac4fc837
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 99 boots: 2 failed,
 97 passed (v5.4.17-102-g9028ac4fc837)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 99 boots: 2 failed, 97 passed (v5.4.17-102-g902=
8ac4fc837)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17-102-g9028ac4fc837/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17-102-g9028ac4fc837/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17-102-g9028ac4fc837
Git Commit: 9028ac4fc83727a47f8fffd43cea9b88a8f026e3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 18 SoC families, 13 builds out of 167

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.4.16)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
