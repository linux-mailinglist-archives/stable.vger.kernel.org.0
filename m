Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE092A732
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEYWEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 18:04:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35467 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfEYWEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 18:04:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so13236632wrv.2
        for <stable@vger.kernel.org>; Sat, 25 May 2019 15:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3WXhE4n2CeiVw9DiN6YBjy5ZWcxtq+CG3K6noJTTebw=;
        b=fjpH4ClZ31T31WBBx55jF9KUzciwO+QSJnvXMog2C5b5zfmKAgPVBkkHXpmMbdhB42
         ALEvcEeezB8qjkP70vZYIj2mIBjX/dvc12TZFrSyfzT40KP0WlxVy/B1UhUDnBhu3K5r
         LH5ohlUL/vbEAEpbF8+QJPI1S/KGR7ucrrv2ociGuIHtoPlIfddYSMpApmKK7G+rrLlp
         AgZue8/YST4eDnjtN81FPijuZFuhc5XUHQe6Lt+RCHs42TkVPOyE6h9oScDyQvDkPqgn
         zI3evKTIxtI2wxolhNLpJBfnP/BBwQH2m8M9wqA54672mVVKBDriZu8U1/5HrLHAIPTt
         vXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3WXhE4n2CeiVw9DiN6YBjy5ZWcxtq+CG3K6noJTTebw=;
        b=namDRK/qY/EIj/KxsqsF1q9SXIK9/Q+TjpU+CVGz6QL6GfbWTTtWnEygpdrojVCiie
         xkojs4FTNNL9ulqCACPX4JGfS8ze0bnGNyqw90YV+bRdDN8zNO/Xy8lEcTFLGteMmRrN
         At8eGyBX2behZDawslfKn3Rtc+yhFqd1V5GaOHooFE0GgwUCtlSsDzmiXnT5W9t+Fxuo
         GQSBUsLNopPIarbSLUjB+JUo746oSTBJzUtfB8KS6zFldFpxtTpPxMjp884XlI6Un/Bo
         YQKiRbP5oR/GqQ4BTAUCTGcYmFr9o4SF1j99QoCWdjQumEBrK2mkiPilI1AkhFbb6Js9
         RZGw==
X-Gm-Message-State: APjAAAXedUHJeFj0AintD/YpV/5tgp1nFNLP6ev+h5dpcjklVN2NXL0k
        X9xO3KhhVsJxbT8GMEXYTC3k6gXyPRU=
X-Google-Smtp-Source: APXvYqz+EBi4DDq6Iuqh0RUitMSml8nkzTFxVQf0TARW1s9Ecy2XceSsIeqBMSGz0MWpRmjbkvpMIw==
X-Received: by 2002:adf:d4c8:: with SMTP id w8mr10102363wrk.2.1558821884156;
        Sat, 25 May 2019 15:04:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a17sm4541843wrr.80.2019.05.25.15.04.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 15:04:43 -0700 (PDT)
Message-ID: <5ce9bbfb.1c69fb81.b2488.8ab0@mx.google.com>
Date:   Sat, 25 May 2019 15:04:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179
Subject: stable/linux-4.9.y boot: 47 boots: 0 failed,
 46 passed with 1 untried/unknown (v4.9.179)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 47 boots: 0 failed, 46 passed with 1 untried/unkno=
wn (v4.9.179)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.179/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.179/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.179
Git Commit: 2584e66ffbf0fceb85c2d2f9179b6954720ec55d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
