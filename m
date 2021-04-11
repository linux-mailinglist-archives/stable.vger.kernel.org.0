Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3447135B633
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhDKQuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 12:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235338AbhDKQuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 12:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5BF5610A2;
        Sun, 11 Apr 2021 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618159783;
        bh=psLyqltR+EN0VKLdamJX1RHbFakkVlqPcfUTO2YRles=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qd4s9NErPLa1t4TGvkqpx39sBVbAOGTl1+Qde+SdTAR3bzYvIkMU+v0+oEL7NHzY8
         9irj3xDIze5B3F7FTUzcVw0K2sKQ8OjetsxzVxSzTA/ml63R7SlFOVQVgqgilj42Pc
         DeYauv0AFmgOJcqAXTd21ksCj4hEv+wK0P8JJfTNonG8tqfSrmQSgjXD++fRcxekOp
         VT2mTI2cyB0jqdl4IAHlKDbKma61D/MdSPypUbMNrFNpKNQH9ldP2CEMug0yyM5nK7
         UR7h09Xquj99XLJm9HmmiUUhlltdH6cZkFRaipKy8pAlXdyw7ubhLA2P2ChRsGtvrk
         S7z7Bb8xhvUew==
Date:   Sun, 11 Apr 2021 12:49:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 5.10/5.11 0/9] Fix missing TLB flushes in TDP MMU
Message-ID: <YHMoeygaDoams9TZ@sashalap>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 10, 2021 at 11:12:20AM -0400, Paolo Bonzini wrote:
>The new MMU for two-dimensional paging had some missing TLB flushes
>in 5.10 and 5.11.  This series backports some generic improvements
>to simplify the backport in the last four patches.
>
>Ben Gardon (5):
>  KVM: x86/mmu: change TDP MMU yield function returns to match
>    cond_resched
>  KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
>  KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn
>  KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
>  KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed
>
>Paolo Bonzini (1):
>  KVM: x86/mmu: preserve pending TLB flush across calls to
>    kvm_tdp_mmu_zap_sp
>
>Sean Christopherson (3):
>  KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range
>    zap
>  KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
>  KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

Queued up, thanks!

-- 
Thanks,
Sasha
