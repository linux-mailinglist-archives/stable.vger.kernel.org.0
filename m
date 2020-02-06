Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3A8153F61
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgBFHtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:49:43 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36717 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbgBFHtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:49:43 -0500
Received: by mail-wm1-f50.google.com with SMTP id p17so5768366wma.1
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eB14vqDqFnE12f0UPL1T5bLOvr3uI5OzWPH0DI9AwhM=;
        b=HC2+7DK3W9w1zZxgp4UrPzAJACuZN6dNi+nCFss6C750m3e8OkuthgpQHqNfz2dIy7
         V6asMjKsQfzM1dGqU25gdLETu4oZO7Nccsnr81x+Lq8tYZ4SvNbUAWFG2kFj31VbwQXB
         TzkQx575GHNB1LxbREx86tEtl5b+XTHU9HClOMqruXXILUtL+vO8XreytwmUY7o26Irr
         1dTCnU1QiZ77h6Zjv1SJ/0qaaOLChXsKk7xunDe/9PaJqK5uPpKAkOUVw/C8+Eh2cPYK
         7nYHywh5saKm5AIHjTvINhRiE+U4BW12KUL6PHYme/uhDChodWzuWQYanV1lRulD2sxr
         cQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eB14vqDqFnE12f0UPL1T5bLOvr3uI5OzWPH0DI9AwhM=;
        b=lxez4PeXZ7ecujQAnT+TiRFFWCHABaVG/tdO8Dd0xuoj2RDz4a+MPTFv9vM7BRCnTc
         XD7npj5Lh3h9lDkQzM497GZxKdwmZeQlBRMjymzsm1jrqKsbl+sZ+wRuykthEbITh+b0
         JfLAClR13q6djpIpDjdRtcjfOkFPpMIx+lpFjg6VpueREUvKQ7tAycpQLOrhjlpAAawK
         HmykKR6agU+g2lwh1ZnCfwi6yrk05ADhVQAdH+mtQyzsyE9tvdESaQ372gCqnR/j+OFo
         oP89TDFErDTzr2Xp4fKctD5Vxh/fjWJDn3zwJGYtkOJSNP3f54KW3wEh44OUZSwzELVs
         MUcA==
X-Gm-Message-State: APjAAAUetCuW5cQUGTotuI+QH3pp7Bgtel2StWUO6yMBIQZeBHwPUGcQ
        QMoDLP/+FyAhS206D/bDN7rScvaOTCu2hg==
X-Google-Smtp-Source: APXvYqyOZWt7CczO/ucF0lm1QJZiNZYPYFki8NiwfbRnEZoT++27LQsC3Cz7HJN8eklnIfwCDo3kzw==
X-Received: by 2002:a1c:7718:: with SMTP id t24mr2802411wmi.119.1580975381422;
        Wed, 05 Feb 2020 23:49:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i4sm837577wmd.23.2020.02.05.23.49.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:49:41 -0800 (PST)
Message-ID: <5e3bc515.1c69fb81.ae813.2f20@mx.google.com>
Date:   Wed, 05 Feb 2020 23:49:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.213
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 6 boots: 0 failed, 6 passed (v4.9.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 6 boots: 0 failed, 6 passed (v4.9.213)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213
Git Commit: 0e96b1eb0ea5e4e8cdcdde6f0c68f89dc1d08be7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 6 unique boards, 5 SoC families, 2 builds out of 23

---
For more info write to <info@kernelci.org>
