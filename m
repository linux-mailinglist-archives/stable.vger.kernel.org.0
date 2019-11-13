Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349DCFA27C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfKMCDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:03:55 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33641 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729652AbfKMCCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 21:02:33 -0500
Received: by mail-wm1-f67.google.com with SMTP id a17so3708830wmb.0
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 18:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=seKoT9eb7gQFZF5zv6pELY6qWJu6uEIZvpXW0XHGlN4=;
        b=u+G6HBZX1RtoB/qxtcbLQDLqeE+SGKxEH4jtHzMRxoQLfOSBssdD/9ccndlvoFd2mB
         yvCJAHVvH4UBYd3cue0ZCksNC6VDzI5JyfGMSDi/nitBohRVxvweL3Ol81YVuwAmjcXx
         VH4V5dakbFFlGyR11ytlTDRY7G7rjkH8NDH0cALJJ1Ijtxom+Dzqz6u6/t6EZXcEkqQr
         YhIta6LK/lUXAqrmLc+UAwyODlTAeptCBt5HfQzrUS5BjuH5ol7wLey28z9siIj9woLP
         QsGdNaoG2EioQgFqATpg/FIBfHSWHAtGbycbv4kIWsdQ4/Js4+P0rEtiC+flGX7vbRL2
         pAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=seKoT9eb7gQFZF5zv6pELY6qWJu6uEIZvpXW0XHGlN4=;
        b=oxP+JGTR9FD3LvLAxM/z0n4v1ABg6OFN+lIEg6lKe3phPa+DS7aSmb77m5QDgwM/EL
         J06mzin8THuNl5p5bjz/0QBUr6oqyemUFp5VPNNPfSXJXIMb8IebKqCqIbTBJvtua3vv
         AvRBuh0IdIeqJ4k23KmAnLs7HVJP0DbYFCCd98ja2RC3KSTwc05tLKVYKruwBdlAiG/8
         vpFh7nM68pg0UBi0kKerawJ3uFjLOM2KqJGghQLalxtHpQDcboD2O2nM33zj1wERgtWg
         3322V9Qoq06tyIeyiO9jwRooI9R1HCf6c0OyL4hC9LH75be4l295skUlcRBKZ4YdbT7E
         f8yg==
X-Gm-Message-State: APjAAAVr50U+EmPZWyLxB5QlU5+994fWqCrl9Xw7c0222KRWbZoPj1R+
        IVpiOR2v1Uz/4w4oouBWzyDifzPSSjZdWQ==
X-Google-Smtp-Source: APXvYqzXzHUK/FYt/Lvb+fwrhNnhScGJHaFaxA1VVX5bqHBUQOPxE/fAi7HKeQW0EG3BmF7zLBDoqQ==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr455840wmi.114.1573610551117;
        Tue, 12 Nov 2019 18:02:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h124sm592415wmf.30.2019.11.12.18.02.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 18:02:30 -0800 (PST)
Message-ID: <5dcb6436.1c69fb81.efd57.2447@mx.google.com>
Date:   Tue, 12 Nov 2019 18:02:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.201
Subject: stable/linux-4.4.y boot: 39 boots: 0 failed,
 38 passed with 1 conflict (v4.4.201)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 39 boots: 0 failed, 38 passed with 1 conflict (v4.=
4.201)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.201/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.201/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.201
Git Commit: 6186d66524c25c70d634206dd460bd6388e7e9f9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 10 SoC families, 8 builds out of 190

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
