Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38C323FF18
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 17:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgHIPxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 11:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgHIPxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 11:53:13 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D422075F;
        Sun,  9 Aug 2020 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596988393;
        bh=chCo/RTkrhfYmi/YrFhdduXRZ+S8iSOwQ1htpl1BwA0=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=0GYZnfrOUZNxMu/8tbXDs+FmCmi/fWcUXYCShS8hAV0UfTNkud1aDsJExvXBlgNCp
         lR4ABjJ+R+MqfXUR3uzmws1S6FT4MvDEpk1LrvD1eMa+tchH7NJZ6Hz5C/6ZGq8cHm
         xTdZ15s9C4e6yQqjDe7pitP/ri5rPQNIH/VwU0ZU=
Date:   Sun, 09 Aug 2020 15:53:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
To:     Chengming Zhou <zhouchengming@bytedance.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [for-linus][PATCH 05/17] ftrace: Setup correct FTRACE_FL_REGS flags for module
In-Reply-To: <20200804205812.638727187@goodmis.org>
References: <20200804205812.638727187@goodmis.org>
Message-Id: <20200809155312.D6D422075F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8c4f3c3fa968 ("ftrace: Check module functions being traced on reload").

The bot has tested the following trees: v5.8, v5.7.13, v5.4.56, v4.19.137, v4.14.192, v4.9.232, v4.4.232.

v5.8: Build OK!
v5.7.13: Build OK!
v5.4.56: Build OK!
v4.19.137: Build OK!
v4.14.192: Build OK!
v4.9.232: Build OK!
v4.4.232: Failed to apply! Possible dependencies:
    02a392a0439f ("ftrace: Add new type to distinguish what kind of ftrace_bug()")
    97e9b4fca52b ("ftrace: Clean up ftrace_module_init() code")
    b6b71f66a16a ("ftrace: Join functions ftrace_module_init() and ftrace_init_module()")
    b7ffffbb46f2 ("ftrace: Add infrastructure for delayed enabling of module functions")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
