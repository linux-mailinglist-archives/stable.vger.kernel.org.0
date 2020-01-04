Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CEC1303B5
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 18:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgADRFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 12:05:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36215 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgADRFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 12:05:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so45226182wru.3
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 09:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/W6Ub+jNIsTynXyEQxsh+rrZBMFPp0H+WO6D/2mZRQg=;
        b=aTsnO7Vo5J+J6nv4RYIRB5hMxNmfmk3QGG2Eckn0GFNITma+2rZ79tmEbQ0cylYXLf
         QpE56B20+IJIt6Vc1JZ6L0lnyucYihAks/TcyFc5O/rZMvCHR+Di4r34BsMq+Q9eamBq
         fFnPYIGB9tH6e2SZc6Zj3tBmrZo15YZB5Wv3SN6m1iBFEt4Duvk4GRx+ZuSfuY4AVpT2
         Kg3OfFxNAKn3+SFSsG8R0Ggzbkrg46mAe3/bH+6pamEEi1wOdo1NdRwHJ9MNkUHw4+5R
         +dT+knLOtlrXk1U+yJl+8rFaudW0SIlmBL9FR+GcpRZr4gaUnXnGs6oPVds1Xa0nB4DM
         X03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/W6Ub+jNIsTynXyEQxsh+rrZBMFPp0H+WO6D/2mZRQg=;
        b=IaiwFJNQBp5gQwhojF16k4QRbWQ5DYcUlDfFD1+PpxN+qfEwmFTqHw0SqjTqOVw/m6
         24eZj8zmhxLzWz7YYKeZ9L7K7TzTDMqF+xl0TPX2Ecu3M5RnvmdmdYv/pslQEuyScnIb
         ScFozUPg6sXfQeowAdC38Fuh3UlzhzFlajksIH5hbxPm5y2ej7kIAdwFjV8oQkB67eTD
         yl5L8nKIL+adAs3cU0Q+FZa+90yV7wuTqWAXQkPG3P5HzVEYLOq7GHCQyJoa2lumQTlM
         QLa96hu0Vn3ejKCHGX1yiWO4kI0HwuA23LPh9COc9SEhRa5oabknTR6I+jnnNq/8WlLS
         ZVfg==
X-Gm-Message-State: APjAAAXUDF473WJPgrwE61kNHLkW1ev5WEJKx86eS2XGDgWUMohCQjNY
        nLPa31cnpDxXRK9epjQFWctBFfFmVmY=
X-Google-Smtp-Source: APXvYqyqfHcKPYG9dLbGThd73tw7aWny5rHld/weTmwJkPUIIlHBE93MYNfWf8TzKDSvHcuBGo3Dlg==
X-Received: by 2002:adf:8041:: with SMTP id 59mr90340461wrk.257.1578157536768;
        Sat, 04 Jan 2020 09:05:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e16sm64006507wrs.73.2020.01.04.09.05.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 09:05:36 -0800 (PST)
Message-ID: <5e10c5e0.1c69fb81.ca3f4.39c0@mx.google.com>
Date:   Sat, 04 Jan 2020 09:05:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-137-gfa59586a2a48
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 20 boots: 0 failed,
 19 passed with 1 untried/unknown (v4.4.207-137-gfa59586a2a48)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 20 boots: 0 failed, 19 passed with 1 untried/un=
known (v4.4.207-137-gfa59586a2a48)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-137-gfa59586a2a48/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-137-gfa59586a2a48/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-137-gfa59586a2a48
Git Commit: fa59586a2a488306bf8ef39d79f77a8785bd1171
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 15 unique boards, 5 SoC families, 7 builds out of 189

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.207-136-g375f24644=
bef)

---
For more info write to <info@kernelci.org>
