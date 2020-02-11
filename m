Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBC15978A
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 19:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgBKSBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 13:01:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33586 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgBKSBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 13:01:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so13614370wrt.0
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 10:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mihgqogddaXMnalkQml5mlr/Qg+6rJyzbp02g+eAx/Q=;
        b=wqdAtFOJlveH4k3NtP8klfvLpgStM5qtZqRatLYN+RVl72tWbFJVl/OMWNYQ47Pymw
         mnO8FnPdunilazuOczXr9oPt2BVaA9CGVzmVwjRR/z48yyklLTYnIPffi4k6O9gKTgtI
         wF59w+HPtf3Yb5TIe+A5DZb20gT1DXh5U357l2mWxdGN0uVOyLYnW9RKIZ9LLrcYku/U
         X7DwHKrzLBA01+uSN9s9gvH5WGhTbr0rmrIdjreLEAO2uH90CVFocuPao5BcauOzfwdC
         bxn0WgAxKNTuR69++TDJ5BerLJulUbH+qU7bSrCKYaEWdn2OX72eYWfEc4GXTwxkHeF0
         y9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mihgqogddaXMnalkQml5mlr/Qg+6rJyzbp02g+eAx/Q=;
        b=jW+9EufY3M9fmeqV8sSS+87TaarinIZ5ig2+TWOQti2apkuJvNQM5AFGsZG4iBTqTk
         lTNfoI58447Ajd3Dr8xumZ+C8BFfcLMXTfi+GVK9gaz0zebDIjKQiZbZGhroI3PrLX4/
         tmGmWbCvnmPWCMNtIbD2l51P0flY0DnsvCC4ylAE8DWo14r/OqKQ8hdsLWDMYAVc8n1F
         yc/82T5JOushPxTpMnlguTtrvSbb7aw7HEaGu8w3EXC23oJf9ZOQrYhXio9P4yQSoqGP
         l3K9IA6VENFaaxzA/YmtiuD6a9DPQZ1yuKU+sCXXhclFI4uUPWsTwv8v4FTVVXkUWCdQ
         QhRg==
X-Gm-Message-State: APjAAAVIndkiIxjsFYbG0rJK0yCXOzaHO7PUzE0kKJN/BKX+rSloFuCK
        lhU8uKqlOlV1/R6siYy3N9w/DLSIojMwIA==
X-Google-Smtp-Source: APXvYqyDNnUFGR24SUoCV77Ngof0gzUWXnrTWjKioRQ9Y7wT0j8SfZmNOAClKnRNUy11T3OSZn68qg==
X-Received: by 2002:adf:e8c9:: with SMTP id k9mr9852091wrn.168.1581444059776;
        Tue, 11 Feb 2020 10:00:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y139sm4945012wmd.24.2020.02.11.10.00.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 10:00:59 -0800 (PST)
Message-ID: <5e42ebdb.1c69fb81.400a1.7397@mx.google.com>
Date:   Tue, 11 Feb 2020 10:00:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-141-g00a0113414f7
Subject: stable-rc/linux-4.14.y boot: 104 boots: 2 failed,
 98 passed with 3 offline, 1 untried/unknown (v4.14.170-141-g00a0113414f7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 104 boots: 2 failed, 98 passed with 3 offline,=
 1 untried/unknown (v4.14.170-141-g00a0113414f7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-141-g00a0113414f7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-141-g00a0113414f7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-141-g00a0113414f7
Git Commit: 00a0113414f7ce94f53501a63376355d55f0068f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 21 SoC families, 12 builds out of 132

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
