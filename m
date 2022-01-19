Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81B6493933
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 12:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353991AbiASLGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 06:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiASLGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 06:06:31 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8091DC061574;
        Wed, 19 Jan 2022 03:06:31 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jf2rg1CJpz4y4Z;
        Wed, 19 Jan 2022 22:06:27 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, Maxime Bizon <mbizon@freebox.fr>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7a50ef902494d1325227d47d33dada01e52e5518.1641818726.git.christophe.leroy@csgroup.eu>
References: <7a50ef902494d1325227d47d33dada01e52e5518.1641818726.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v3] powerpc/32s: Fix kasan_init_region() for KASAN
Message-Id: <164259036257.3588160.3465491440781256341.b4-ty@ellerman.id.au>
Date:   Wed, 19 Jan 2022 22:06:02 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 15:29:25 +0000, Christophe Leroy wrote:
> It has been reported some configuration where the kernel doesn't
> boot with KASAN enabled.
> 
> This is due to wrong BAT allocation for the KASAN area:
> 
> 	---[ Data Block Address Translation ]---
> 	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw      m
> 	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw      m
> 	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw      m
> 	3: 0xf8000000-0xf9ffffff 0x2a000000        32M Kernel rw      m
> 	4: 0xfa000000-0xfdffffff 0x2c000000        64M Kernel rw      m
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/32s: Fix kasan_init_region() for KASAN
      https://git.kernel.org/powerpc/c/d37823c3528e5e0705fc7746bcbc2afffb619259

cheers
