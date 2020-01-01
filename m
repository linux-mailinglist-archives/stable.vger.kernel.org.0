Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD512E08C
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 22:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAAVcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 16:32:01 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:38855 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAAVcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 16:32:01 -0500
Received: by mail-wm1-f42.google.com with SMTP id u2so4214398wmc.3
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 13:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gB2HDuU6OLDGKAUExmmL59WdgvHVFml8pBY7OuvUGp8=;
        b=b+hWgL0NSIFqZP/couDKd8trCy7a/WPyJSsn/PPmqbGnOICWPjzUDcMXntWNah/wrU
         Kv8ivKV09z5kn7YNoqVVEhWG4sxoDUdFnVIJp54lsvvhwLiJEVQTEkEWOf8OZ0TuG4EX
         nUBKZ+L5cHy7pxmQftUBIG/tTD45dZu4oXJfUxjdpiA9FTfcBmlQ6OIr/E8y9ChQ7ubY
         6VJ5kqpzI6gIKMCxA5dhd7Z/AU/dDVw6x8Kgalc2uWYdPJotgFkGZQ7iukRk5AjUZTIP
         8D8EZj3h8ZDBJvbNDTkPjphs2HAYS8ebQnax7bA+WpyzI1lytPPcmofvaKnAUwPwbhzC
         ubqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gB2HDuU6OLDGKAUExmmL59WdgvHVFml8pBY7OuvUGp8=;
        b=IqJlxOYf0tBoDZNxgGeo45vdzvcKNQvy900rp+CdS4nLNtMD3TeGOiCUJC5enzc8xO
         EFpr4e2zfJrv0McTzhxUbZh6ewtqgrDPJdqcChV/sjirVlYOtFV2i3vko9MUx/xWj/uo
         a17CFI5nke8M++FxerD34N0xpkA/iM2piRHbpKNHdWNA/UR3utNyS4QGhEUiptfq1N2Q
         +HJeg6/2XUjA4ldqeHY9D0QMLehIAK/ZLc/Eb+zLoWvukcigvV0B41yXIQP/0vepeaZC
         J+PT6eZqxmM5OpJZX7jFv6+fLwqCdx8BYQtE3GGrf5/4o4W0poL/gLzY8qeIGp8GbMc+
         peUQ==
X-Gm-Message-State: APjAAAUoCxVp8j4BOW1pmQCVR3xAv/fDwG1zhp+dy+WUpcCqobJLZ+Xa
        NgF79jAz9+kwHzvVvgkCISAGe+5Z64gMRw==
X-Google-Smtp-Source: APXvYqyDZDFeUscUURV4afka5YHctH2CiJabeHahCYisjcVPofTBa+gC7htOp6lZ9dvSA4g2pq8jtw==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr11249233wma.134.1577914319572;
        Wed, 01 Jan 2020 13:31:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm6307362wmk.34.2020.01.01.13.31.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 13:31:59 -0800 (PST)
Message-ID: <5e0d0fcf.1c69fb81.b22e5.cdb6@mx.google.com>
Date:   Wed, 01 Jan 2020 13:31:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-55-g882d99a48d68
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 34 boots: 1 failed,
 33 passed (v4.14.161-55-g882d99a48d68)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 34 boots: 1 failed, 33 passed (v4.14.161-55-g8=
82d99a48d68)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-55-g882d99a48d68/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-55-g882d99a48d68/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-55-g882d99a48d68
Git Commit: 882d99a48d682301638e8d97fe759161f22f5915
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
