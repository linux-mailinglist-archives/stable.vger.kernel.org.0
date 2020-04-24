Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D841B7FAE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 22:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgDXUGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 16:06:11 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3437 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDXUGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 16:06:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea3463c0000>; Fri, 24 Apr 2020 13:04:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 13:06:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Apr 2020 13:06:10 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 20:06:10 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 24 Apr 2020 20:06:10 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.165.152]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ea346b10000>; Fri, 24 Apr 2020 13:06:09 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <baolin.wang@linaro.org>, <kstewart@linuxfoundation.org>,
        <tglx@linutronix.de>, <bradleybolen@gmail.com>,
        <gregkh@linuxfoundation.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>
CC:     <anrao@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 5.4.33 0/2] Fix for long operation cmds busy detection
Date:   Fri, 24 Apr 2020 13:06:04 -0700
Message-ID: <1587758766-3274-1-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587758652; bh=UfGeyrkbNZXh5G8PF6DuyJaJvNbRZiJ76BYRYIS88GE=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=LHDS/Bc5Yfu+x1rlDl8vPzR64nkLUJFdBhWqKH5HeACD3AVRzVLIBZLWg5aUE/mdB
         cQIms0Hvjq+sSPfDufKhxbUd8XJ5JMYlMDB8f4D8pJuHjZd6em0XtffPig6tutX6Vg
         gTlBWqK7/SkajNJDBvO6O9dt/UiqpnphCefhYwZ6BckOoy+Vkacq8GbFNwMe6cjnWT
         pUDVu3s/1TJwyQCilF8A/t2p67USqWTwzNjl3PdUgR838Dh74E5APB8Rt1NgS6tB6C
         MDj/B8BwMn7mEOthdJnZSUa26sZtpHGzf0UE3kySlCF5IZkH4ARsUaowQzADwTb9dr
         BIvpUfcmW1a5g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series is to backport the upstream patches that fixes busy detection
for long operation mmc commands by implementing Tegra specific timeout
callback to switch between finite and infinite HW busy detection wait
modes.


Sowjanya Komatineni (2):
  sdhci: tegra: Implement Tegra specific set_timeout callback
  sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability

 drivers/mmc/host/sdhci-tegra.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

-- 
2.7.4

