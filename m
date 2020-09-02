Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4A25B778
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgIBX7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 19:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgIBX7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 19:59:48 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F76A206F8;
        Wed,  2 Sep 2020 23:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599091188;
        bh=XzkbUniJSxkCIQdUyyrVHwyUPTM03iMXc14/JCTEQCU=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Kg0JctmZd/poMrNdrOeV+szP56X9rL1g8im8CLcEBmqaYhlBPoVtowR3A10HGahcn
         a5GxO5AdKcGoZduUIQ3rZl8G9xwASWrQPihAd7mSdi74aPWLloRYdBWAz0BbPberXS
         ODx8f4JLizsTleUewVN9uisn7865BCeaAZM4krxA=
Date:   Wed, 02 Sep 2020 23:59:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Kyle Huey <me@kylehuey.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 02/13] x86/debug: Allow a single level of #DB recursion
In-Reply-To: <20200902133200.726584153@infradead.org>
References: <20200902133200.726584153@infradead.org>
Message-Id: <20200902235948.2F76A206F8@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 9f58fdde95c9 ("x86/db: Split out dr6/7 handling").

The bot has tested the following trees: v5.8.5.

v5.8.5: Failed to apply! Possible dependencies:
    0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
    27d6b4d14f5c ("x86/entry: Use generic syscall entry function")
    517e499227be ("x86/entry: Cleanup idtentry_entry/exit_user")
    8d5ea35c5e91 ("x86/entry: Consolidate check_user_regs()")
    a377ac1cd9d7 ("x86/entry: Move user return notifier out of loop")
    b037b09b9058 ("x86/entry: Rename idtentry_enter/exit_cond_rcu() to idtentry_enter/exit()")
    ba1f2b2eaa2a ("x86/entry: Fix NMI vs IRQ state tracking")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
