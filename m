Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA2A243D44
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgHMQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHMQZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:49 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 934BE2087C;
        Thu, 13 Aug 2020 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335948;
        bh=AiUyK0/qY/ID5bYJiujpY0vExC+Z3AqkgqmA3vliz/w=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=j+yNRbO9gQNBn8iPY9nvm3DXlCr1pVQ5/ie20sRWL9AjwtNpVWlspzP3cljsesehX
         g4ukQcTabT6F+ZG/WZvq3YqVI9SO3wMjUFaFvZAfmlBxeSur/6BgmBUWZDyChM+VAp
         e7gu7bLlwtgGBSSVLuwn6CB6gHYUebTYN32NYAtQ=
Date:   Thu, 13 Aug 2020 16:25:47 +0000
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
Message-Id: <20200813162548.934BE2087C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang").

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57.

v5.8: Failed to apply! Possible dependencies:
    90c11fed93ca ("ARM: backtrace-clang: check for NULL lr")

v5.7.14: Failed to apply! Possible dependencies:
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    90c11fed93ca ("ARM: backtrace-clang: check for NULL lr")

v5.4.57: Failed to apply! Possible dependencies:
    40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
    5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
    90c11fed93ca ("ARM: backtrace-clang: check for NULL lr")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
