Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945D11B30CD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDUT4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgDUT4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:22 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E3820774;
        Tue, 21 Apr 2020 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498982;
        bh=Q38SnWOvz4AnBx07LWYwNxGnnvvT7pWqjzliwW5rQB8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ruVji9SgCdr/8ZmxfPRHsSVZjVD3JIF+5KINhiTaybm4z3AfwHG9N5JNss7Z+O9+8
         YzdWM2rSo8HxSW8DEUzfozH+luyTZBCPq1DwbYxaFxclAO51U+FHPIhL7tttT5RYIc
         chKRyXDRWJnBzBHQuUpEDG+cUVtqKC2JV7oh+29A=
Date:   Tue, 21 Apr 2020 19:56:21 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
In-Reply-To: <20200417163843.71624-2-pbonzini@redhat.com>
References: <20200417163843.71624-2-pbonzini@redhat.com>
Message-Id: <20200421195621.E9E3820774@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)").

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33.

v5.6.5: Build OK!
v5.5.18: Failed to apply! Possible dependencies:
    Unable to calculate

v5.4.33: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
