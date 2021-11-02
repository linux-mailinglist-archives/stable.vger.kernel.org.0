Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125E0442CEB
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 12:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhKBLmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 07:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhKBLle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 07:41:34 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F8DC061766
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 04:38:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hk7G50vTTz4xdk;
        Tue,  2 Nov 2021 22:38:53 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Laurent Vivier <lvivier@redhat.com>, stable@vger.kernel.org
In-Reply-To: <20211027142150.3711582-1-npiggin@gmail.com>
References: <20211027142150.3711582-1-npiggin@gmail.com>
Subject: Re: [PATCH v3] KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling
Message-Id: <163584792636.1845480.13123801071900651705.b4-ty@ellerman.id.au>
Date:   Tue, 02 Nov 2021 21:12:06 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Oct 2021 00:21:50 +1000, Nicholas Piggin wrote:
> From: Laurent Vivier <lvivier@redhat.com>
> 
> Commit 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest
> context before enabling irqs") moved guest_exit() into the interrupt
> protected area to avoid wrong context warning (or worse). The problem is
> that tick-based time accounting has not yet been updated at this point
> (because it depends on the timer interrupt firing), so the guest time
> gets incorrectly accounted to system time.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling
      https://git.kernel.org/powerpc/c/235cee162459d96153d63651ce7ff51752528c96

cheers
