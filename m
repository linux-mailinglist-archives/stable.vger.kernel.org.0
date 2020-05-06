Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A521C7E0A
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEFXmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgEFXmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:10 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BEB20746;
        Wed,  6 May 2020 23:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808529;
        bh=gPcgj6HdXpoIfsTowrHYChJFHu1lH1/EjkkmN72nDfY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=q8KjyjU9tNXznxBILYyHnunbN0XNaQEGvSwSn1LVH2UtO1rEeielMBqX/rJyrnvPW
         Wje4WWjShtUm64YIJlGp2qjWYwxr+WIMzI9KePAXrsa99lW2RPrcC0nJMGOIVJK7sq
         kSBx+rwGPYLlNQ6GLNT2Zno/vVtiye2yoQ5aos2c=
Date:   Wed, 06 May 2020 23:42:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: SVM: fill in kvm_run->debug.arch.dr[67]
In-Reply-To: <20200504155558.401468-2-pbonzini@redhat.com>
References: <20200504155558.401468-2-pbonzini@redhat.com>
Message-Id: <20200506234209.B6BEB20746@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 42dbaa5a0577 ("KVM: x86: Virtualize debug registers").

The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.14.178, v4.9.221, v4.4.221.

v5.6.10: Build OK!
v5.4.38: Failed to apply! Possible dependencies:
    Unable to calculate

v4.19.120: Failed to apply! Possible dependencies:
    Unable to calculate

v4.14.178: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.221: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.221: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
