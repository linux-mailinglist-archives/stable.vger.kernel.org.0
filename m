Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18F25276EF
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 12:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiEOKbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 06:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbiEOKbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 06:31:13 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B9DAE4B;
        Sun, 15 May 2022 03:31:12 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L1JZS1sXJz4xZv;
        Sun, 15 May 2022 20:31:12 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Laurent Dufour <ldufour@linux.ibm.com>, mpe@ellerman.id.au
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>, stable@vger.kernel.org
In-Reply-To: <20220504101244.12107-1-ldufour@linux.ibm.com>
References: <20220504101244.12107-1-ldufour@linux.ibm.com>
Subject: Re: [PATCH v3] powerpc/rtas: Keep MSR[RI] set when calling RTAS
Message-Id: <165261054578.1047019.8022784676618367625.b4-ty@ellerman.id.au>
Date:   Sun, 15 May 2022 20:29:05 +1000
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

On Wed, 4 May 2022 12:12:44 +0200, Laurent Dufour wrote:
> RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
> big endian mode (MSR[SF,LE] unset).
> 
> The change in MSR is done in enter_rtas() in a relatively complex way,
> since the MSR value could be hardcoded.
> 
> Furthermore, a panic has been reported when hitting the watchdog interrupt
> while running in RTAS, this leads to the following stack trace:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/rtas: Keep MSR[RI] set when calling RTAS
      https://git.kernel.org/powerpc/c/b6b1c3ce06ca438eb24e0f45bf0e63ecad0369f5

cheers
