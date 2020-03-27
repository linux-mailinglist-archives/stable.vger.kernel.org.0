Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70590195976
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgC0PDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgC0PDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:37 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7953F20748;
        Fri, 27 Mar 2020 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321416;
        bh=6BljeoalHNjzRmGiTkR8t8oBE7c7fmlwnyuOZVlKyG0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=KrX64+c9habUpaAD0e9Pompsd1BZ40t8hiSZFEU7rmXhE7i0I9NfTvrUizFhSz0o4
         sSd3vmquz61icI38G2AwW0fOhd9/71WNmmaM7fmqKX5ibjKmpU5coeOy95tn90LIrd
         NVtjgexlgyXkagX3L9WR+2KfSTRDlKOraQkKsxmM=
Date:   Fri, 27 Mar 2020 15:03:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3
In-Reply-To: <1585107894-8803-1-git-send-email-chenhc@lemote.com>
References: <1585107894-8803-1-git-send-email-chenhc@lemote.com>
Message-Id: <20200327150336.7953F20748@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Build OK!
v4.14.174: Failed to apply! Possible dependencies:
    b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")

v4.9.217: Failed to apply! Possible dependencies:
    b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")

v4.4.217: Failed to apply! Possible dependencies:
    0c94fa33b4de ("MIPS: cpu: Convert MIPS_CPU_* defs to (1ull << x)")
    380cd582c088 ("MIPS: Loongson-3: Fast TLB refill handler")
    5fa393c85719 ("MIPS: Break down cacheops.h definitions")
    9519ef37a4a4 ("MIPS: Define the legacy-NaN and 2008-NaN features")
    b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")
    b2edcfc81401 ("MIPS: Loongson: Add Loongson-3A R2 basic support")
    c0291f7c7359 ("MIPS: cpu: Alter MIPS_CPU_* definitions to fill gap")
    f270d881fa55 ("MIPS: Detect MIPSr6 Virtual Processor support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
