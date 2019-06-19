Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA14C177
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfFSTZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 15:25:33 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36619 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbfFSTZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 15:25:33 -0400
Received: by mail-wr1-f46.google.com with SMTP id n4so467658wrs.3
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 12:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z4B0WS5XAFgBHm+b9OQ7enlvrHftrnmUSmQ89jOfF3k=;
        b=QYhWQNjRhTGNlHSrzPkgIdiZBDzqGQFJy7RMH/8FitPFyfGw8pd7Omy9ZxvDnEYq0a
         X4ZCzP/Q9lKzobzjR9+Nh3XQSXI0+oR9eMGcic4gdcs4pYESXX9vj5/mOpw+tuZH/Een
         ejubvK8R7kMBz+iC+fMRTcgjG6kSXNCgtDwkcO0y5fAhkjWu6rCxVgDg8JUX06c874wH
         Mz2016e1pdFREx1TVngrZNupOt03x1Mlka19EdTZ9f6xFtW1ApLU+yMLOMhNfPHrL4HY
         xSigyRZuWiwhn+T/KKe5Nl4IhHzhxWX+woIA8vmWtfrMcf5pllHGp9ej0YaOYgrxcAB6
         bzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z4B0WS5XAFgBHm+b9OQ7enlvrHftrnmUSmQ89jOfF3k=;
        b=DLxSNAU7egLtph4YzQ5au/z4UNH+xNZ1aG5+NJUGNUAW4Fkbg3qOY6/IowyvaHH8q8
         v8p5sy4sQaQPAmMTM3WTPho6goxS8ogyEDhHL7QkoNG9BFno8+8w09QIVQzUoxGAn08e
         l6GSLcZOCBj4gwxxSKSndvIQ1EJLiHmxyqDKD37seXVVtrCVMkbMGYVA30OSZb4+BZL9
         +yHR4tAKuz8UaaC5oxP63ddMIZ7MRfMY30Qv+wo7CCUe1mY10nWAn4MZj+3a0MwGpnwX
         QkJ+Ha6HamQU701LYgJN1c4Kcwf8avzTHYmNmKH9HXIODmi8XMn8qqt0ChWxHzX/ZcXK
         siTg==
X-Gm-Message-State: APjAAAWfLgjS4s/eiy2ItGd5WThS32D5W9jFFoPLnm7hcDY/XTbRJk6h
        xWTntac2SBwvrsc1Am/F9AeePpELW6mDnA==
X-Google-Smtp-Source: APXvYqyBpm2zO2zqUdLjZdwluLxWrkv3FKWtLWBNzw2fVM2Wkw+Ekpj4yZkBRQq6zDWmiVIKbSeOOQ==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr52140144wrv.327.1560972330642;
        Wed, 19 Jun 2019 12:25:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d4sm14141496wra.38.2019.06.19.12.25.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 12:25:29 -0700 (PDT)
Message-ID: <5d0a8c29.1c69fb81.c381f.043a@mx.google.com>
Date:   Wed, 19 Jun 2019 12:25:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.12
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 127 passed (v5.1.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 127 passed (v5.1.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.12/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.12
Git Commit: 5752b50477dace442b8ca238a6957918436efeeb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
