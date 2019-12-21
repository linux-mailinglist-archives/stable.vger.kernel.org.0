Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15517128A74
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 17:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLUQjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 11:39:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33355 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUQjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 11:39:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so11734993wmd.0
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 08:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H9SO/wJ4ytjY8qZZIScOtC620GP5YPJsO5y77uY3tHc=;
        b=VVIj7ORkLM69vLTFZrUr9In7qdUMQJ2jtzblSwqzR2UldDu+lM9Us19LV43CPvd5Ep
         eWZlkgW7CcIBD8ZYvexXx266dVPpjy74pr3DhIPhCDcIr0xl+UI+EG+rEIXqK12QUUE+
         TYddWqadPuGxTh7HMu4eLQcitxKJlQ37koeezlwbl8IKjr2HH7thzGiCks2o/ydg8hov
         J7e691SaiY2RWX4KmBXZKsa1AvcnNguJY3OD166UlW4j+RE14jIBn9IhVGOk+t+ovQPU
         SwVgQVJ2zul012LyuTdECU+6oYbUb/tZg7XU5K2XgU0CkHNw8pCiJeehXTo70KeGXZjS
         0i6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H9SO/wJ4ytjY8qZZIScOtC620GP5YPJsO5y77uY3tHc=;
        b=YACd6GpmlN8gxOqqMJehPEY4RSxjgFnPXriXjP7pK6GluU5FffP1mYc0qFWS3cm3MN
         3S/NR5P0VcElR1ulev7G8xwoF2On+1HhOBET00VeiEQZbGna9Enl8TS0mlydul1iBNk8
         MdpzBqgEciBkhLlQrYeVatRTBnf8dLM9JjOEn6gBcR8wc6LX6BuvPr+ZgTCNv8LqzqcP
         r6MntvG+jr7aHACaxT9kywtob9HwQOcwfPDBHRobsEegEYE6fG/D6LA8YQdn0UlACIaa
         IOG2ps52j+SoSoZbPXbNg/20HasmI4X2L5E4hgPadifp6kYBYAEwX5F8AyqOFL/IuY2W
         MufQ==
X-Gm-Message-State: APjAAAX3qg/H22/U7HB+bU/9A5rYeDPk1y2Fz85XYZrhEmTZkk5xcHQj
        zd+YXGuf20piGa6OTkxwyuae0YszfW0RtQ==
X-Google-Smtp-Source: APXvYqzFDWGF1Rm3ERkhbY65BQQZHtNgrT1QcyrsG5AGnzyiDE+0nWEtRy89ynPuZPAHdEbNU3ukMg==
X-Received: by 2002:a1c:c919:: with SMTP id f25mr22353069wmb.49.1576946350074;
        Sat, 21 Dec 2019 08:39:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x18sm13925707wrr.75.2019.12.21.08.39.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:39:09 -0800 (PST)
Message-ID: <5dfe4aad.1c69fb81.39f42.509f@mx.google.com>
Date:   Sat, 21 Dec 2019 08:39:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 104 boots: 2 failed,
 96 passed with 5 offline, 1 untried/unknown (v4.9.207)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 2 failed, 96 passed with 5 offline, =
1 untried/unknown (v4.9.207)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207
Git Commit: 5b7a2c7d46bf29fa59e746a520369c0fc30fc655
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 19 SoC families, 17 builds out of 197

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
