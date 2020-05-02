Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33F1C2879
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 23:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgEBV4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 17:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728523AbgEBV4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 17:56:10 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200DC061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 14:56:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a21so1584124pls.4
        for <stable@vger.kernel.org>; Sat, 02 May 2020 14:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4vHTo3Wh7es2GQAtz/rzMOzjgqOilkEdxprcoNegrCE=;
        b=slF8qM6ZH+iT6E8ZWBN2E+p2ZkQhrlf00LCw87hzR8PTAGR2+GVDZj6rKutVnFqNeW
         dIXf0pIjEP4RfZ2zqT1Vyt9MNQc8D9YZM48pKmzNNQwKSwLK+wz9WpZ3PDafSS7w4mCq
         N9zzCc1KnKDK8RC1BcyBqJ4AV/KGZfoIuI7vn1FQoRbDoSPztWJxPEorfFKYbnoMNaJm
         XEGVHBBhmsGXmDazmecjznBlzRjzOl0oEpmNOitAVRZWGS8np9QSp2OfSej2CNBwURoW
         OLmjE0+XpQqD8FVLLZxRT9LR7TfgRezwoSWxMy5iia4F79WH+t/OoFs9pr7mnpCRPyqd
         yewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4vHTo3Wh7es2GQAtz/rzMOzjgqOilkEdxprcoNegrCE=;
        b=aFG2TDk3S14fctAzozYz6kuJdaF18ARwyso+UuuZMfcgH9wuQldJbclkYPux1DVgTy
         uT6hmeWiIWYC7Rfbf+4w8mxHlYR7gl1UHJ9/yMw7fpHg+00JdfiQF3Chz9QCUQeLXPP6
         hf3treyzQpw/8rVg8Sl1gfbdm5XnV2cYAf92ke6/vuuELoBUiDUs31oWAQkGl+ot7Can
         mwN/h3+A7CMxof/pXu+aAMJcVLo7U3ZsJEQl/4Rw1Pa+9nJSxnV6+etO7ENQFg+mFECT
         CZUUiACoT7SpC8c34/Cw4OL+g1be9KPXqvnvXpqSI21bwCq6Uy80ATj8PMc1GNTBRcJa
         qtaQ==
X-Gm-Message-State: AGi0PubpAiRMnZLOKbJGe1Cl7oVLdxcGVmhIgqs17wNQei+Gw0h7TyH/
        14tL2WIiamc1jITY7V9fql4BrEqqoDg=
X-Google-Smtp-Source: APiQypKK82hrPak6LNvjbx+yLS+ZXWyLBBcXcaVlXNNt1cq5rliWvMU63RJKU7sS/545qkwHquCkqw==
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr8399007pjh.66.1588456568997;
        Sat, 02 May 2020 14:56:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10sm5194849pfk.103.2020.05.02.14.56.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 14:56:08 -0700 (PDT)
Message-ID: <5eadec78.1c69fb81.56ec7.50c9@mx.google.com>
Date:   Sat, 02 May 2020 14:56:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.221
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 58 boots: 3 failed,
 51 passed with 4 untried/unknown (v4.4.221)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 58 boots: 3 failed, 51 passed with 4 untried/unkno=
wn (v4.4.221)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.221/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.221/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.221
Git Commit: 54b0e1aed69edd904ba7e2e6516d37750c29beec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 12 SoC families, 13 builds out of 190

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

---
For more info write to <info@kernelci.org>
