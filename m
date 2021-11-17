Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B764945459A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 12:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhKQL2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 06:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbhKQL2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 06:28:38 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F29AC061570;
        Wed, 17 Nov 2021 03:25:39 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HvLFr4hkdz4xdS;
        Wed, 17 Nov 2021 22:25:36 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <a21e9a057fe2d247a535aff0d157a54eefee017a.1636963688.git.christophe.leroy@csgroup.eu>
References: <a21e9a057fe2d247a535aff0d157a54eefee017a.1636963688.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX
Message-Id: <163714821663.1508509.919431268872483842.b4-ty@ellerman.id.au>
Date:   Wed, 17 Nov 2021 22:23:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 09:08:36 +0100, Christophe Leroy wrote:
> As spotted and explained in commit c12ab8dbc492 ("powerpc/8xx: Fix
> Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST"), the selection
> of STRICT_KERNEL_RWX without selecting DEBUG_RODATA_TEST has spotted
> the lack of the DIRTY bit in the pinned kernel data TLBs.
> 
> This problem should have been detected a lot earlier if things had
> been working as expected. But due to an incredible level of chance or
> mishap, this went undetected because of a set of bugs: In fact the
> DTLBs were not pinned, because instead of setting the reserve bit
> in MD_CTR, it was set in MI_CTR that is the register for ITLBs.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX
      https://git.kernel.org/powerpc/c/1e35eba4055149c578baf0318d2f2f89ea3c44a0

cheers
