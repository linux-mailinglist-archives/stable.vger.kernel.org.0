Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA0D7109F
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 06:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbfGWEbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 00:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732028AbfGWEbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 00:31:33 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556EC2239E;
        Tue, 23 Jul 2019 04:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563856292;
        bh=Wwn7yxrLGk/utWQ17mVT/x50WAlz/xuOFG4qv+F12VI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=dJcP4WDobdtr3hhBFMeerB7mUEoeq9/VHqEthwhZ3oQWXUpRjKZQQdI/KocwiqU6R
         4NFi6Po5l1BQBW1IX5gCGjJVXxZQwMkr6npl9RwKN+UzUbpSnh5irqhFAlBWSCh02A
         RlvHghqIyMSVnJ1/RkG52zPfrUUlwJZOpYWC29dw=
Date:   Tue, 23 Jul 2019 04:31:31 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Revert "kvm: x86: Use task structs fpu field for user"
In-Reply-To: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
References: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
Message-Id: <20190723043132.556EC2239E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 240c35a3783a kvm: x86: Use task structs fpu field for user.

The bot has tested the following trees: v5.2.2, v5.1.19.

v5.2.2: Build OK!
v5.1.19: Failed to apply! Possible dependencies:
    0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
    2722146eb784 ("x86/fpu: Remove fpu->initialized")
    4ee91519e1dc ("x86/fpu: Add an __fpregs_load_activate() internal helper")
    5f409e20b794 ("x86/fpu: Defer FPU state load until return to userspace")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
