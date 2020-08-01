Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99536235497
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 01:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHAXSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 19:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgHAXSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 19:18:15 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7817920829;
        Sat,  1 Aug 2020 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596323895;
        bh=WX6kMAvcgYOC5R0JdayLAzECqlmeXxK9KmHHwTYNbb8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=En1BscZmlJ77mlPvzYbqxGXxPYWfDXq9hdDOcktdDK1f9FnoY2bsCBX6oeQowqnA1
         MSxUWkxvKMcG1/hm1SZPvTJGblU/vaIETXRvBmHcWtY6uD3gUezR2123pkrFI3GQVL
         AJvQtoJX0V9wWe2P7s5UzbXs+HyXPNUR7UF2DuM4=
Date:   Sat, 01 Aug 2020 23:18:14 +0000
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
Message-Id: <20200801231815.7817920829@mail.kernel.org>
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
    99c56f602183 ("ARM: backtrace-clang: check for NULL lr")

v5.4.54: Failed to apply! Possible dependencies:
    40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    99c56f602183 ("ARM: backtrace-clang: check for NULL lr")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
