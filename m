Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66298168C38
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 04:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgBVDoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 22:44:46 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:42541 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgBVDoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 22:44:46 -0500
Received: by mail-pg1-f170.google.com with SMTP id w21so1969810pgl.9
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 19:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WVdqEezD2CxTsaf5GTaUF8XROBU2iE7KQHG88+w6WgU=;
        b=PojAnjiflO2mTs0YZg4rUl1gJesQ2b/PXikslwS3ylKiT7EfmxaFqHIUP8LiOWrPdO
         /FAMU7AscigssfUvAOjs1F4N1KvkunyXkKwQay8aWoPin1lZbAnM7p5hJHa5uS84fx0f
         Sx44YImt73olTTLiIon0AOSTTpP704bubyeZjm0Gvs+vMRJmQPxkn/zbntL0qJEoHYvv
         2SNAEpW8qPhZYVGsZ03u2KEshlMxQ+ZTRYbTZenYaV1vft0E1RHFNM8PjKQlJfMCPRso
         HYOOVS1pcRbyFARqv2Fbu/5mHGE1Zanmh/DQYzvptqDISny5nlgAUyleghp+3EU5rnzP
         khvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WVdqEezD2CxTsaf5GTaUF8XROBU2iE7KQHG88+w6WgU=;
        b=ZGVHBrtYZ1k/J5W2DkOnNlnn2+i13Sk+TAApjFVYygq8QlxmRF4tdaMS8icZDhdMP8
         5LAwyDlxmhoeq2ymcmQvUBRSbqoDJbv08UQ2ehGKMeWsJvU+3PmEmlQyFUCRg6F3CBoD
         ldUroVadga23thsNLPtx7yVCljh4Cc23tnn7Z3jx6bCbFZNGtXLFN4ctRzh5HzYoBQeZ
         yTNbE/aWg29JMJnWX6WEM6GoBgV2DIkFGH39MG1JPE2auQfeuZ//drG6whQLOZ3nJaBZ
         hknIQMT33zVbeuwKaqDKhQfLT8nME2xiEc66Jc8qIuRDSwcKga67C+zwnvu7cm2xvBMV
         epfA==
X-Gm-Message-State: APjAAAVCnYoKgwH15wh1c/vG6e2VRDeRBBqlHn1HS8zkTSt8KodxzmgK
        4mllfDM1XHUTTx0DY9bGuzjJY04hZzE=
X-Google-Smtp-Source: APXvYqyv5uUWS/+bB1LCr+MPUvUXTBbRiyxc6lHn68Anelw1zxR33zlKB5aOqgUrX4zWUp0usXwDGA==
X-Received: by 2002:a62:fb07:: with SMTP id x7mr41098151pfm.125.1582343085051;
        Fri, 21 Feb 2020 19:44:45 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 64sm4251637pfd.48.2020.02.21.19.44.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 19:44:44 -0800 (PST)
Message-ID: <5e50a3ac.1c69fb81.a5710.e1b2@mx.google.com>
Date:   Fri, 21 Feb 2020 19:44:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.214-83-g4e4aa6d2ec5e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 22 boots: 0 failed,
 22 passed (v4.4.214-83-g4e4aa6d2ec5e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 22 boots: 0 failed, 22 passed (v4.4.214-83-g4e4=
aa6d2ec5e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.214-83-g4e4aa6d2ec5e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.214-83-g4e4aa6d2ec5e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.214-83-g4e4aa6d2ec5e
Git Commit: 4e4aa6d2ec5e7bcc5b31343d7b686fca95ade2e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 17 unique boards, 8 SoC families, 5 builds out of 77

---
For more info write to <info@kernelci.org>
