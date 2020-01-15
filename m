Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B4313B8BA
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 05:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAOEvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 23:51:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39082 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgAOEvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 23:51:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so14413913wrt.6
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 20:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pf/RQPmRM/reyIAS2t0PlZWUgPaBf9o+Xq/UviUupEQ=;
        b=xMEl5SIOwKrda9R2WokUpU6u0+9UGDAMTW3v3fXFIwKrKvLZUCJnBMgjv0Z9y5hP1q
         gNNQr3Wy4nj/JJjikauZvvWRiIRavAskcnc7dJTTd1u0X4Qp6x8vEO4krLWDXk7FYjQR
         D0QbyLDD3rTHmPFAxJdNbA04+B4QLqCqoG/FDE+mLe5HbLrxVHo1nrd0hzjTC5iw/JzQ
         FHshlHWtUCLMapr2e9pOJqM+wzkFU4mfbBVKrCpN9ZMcVW6xkxP/hRgnEYqlM+VStXzZ
         FvFo+vyp78o3LQh0tIHptQAwpeWJ0YoKMfapcfqThmI2zLZJQrBA7RXMiavRIiwR0fQg
         sG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pf/RQPmRM/reyIAS2t0PlZWUgPaBf9o+Xq/UviUupEQ=;
        b=tcMpKbofjk3plFDR/2WzkzZNE/G0rxZeOwz6p9eNY49ek8qdQBCYCwgnk1sBrDhX6/
         5vQ3zvOJL+Gl2Y1fm7FPyjFccM4aqJR9FvcVCOunup5KbBkaeQMxF94834llDbEJO91N
         srodqY12fH40VO4AWqLCwPHlvAhuI4+w7XEZphnIk+aYuXpOmtVJnn8QwLLMlQVi447P
         VHP/WYbGV/ArfRwDVm1EyllrePo26Thz60F0duWYH2HUZdofDI8HVz1xBAszyKT614TD
         4QS4ELnxR96WVIQTawVn5DeT1PW5tKAsTWdJQA2E2rnXBx/9rTqrGrBGmgLEL1nTX2Hj
         Fqfw==
X-Gm-Message-State: APjAAAVe4IRuxeV2zn1Fhk/DlyKO9U7ZOnY1pck5Vv/tG6g7xeDdEH3d
        lZUsLXTgEuRd32DjhnYxjxn0uPk2s2VMFA==
X-Google-Smtp-Source: APXvYqwu3fF1Z8bhlJmTIUYB2uFfL+SpyD1JhJgAvKvVdgVnobdBH08qbEQCL+0YP1JysIHwqKURZA==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr28225107wro.209.1579063901425;
        Tue, 14 Jan 2020 20:51:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x10sm22482935wrp.58.2020.01.14.20.51.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 20:51:41 -0800 (PST)
Message-ID: <5e1e9a5d.1c69fb81.46933.e654@mx.google.com>
Date:   Tue, 14 Jan 2020 20:51:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.165
Subject: stable/linux-4.14.y boot: 68 boots: 1 failed,
 66 passed with 1 untried/unknown (v4.14.165)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 68 boots: 1 failed, 66 passed with 1 untried/unkn=
own (v4.14.165)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.165/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.165/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.165
Git Commit: c04fc6fa5c96ec57316527b2228fa31f26494abe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 14 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
