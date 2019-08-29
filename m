Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B864A1906
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH2Lj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:39:28 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:54202 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2Lj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:39:28 -0400
Received: by mail-wm1-f41.google.com with SMTP id 10so3351051wmp.3
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AYgvbiTAQ3inOXOlhATPG0lFzAaxSuycKjeCu+6mjow=;
        b=yK+OqhKjgmyO1bWqo07FLu35wzIMDUtc4C6gC0UDI5NqALHmGePQ5+XBsbl7peBVoT
         +PpcuCHJqPPY/Vu2wrRQv+hSNryt3emLRyd1LDV83wyIBg6aG37YO4X+CnPhekyUcp5M
         cUjbLi3FWtStuoOzvLBhDjBKB+8MciDxJC8g6btvRz06NDBYv/p9gKrTQAFf1e2h7f83
         NcJ3x7xOONqRSGrwk8GYb7NVJOveR2cpcIEjOvZkVjqaAF8DRRRoVkBSVF+MsniO9/Nr
         DxTxg2laVVSKsL0Gfm95GOdYEWSNwUvYclF+KpfOQgYgLLBy9X3ndibHBm+AizeCojgJ
         k9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AYgvbiTAQ3inOXOlhATPG0lFzAaxSuycKjeCu+6mjow=;
        b=mrRcHdXc4lZRa0CZ2SweBJMYoZLdR7ymTll86LxOWqeqQpvcFsF6DXxYByb0pKYgS4
         12OBP0admmsBjzcUM0BsQ1hL1rItETfheH1RPYyrENfHbCc1mrOvEuf3JROUM8+V/LdP
         vKU7slEqdDl5eXr0YCkcUAIrnvsqRvfuRm4wAiGi1MJqgh11bnPm6rkGQIRCizl3PKsP
         pADRhPReFYKT2iGVySLkLdlwGhXd2Jrt79wVXlExjgyJQlWk5yoeCjXeWbLar+VDp4JB
         p5/+S/wEGPV+WdnaKSfyRiKbxM6P9W5Rc8ez+E3oXf0xnm0gu45VYrM5g8xooowBhvyP
         oIPA==
X-Gm-Message-State: APjAAAVWfTiqwN/tjD+oWJlId2GSZIbp8Pr/EtftnqX4e3dt+wBvWO+j
        jnwP77zLMo6QlCXaXu3mIEaOnxy7wk+AUw==
X-Google-Smtp-Source: APXvYqzpI+j4VTgWTm0sBFhg624s7PZC8lap1brhcj4pYzTDhrrxJEyJOKg7flUfWzf3ihAWvZ+/ug==
X-Received: by 2002:a05:600c:2311:: with SMTP id 17mr10851851wmo.68.1567078765867;
        Thu, 29 Aug 2019 04:39:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm5322407wre.44.2019.08.29.04.39.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:39:25 -0700 (PDT)
Message-ID: <5d67b96d.1c69fb81.d93d8.7a30@mx.google.com>
Date:   Thu, 29 Aug 2019 04:39:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.69
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 77 boots: 1 failed, 76 passed (v4.19.69)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 77 boots: 1 failed, 76 passed (v4.19.69)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.69/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.69/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.69
Git Commit: 97ab07e11fbf55c86c3758e07ab295028bf17f94
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 18 SoC families, 14 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
