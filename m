Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4667744
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfGMAeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 20:34:13 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37136 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGMAeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 20:34:12 -0400
Received: by mail-wr1-f44.google.com with SMTP id n9so11565892wrr.4
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 17:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ei39K8sI8c1CQu9qLP9wO6yL+QwMK0bpoE666G1COAY=;
        b=EUrJYwel3xjJ/JqOswtK39osH/gxxem04MIpTCPQ8CHJzi6ewcZpuXKlyXloeAN4KM
         Sw+dYFzsG9Mjqw6Fil9mo3HeYotad86YJRvwvFR37DyO/RP7XRSxTg4L36U59dow9Rg5
         mKYhyKqwVdM63uikWAFWUlPEvcAVcgYR0dO5/Wn8SGLlpzQfVijpdE6qXhh7BI5v01Gm
         55wOBqg8CFnpRiGiUTYzAeksil46160YT4xEl5XbxfNHFXTNdtlDDCsTLXYETo/xnaXl
         eahzqVEWkOOqR6qxAZAnfP9yGlTzoZJ4qIcawZFX29sQhrAI4sKHftZ6IPzi/6chsrCW
         /tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ei39K8sI8c1CQu9qLP9wO6yL+QwMK0bpoE666G1COAY=;
        b=rP5f85P+W9ybd/k6IwJad9NzZ+hmXNLWkpjqm2yq3VmoHzs+3UryWiREgjwUlheD7h
         i7G8PssL/z/YgMVkbBOV0yMmTH1QLId1BXyhTVzGfXI2sB+jpjwyg/W7FORZ5eJ7p3kD
         32CnMcyDQxxVBgl5e+bV/iERNbFe87oqlIs2SeQJIND24SkTNsqJ1UKiSyJWS5b08P8y
         1MbRcGVbavadnC6LXHVB6INAVerRYrJ1FMrz2+gpZZibPJ71k7MlkFcEoGGzSN8F75gv
         pVdwGzYwlEjw2X0FRHTTfLnohcbmJBGqlQHH4bm7n+umxm3KxLHKelOEtnxPHzYy6TSJ
         8/9g==
X-Gm-Message-State: APjAAAU+a42R1P8ccEdg+VbMl/Sja8jzCm8FtSvKKARr0RQSfIBE9GwY
        tlSOZfZANjXli5v+U7uDwTD27ABSkyw=
X-Google-Smtp-Source: APXvYqxbjkvStu7EWdiY47zTOBVhgzKahTT4GBObIHdbetXc0zedItlPoUoI9i3YkrLZZ27oyTI3ng==
X-Received: by 2002:adf:e803:: with SMTP id o3mr13908433wrm.69.1562978050565;
        Fri, 12 Jul 2019 17:34:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m24sm5866056wmi.39.2019.07.12.17.34.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:34:09 -0700 (PDT)
Message-ID: <5d292701.1c69fb81.41d08.1e84@mx.google.com>
Date:   Fri, 12 Jul 2019 17:34:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.185-40-gbb6f286f679e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 102 boots: 2 failed,
 100 passed (v4.9.185-40-gbb6f286f679e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 2 failed, 100 passed (v4.9.185-40-gb=
b6f286f679e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185-40-gbb6f286f679e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185-40-gbb6f286f679e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185-40-gbb6f286f679e
Git Commit: bb6f286f679e771c94247282a028d4b043b644de
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
