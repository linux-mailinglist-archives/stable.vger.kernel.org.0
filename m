Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BAC4333FB
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhJSK4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSK4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:56:45 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB62FC06161C;
        Tue, 19 Oct 2021 03:54:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYVxH6Jbbz4xbT;
        Tue, 19 Oct 2021 21:54:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634640867;
        bh=I9PhYR5T9yGExVlfH3Zmx5qYwYLJHSh5mPBvxSAvzI4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DsnAsOtWuCvFLWUqifqc7Pgxwtpru5SHkYeDQfIqF+jG1KMGzcW8CN8uvbNszHih6
         csmRf1hwZg7a8lCUo1B2ZtKNHAyYlCnkiwcz9RBIqP8F5z0JyaxrWSB6LQaXTSKPJq
         JYXF22w7U+W3FR3BW01oP/D6HMwx3Quqo0u2ieUEb94DCslqg2ZWtvG5rR1AFisyiE
         OywYuHIZrWEqvuqOoNasiXu5HTSHXcyF2xipDrswCyxtOFlqFtSUrpf2DL8OKxXpC3
         fFlaOJFdRPer6cN/yLtNM1GNCdii67nZNYh22XQebK8FezpeYGUG8z69tz5yUFcD/Z
         D0XefTUO+tx1g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 35/69] KVM: PPC: Book3S HV: Make
 idle_kvm_start_guest() return 0 if it went to guest
In-Reply-To: <20211018132330.646217210@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
 <20211018132330.646217210@linuxfoundation.org>
Date:   Tue, 19 Oct 2021 21:54:27 +1100
Message-ID: <87fssxcmjg.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> From: Michael Ellerman <mpe@ellerman.id.au>
>
> commit cdeb5d7d890e14f3b70e8087e745c4a6a7d9f337 upstream.
>
> We call idle_kvm_start_guest() from power7_offline() if the thread has
> been requested to enter KVM. We pass it the SRR1 value that was returned
> from power7_idle_insn() which tells us what sort of wakeup we're
> processing.

Please drop this also, it won't apply without the previous patch.

cheers
