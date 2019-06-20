Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3D4DDD9
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 01:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfFTXpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 19:45:45 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37981 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFTXpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 19:45:44 -0400
Received: by mail-wm1-f54.google.com with SMTP id s15so4742924wmj.3
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 16:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S7uZln84bCxKpVx963+oHUwr718plp1Ch28m6QS5bdM=;
        b=fb7nsJb6d4FvC7qdzYaRAP+/3sQe6TGONK2EsW4i9K/L2vwsG4sxUDgUxJtwgrJl3Z
         8EgJLSXJCruktT+p3+QL8FBnot/lw23LNARypilagObqNGgrsztiPX75s3ypFxlYZMs3
         HVaWPEFyVCs//7oRvd6K+JBOx2GvfHBjKaUj5MfeEL5sMK7spqCZ37HzGODME4yc3s+K
         je0pcMlMN/xGF9UsQSn7U85tWVkcITRagOpLTZkekzq+ruUoOLnC1elot9IHuqp+0Qdg
         wc+JFh3sXHn1pSe2JystxltW3e+976vO1IMaxmefjar4ikjObG4RUaM3Dnf96f68DQUB
         ueiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S7uZln84bCxKpVx963+oHUwr718plp1Ch28m6QS5bdM=;
        b=FY2i4xyEsR4ZDnUSLf5Gkl0dCZSQ5foj67i9Wk3PiCGGR/VFS6vVu13OxwXK6bOanT
         MJN4V7aIB4TIS8nrR4yQpi1/2FO5kanL5gj9IvLWsbh3OoTyq2aS88wxjA43RyHFkCTo
         sSsdPU+p1KcXgEKcfgsL1jz0hlID1v37IQivlryina+pkKttuQDn382DIbQLl9WxiLF1
         4DkafVOpSLsQANcTsgiRAMMqPREmSE3Qf7t02LgHP30s3UgSsVZBLWxbQXB5ccikW9Rq
         kVE7zDVAG9DJCw2ifL2z0o0PB8e8YphpTNp2mM4FUK5oh3ofTnKSVBn6GH+JHujXftVR
         Ejqg==
X-Gm-Message-State: APjAAAVQdIKg/W4TcX9llyN+aDTW8e9nUC6wAMmZTn+ODfiAYVJIDcPf
        /UjjAFlg/F+sZW3jNi5S3fUTMuW6/Opisg==
X-Google-Smtp-Source: APXvYqxbE3V7OqvYlFQ0NjZEzjuAinT50nUSxqsTwbw0+DnX4X5WOI1H/s6BQYyD90Xgre04PBnv5A==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr1281924wma.78.1561074342576;
        Thu, 20 Jun 2019 16:45:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm886790wmd.38.2019.06.20.16.45.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 16:45:42 -0700 (PDT)
Message-ID: <5d0c1aa6.1c69fb81.68052.54d4@mx.google.com>
Date:   Thu, 20 Jun 2019 16:45:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.128-46-g7741fd984e5d
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 63 boots: 0 failed,
 63 passed (v4.14.128-46-g7741fd984e5d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 63 boots: 0 failed, 63 passed (v4.14.128-46-g7=
741fd984e5d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.128-46-g7741fd984e5d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.128-46-g7741fd984e5d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.128-46-g7741fd984e5d
Git Commit: 7741fd984e5da7edc8b42719cac2db8d8f56b9a3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
