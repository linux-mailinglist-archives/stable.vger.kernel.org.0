Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D408B3987E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 00:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfFGWVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 18:21:32 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42626 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbfFGWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 18:21:32 -0400
Received: by mail-wr1-f53.google.com with SMTP id x17so3543238wrl.9
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 15:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=in4XTbb2PbeHsOP5GimQeEwJqQ8dnlMe9grq5mDnu1A=;
        b=SBmDqtiD4YaO95dtv5uESGEL9I2ceL/+gkzME+DFf1NeY2/UDxzUchaP/GvimFWGbd
         EX+L9DCwCr7RhET4VO3QmYsnnNwS0E85q/enWasuZ9DWIfj+GYQR91prDxaPluKQG3hT
         31jZNf/V0cR5xaz4tmf4FDSfdSRo9ODMwwkuBQWyhch1xQso3a1YQKD0+VTi0GHlmUGq
         7/WoLVmP6wbkE0Er75oHZSESoksJjOARpSFU/HJurYOt3l0nJWS11hAAGJ3Q+U9hh/51
         eqgAUhjWNpX2XlR05qizkHpg+h4Rip22kylCgHyPzwsdCyvDYcjZR7ockhcVhFtU0SDD
         FxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=in4XTbb2PbeHsOP5GimQeEwJqQ8dnlMe9grq5mDnu1A=;
        b=Qx2Cw3FGTKPnASzrY+YajsnpMWCmTqn7MKcMqmm/yzU46bniPEUYhekDtjuCJy1Lx8
         zjAfNPYBFF0YTkeSYIZNh0cs0dMiVof1oq2kH1AKb5KNoUUEh4hh4Oro95djZ74Ctlcj
         sSRpA5dmFxKqmLyDUYvYtsMv5jpy5DEApcrDJQsrniaMCKuq/bynyzEQs2Rh5gO+icZV
         bFe4rjb51zE626bqQoKmJW5b/anjmk1wm+IIqLi6pi792Xrv1cNzwokATK3wt6ToXYep
         zqdaVRsbCoM0Yb+y5qqVWGWg2Y+J4khjXlTYBlrQrpAvPYTGOUPchXi6sG6//EOqMynA
         qhPA==
X-Gm-Message-State: APjAAAXvDV9vQEPzYAfjCXI6MXV3XcIq6AhKV+1M3Gtt+U9az64j7OvU
        63CE4FTfgDA3xjFcihEsrauWXxb97OhdGw==
X-Google-Smtp-Source: APXvYqx8gBGqBwVv4GM7q4srbUFCBeHuudETFDOPa/IS3L2obiaEit/GO2Jbr1fNsV7eFkOPUAXNcw==
X-Received: by 2002:adf:afd5:: with SMTP id y21mr34587983wrd.12.1559946091114;
        Fri, 07 Jun 2019 15:21:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm2784973wru.28.2019.06.07.15.21.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 15:21:30 -0700 (PDT)
Message-ID: <5cfae36a.1c69fb81.ad9ef.1a25@mx.google.com>
Date:   Fri, 07 Jun 2019 15:21:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.180-230-g17950b5be27c
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 50 boots: 1 failed,
 49 passed (v4.4.180-230-g17950b5be27c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 50 boots: 1 failed, 49 passed (v4.4.180-230-g17=
950b5be27c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-230-g17950b5be27c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-230-g17950b5be27c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-230-g17950b5be27c
Git Commit: 17950b5be27cc26dcc48dd3f8cb9a71ba650a6b3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 13 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
