Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1945459D
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 12:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbhKQL2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 06:28:41 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:57869 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbhKQL2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 06:28:39 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HvLFv1hzMz4xdV;
        Wed, 17 Nov 2021 22:25:39 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Stan Johnson <userm57@yahoo.com>,
        "Christopher M . Riedl" <cmr@bluescreens.de>
In-Reply-To: <99ef38d61c0eb3f79c68942deb0c35995a93a777.1636966353.git.christophe.leroy@csgroup.eu>
References: <99ef38d61c0eb3f79c68942deb0c35995a93a777.1636966353.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/signal32: Fix sigset_t copy
Message-Id: <163714821584.1508509.9112860111598863862.b4-ty@ellerman.id.au>
Date:   Wed, 17 Nov 2021 22:23:35 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 09:52:55 +0100, Christophe Leroy wrote:
> The conversion from __copy_from_user() to __get_user() by
> commit d3ccc9781560 ("powerpc/signal: Use __get_user() to copy
> sigset_t") introduced a regression in __get_user_sigset() for
> powerpc/32. The bug was subsequently moved into
> unsafe_get_user_sigset().
> 
> The bug is due to the copied 64 bit value being truncated to
> 32 bits while being assigned to dst->sig[0]
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/signal32: Fix sigset_t copy
      https://git.kernel.org/powerpc/c/5499802b2284331788a440585869590f1bd63f7f

cheers
