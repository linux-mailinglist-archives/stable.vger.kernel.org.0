Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B041303D2
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 19:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgADSK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 13:10:27 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33556 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADSK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 13:10:27 -0500
Received: by mail-wr1-f41.google.com with SMTP id b6so45348751wrq.0
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 10:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qofL9gsn/cJ/+8aa0vQxpsDlKzsFizPtmG9UoknYNTc=;
        b=lJ9RI5/hgR3bfQSUqpm6lS+HS+GkbBqFHAxKUSOZIPz9cLPvrzfeh2hROAhYlp/8G8
         8ANJVyt8XolV0Cj+4IJAo5NxIA9CX7+UX2hinC7LBbM2+lUxgrBkiSyzCN3ZynP2CD4u
         PEbcz9aa7P7iyCGbgp5OHttsSrbtMQhws8+5q4ZfxMEEYHJEDrCvVfue4NyrH5MqiEdt
         mWhlQONP5QEpsKcfCwLdOKmixVM9/zwycN3BGq4pNv2YBxBmyYbnIYewbcp6HKVbVSeE
         ru2M5aIOvVaxbgHpUAM4h2WcRCMzM23hSa/BmlJkjic1bV7MmMG9VqFtpbW4ILalS1WX
         dOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qofL9gsn/cJ/+8aa0vQxpsDlKzsFizPtmG9UoknYNTc=;
        b=JGNlerzb5jEO5GCuNHVYeTTLI6baxAMa6JHsVs5ntfD3hvyT/a41wNY1kBNMuov/TD
         aG1/Qw8wtTk92CgIoic9GCa2+24DhsLb8Ha4wrg4TNpPkdO3Ly5MXKQeAKsJc91INKeY
         XbqMuVIYeZtuu0oMT+U6Wbo4Xek/0sWiA7fUO4z2DbYEKrlSRfWureucC12GkKnQ3q4e
         FLzIQh67NWkz5ZlR9+jQtoiPFz1rW5JDit3fUB/Ydrov+OfiJif1PzLRVHzatFTNEQ4R
         3ERt2Rb6KlCbJziSOHC5areG/CawMCagkg0nQYtpupEIRShiDoXjpNBq/8tnfDVn7mwL
         40mQ==
X-Gm-Message-State: APjAAAX2+0btoCNKd71yIJsZO5syz6bZUslKF34om06kGpUEmrvKZc1F
        oGfCIHKizQabwCjz1XlyHXMC8wQttsA=
X-Google-Smtp-Source: APXvYqwOPC2SXK2YEk3+4F6DG2bpR/6WdqVnrivTzNncw60K3pNEu/BIEFmo9g5HKrgC0NeVBIxMOA==
X-Received: by 2002:adf:f5cf:: with SMTP id k15mr96995768wrp.182.1578161425204;
        Sat, 04 Jan 2020 10:10:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z83sm16691989wmg.2.2020.01.04.10.10.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 10:10:24 -0800 (PST)
Message-ID: <5e10d510.1c69fb81.e3891.a70e@mx.google.com>
Date:   Sat, 04 Jan 2020 10:10:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-90-g01b3c9bf3424
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 34 boots: 1 failed,
 33 passed (v4.14.161-90-g01b3c9bf3424)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 34 boots: 1 failed, 33 passed (v4.14.161-90-g0=
1b3c9bf3424)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-90-g01b3c9bf3424/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-90-g01b3c9bf3424/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-90-g01b3c9bf3424
Git Commit: 01b3c9bf342438dd8af010d6e93f39d166653b89
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 27 unique boards, 8 SoC families, 10 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
