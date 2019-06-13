Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9189B44192
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfFMQP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:15:26 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35382 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391691AbfFMQP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 12:15:26 -0400
Received: by mail-wm1-f47.google.com with SMTP id c6so10768418wml.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 09:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ljewllLs7dlNeTZuXDkZ3SLU4vjUhxo4/P0HciVdGik=;
        b=QyD4hbbEBEPbb0iXIrgtPJvMdzEmedbzBHyC/pYdzRuDM8ugSnmQ7725VLIubhiZkB
         PX6gbGNMbt8LQlZLg2cqfBnY/7qfbeAhxpyu+/PtDSCTjWsHTvcbPSk+O7is5tRs31UZ
         qjzxqycJzlvNubMTv4jwV+qLePuRePP/e348sft7pUqJ59PJktU5SxvhTMxIROknB9La
         vq/Fz1Q+STb6GM3t/dVakgrOpWqG3eJZD/8EzLiiLUZ3V7WwuoEMjEcZKhw4I/INFYYe
         SuQdztgEhtvXqgOsdXXvBrn/yS7zalnPkFy59hdVFuVFwvECtOMEsbOmT4PkPZif8Dym
         krfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ljewllLs7dlNeTZuXDkZ3SLU4vjUhxo4/P0HciVdGik=;
        b=DDeKvYrtb5PJ9Uux9bF66L/StPZILHvavbaitPCqbPggvgigjDQn9B1bSuCOeVCc0H
         DTs2w61sVBZzXbC1MGxNxdIayYv/QllWMW1MU7/SsjJ7wzOUzTW+aaS5Yge+meP21ROx
         3It7Cq0FRTApHq5zqhQS2NwQn6Z0RD9cMjtMVh8lB+Ie7HlJUY3b8t+wySjGrf6V0nPN
         Ymjw5nEnZ6GtmG5ghaQU90hRX24OOzKhzM1mx2HrUxnbqOzeHrSVJivHXNavjbbcIdI0
         BZfMu1cy6nwlKnvrMVo2/RzMseyuWdaTSpDTt8B1i19M/DxhGyv3ganF87U1/OrDTqXY
         grFg==
X-Gm-Message-State: APjAAAWNyxccSw9APweWES7FHNSdu8xxr7lF/Tk9I9QZpXuYIEn97k2H
        1hBGGSkEU0OULQIy76odSF++TFbq+KZFWA==
X-Google-Smtp-Source: APXvYqwDPRNgFDO55NIL2ILXiAVIoo5uCDKi42Wfnzwz8UQmbXCYEQb6crMC3Ao1cad655+ilzK9SA==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr4588432wmc.77.1560442523847;
        Thu, 13 Jun 2019 09:15:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w23sm188427wmc.38.2019.06.13.09.15.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 09:15:23 -0700 (PDT)
Message-ID: <5d02769b.1c69fb81.9584f.105c@mx.google.com>
Date:   Thu, 13 Jun 2019 09:15:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.50-119-gc6c7a311e997
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 123 boots: 0 failed,
 122 passed with 1 untried/unknown (v4.19.50-119-gc6c7a311e997)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 122 passed with 1 untried=
/unknown (v4.19.50-119-gc6c7a311e997)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.50-119-gc6c7a311e997/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.50-119-gc6c7a311e997/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.50-119-gc6c7a311e997
Git Commit: c6c7a311e997d044523cae077b58b1849cb8858f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
