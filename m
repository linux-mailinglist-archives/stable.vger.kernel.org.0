Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E182117B64
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 00:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLIXVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 18:21:42 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46473 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 18:21:42 -0500
Received: by mail-wr1-f47.google.com with SMTP id z7so17918162wrl.13
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 15:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jZ9xCTsw3N4J8FOGn+/PX0JChNRzac2HRqWDrFdgFpo=;
        b=xF9gLMwKiw2GEDHhGRbgrY2O++D+ocxJaWHT7HxdcUcDKd9pQgXT9DDsVGe9xpqs8w
         n6DZ8TyjysDlG9uNuBCK96npjnUOdj3WDoYVBXhoXWlqLZTXSWO1DpHIHsSo2Fk3Zdcl
         VaEekMj5GQ0dkyr10CKwlfcFj2Li0uq6ivmTS9Vz51TrRcDVIWvxsm04MHMEPcvDvL+7
         qVHk85iM8SemZ+4kFNDSHEPPwSwPUyJMp3Jhw11sbD7FQiaumOMzu+kBX+jUxqKk/GNO
         Rw/7LR1ITV5fWIOAxtn29D95XZV4EmRmUxuhyyWR9MNi3hF3eXZ7KA4LdPUTTF9xB2Mf
         2Sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jZ9xCTsw3N4J8FOGn+/PX0JChNRzac2HRqWDrFdgFpo=;
        b=RbDIi9c42j5sP08tb4In5pAx8XeeBwmLPrzaxEKLKwFEAgxvnb7nQUQd8Q6NnT1Ls7
         hDDykgOawqYWKZI7CB7AbmumR+9Im71K6/c7OFc2z6RlXAx8khYLWbGoBPFP+0fiVlRL
         jElWLbqOBKM73FHD9gzFfX7BbLOPC0dATFYYKHG0+S0+NUMHbbU3/g/G31vPXQmnBUoF
         odXuwu1mgqTQB8gQF30V+3pWsnrPCWQVChfUYXK57EUV0MUMFs3iK4uXqbWfl8PWtzb+
         27I4oVcDUl65yXfROrDrrs4fTSMACFN2QT+mZcydB0VVWUKuxjWc6f0kc3SP2iuol6aG
         Grqg==
X-Gm-Message-State: APjAAAXMz1R8pXFh62mEalSzrYlUNQRHm8E4eBm10G/dMBIrS8o/Z6VT
        JKD4Al9+eTWyWtRm+WoaPzvAx1oaAjcA1w==
X-Google-Smtp-Source: APXvYqy4tUasOReHX8joidGx59FJVVM0K1Hf7AdZUUR4jehQ+hKXmG4awEzbB8dDGv05I4Z0CxO3GQ==
X-Received: by 2002:a05:6000:1052:: with SMTP id c18mr4700414wrx.268.1575933700181;
        Mon, 09 Dec 2019 15:21:40 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm1081821wrw.76.2019.12.09.15.21.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 15:21:39 -0800 (PST)
Message-ID: <5deed703.1c69fb81.19dda.638b@mx.google.com>
Date:   Mon, 09 Dec 2019 15:21:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-133-g77d1533ec9d1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 113 boots: 0 failed,
 106 passed with 6 offline, 1 untried/unknown (v4.14.158-133-g77d1533ec9d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 113 boots: 0 failed, 106 passed with 6 offline=
, 1 untried/unknown (v4.14.158-133-g77d1533ec9d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-133-g77d1533ec9d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-133-g77d1533ec9d1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-133-g77d1533ec9d1
Git Commit: 77d1533ec9d10845c210dc8cd1c06b921e2ee0fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 19 SoC families, 15 builds out of 201

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
