Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647A7139057
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgAMLqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:46:06 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:53149 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbgAMLqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 06:46:06 -0500
Received: by mail-wm1-f48.google.com with SMTP id p9so9307896wmc.2
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 03:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4DJPA9N34BfhTPaAGSo/23JvrhSMWKfPRVHM7siXISw=;
        b=aV+ZhMi5cuIzb3hmg4KDiwjWY4oFG5HXK+B9PtDCI8pzZitj90DgVBR+0xBLmkp3IP
         PAo9MUrZ9dwusNyHd7XKd6HkGenbFGzK7sb8rOiBxSy2DZhND3uvHfTMydkjAVp9VlNs
         ZAkv2ypt+wvgD3M3xWLeZqWLDPHAGabTGxYJ+QiudKRt4Va5yuRemD3ifh8QXjGiI/p6
         PqtwaT2IKr2E4x9ON+gGh6jR3WItB4XFQMP+bIA0TyLOSTlj9PmoBZd0zCk7XrzCw/ZT
         bTOY5JwKc/lT9qTfvxnj8rPgpfaFVb7IWThjDkrssMAKLNwyvDmyEVocNPqamsmbZ1fc
         //Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4DJPA9N34BfhTPaAGSo/23JvrhSMWKfPRVHM7siXISw=;
        b=UH4z6KeqyQVDroCodsQmiSTUIaTTKup7gIcEnqdNs2w797dNbyX2uRbp9zjjAnWUWD
         6AgkEq1Rqa4yKAshtqDBKZoVDlDTF3zgzVwxr1e60GfwzEDruqByELHOCSvrq89Y0H9b
         c8UFzRYN+ACyiT3/TfGxJgGU0ovIdnofHQdVP9+1XVqmSpt3kUlAkbo5UQE2m9haNTKS
         ApK+zV2STczakkXMcahrwPYJAb4zj42eLRDAwYjoShnokaMKVzQgwFBea5Vkn9e92QmB
         cw10MzMMjc1jba6audR6XFPglcGRuMMRxLFh17l9bTBi8rl1LZbrlHld0Iz0fbtz4Ym5
         KUog==
X-Gm-Message-State: APjAAAWZ+o8BEhtzFeqQLSeI4na/E7CGt91HLo5Ez3CglY4Dt8KXuUST
        hrntl2OvXecaZYAaGvjxpoHNDfmUrav4Eg==
X-Google-Smtp-Source: APXvYqyv5lPgCTuTDEjJ/cHgl1B1SXQUroWBNLITTCGz2k2h+A0QgkihrfPhB/nobn1MtcjfdfsDRw==
X-Received: by 2002:a05:600c:409:: with SMTP id q9mr19578552wmb.19.1578915964190;
        Mon, 13 Jan 2020 03:46:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z124sm15154998wmc.20.2020.01.13.03.46.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 03:46:03 -0800 (PST)
Message-ID: <5e1c587b.1c69fb81.a5968.da28@mx.google.com>
Date:   Mon, 13 Jan 2020 03:46:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.209
Subject: stable-rc/linux-4.9.y boot: 49 boots: 0 failed,
 48 passed with 1 untried/unknown (v4.9.209)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 49 boots: 0 failed, 48 passed with 1 untried/un=
known (v4.9.209)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.209/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.209/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.209
Git Commit: 753a4bcdbe536620ecfc66e8ba7f59389edc6304
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 27 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
