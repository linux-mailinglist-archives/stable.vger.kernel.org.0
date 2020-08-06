Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E682123D50D
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHFBYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgHFBYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 21:24:08 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE8C22CAE;
        Thu,  6 Aug 2020 01:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677047;
        bh=f4jYhh6XVpG0VcVY7qAKYQlGuzbKcj6bwaI9qB3s1us=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=BLkz+HJwf3/Is6mjudSgmI60+baAGPt0e2mkdKlA7igEUIpFKouwA+b3O3OUjWTiF
         LmC9nbVUONdGYLkQ7YFuU+UDsnOIkXTX5iYXd8CpOCgEdtZfRLLaQ1Jl6bCeI1X94I
         Q0J3fCs+OzfoT76LuChtQPy4TZA0gBq3S6TOJAcA=
Date:   Thu, 06 Aug 2020 01:24:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
To:     Nathan Huckleberry <nhuck15@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
In-Reply-To: <20200730205112.2099429-3-ndesaulniers@google.com>
References: <20200730205112.2099429-3-ndesaulniers@google.com>
Message-Id: <20200806012407.BFE8C22CAE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang").

The bot has tested the following trees: v5.7.11, v5.4.54.

v5.7.11: Failed to apply! Possible dependencies:
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    e6902a275517 ("ARM: backtrace-clang: check for NULL lr")

v5.4.54: Failed to apply! Possible dependencies:
    40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    e6902a275517 ("ARM: backtrace-clang: check for NULL lr")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
