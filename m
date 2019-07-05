Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F7160CD9
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 22:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGEU6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 16:58:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35513 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEU6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 16:58:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so2491141wrm.2
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 13:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qBcKthUThCvcOq+svfWF6YWcxj9MOhwycEHJlhCVquk=;
        b=xcz4cqE9l4GRhpyxiddFgZ5XjJ1Vs/20j8oKzycXtqtaWKi+6ZTVWGpBzqIWxY3RpN
         zRFjjsojcFkDEsvTIhOB9AyPbpqVGsCidUvGY2YKVlsD//vC/8I5jQ3mWnq2tJYEvLox
         Zch1zQrku7/qC2ODyjNye2wxe6qPX34YIEaxZdWOZ75MpAGW0sVO8317xaUR3FH9j3Fv
         hwfzItbOOZwfbFIOf/f4FiEUtoPsn3l8e6/VWC7CiyBKOeovV6S7GjAO2DQ/salLun9u
         rne0GPQOGTwCZN7CAuNttCI2sL3m1FOc1L/47qGq4FCofLjGZ7KyDuVG+6XdbOA59eSZ
         S/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qBcKthUThCvcOq+svfWF6YWcxj9MOhwycEHJlhCVquk=;
        b=r37aYlLrioA7SUV8nWpqlXgYrzN4TbSCGSjCfvD+Xt6CuGypSBI8Z1jrUeC48v7hBB
         Abhz61cig5pdBWVLbAjYpActH+mgRgtaEE7ix7/bafswawGkKN3tWnRl9GidcEwnxTpB
         JTpSkKObwPsyCZK1kZqRH5RlCglfxEuEE8ZEbHAMWawzTAGa91gMeew2jaOowSHActWV
         xXXtk9TdfATCGlOFsdT7EnrscbaOizNapDjJHhYS6NYxdHAjs9iLO62V6eSIwwIDCec/
         vJbkM0fFzdHBeypOe1leBDKtS0ZnHsNmNktbmtEThNsm1qRaonb9icpb0LOTNT3bmZCG
         es2Q==
X-Gm-Message-State: APjAAAVhwtn9A1IGPqiPtkrWbExMkH6iVVcge/kguq/nj1HYjypBAllP
        fE47lxoKDRpGARLRXiYIGte3bw1j2xIHoQ==
X-Google-Smtp-Source: APXvYqxwHqkYdiUdfgCABI53mll0/vnl8Z/r1pveFCewzlqYxti3hxkd2SuK8mXKSNoAPZnE8jE9PQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr5262058wru.280.1562360325918;
        Fri, 05 Jul 2019 13:58:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g17sm7073691wrm.7.2019.07.05.13.58.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 13:58:45 -0700 (PDT)
Message-ID: <5d1fba05.1c69fb81.fafd3.77e3@mx.google.com>
Date:   Fri, 05 Jul 2019 13:58:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132-50-g32eb3a77d8ba
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 130 boots: 4 failed,
 124 passed with 1 offline, 1 untried/unknown (v4.14.132-50-g32eb3a77d8ba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 4 failed, 124 passed with 1 offline=
, 1 untried/unknown (v4.14.132-50-g32eb3a77d8ba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.132-50-g32eb3a77d8ba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.132-50-g32eb3a77d8ba/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.132-50-g32eb3a77d8ba
Git Commit: 32eb3a77d8ba50ec9e0798845a3020922840c8ed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
