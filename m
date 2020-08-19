Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04F124AA46
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHSX5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgHSX4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 230C521734;
        Wed, 19 Aug 2020 23:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881411;
        bh=fL4YR8/v3yE2xfz+pPXzffhsdvbs1PesJ9MozBly0nA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Y4UfwQmqZVwC29uDM1k8ue9CFKA/b2L8w5KLyCx2s1hL9vpXw/T5SEgBQZj3UUn0X
         qteg+xwzTBj8BZhUSV3vjIv5mBsEYLxx0aajM2Rd5JR5UChYlASjlqoDjXZqd4xhHj
         6jbKCMSFc4RLqAgcC64cZU+ysbYD2g9A7qxxgrzw=
Date:   Wed, 19 Aug 2020 23:56:50 +0000
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
Message-Id: <20200819235651.230C521734@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58.

v5.8.1: Failed to apply! Possible dependencies:
    8e8b31494db7 ("ARM: backtrace-clang: check for NULL lr")

v5.7.15: Failed to apply! Possible dependencies:
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    8e8b31494db7 ("ARM: backtrace-clang: check for NULL lr")

v5.4.58: Failed to apply! Possible dependencies:
    40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    8e8b31494db7 ("ARM: backtrace-clang: check for NULL lr")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
