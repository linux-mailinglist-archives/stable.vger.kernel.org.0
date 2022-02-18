Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2ED4BAFA0
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 03:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiBRCYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 21:24:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiBRCYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 21:24:46 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3C56582E;
        Thu, 17 Feb 2022 18:24:30 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K0FrX2PKXz4xZq;
        Fri, 18 Feb 2022 13:24:28 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Anders Roxell <anders.roxell@linaro.org>, mpe@ellerman.id.au
Cc:     stable@vger.kernel.org, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20220211005113.1361436-1-anders.roxell@linaro.org>
References: <20220211005113.1361436-1-anders.roxell@linaro.org>
Subject: Re: [PATCHv2] powerpc/lib/sstep: fix 'ptesync' build error
Message-Id: <164515104019.912400.12978382532397324353.b4-ty@ellerman.id.au>
Date:   Fri, 18 Feb 2022 13:24:00 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Feb 2022 01:51:13 +0100, Anders Roxell wrote:
> Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> 2.37.90.20220207) the following build error shows up:
> 
> {standard input}: Assembler messages:
> {standard input}:2088: Error: unrecognized opcode: `ptesync'
> make[3]: *** [/builds/linux/scripts/Makefile.build:287: arch/powerpc/lib/sstep.o] Error 1
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/lib/sstep: fix 'ptesync' build error
      https://git.kernel.org/powerpc/c/fe663df7825811358531dc2e8a52d9eaa5e3515e

cheers
