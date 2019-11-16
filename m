Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E8DFECAC
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 15:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKPO2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 09:28:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45490 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfKPO2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 09:28:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so14029029wrs.12
        for <stable@vger.kernel.org>; Sat, 16 Nov 2019 06:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IJGwdqIe2h9+qI3pz3uxHEPoikqJANNz2AAJ/uwsqsk=;
        b=nkAWK+huiT61bJcvQ5XkrfZ56TN6N+EoH3MXEQxkJe2lJfMWLQ7tmKpmNYiISCydem
         amhi/OL+KdVPkmMjUHNV3a499BSUlFcLP+tFdVienDNyNP16NPb/AJZxvoCu9Kcoav4Y
         O65jdsDQbCKVaHkcKSAiZEY47rvaw+vNMlMABgZ9QvwduN4s1i+VFSjMHXjB4oAxca87
         yGzuwMWSLI9rkbUjIIApuOdaPvEtKUUTvcBQwheZE6kMqA2YtCEtXDey8elGz5+IQL1I
         e4dx0Y3Vgn2qpKl8sAibl29b+P4t1WtIARTARprcabodfb1VLYzeJD0tGg4tAfO/9mlF
         zGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IJGwdqIe2h9+qI3pz3uxHEPoikqJANNz2AAJ/uwsqsk=;
        b=gp9GvjY2EaId/rgmglTNl3KK02l87H8ViO9uR5ikyvjGg/HaXZF8GIYTL+u19yDPaW
         F8innYJTO7vpJJa4Flf9F0U1TOM3a67n0OQODllPa6L4Pme3gAw7N/mCb1Y2Jn4SLJHc
         bFrrrNeRcJgd/fN3sRLN48KDpteKnhTJfvcXw4w8rfVTC1AqskrGcQJqZ5s96cMtWkln
         8tA98gyFFEplkf6a5DPOaoKb2B8TKoT2eWV7qT57A8GMKd7GCdoVyNIpf7uTstmZetSd
         jr1rleinXOUn3fm5voAz77eCmkfsxj0/NjDd3Ybbrj9d6AWpqcQMwUnoE/6xJYd/NX/N
         7Gtw==
X-Gm-Message-State: APjAAAUI7mdVd2SQ8ry+OzN9yxi9PMKKJfqmehjoU/zFJ7qJPV5zFmAA
        RTbWvTcSt8G1kgtVsplC+/0MTw1/RMk=
X-Google-Smtp-Source: APXvYqze4wQGPJEHseF2xB6wtcPZFStY36MFjwALE0k1Lr7lwjZS6kLg+iYe9zE1MYAqmf6ojigRYA==
X-Received: by 2002:a5d:6746:: with SMTP id l6mr10749829wrw.349.1573914513815;
        Sat, 16 Nov 2019 06:28:33 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d18sm16047750wrm.85.2019.11.16.06.28.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 06:28:33 -0800 (PST)
Message-ID: <5dd00791.1c69fb81.eedd.ba2b@mx.google.com>
Date:   Sat, 16 Nov 2019 06:28:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.202
Subject: stable/linux-4.4.y boot: 45 boots: 0 failed,
 44 passed with 1 conflict (v4.4.202)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 45 boots: 0 failed, 44 passed with 1 conflict (v4.=
4.202)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.202/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.202/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.202
Git Commit: bc69c961f59512012af64efd4ff20b3cb67c99ce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 10 SoC families, 8 builds out of 190

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
