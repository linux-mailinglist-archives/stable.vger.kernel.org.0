Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4660DF82DC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKKW06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 17:26:58 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:33251 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfKKW06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 17:26:58 -0500
Received: by mail-wr1-f49.google.com with SMTP id w9so9581822wrr.0
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 14:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=isPaAaMoxfK8ANQkrDeI65OvcTSObXjccd/rJyjoBTw=;
        b=Uw1Ba3MB1Ltqij0WSxNHopdqYwHidRCEXtuVR/rfq3JCsU+RPoDnOp8JUwixdO3ctV
         MHDTC3YHjfAoankW+xayTvalENyZXV/WDEnK40md1EQM6bezkn+G5rb1FKoy1Q7XH3Cz
         5Avypdv9GlxtedJfd5gydJLcfPpzTda0D9NPzMAtFUglAaKIVTPIjfA76a7/fLFEzqf7
         tUhpWSPqtlNY/1HJ+9Ww7m7rr05/3ChoQWK2nhzALzcAW0Lwp31QcH3vsJVy0oXi4ORR
         ajDN/l5kX5iaWLO+HDKp4BS6sW9f/+WnCzVo6mQeWjzy/wEEgsN4Zx/pPuNoesdL9mUX
         oBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=isPaAaMoxfK8ANQkrDeI65OvcTSObXjccd/rJyjoBTw=;
        b=HRW/0xpzamIuEFv0h+f3xY7avMgePMOWYhMPi4BIca3LhS2z/8SiqSGQM7kkZutTTN
         hmVlc+PXCJcWBzye+RQDQ7nwdTdJVlL2rDLAH5GVpo4l5cXY/deuNSXw98JCQvW1evKM
         5DYxCB+MGgHtt4abY/TzGThNYl8dmIIa29oL1mMgmRsANylKhRjUAWMueN6tehefZ9S8
         YumPUWWUnUlscOiOvkgqxrEC65TGgrKlQ3tVm5Ik69T4DWI+q7zQCaZ7ks6JuA5glCf0
         a/qGidlig2e36rlYASv9axLH4YQKQvJxjGMkGK+DaMPYfIDJs3VtWbcMAmlNSGi0WIwV
         poRw==
X-Gm-Message-State: APjAAAW3iLqX6DlQnBxkGUFZX41WLPEjKNeNsW0hCIC/+cOlBKazNw0B
        LsbGUIhXo4jWUVJtjPZCg3xy13l8CGuGHw==
X-Google-Smtp-Source: APXvYqxR+2QnWs2mh6b1eL14uoHgXsH9kXbVuG8nhM2Wp3Dh1dYjisINZfbUJjfdAEVDwm66MWbWGQ==
X-Received: by 2002:a5d:4991:: with SMTP id r17mr8326097wrq.176.1573511215803;
        Mon, 11 Nov 2019 14:26:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t1sm23562677wrn.81.2019.11.11.14.26.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 14:26:54 -0800 (PST)
Message-ID: <5dc9e02e.1c69fb81.bdbf2.0e41@mx.google.com>
Date:   Mon, 11 Nov 2019 14:26:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10-192-g3d4242f0ef80
Subject: stable-rc/linux-5.3.y boot: 73 boots: 0 failed,
 73 passed (v5.3.10-192-g3d4242f0ef80)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 73 boots: 0 failed, 73 passed (v5.3.10-192-g3d4=
242f0ef80)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.10-192-g3d4242f0ef80/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.10-192-g3d4242f0ef80/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.10-192-g3d4242f0ef80
Git Commit: 3d4242f0ef80fb4ee50fc92188e71bce32af1a8e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 14 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
