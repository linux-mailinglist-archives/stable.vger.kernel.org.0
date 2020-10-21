Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E53295019
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 17:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502517AbgJUPop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 11:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502369AbgJUPop (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 11:44:45 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F782177B;
        Wed, 21 Oct 2020 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603295084;
        bh=D6/0oJJgmsGcKB44y2D0I2ANEAwcXtCNXQ/YzqieLeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOCmVMZ9RG4ALXeO56+gd3C7l8o1jk4FDoA6Qo0tvHjKo5AW6IcO56ZjSpGbWHe4q
         oLjR0Hd9jgiW1JAeNAQnpwsXN96AfGLfQg7riAEDey2HWWwYbX8SJK4JE+YCeyRJU5
         Ldifpenvi+SvnFhkPiz67rD/9G6rHiXUesDs+KdU=
From:   Will Deacon <will@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Steven Price <steven.price@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/2] arm64: Fixes for spectre-v2 detection in guest kernels
Date:   Wed, 21 Oct 2020 16:44:38 +0100
Message-Id: <160327484838.3685216.1991063406646730235.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201020214544.3206838-1-swboyd@chromium.org>
References: <20201020214544.3206838-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Oct 2020 14:45:42 -0700, Stephen Boyd wrote:
> The first patch fixes a problem with spectre-v2 detection in guest
> kernels found on v5.4 and the second patch fixes an outdated comment.
> 
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> 
> [...]

Applied just the second patch to arm64 (for-next/core), thanks!

[2/2] arm64: proton-pack: Update comment to reflect new function name
      https://git.kernel.org/arm64/c/66dd3474702a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
