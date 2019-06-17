Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F324961C
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFQXxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:53:49 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:54436 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFQXxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 19:53:49 -0400
Received: by mail-wm1-f51.google.com with SMTP id g135so1195775wme.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uNNEYOM6VER4jqPw7i2ybx+uiCIPikrcJaNOMjBYPDo=;
        b=LyMhh6XrJyV0QipOD9JRu87+E+gWFoGB5hHt/nOiy9u1F7NORw6DzUuk8VDZnQAGTt
         cfiv4Dz9U8iRGokriom3O+V8SeraZl3t5iDgjRpjsKQujcYVYkSjgXnMrtBiOOw3Qhu6
         zYJbRI25BIGCfzHl4s2b5HDGTKfKkQSuzad/egWQ3uUcVU/U+jHLZPBzN+5BgEo87OOq
         38egh9IyLArJR9TmRrfDGEcbo6kEJoUi+vZ3kLVEFH3u2LN6nBSFEO54oaCUolWwa3xU
         yY8TIxcazRcPPRVaDGWTDetAHQlwydTEmewDn4/u6BXWrrEqUI7FsBPPsccqSMZSkc6d
         /gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uNNEYOM6VER4jqPw7i2ybx+uiCIPikrcJaNOMjBYPDo=;
        b=JIifu9tFvgOtanj6Srmtw0hX6ufGsAFR4pVbQUY45KtIcs2lWjl+msK8Oy9FyEX4Ln
         CZqyDbHmO3JUbJXetN2+4UyMGaM2k60sQYRfWPyOoBLBZ9lHx/PvKI3ZznjBcMW/evVp
         YLvRURJ8Arc1gcNGEcBMJQq0gcT85SjI9wYz+I6a8DPcu+KwuxCTcrZxb9v3vzQvA8W8
         oKLp3epezqK3n6YqiTGb7soNVpPGAocjyuS0f9VF+sMheycQv/KMf5uI3w9EQAscGtNc
         g6ezA88HUsXNy0LTzeKXQcQc0zOBE7Seccvn4/6JmEp8G4Sd05s48oW8zBDRq0Ogv2xm
         kmEg==
X-Gm-Message-State: APjAAAXYwBhBH4DwSg1S4HlYDK6nohskgrlwS5OypwDBoHul2eQIbWAP
        iPjlAlOlpvv5um8kUE7hLkZCRl66bL7XvQ==
X-Google-Smtp-Source: APXvYqypI51vYzXQ0KjOk0/gfaWuN9CV+VXZTO2G9JhARqbiHuwy0hf87uMtb47toRPlTthN36sCzg==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr737124wmj.41.1560815627459;
        Mon, 17 Jun 2019 16:53:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o126sm1119366wmo.1.2019.06.17.16.53.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:53:46 -0700 (PDT)
Message-ID: <5d08280a.1c69fb81.92386.685d@mx.google.com>
Date:   Mon, 17 Jun 2019 16:53:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 36 boots: 0 failed, 36 passed (v4.9.182)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 36 boots: 0 failed, 36 passed (v4.9.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.182/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.182/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.182
Git Commit: f4e2dd989e87a5982ae52bf5dc150287da8d729b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 17 unique boards, 13 SoC families, 8 builds out of 197

---
For more info write to <info@kernelci.org>
