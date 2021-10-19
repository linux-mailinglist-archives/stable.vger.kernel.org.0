Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED51E433402
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhJSK50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:57:26 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:34981 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbhJSK5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:57:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYVy06QWHz4xbb;
        Tue, 19 Oct 2021 21:55:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634640905;
        bh=x2ytmbg7gwsAE45QXX+LTY1Rs6nJEpauqSbvOn/silc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=n7TTWWOBd6RX+p/IN+p268kU2u6ImzN06R5YXKjhPZBFCVaR2Ks6FdIxmAwcuyCio
         bOXGp8dEpDYRQqSjdUnqKrPpS6v0+Dl7qtTq3Dhgf8kTm3UapvTGpCURinNTbEIl4X
         4LRr4MdQsBZRPlIVOtg3KZWbB9jig0DIdXujL7V524VLdShFemNJLtKFZh1XGEgKn8
         +StDoM1BkHq3l7AuAzflrxKtO5L1K3iVG8FoNMm4e4RcR+1ndug1Z+ehePaVwA32IZ
         ZdD0MYcH4gnm6Q7iwg5aM2/hwg4YlTbj3mCa61a/oP7ZV9NIct/dqnvB18oGCChpzA
         EYqh4NxBNv+Vg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.14 060/151] KVM: PPC: Book3S HV: Fix stack handling in
 idle_kvm_start_guest()
In-Reply-To: <20211018132342.644684017@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
 <20211018132342.644684017@linuxfoundation.org>
Date:   Tue, 19 Oct 2021 21:55:04 +1100
Message-ID: <87a6j5cmif.fsf@mpe.ellerman.id.au>
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
