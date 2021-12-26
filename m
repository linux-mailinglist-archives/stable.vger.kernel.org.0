Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A3147F918
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 22:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhLZVyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 16:54:01 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:33671 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbhLZVyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 16:54:00 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JMZLt4mSnz4xmv;
        Mon, 27 Dec 2021 08:53:58 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, Emese Revfy <re.emese@gmail.com>,
        linux-kernel@vger.kernel.org,
        Erhard Furtner <erhard_f@mailbox.org>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <2bac55483b8daf5b1caa163a45fa5f9cdbe18be4.1640178426.git.christophe.leroy@csgroup.eu>
References: <2bac55483b8daf5b1caa163a45fa5f9cdbe18be4.1640178426.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/32: Fix boot failure with GCC latent entropy plugin
Message-Id: <164055556121.3187272.3735190778169205691.b4-ty@ellerman.id.au>
Date:   Mon, 27 Dec 2021 08:52:41 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Dec 2021 13:07:31 +0000, Christophe Leroy wrote:
> Boot fails with GCC latent entropy plugin enabled.
> 
> This is due to early boot functions trying to access 'latent_entropy'
> global data while the kernel is not relocated at its final
> destination yet.
> 
> As there is no way to tell GCC to use PTRRELOC() to access it,
> disable latent entropy plugin in early_32.o and feature-fixups.o and
> code-patching.o
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/32: Fix boot failure with GCC latent entropy plugin
      https://git.kernel.org/powerpc/c/bba496656a73fc1d1330b49c7f82843836e9feb1

cheers
