Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDD22F966
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 11:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfE3J3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 05:29:36 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38641 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfE3J3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 05:29:36 -0400
Received: by mail-wr1-f43.google.com with SMTP id d18so3710065wrs.5
        for <stable@vger.kernel.org>; Thu, 30 May 2019 02:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EzivaMa5Pk1jCKAVWliIAnnNpYPzY+wQZvNWBP7vQJ4=;
        b=lkIwlgIs0Apuk9MO7QdCI/CsYKwpuY7scz7KvKpCu4zNwnutSPav57R80ILHdirehq
         vsNAszMXxxsYbGb/flEDc4+msAtPbBZZym2RF76ySHgM50UJJRoKUjI3AooHjoAeG49X
         Pw7fYlNFVW2+1CsRp27mORcmMvTwoq2fggP4ObyHOjjqS3h6v5Wljogg7ZggjXexcrH4
         D9WtvOxl1yrBhjgorq2bjfYrNMxRZa+9tReuKEYbOHh19JEhPWS3jTkPvzNKFB33em4B
         soQNi4I0oDGukPQ96dUTw17WNIwzdzYblJWQwim7eQxudzPG3Bqma1y5NVgkp4KuFDSb
         pLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EzivaMa5Pk1jCKAVWliIAnnNpYPzY+wQZvNWBP7vQJ4=;
        b=eqhPS9s2YAnxUQkDazrGyZ0UxJedlAh1rD1Dx7VSD83nqVh0Ip+B4eWyA4d9OHKv7R
         uwKJ30WEKg0re9G71xhXSECggKKcIcbUAE8C4pK4MUxKAzOLodI3B70MrNol7JhpdUf7
         ZFPAHBWdatSjFYUV9GO+3nwXHhrDiA4PNF/PlCH2kvaXaqARJe2CPv/JuUqZzAeeFDIJ
         ZDj3tiACt30LkGL795F/vmxLCTcSiw4vIubmnFbsBSyaHgI5eBHFWYE4uYa002ENNcWu
         pazuonwoC1mpGaQsqhmDqWGGWs0hSZNCPnXI2R0jBrTOnuEi8CLWfQG63h6yKkdNKZKs
         JnFA==
X-Gm-Message-State: APjAAAUHDykzPcBXr5oeK8iAKiQIvoN8h09BKiQ4zhu+J3kvc1r61i3r
        qeNR9bezq+Xn5w8dIatv9Rwd/YO5tZ9jGg==
X-Google-Smtp-Source: APXvYqy07UEMnfuE+0UZlqq8hymLNzGyo+5tNRSio+6Gg346h+yWMkx0Vf4fJ0G1/7fSE93HBPjg3Q==
X-Received: by 2002:a5d:4a46:: with SMTP id v6mr1871588wrs.105.1559208574429;
        Thu, 30 May 2019 02:29:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm3366610wmd.38.2019.05.30.02.29.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:29:33 -0700 (PDT)
Message-ID: <5cefa27d.1c69fb81.89026.18e4@mx.google.com>
Date:   Thu, 30 May 2019 02:29:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.19-347-g79c6130942fe
Subject: stable-rc/linux-5.0.y boot: 124 boots: 0 failed,
 124 passed (v5.0.19-347-g79c6130942fe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 124 boots: 0 failed, 124 passed (v5.0.19-347-g7=
9c6130942fe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.19-347-g79c6130942fe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.19-347-g79c6130942fe/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.19-347-g79c6130942fe
Git Commit: 79c6130942fe2bc8d8cc92c526e93cce6a068262
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 207

---
For more info write to <info@kernelci.org>
