Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E068647005
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 13:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiLHMuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 07:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLHMuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 07:50:08 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062BC8E5A3;
        Thu,  8 Dec 2022 04:49:59 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NSYs021q9z4xvd;
        Thu,  8 Dec 2022 23:49:56 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221201161442.2127231-1-mjeanson@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Message-Id: <167050321063.1457988.11365233998356574445.b4-ty@ellerman.id.au>
Date:   Thu, 08 Dec 2022 23:40:10 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Dec 2022 11:14:42 -0500, Michael Jeanson wrote:
> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
> changing from their dot prefixed variant to the non-prefixed ones.
> 
> Since ftrace prefixes a dot to the syscall names when matching them to
> build its syscall event list, this resulted in no syscall events being
> available.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
      https://git.kernel.org/powerpc/c/ad050d2390fccb22aa3e6f65e11757ce7a5a7ca5

cheers
