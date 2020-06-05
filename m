Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820641EFA20
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFEOLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgFEOLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:11:03 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022252086A;
        Fri,  5 Jun 2020 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366263;
        bh=X8XMv0WjqPtzrIuk0/WcCHX76W0e8BPmOSHGc85vVt0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=QT9hLq9XJzBvxl2/xRUzVLQZ0fzvcHOyE9QEovrqG/TBH/BmDCuuMRi4kXnDyO7iM
         zg5Owlk8wXWa81YXaT5ikb8bTLvETNMvMn8Dt4APpGUrF9BnUEkoGcKGGLUeOrSAnb
         EeT5HxM1b75uZRfn3YVQy5PJ6jiTBcyKLBB78Kcs=
Date:   Fri, 05 Jun 2020 14:11:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Bob Haarman <inglorion@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Bob Haarman <inglorion@google.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] x86_64: fix jiffies ODR violation
In-Reply-To: <20200602193100.229287-1-inglorion@google.com>
References: <20200602193100.229287-1-inglorion@google.com>
Message-Id: <20200605141103.022252086A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 40747ffa5aa8 ("asmlinkage: Make jiffies visible").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Build OK!
v4.19.125: Build OK!
v4.14.182: Build OK!
v4.9.225: Build OK!
v4.4.225: Failed to apply! Possible dependencies:
    9ccaf77cf059 ("x86/mm: Always enable CONFIG_DEBUG_RODATA and remove the Kconfig option")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
