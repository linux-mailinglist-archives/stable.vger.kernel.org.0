Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD0825B4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfHEToJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:44:09 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:34147 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEToJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:44:09 -0400
Received: by mail-wm1-f46.google.com with SMTP id w9so7351422wmd.1
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ragMUxHzFNHoNx7VnjUhTaXx0XipeAkulRW4PIdr0bA=;
        b=QutabvlN2uP6JwReSOGM5HlShUWNj+kQbRVygL42t8lVYJWGXZo/BcqW7fBb5l7/rW
         Soc626Ysk/46/9WMbiqwfs1UNKlKD40CV5NN5DFSJeMQxWq/e8vwjVbqKzxNJA7oTA6x
         wXHH3o9+XnT1d92J6nXOE6X/5cmNXGEUkjoop0wwFWo3qYJsYk1aQeebNJwe4n26z6gC
         +Ir25tSMKUXtbSeWVdq0rQtd0hwzL3qhIFFQlI6zeV+vfjpP5EOhbn+mVWKxG14dP4NX
         UhPCFjk1n9t4EcTGisz2UmJdJ9yY4Lz26m4V0sGtyG5RrISmZ9dbngbxs2nWrkioXiJQ
         hzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ragMUxHzFNHoNx7VnjUhTaXx0XipeAkulRW4PIdr0bA=;
        b=nEmxGeAd/kOLvGKBeUV+d1Vvo74DKJUI9ygKf9jNppVZnMbuWvtjSoL6PUsE7zbdUL
         MQGVxdWHb+1ZD6QtiMV6a2cSUb0C562rCIDTUkx39CH301/e2a87pP0CYJMSP9xCfN+o
         esDlFPm9z5y8CXMJNMePoQSNaLp7P0iYmXIocClPyIjN3SU5MX6LU/XbFGr15Qsnovgc
         9iyLi2yX7oOQIUwihQh+jZk6hMtIlRYrSGnfG5e77UF7M+6L0pXx6pXPe6jAey/oRuLv
         bXST93cvaFo5rblJExP8c2mY7Td9aRn5mfbwXC9K5mOFGgHD10VTZlzZDwDnMxvRYM8p
         4Z2A==
X-Gm-Message-State: APjAAAW/ZodKCg/qb4PHTwad2RZmUYX+WKFyGiRV/hQlDAEX97/u21yW
        wTFvs5QglwU2T9HzQg6tCnVt/C2cGi/+dw==
X-Google-Smtp-Source: APXvYqzaOZAsrA5r5/1gN0bBseQ/pb+LHbKk6+o3HsjRHcs3nzbZFvrgeFc98n60LSrhAvntDpc4Nw==
X-Received: by 2002:a7b:c104:: with SMTP id w4mr51926wmi.42.1565034246874;
        Mon, 05 Aug 2019 12:44:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p63sm36866799wmp.45.2019.08.05.12.44.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:44:06 -0700 (PDT)
Message-ID: <5d488706.1c69fb81.1ee75.cf4b@mx.google.com>
Date:   Mon, 05 Aug 2019 12:44:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.187-43-g228fba508ff1
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 101 boots: 0 failed,
 100 passed with 1 offline (v4.9.187-43-g228fba508ff1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 0 failed, 100 passed with 1 offline =
(v4.9.187-43-g228fba508ff1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.187-43-g228fba508ff1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.187-43-g228fba508ff1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.187-43-g228fba508ff1
Git Commit: 228fba508ff1bf754e9bc4b3e72a327620ffacf2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
