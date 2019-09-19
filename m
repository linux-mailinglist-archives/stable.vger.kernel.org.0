Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6756CB7984
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbfISMdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:33:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33446 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbfISMdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:33:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id b9so2962025wrs.0
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 05:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1apuBGMd6DNRUzFMWA+UITXwocV+IQkynhVUUhiZt4I=;
        b=l6sIUsrcsq7o/+Lc9fp5fotswc0i5CnpZG2TZ3geYTNrbNRrRwNnA9DJHyZpy+3k8R
         CyOka6VerEPeEZGeMOfKWIinPzoEcnawPQTA5UiwfjGrLLjpvxCWWWXFjNgDRulKt2Gx
         vCYgf7GgNixAOK6SqxPzeKkj3Re3/7St+N4cIYSfvIFe/ulo9m4JEv+pVuzaRCju3NR4
         4LcIMaWS2WmDTfUl7I5CFzo+Vfw1QJodS7Rnoh1bIovlt+GaYl4DYKFGt2F3ZDsHEYym
         FXHI2NwjAKG54i8A4sgdRqHzMVVhkouZ4jmjrqWld7uOkZg0anJa5mK3hh9XBxKW7nJc
         H/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1apuBGMd6DNRUzFMWA+UITXwocV+IQkynhVUUhiZt4I=;
        b=kPT+0pYaDq4qeD8pbKGKUgr4fKOIIxu0chUOaccTImoQG8tieL5YdsqzMUZYLOkXu2
         7VIkh2orUo+Os9rChrKDEJTmcv8218X0DRnOTXqk96U1Y1jjiDV5Z7ANDp3jX2Jp3x1U
         pPjbjsvdFGqBgOwdGuRvYwEeI74e7+OgjojcjNzdf9N/gSaZkI/q3SvSpxYRuHek2zZU
         UWFCgrTGNGRVWo6P6eioRA6/KRt32hG1nPmAvtgQYTiLL2am4CD5IuL73Be77Zw43EVZ
         sqGoEyUetk/dR1jm8smaG+U0CwUYCNYNMhcsv2bb7QIp1kPHK06sT/wANwt5ImKdHedD
         qoFA==
X-Gm-Message-State: APjAAAWUsURJnrAG3t8eieTdvowV1uhtml08EXxtRFX+dPyANsS9Z1Uc
        mIaYj131cknISFA3IXDOsUsx+M0tgxxFDA==
X-Google-Smtp-Source: APXvYqx4F9ulcg905+Wu8zK8W0+3b5GHWkkF+UihXlIJzmE4SqV6HU0SEntkaSsP6M5RZodTM41c3w==
X-Received: by 2002:a5d:5185:: with SMTP id k5mr6309795wrv.341.1568896418800;
        Thu, 19 Sep 2019 05:33:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s1sm12965990wrg.80.2019.09.19.05.33.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:33:37 -0700 (PDT)
Message-ID: <5d8375a1.1c69fb81.a1144.dbba@mx.google.com>
Date:   Thu, 19 Sep 2019 05:33:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.74
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 85 boots: 0 failed, 85 passed (v4.19.74)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 85 boots: 0 failed, 85 passed (v4.19.74)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.74/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.74/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.74
Git Commit: dbc29aff8d04f134553326a0c533a442a1774041
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 18 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
