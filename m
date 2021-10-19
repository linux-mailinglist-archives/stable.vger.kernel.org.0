Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53B84333FD
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJSK5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSK5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:57:00 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDB2C06161C;
        Tue, 19 Oct 2021 03:54:48 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYVxf5rHzz4xbT;
        Tue, 19 Oct 2021 21:54:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634640886;
        bh=x2ytmbg7gwsAE45QXX+LTY1Rs6nJEpauqSbvOn/silc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BeqNtxj9fcgJchbZO6CK+C3piBovokudXm+CZw8VBvty/2RuMhx1zq2Zf+CgYYMTo
         mUip8akC+86F8Y9Hlx853M04ynfolpXmKULXXWs5IYPsm5WgY3gLYiuB12ECWqzVYk
         F2yZt8Mx3TqleISfcp5brtwBzj2bQg841FxUMrNmSxbwnIss9ZV+jXCmeR+vVqMplZ
         EdB+RiFwpUIzKewXD0axRXVOCiwIKjoKigHNVJBYHtLkzmG44V5wZavAyi6Px5Y1u8
         BijuL8eR7ftqIeLyJpy0/IXt856omumNIdMayj9ozEoJE4Gy7tZC55stDBy4y43BNw
         BFu/lsV8omS2w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 044/103] KVM: PPC: Book3S HV: Fix stack handling in
 idle_kvm_start_guest()
In-Reply-To: <20211018132336.219642035@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
 <20211018132336.219642035@linuxfoundation.org>
Date:   Tue, 19 Oct 2021 21:54:46 +1100
Message-ID: <87czo1cmix.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> From: Michael Ellerman <mpe@ellerman.id.au>
>
> commit 9b4416c5095c20e110c82ae602c254099b83b72f upstream.
>
> In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
> C") kvm_start_guest() became idle_kvm_start_guest(). The old code
> allocated a stack frame on the emergency stack, but didn't use the
> frame to store anything, and also didn't store anything in its caller's
> frame.

Please drop this and the next patch.

cheers
