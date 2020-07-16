Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295EB2218E0
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGPA1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgGPA1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:45 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD32F20787;
        Thu, 16 Jul 2020 00:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859264;
        bh=Vkb7p0w1IjPedbSdymxsT8UMtKkNHmrzEESrAFXmZwk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=ytA9kQpz4s1wPUpyY92vTTQCNiQrsmw51DZLA2jB8WHjO20huXxb5ecm/D1rF3wHE
         yRx8UfRHqS2hNQsvmGJU1WWsd9CmbnqLkWdrEUtx+eJC+90E2SdDYw7zryFn6mLebx
         dkqorTXjp/0im19M69uN0gfH/DQmAf99ymrbowCs=
Date:   Thu, 16 Jul 2020 00:27:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Keno Fischer <keno@juliacomputing.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 2/7] arm64: ptrace: Override SPSR.SS when single-stepping is enabled
In-Reply-To: <20200710130702.30658-3-will@kernel.org>
References: <20200710130702.30658-3-will@kernel.org>
Message-Id: <20200716002744.AD32F20787@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Build OK!
v4.14.188: Build OK!
v4.9.230: Build OK!
v4.4.230: Failed to apply! Possible dependencies:
    44b53f67c99d0 ("arm64: Blacklist non-kprobe-able symbol")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
