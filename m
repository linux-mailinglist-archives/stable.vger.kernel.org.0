Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDBB127264
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 01:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfLTAYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 19:24:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54521 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLTAYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 19:24:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so7213983wmj.4
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 16:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+0/dP1Ui+paZJMfapMlYjJ6EYgBbWF6P++a2m+LaySE=;
        b=qYG/BPDcgAHfzoYHCvaxkKRxcfkzPK9r3pZvxdN6K9xxvFmRN37lNSG3iotGI3DyiC
         ELWYRzKNGPZXGEP0YTKoCl562qK8oAMWKUIyJyUeaBXO7hwTsUU4r1mrwlJgr1Wzz3jU
         31kOEdlZbix+UzxcoMQ1jSKy5Lu9EEtDrltkdVmivS0E9faty9f3jer2m8yh+vifXzmI
         1a0slSOcWxr+KxFEi//NFdHQ4zRr0auCH5gXu6rodSvOWr4eAP3rW6HLn8pilYA+PlW3
         mXM/G49aBRhUJwqi8wmlPM2bq7hSOnKRqr2Zb5RxizbeHnAq0AsGyVwmLpW8ChzKzLR2
         uk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+0/dP1Ui+paZJMfapMlYjJ6EYgBbWF6P++a2m+LaySE=;
        b=hdJ8NGJqh7SEcMCwXULzmVXewVcXd19w6uXm4ngrFxCYbVwrWXyA0d1jhUDbHwn38G
         mr4KQo1T00aLjxocpDYvQfQiizs7rQDLZ9RnfVOQvsaOvcsw0Pp8zQtdLoxDXdeY5uf5
         cUx7IjfY67HE0TmbfqFrWEWycaB7RZSQ81N8L1o2/gox6HwhN1yCsAdwiij9KukclmC/
         IfuvhNUTGpO0UCeaHKaSBHAkbpkmEs/dwT0wE8p7kWRGkQw6DK0noWp9cKeSsjIT6HLu
         ct3/FRG2Wv1HqdAx7KjTUH8vBQXkb+J2rk4rodPxwELQWIH/ei68+uW/lJDb7wxoUqDY
         7xkA==
X-Gm-Message-State: APjAAAW+nQvyQpdlNYjbGkdsyFATN5zC+jaRnWmTD64W2lquXceo6s60
        Wi6RZQPM96/zuvoa8acp7IaTwsEGHJrx0w==
X-Google-Smtp-Source: APXvYqx3mrx1mFk8hat0XylcXfCRcZ4rhJ+UqEHMcHcUL4QEdw9dojD3W7UobU0EmFQVz5syTSk8EA==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr12583385wmg.92.1576801485772;
        Thu, 19 Dec 2019 16:24:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o7sm7539111wmh.11.2019.12.19.16.24.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 16:24:45 -0800 (PST)
Message-ID: <5dfc14cd.1c69fb81.e4721.6c59@mx.google.com>
Date:   Thu, 19 Dec 2019 16:24:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.159-37-g838b72b47f7e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 114 boots: 2 failed,
 105 passed with 5 offline, 2 untried/unknown (v4.14.159-37-g838b72b47f7e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 114 boots: 2 failed, 105 passed with 5 offline=
, 2 untried/unknown (v4.14.159-37-g838b72b47f7e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.159-37-g838b72b47f7e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.159-37-g838b72b47f7e/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.159-37-g838b72b47f7e
Git Commit: 838b72b47f7ef92850331f8b87e1228d8301f392
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.159-37-g5=
f381a956c02)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.159-37-g5f381a956=
c02)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
