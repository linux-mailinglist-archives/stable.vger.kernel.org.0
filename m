Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733ABCCC7E
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 21:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfJET1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 15:27:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45130 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbfJET1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 15:27:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so10749184wrm.12
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 12:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+rpbMGmZ0fiFAw9iz7QLDK4hhNZNkD1hUISXQ50YyEI=;
        b=ZvSLaLy2DoJqaC2yWFlEy/cOYmVesAA0e0DxBwAZhycrYExWvt+wqm+etIi+ztqqsi
         huLjpI/grQP9q5mndIATVg9GgXv3Dd5/9Trgpb1kNZQ2y95TjH3A524UwpPfZCUoqsa+
         7JNtqs83CHxA8iNmlZfCnZa17VcyfHDYb7Ku6bfTSjksRbFIL7ymWs+narO5x9mI+NZs
         ToE4b1TIIX3eYvqyrqyEh6CSzY3uRnrn31+BCuoic4smHDtahtwQRlqAu4H6/0rAwXoR
         LbNc69HArA6KvevFbUGP/Mj/2XXkN9COpYYz/LSUSDb4aR1FRl0pMirHdsnR0SXSJt7R
         sEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+rpbMGmZ0fiFAw9iz7QLDK4hhNZNkD1hUISXQ50YyEI=;
        b=C3ukaC3iz+oW/8HUMfwijJTC8Y+3hGzyix0uZa7JS70KI3tgdVqpyitBdF02wC/OCl
         iZYSaRMpiqu0ZsB1Jrf+WZXp9Gckc5ZhuIpjmggw5/WEEq2JhJednN8bSdNrFBDTfi3I
         reyivskOCgdjicJnOWpqYRuK5VeS2P70Xqc9kziKfiKDhjp9HwkkacFVY2KLo8oH5O2D
         JtRWLSVagRaDugpoDvFxSBNOcdCp3lQIPkliI9Nb8t64qSnboV+UcyLFF/rndgiOhh7r
         1AdFewl7s+t4/PNwQFjdi9wJyiRiPRrKNpqyHRbk7/blzWBg63lrT28UhploVDt5NGMQ
         FoyQ==
X-Gm-Message-State: APjAAAX6XFxInxC8K4Y+6oKSKMr7TveEAcZjEkGc86Tg7foX6Qi7WBGG
        8yShm3DgcqpYUsRBuOEbppioNme/toY=
X-Google-Smtp-Source: APXvYqwN62qSc5NI15XSgUooWDDpmMLpPFDj0/Z/QtRqeK+q/RG1ygFVqUiTzPhClR3U+U6qESMyDg==
X-Received: by 2002:adf:e612:: with SMTP id p18mr8109717wrm.181.1570303629179;
        Sat, 05 Oct 2019 12:27:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 36sm13603499wrp.30.2019.10.05.12.27.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 12:27:08 -0700 (PDT)
Message-ID: <5d98ee8c.1c69fb81.f6a99.e32e@mx.google.com>
Date:   Sat, 05 Oct 2019 12:27:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.195
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 43 boots: 0 failed, 43 passed (v4.9.195)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 43 boots: 0 failed, 43 passed (v4.9.195)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.195/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.195/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.195
Git Commit: 6eea609ac3091741dee9080bae6bcf2edc879ca2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
