Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763E311493B
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfLEW1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:27:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35967 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfLEW1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:27:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so5633291wru.3
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 14:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hDcK3df9L180/ZqUlZg8Gf7qSSwKRsFNy1W+OBSjsTo=;
        b=YvguBbInMRX0/Oy+BkjTk8Vuc6yclGNKB9KFeep0Q7eYAgZA9GDTOEKFCyj0FA/Hi+
         ByyCRBB5ltlHoe1CRMj26ff33NZzM0IN7dPDctwPVyrTsZbNiHEXwAF7Dof+hpf+Lene
         HztIc5gYVK0PsLPpcrZSz4TxmJr5ehebP9SEtDVAL5K+gWgfhJ6wrTBGnlJu4KPHuDOD
         ZMc7HnWn7oG4EMMfRDdPqE2yE2AKGh/F1KyHK2VtPFCzUPtY6tVUqD9McjPJS1BM8tXV
         0C5EWRf3qjjshMiB6eKES/37LNa3/ok0f1sum4jWJEKc2zacsyC24YGpN9LGfgXoTTIO
         G2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hDcK3df9L180/ZqUlZg8Gf7qSSwKRsFNy1W+OBSjsTo=;
        b=WsH4ZR9fQJ7nnCJpk6fFIBX7ctR5ePwhZTanPJfzty8iYoEXyzMTDPe/Rzn6zCT8B1
         UaZltUJrWsmmoXweXgOLLBXTvywaIvy/TLQHKtNXwBUKkyTT51Dw4Eq97PjDGWYRpYuy
         9XhXGOKawwQ7b5HE2wTTBD931VEk0wFHUu4F4SYtOpQslK2YOLop5nGcTGx2ryZmPycJ
         MC9FQ0dyhMM7fsMAqOJ/yFwUxEz13cEoaoGmFTJzqkzh71efM+GNm+TMDAv/DRPBPzmC
         UgGSvWzB0LApeA87RfmNPvWnVqzxPnLlWgE3UcILjL2FIFhCVZqrDZL24k4AdJsOE8l9
         SchA==
X-Gm-Message-State: APjAAAXH+2pQqsFsrky+u88NNeyKVmIwafx/U2KZEB8or5TzXes3Tewx
        zCLfpm8pXNjrSpYmk+sRm9KH0PvDjWkFww==
X-Google-Smtp-Source: APXvYqzom/umgXI3yv67zL6ADkME9Z1hpbri7lwa1c1lDEknNkeVSOeLRoHZ+FznEdGUHCMqnCyM5Q==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr12178072wrs.303.1575584870104;
        Thu, 05 Dec 2019 14:27:50 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g21sm16109871wrb.48.2019.12.05.14.27.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 14:27:49 -0800 (PST)
Message-ID: <5de98465.1c69fb81.4ac1f.3f2b@mx.google.com>
Date:   Thu, 05 Dec 2019 14:27:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 70 boots: 0 failed,
 69 passed with 1 untried/unknown (v4.14.158)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 70 boots: 0 failed, 69 passed with 1 untried/unkn=
own (v4.14.158)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.158/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.158/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.158
Git Commit: a844dc4c544291470aa69edbe2434b040794e269
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 14 SoC families, 12 builds out of 201

---
For more info write to <info@kernelci.org>
