Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CDE1EFA22
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgFEOLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgFEOLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:11:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F416D20897;
        Fri,  5 Jun 2020 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366262;
        bh=0ojZB7fQfC1YkhpRfbstGilfYn5GiwoAxRC4h1i0gGA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=y+skYXc364qE2LYnW8uMSKPrGiKse6AZbNCtZMKGeGZ19Yganp96AAUQOd+Sm9e5C
         2cNFqbas5FLwrc4kx83bNB9EtV7BYkM8rwLYlqWrihH1dHLoJfgpWH6WXGn7kDWQq1
         cz97d128m+kFWwSZgHlPIB4Qd2rNgm98ng2LXbA8=
Date:   Fri, 05 Jun 2020 14:11:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/6] net: core: device_rename: Use rwsem instead of a seqcount
In-Reply-To: <20200603144949.1122421-2-a.darwish@linutronix.de>
References: <20200603144949.1122421-2-a.darwish@linutronix.de>
Message-Id: <20200605141101.F416D20897@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and netdev name retrieval.").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Failed to apply! Possible dependencies:
    2da2b32fd934 ("sched/rt, net: Use CONFIG_PREEMPTION.patch")

v4.19.125: Failed to apply! Possible dependencies:
    2da2b32fd934 ("sched/rt, net: Use CONFIG_PREEMPTION.patch")

v4.14.182: Failed to apply! Possible dependencies:
    2da2b32fd934 ("sched/rt, net: Use CONFIG_PREEMPTION.patch")

v4.9.225: Failed to apply! Possible dependencies:
    2da2b32fd934 ("sched/rt, net: Use CONFIG_PREEMPTION.patch")

v4.4.225: Failed to apply! Possible dependencies:
    2da2b32fd934 ("sched/rt, net: Use CONFIG_PREEMPTION.patch")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
