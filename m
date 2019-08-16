Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EE090399
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 16:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfHPODM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 10:03:12 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53019 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfHPODL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 10:03:11 -0400
Received: by mail-wm1-f46.google.com with SMTP id o4so4143241wmh.2
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 07:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VNMwAgdMtJ6w6oiFObC0qLTnJj9e0/0b9YGN+1o+asI=;
        b=bjNxmYsu8WBflzMl66kMBMO5QfQnOfFGxTakSOf/I0XtOyUDQegLX/uzOahkfXzbMR
         pi6FrHElfpFfmV2yWhpkuBbSbT7ruNX/CtKBAqNdUdR5G9acW1/qVzZbucCDRYUPIxJx
         R2rHuSdF1QcruxC+YIe6iWTDpGHs9HpixGdVcrPAKj6kTj6T3Wp6p2GJmyC9MBgvjuoJ
         MdSalbgiuCjwxUgxWyJPBGTVfqdPJddteADDmcRlwrilQPDKKK0a9RW+qytpLlg3YW9r
         1zhEZctoQqhDFfV8gRyqMwehkEbFkrLs1wLLyfuE5ULtQExYgwl1FuuhC/sVMR21i1iY
         DHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VNMwAgdMtJ6w6oiFObC0qLTnJj9e0/0b9YGN+1o+asI=;
        b=lMB80s5tbJM5x+yvRtgpHb974jDcBD6gNB9kMThHWv0l0GBimwIfnwzeGcwifGrscx
         3vsPtqZyRPGO/hZZXbqDChV25tCksL86wPV3WL8vxz8qw2xALVGyMbWX7Y1NPOFLJnJE
         7HFK8/0rrKx5l2I8lFxcznqqk3sGtyRtWcdGbTi5KJCHxQEEb/yQ8zjrdSDuPQ5433Ap
         4kABoAqIn2lHKDYkbH9X/af+nsjY4ycmjYzuBlicGZ+a9tHiHdGrzZQTHkrfOwxSAleT
         sQW5o9FdLHYevivNpzt3CC9jVfUqA7Y6WHz68ziV5i+Txw2WQwfrMmTipJ9BEzXBoQVZ
         GvtQ==
X-Gm-Message-State: APjAAAXv/n8G1pJh49XvnwdzBi4dOdfimfLa+NTky77ibm3/FrOl+YLk
        lSA/Yo85ugPI8SwgowRg/fSB5TstMbk=
X-Google-Smtp-Source: APXvYqzy/UxBmVrNU7iMn7LJiiLA5es3Lm/l5E1k8Lp98SSKWaTwKraGBHENgHBM8f75wCdrTa7ggQ==
X-Received: by 2002:a1c:d10b:: with SMTP id i11mr8028560wmg.78.1565964189193;
        Fri, 16 Aug 2019 07:03:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o14sm8616163wrg.64.2019.08.16.07.03.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:03:08 -0700 (PDT)
Message-ID: <5d56b79c.1c69fb81.a5987.b15f@mx.google.com>
Date:   Fri, 16 Aug 2019 07:03:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 74 boots: 0 failed, 74 passed (v4.19.67)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 74 boots: 0 failed, 74 passed (v4.19.67)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.67/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.67/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.67
Git Commit: a5aa80588fcd5520ece36121c41b7d8e72245e33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 18 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
