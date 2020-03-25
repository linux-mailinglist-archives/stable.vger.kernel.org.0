Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D9192B75
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCYOpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:45:38 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50805 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgCYOpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:45:38 -0400
Received: by mail-pj1-f65.google.com with SMTP id v13so1125326pjb.0
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 07:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ugCeqmp/Mq0jKBiu2BjHElJ0M5EMcj2uFtWdNcNxFTY=;
        b=s6ai0HpgBFXJMc2A1CCq1fIq+8pcSCAs9jnRKN+CozD5xWouSJOMTteFYMwqkSnWaC
         23OlBx0YSnpRaT5AXgbuwwR+l7+DhBNQP0moEM32N3LUdRZzJVR5i81tGKpiwuIFjjht
         W0+hjzt0nIk8qCDCxmVX7EIHCRNTf8N+jGAKaw5X6eBhBDK5sMelpabUSZyhF3wUVUPY
         u4FWINn0iAvbT6obpsiVn6mWdr30bXLbMlSSN1eeX8BBIVCh2Aai62cJITDs6jNwQ1NS
         s6E73P7LIkgpaPAFEjixVTaeTPgEBW01vahtdJbQlIa7RTSBu5aj9k8qhfgJSmSqP8SU
         qBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ugCeqmp/Mq0jKBiu2BjHElJ0M5EMcj2uFtWdNcNxFTY=;
        b=o9Y5/e25lsKd8XOgpFXOUNdmD+oOaiOrlOIEZl6+z8QEdGgdQWo4AmPii5+SVF7Ftl
         ffG55V7hwTZNdWlPOP46873cTJtZLeejCu4rnETn6K5w3ks+exOIOpj6RvSu+DVy/VRP
         d6fI7sQjDKq5lW//AggKecIn9X3UdAUI5gxVcgt48D+j5HEvLHrgq6AqyLJb8/OoiVQm
         9QCvj3PNxtLWxF3+AWEH8Oe59nYAzYd2BizYsMa4JShfnQJQbfv1Z7flbJKioK4I5oH4
         51FwUFfvkqUSXoWjBhMdmYNfw4boRROCzNr7vzhPcmmCbYHXy8KgrRr5VENlNH2Jiec6
         c3Ig==
X-Gm-Message-State: ANhLgQ1Wsk0tBKq5tJQd7eOO8fLlW1vOMRV2rx1R287Qs5Qv7MtoXZLs
        zPX2U10aMp88i0GRHgFzoKht4B4R8oM=
X-Google-Smtp-Source: ADFU+vvAbLYRUCdWvgyBkx9ZCsrk/1XNaQDOy94Ar8lWfRLP3c8Joii9wVmn8+tw3HHP5V2HvFTxzg==
X-Received: by 2002:a17:90a:2226:: with SMTP id c35mr4268051pje.2.1585147535477;
        Wed, 25 Mar 2020 07:45:35 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y142sm19317132pfc.53.2020.03.25.07.45.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:45:33 -0700 (PDT)
Message-ID: <5e7b6e8d.1c69fb81.35e47.93c5@mx.google.com>
Date:   Wed, 25 Mar 2020 07:45:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y boot: 104 boots: 2 failed,
 97 passed with 5 untried/unknown (v5.4.28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 104 boots: 2 failed, 97 passed with 5 untried/unkn=
own (v5.4.28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.28/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.28/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.28
Git Commit: 462afcd6e7ea94a7027a96a3bb12d0140b0b4216
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 66 unique boards, 19 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.27)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 7 days (last pass: v5.4.25 - firs=
t fail: v5.4.26)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
