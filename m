Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF9B9D7D
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 12:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407524AbfIUK7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 06:59:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40030 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407520AbfIUK7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 06:59:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so4553293wmj.5
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 03:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xDSEWlaWlNQ2Twu1OgnNMK4lCX61IrXFLTewDwGvpPM=;
        b=n6i049t31LEwgGtK3D5akCKmLgs6gSEJgK7VW3mrcWJyY+mooz4yX/BpiKoU5XjXCS
         TQWOTYg56C3LPiR5F8e7/yMJg7sPMKluowlnV/eJR1Iny5uQ+AGtG1r1GDHjGxD9NTLI
         gS4RfkBphpSi/fVbi6WZaXzahtalCQKo3gkIK5CgJFTntojnFYIWStVZeSoqcoJgwNZe
         jKsTiws+gaaIMRRFAjdXcrEe0YsZ3f6CwqaPpFtwbC4ybGjhUvmxqUMWEej/1sn/wYrE
         HBvvU0R+CY88J13TbkARwfv+EHn+i8CHONJ/EOxvpnqOK7Nai0jispqUKsJpklPIeNBG
         bjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xDSEWlaWlNQ2Twu1OgnNMK4lCX61IrXFLTewDwGvpPM=;
        b=FGXzhNuiI2nCzRCI/dT3LLeTSfwO++7tKH0OPBBCAlXj3rSmR/HGa6sYfIybkL9Dqw
         QstRoaoIhM6UaCvFmqAmJfX22F2n4kcD8v0RRlFSGO6B8gOTTarSF/SEzYau4fye5JDR
         3taAWCypNzGJ3dAcnCVRZeE96I1Dh+OiUW9tvHPs8ZqpVtebMwLOcZzV6cgnemDUyhXe
         jUOZNcofFJCl7kKax3K1Vz30u4bBG0o1VwelbjbHdO0P900+3QjfLkUQgc8nRD516jSp
         4sy+xtoGlqeYGZNrUqYbEMXJm68GZMZtVfItvNldL8TlILd8pY5ZTNqcH0ioNjqThOri
         6DFQ==
X-Gm-Message-State: APjAAAVhwbdK+f43UywxvfetuTLnaxzyX1M2biMnIcjLIoyLWX0ix4mA
        xUjayPIDKWRPXAqYLN/uPtswO4TIj8k3OA==
X-Google-Smtp-Source: APXvYqyj8PVYCT6o/NaY594ZANVaG75o8AfL7362uZSgaG2HoSE5DcT5aifeQmcDRsW6eXyTnE+e5A==
X-Received: by 2002:a1c:6143:: with SMTP id v64mr6833384wmb.79.1569063575464;
        Sat, 21 Sep 2019 03:59:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm6382648wrf.62.2019.09.21.03.59.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 03:59:34 -0700 (PDT)
Message-ID: <5d860296.1c69fb81.efd9.2331@mx.google.com>
Date:   Sat, 21 Sep 2019 03:59:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.194
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 64 boots: 0 failed, 64 passed (v4.9.194)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 64 boots: 0 failed, 64 passed (v4.9.194)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.194/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.194/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.194
Git Commit: 1b2be6d75ad971d27decf2a97f5544c35aeb9f2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 14 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
