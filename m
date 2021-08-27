Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE1F3F9A2A
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhH0N3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 09:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245350AbhH0N3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 09:29:20 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA5AC061757;
        Fri, 27 Aug 2021 06:28:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gx0sS3ky9z9s1l;
        Fri, 27 Aug 2021 23:28:28 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v2 0/2] Kconfig symbol fixes on powerpc
Message-Id: <163007088913.57684.694810119971696811.b4-ty@ellerman.id.au>
Date:   Fri, 27 Aug 2021 23:28:09 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Aug 2021 13:39:52 +0200, Lukas Bulwahn wrote:
> The script ./scripts/checkkconfigsymbols.py warns on invalid references to
> Kconfig symbols (often, minor typos, name confusions or outdated references).
> 
> This patch series addresses all issues reported by
> ./scripts/checkkconfigsymbols.py in ./drivers/usb/ for Kconfig and Makefile
> files. Issues in the Kconfig and Makefile files indicate some shortcomings in
> the overall build definitions, and often are true actionable issues to address.
> 
> [...]

Patch 2 applied to powerpc/fixes.

[2/2] powerpc: rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK
      https://git.kernel.org/powerpc/c/310d2e83cb9b7f1e7232319880e3fcb57592fa10

cheers
