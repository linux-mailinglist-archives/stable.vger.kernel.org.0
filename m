Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E914CAF9
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 13:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2Mt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 07:49:59 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:50931 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2Mt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 07:49:59 -0500
Received: by mail-wm1-f54.google.com with SMTP id a5so6067435wmb.0
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 04:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a9ASkoN7C7lCS0iQ4ejLF0UD/yEFjh7CngDexqfoj1U=;
        b=X2u1nsWrNttqCy0L0iIA0/0BTQzDVTtrEKkIsHUXBjyjvFoOrFZL+lUVdB3Y02OfEd
         i8juO+FCeLT0oriDlcUR08BjffBvQxUOGSr6iHNgLIxPh8NXtJjlKGIevW0AfkkREmai
         EaXO+mr0yWSFE3saTW1DMkN69rpM3141T6vZElkntomy1a0FguPX7Hou+iZN8KPeGfGn
         EaHtBVw6c58i3rjBLlTjpbc6hdbUo7g0hsRqIjM1SoaeBwt2chlQhm+RUkDu53ywJRWb
         8ExCMKAsBCgO24ps5jCJskFVRXeVbfKZawXc09Os9Mcm+esqNPwFL3pO4YgOIzLiTQpQ
         ouXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a9ASkoN7C7lCS0iQ4ejLF0UD/yEFjh7CngDexqfoj1U=;
        b=tatQ38Uqsn64f4vBbOhlqdtNMORK0UGrumMa84yOQP70RBW3otcwLsYtJXspRPJzNp
         H9rTxzVUtNTz0mmsX/6eNOleFZvteu03CkwCrg/TzS01GsNvP7Mqe0XtlXs/QUmHK8ca
         fMiGxxYTjlT5/meEk0kpT8W+6qSPh9gcvvoQPxfHLdZqURSBtdnxwlGaxBVAcE14Lz4K
         IGFtz+9EuLapbA9iACzbEIzj5AuU+rhNRTJbt0L5j1xShytroP2pIgk5u2hASGb/5edS
         TKDTv7FvD84RzEAqqzHIj0Pcza0hfJZ0Id87+8UXfgePlanC6KfHdVX/m+NHrJpWssf4
         pATQ==
X-Gm-Message-State: APjAAAWCZ9W0QF65CXblV8ffNcFICson5DygVex+K9YivMqwQK0BcYGW
        g4sRAMgu6Hp21RL7DE+18y4vYi9wVZhJsg==
X-Google-Smtp-Source: APXvYqzQr4+0a6ZonNMn4EflpUIG31VZSe/T0f31IsqqU5QeNuYHKnKT9ViuEN6TNt+W+5bISWPZ/w==
X-Received: by 2002:a7b:c74c:: with SMTP id w12mr11037760wmk.1.1580302196777;
        Wed, 29 Jan 2020 04:49:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c195sm2318471wmd.45.2020.01.29.04.49.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 04:49:56 -0800 (PST)
Message-ID: <5e317f74.1c69fb81.e3d00.ad6f@mx.google.com>
Date:   Wed, 29 Jan 2020 04:49:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.211-184-gfc5b03776f2d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 18 boots: 0 failed,
 18 passed (v4.4.211-184-gfc5b03776f2d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 18 boots: 0 failed, 18 passed (v4.4.211-184-gfc=
5b03776f2d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211-184-gfc5b03776f2d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211-184-gfc5b03776f2d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211-184-gfc5b03776f2d
Git Commit: fc5b03776f2d3b13543520d5a61a0c56ee4d1a5f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 17 unique boards, 6 SoC families, 8 builds out of 163

---
For more info write to <info@kernelci.org>
