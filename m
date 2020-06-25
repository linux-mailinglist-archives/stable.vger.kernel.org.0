Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFEF20A156
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405637AbgFYOyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405577AbgFYOyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:54:00 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E103207E8;
        Thu, 25 Jun 2020 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096839;
        bh=W0jx8E2p1qZSPESd1ndKtVHaGjJF3gBb1cYL/Y2Ds+s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=t3gjhbLIhFfWNctgCOvfXvkEvtDTSEl1fh342YkR3uLaFJYR46yyQDoaKMllJPyjN
         k+TfPty0jXsu8w3VxXEMkcSJO6cc8j03gvOT1ws/SMJGa6hYhO6R6GkHzAltW1OSyd
         JWfP8PARl+aj3rQ9Ixfff0GVMNHfQ0qJ8fYLx0Mc=
Date:   Thu, 25 Jun 2020 14:53:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] irqchip/gic: Atomically update affinity
In-Reply-To: <20200621142537.784191-1-maz@kernel.org>
References: <20200621142537.784191-1-maz@kernel.org>
Message-Id: <20200625145359.5E103207E8@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature").

The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129, v4.14.185, v4.9.228.

v5.7.5: Build OK!
v5.4.48: Build OK!
v4.19.129: Build OK!
v4.14.185: Build OK!
v4.9.228: Failed to apply! Possible dependencies:
    0c9e498286ef9 ("irqchip/gic: Report that effective affinity is a single target")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
