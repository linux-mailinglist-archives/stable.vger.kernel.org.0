Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A7A1CCD4D
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 21:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgEJTls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728823AbgEJTls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 15:41:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74B6C061A0C
        for <stable@vger.kernel.org>; Sun, 10 May 2020 12:41:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k19so2993627pll.9
        for <stable@vger.kernel.org>; Sun, 10 May 2020 12:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6T6lWlcrZlvJ9rqTyUji6O3WEfymppv5V3p/ZIrS92g=;
        b=OAR/VZi/4TDmMW3wVqVUMRamzSzFMU8Jg07Wlyj6Jz4tdEYWhc4H2K20YvvBondPtd
         dVELD0JbpSjYvcLOrHqQjw1/ZcdjkE4cZix11WReOQfA1z6qkTWL5WBYC6lGQuB8Vsfz
         TN0stPDELyszcMQsTpWaMvGGKBNDaD+vO+kHH17pfbF0+hy0LZciV+QlmmkUxKU81ks8
         1syB/RWfIPH6Pr+Exya2ZY8I8Czz9Ol6f3VyTN96c3sDB/cp3bvMzdxi+Prp0MbeL5qQ
         M0lESgGoGlmZgOE9hOibNJrPqRk5bjTfO0XH2s4uJV0Shwi3EfLmA/tNFGCJCqidjdjh
         Qp/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6T6lWlcrZlvJ9rqTyUji6O3WEfymppv5V3p/ZIrS92g=;
        b=ImhJ91q3XX7avk1OY5tunyNNiD7sqQi3M45M9XzsKMXHR22rrxg82xDn2A6ecRSRWY
         MqgYGr7c5U3qcGutZRLgzzQE+VebUljClQDIh+L8jiNU7amnh93g2o1KbqX+ynLlg9cY
         ZlXpnUyLyXwKeR/d4ogzRuL3P0P2oLopIKHZxiKR0bNC1aLIwOD+dAG4F6AsRDFDK3bk
         mPC9hX6cYiUFQGw0pAQgraUko7MFHjLNj5SxfxSoODhr9AG8MARE5+yjx3JfE8KoblzF
         +TXbGwRWi+945e99rsgMEv1wOVtSyCBxDpUEjImYncP27WCkhmxXTGIFylmY3YPy1u5f
         x4zg==
X-Gm-Message-State: AGi0PuaEzJ6Jzdw6zxWc0sPKuGWt4nLDvkrvYx3GMTohUirzPp2pY8gH
        prqsqcNugkn67JH+ukEfyBIAAP1/btA=
X-Google-Smtp-Source: APiQypLvQ9amlnL3Nc6bHMAray2e8nbfVwKNhKFws9ctWJl41k6qjjAsBlC7Jna0mJ0p5eh8p3+iKg==
X-Received: by 2002:a17:902:8bc5:: with SMTP id r5mr12164463plo.218.1589139705595;
        Sun, 10 May 2020 12:41:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j186sm7449682pfb.220.2020.05.10.12.41.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 12:41:44 -0700 (PDT)
Message-ID: <5eb858f8.1c69fb81.e213e.9aa8@mx.google.com>
Date:   Sun, 10 May 2020 12:41:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.122
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 97 boots: 1 failed,
 91 passed with 5 untried/unknown (v4.19.122)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 97 boots: 1 failed, 91 passed with 5 untried/unkn=
own (v4.19.122)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.122/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.122/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.122
Git Commit: 033c4ea49a4ba7a2b13aabf3ec755557924a9cda
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 57 unique boards, 15 SoC families, 17 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
