Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8465658E3
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiGDOqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiGDOqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653C2DEC5;
        Mon,  4 Jul 2022 07:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01053616C2;
        Mon,  4 Jul 2022 14:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F8EC3411E;
        Mon,  4 Jul 2022 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656945978;
        bh=Pd8bOydNgagNlzM2jEnf+b0RCzLznrRr1KtZ3YY8Fdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlxfBTghgbYYw3LLCP/brHUH7sId2SktlL/XJGPU/apFOSBb5pnbEksg+CpvDOub9
         U60B8QVEEOXscaGsoULTpy2txlIiNyDjtd8ch2NjI5MeTJFUSTtPzweUKv+ED10kCW
         D2Rvmhhn0r9VFfm9twPWVWsmOrmzzXfnXHio5POQ=
Date:   Mon, 4 Jul 2022 16:46:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     stable@vger.kernel.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, ast@kernel.org
Subject: Re: [PATCH stable 5.15 1/1] selftests/bpf: Add test_verifier support
 to fixup kfunc call insns
Message-ID: <YsL9N8ItUlQaevCs@kroah.com>
References: <20220701130858.282569-1-po-hsu.lin@canonical.com>
 <20220701130858.282569-2-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701130858.282569-2-po-hsu.lin@canonical.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 09:08:58PM +0800, Po-Hsu Lin wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> commit 0201b80772ac2b712bbbfe783cdb731fdfb4247e upstream.
> 
> This allows us to add tests (esp. negative tests) where we only want to
> ensure the program doesn't pass through the verifier, and also verify
> the error. The next commit will add the tests making use of this.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Link: https://lore.kernel.org/r/20220114163953.1455836-9-memxor@gmail.com
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [PHLin: backport due to lack of fixup_map_timer]
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

Now queued up, thanks.

greg k-h
