Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7744134211
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 13:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgAHMo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 07:44:27 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37644 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbgAHMo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 07:44:27 -0500
Received: by mail-wm1-f54.google.com with SMTP id f129so2357008wmf.2
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 04:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b+nZZiS1bR+Wl0DbVUX3VIlmpRBz+YoEPD9yYWHa+9w=;
        b=tgMHmHi2ySsINTi9Th5kOKu3L5V6G9yNNVeuuM8fD6tk1XSK8vj9oW1FMvRK/UgQux
         SDuwlE0EHx7+yYGBVC1WEVaUn2rvIzWjy12whafbOX12CMIPwo+5iENeEV+mnk4Y58sb
         OYaq8dkqGBfGeDU6kD/8aDrQOXAVtqseKaMiaTSIsxNGDaNu4jw6oVdzRZCM5ZbJq0Pr
         op2ZZo69QKWaTWfZX5UhAUH3pKzqbHLPHh+ORCgfrz5ol7JkPsvnpmNFrGk1QsZ4iNpg
         Bc9AygXvTIAxAWERD+gdDwKVNakitFui6upzYHAwRPO7/6BnDyXeQeoiZHLlHlLwjoXk
         U1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b+nZZiS1bR+Wl0DbVUX3VIlmpRBz+YoEPD9yYWHa+9w=;
        b=iViN7KsZK2vAhOWtN8pXmPL1ljOSzdAW/9bvLjuAdcXlOHozPBUsY6DwhA1gIVXyw3
         K9Y8Tje1hwr1xPPdwDdlkLBiVBqUpRWlVOT1MbQdBKLvgN7wJObzCS0ii5PlmFK3n8oT
         bOVL1y5uo1/KFRETd7HHHJG5oQYe7MNG7Bsjv7dvaRcoPlBYZtIjD40UZXD2DcJ+3ZVr
         uIaExSqOT1SHmM2mzWPyBpMTTDlHFko9fl4vQMEvuNUEIAh4ZbU58cdq3nkAWKHs2YfX
         bO+QHhEJ7X7+it2IHT9D26VIOPkCvuK9K/CazUKdrticBBUFkZduwWzozx7eo7ySm46h
         E5Lw==
X-Gm-Message-State: APjAAAUBrnC/ZtTFz9jNB1+lLji36FxA5r/rXchg4nspUrFpeBXw3CUk
        TWZ9ec+CcvGi0+1CnpK9nKyWimqH27lmIA==
X-Google-Smtp-Source: APXvYqwoHopeiURUpgccxvIurPq1Tfv8tOiHoYvLsB42LbXQJQn0/tnvISSoYBsT+a+XVPRkUGlc9g==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr3543067wmi.178.1578487465538;
        Wed, 08 Jan 2020 04:44:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t5sm4113516wrr.35.2020.01.08.04.44.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 04:44:25 -0800 (PST)
Message-ID: <5e15cea9.1c69fb81.261da.2c75@mx.google.com>
Date:   Wed, 08 Jan 2020 04:44:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-228-g9dcb411d44b4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 73 boots: 0 failed,
 73 passed (v4.19.92-228-g9dcb411d44b4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 73 boots: 0 failed, 73 passed (v4.19.92-228-g9=
dcb411d44b4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-228-g9dcb411d44b4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-228-g9dcb411d44b4/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-228-g9dcb411d44b4
Git Commit: 9dcb411d44b43b674d36f5d642e2a693b907d1cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 15 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
