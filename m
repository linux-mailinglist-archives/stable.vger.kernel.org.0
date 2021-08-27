Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3983F99E7
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbhH0NXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 09:23:44 -0400
Received: from ozlabs.org ([203.11.71.1]:41477 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245341AbhH0NXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 09:23:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gx0kp4HDfz9tjx;
        Fri, 27 Aug 2021 23:22:42 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Michael Neuling <mikey@neuling.org>,
        kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     kernel-janitors@vger.kernel.org, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v2 0/2] Kconfig symbol fixes on powerpc
Message-Id: <163007014161.52768.9837791663447874626.b4-ty@ellerman.id.au>
Date:   Fri, 27 Aug 2021 23:15:41 +1000
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

Patch 1 applied to powerpc/next.

[1/2] powerpc: kvm: remove obsolete and unneeded select
      https://git.kernel.org/powerpc/c/c26d4c5d4f0df7207da3975458261927f9305465

cheers
