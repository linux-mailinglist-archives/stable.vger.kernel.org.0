Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7845D753
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 10:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbhKYJj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 04:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349450AbhKYJiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 04:38:21 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BE6C061748;
        Thu, 25 Nov 2021 01:35:10 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J0CQg74YDz4xcs;
        Thu, 25 Nov 2021 20:35:07 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <ce30364fb7ccda489272af4a1612b6aa147e1d23.1637227521.git.christophe.leroy@csgroup.eu>
References: <ce30364fb7ccda489272af4a1612b6aa147e1d23.1637227521.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/32: Fix hardlockup on vmap stack overflow
Message-Id: <163783287691.1228083.396612201232244532.b4-ty@ellerman.id.au>
Date:   Thu, 25 Nov 2021 20:34:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Nov 2021 10:39:53 +0100, Christophe Leroy wrote:
> Since the commit c118c7303ad5 ("powerpc/32: Fix vmap stack - Do not
> activate MMU before reading task struct") a vmap stack overflow
> results in a hard lockup. This is because emergency_ctx is still
> addressed with its virtual address allthough data MMU is not active
> anymore at that time.
> 
> Fix it by using a physical address instead.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/32: Fix hardlockup on vmap stack overflow
      https://git.kernel.org/powerpc/c/5bb60ea611db1e04814426ed4bd1c95d1487678e

cheers
