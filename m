Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B58B5133F8
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346563AbiD1Mpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 08:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346556AbiD1MpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 08:45:15 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF56BAFB1D
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 05:41:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KpwH71V9Bz4x7Y;
        Thu, 28 Apr 2022 22:41:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1651149715;
        bh=angbs4k+nefnWKYYA4PyhQF8HIwJeqJDKwFomJisFV8=;
        h=From:To:Cc:Subject:Date:From;
        b=phxVTDZ11wzTf6qMuKjvp9ReQ3nrmVkIgNz4g6KTDOvzKsl1Ng4XdxT0WLwUpUw8L
         MZwHIjhtFzkb1QIUyvhMIxJqx4r+ywfxh8NAAbhd7zbu3jsJqaZRVNhQ4eQ+fnl7aK
         7+LDrI0M+lxmdG7+7R2AIA365RPc3EXayKsyIZhqub8AuzBzdfB7XZM3oAoliZhkY9
         hqylqptCg+8O5tBRXrUQ4PisGzUbeMzQqnJSUnFcPyj95ig1mnHJA570Pc1InTvug/
         RYGxr3ExpStbkH5v55NtMOmxPaaTWYypmnb9tYyuZQJCedzp7shzQD7FpyN+eCvwRf
         TZGU8SkZF8OKg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
Cc:     <linuxppc-dev@lists.ozlabs.org>, <npiggin@gmail.com>
Subject: [PATCH v4.19 0/2] Custom backports for powerpc SLB issues
Date:   Thu, 28 Apr 2022 22:41:48 +1000
Message-Id: <20220428124150.375623-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here are two custom backports to v4.19 for some powerpc issues we've discovered.
Both were fixed upstream as part of a large non-backportable rewrite. Other stable
kernel versions are not affected.

cheers

Michael Ellerman (1):
  powerpc/64s: Unmerge EX_LR and EX_DAR

Nicholas Piggin (1):
  powerpc/64/interrupt: Temporarily save PPR on stack to fix register
    corruption due to SLB miss

 arch/powerpc/include/asm/exception-64s.h | 37 ++++++++++++++----------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
2.35.1

