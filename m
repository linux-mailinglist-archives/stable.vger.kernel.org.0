Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF12421B7A0
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgGJOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbgGJOCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:53 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A991620870;
        Fri, 10 Jul 2020 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389772;
        bh=FBE18phTYM0HmIHzEwqJPtolOgnZDBgmEL23f7IRmtE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=whZkR9qGxLnII4AoJ+nxaWpLOAL0TPmc5+/hFxci2s8+jtRNCdNNCvUIYvPAXf7Vf
         huO0pSuU/JcXfDaRwOZM4VKwBlZYkBmfIBC+bZo78b+hzLWN4tGlT9qYj5TZQ9JEg5
         Ls+N9eYGOF88FZmGlwEKPSecJGNHA7Ar/3juWMm4=
Date:   Fri, 10 Jul 2020 14:02:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com
Cc:     <stable@vger.kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Keno Fischer <keno@juliacomputing.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] arm64: Override SPSR.SS when single-stepping is enabled
In-Reply-To: <20200702212618.17800-4-will@kernel.org>
References: <20200702212618.17800-4-will@kernel.org>
Message-Id: <20200710140252.A991620870@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Build OK!
v4.14.187: Build OK!
v4.9.229: Build OK!
v4.4.229: Failed to apply! Possible dependencies:
    44b53f67c99d0 ("arm64: Blacklist non-kprobe-able symbol")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
