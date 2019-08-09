Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC4886D4
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 01:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHIXO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 19:14:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37782 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfHIXOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 19:14:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so6912513wmf.2
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 16:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VPvy8k/jXLWa53IRS83mclCWXNRlTkMCqZz+7E2hc2E=;
        b=Uwc61fTJjxSsN1MtZp+lj5mRD3ZCQc2BZv6Z4Du4bvM6gmlbS/30kRflaSeU/VGwPM
         QHEIMhMgsdY3LKV2uXby9j8vXih1S7ZI5WE7feYTpQDMN4Ksrki6kQd9O0OzGBXF7w0s
         aGU88kqiJO27uqB0C7spYjo1MCEqOtnLczn7xQK6U2dCFwERFWXT3Yg8rdbIrw1b50wC
         CdfHSC32UX4KJ8lBM0fOozR13seROhEG3kE7CdQ3oKAQyMMQYH5J2hdWKObUWk5ENFZf
         3QjZpEmOZ07q+szB+1G+rtZvvyMSuSMA99h08z6r8Zha3z8TgxcgarjO09uAzO0LmJwM
         3ZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VPvy8k/jXLWa53IRS83mclCWXNRlTkMCqZz+7E2hc2E=;
        b=Zg4/n7jVqlg32vli2aqid5oIQZxcRTDJH5kxqQK5MAbiZRiz7BiefYiOmoevqIIfvA
         ZpdamUxp5TH2s17dzPgS0AeVBSUzslnRsuY1IfmdB7c4SwPoeGHOtEQoLYa6l23Rj0mV
         3K2o+GKrn+2dDWWbpeE/TuMuxqkUD112EQNIiQquZqVCIrgQ7n8TfIIb8nFbvm3odaPb
         fYnLmaOJbEidux6pXqwSOhH5HWSeTjhCuFywkzqLJb/7UFk1Yof+wLMExfEBUjwEYHob
         QTLqytKI7cJY0X4IEiAuw/UdjXOty/CHatgrMVtCGnFtjRPaoH7SdDZvVt4b9ST9v5Qu
         WMzA==
X-Gm-Message-State: APjAAAX3TDKn3kDZsjo3hJXTAGORAgmw70eQi0938qY/WCz81LIVhlUD
        TMB0ZCKwRPcLRI3+Dj+sSDpVP+CNcDLJGQ==
X-Google-Smtp-Source: APXvYqwgr0pVVjfhNY8Ia+NbYgSnkZxshWhKIeE5nMCubnsGa0COXIrXF2i9xFmqjK8vwWAK8AwlBA==
X-Received: by 2002:a1c:a7c9:: with SMTP id q192mr11452159wme.144.1565392463549;
        Fri, 09 Aug 2019 16:14:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u6sm7568199wml.9.2019.08.09.16.14.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 16:14:22 -0700 (PDT)
Message-ID: <5d4dfe4e.1c69fb81.add47.7481@mx.google.com>
Date:   Fri, 09 Aug 2019 16:14:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 74 boots: 1 failed, 73 passed (v5.2.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 74 boots: 1 failed, 73 passed (v5.2.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.8/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.8/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.8
Git Commit: d36a8d2fb62c7c9415213bea9cf576d8b1f9071f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 17 SoC families, 12 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v5.2.7)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

---
For more info write to <info@kernelci.org>
