Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF13330BF
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 15:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfFCNPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 09:15:39 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:38861 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbfFCNPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 09:15:39 -0400
Received: by mail-wm1-f41.google.com with SMTP id t5so11050880wmh.3
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 06:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qX5GjP07fdRDS4KbikdzdPkb1+NJWrdAODNcsJitWPg=;
        b=rA1V4cQsA17HLbjJeT7bZz67apGxIN1sIogJLpckYmRNSWB3tNIQkPE9KrY2/5xG78
         AqbGdwE/r4WYLe0ck0WAp1cYXS40Xg/To8ostqT3mAD0DjNywVGCJt46aqs+obFuiEa0
         wcupTMKBnOC7jr7lFae+DLz2BzXV1lVWfuDxA7rFS7f7UM7l6VUlfjCX/fv+aaJjypLc
         O9a9KJ/lk/qQAsoXV2TxHVKCmiy+OSLpzaT3S9LxkfusRa3TZbIGgYmi/k5HjW0bbSF/
         A6qGVCTbK0OA3yztvZZ1v7TgwmJ2xlaGlEdZF/SVEzaR0EssIc2s6Pfapk5hGgaq5EMx
         m12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qX5GjP07fdRDS4KbikdzdPkb1+NJWrdAODNcsJitWPg=;
        b=bAkV9o/VvEcPqG9lBjeHOi9nhnQX9WNMPhSEwE0rjrrC4HCLDVJUXCTZULrEs58gFL
         BeP2+Ug5VVgrbqD8qAetn03uWjeUyVb3VhO+/lOWydgTmk9NPzvdzpe1CE0RW2GODrn8
         rmnSL/eMHivb+M26m3k8dUjvSGb6A36C0h3aqVvqzHSlN00wZNBnopniR+wgKKJwD2Bx
         eXDVEY2JLvdSb6ZF85ID1VqgIPKylxz3JIEimOjtDemopLQ0AD63q2F/VUcFEvc08aHa
         lFtE38K8rSqIt9poHlHaw7wrv06QLXG3S7nMolK0C5o4fyp6yEDddmibm5ABYeCCfWPJ
         E8hw==
X-Gm-Message-State: APjAAAU3bOSTLmIgtRxhVkDe6nF46dIyeTldR3KO5fWotxViD5OlhQMU
        zpw0llAg7ucB6oKRSCyH5WIAKr1d12k=
X-Google-Smtp-Source: APXvYqybbHUBJZKEngQh8CLnCb+Q6hy3MJ29C63tgwbQde53zNy+I4OvPkDdcfddRvDMxQNkmT3MYw==
X-Received: by 2002:a1c:2907:: with SMTP id p7mr14200600wmp.100.1559567736948;
        Mon, 03 Jun 2019 06:15:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d2sm11118438wmb.9.2019.06.03.06.15.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 06:15:36 -0700 (PDT)
Message-ID: <5cf51d78.1c69fb81.f8ab.931c@mx.google.com>
Date:   Mon, 03 Jun 2019 06:15:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.47-31-ge70b94fa650f
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 126 boots: 0 failed,
 126 passed (v4.19.47-31-ge70b94fa650f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 126 passed (v4.19.47-31-g=
e70b94fa650f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.47-31-ge70b94fa650f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.47-31-ge70b94fa650f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.47-31-ge70b94fa650f
Git Commit: e70b94fa650fb695da2d68dfa649ee7f0036c153
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
