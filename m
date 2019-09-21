Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFFBB9DCA
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437828AbfIUMUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 08:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437826AbfIUMUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 08:20:39 -0400
Received: from oasis.local.home (rrcs-24-39-165-138.nys.biz.rr.com [24.39.165.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8982720717;
        Sat, 21 Sep 2019 12:20:37 +0000 (UTC)
Date:   Sat, 21 Sep 2019 08:20:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tom Zanussi <zanussi@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [for-next][PATCH 3/8] tracing: Make sure variable reference
 alias has correct var_ref_idx
Message-ID: <20190921082035.4fc9ccc5@oasis.local.home>
In-Reply-To: <20190921120618.DF81120665@mail.kernel.org>
References: <20190919232359.825502403@goodmis.org>
        <20190921120618.DF81120665@mail.kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 21 Sep 2019 12:06:18 +0000
Sasha Levin <sashal@kernel.org> wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: .
> 
> The bot has tested the following trees: v5.2.16, v4.19.74, v4.14.145, v4.9.193, v4.4.193.


The fixes tag is 7e8b88a30b085 which was added to mainline in 4.17.
According to this email, it applies fine to 5.2 and 4.19, but fails on
4.14 and earlier. As the commit was added in 4.17 that makes perfect
sense. Can you update your scripts to test when the fixes commit was
added, and not send spam about it not applying to stable trees where
it's not applicable.

On a git repo containing only Linus's tree, I have:

$ git describe --contains 7e8b88a30b085
v4.17-rc1~28^2~43

Which shows me when it was applied.

Thanks!

-- Steve



> 
> v5.2.16: Build OK!
> v4.19.74: Build OK!
> v4.14.145: Failed to apply! Possible dependencies:
>     00b4145298ae ("ring-buffer: Add interface for setting absolute time stamps")
>     067fe038e70f ("tracing: Add variable reference handling to hist triggers")
>     0d7a8325bf33 ("tracing: Clean up hist_field_flags enum")
>     100719dcef44 ("tracing: Add simple expression support to hist triggers")
>     30350d65ac56 ("tracing: Add variable support to hist triggers")
>     442c94846190 ("tracing: Add Documentation for log2 modifier")
>     5819eaddf35b ("tracing: Reimplement log2")
>     7e8b88a30b08 ("tracing: Add hist trigger support for variable reference aliases")
>     85013256cf01 ("tracing: Add hist_field_name() accessor")
>     860f9f6b02e9 ("tracing: Add usecs modifier for hist trigger timestamps")
>     8b7622bf94a4 ("tracing: Add cpu field for hist triggers")
>     ad42febe51ae ("tracing: Add hist trigger timestamp support")
>     b559d003a226 ("tracing: Add hist_data member to hist_field")
>     b8df4a3634e0 ("tracing: Move hist trigger Documentation to histogram.txt")
> 
> v4.9.193: Failed to apply! Possible dependencies:
>     00b4145298ae ("ring-buffer: Add interface for setting absolute time stamps")
>     067fe038e70f ("tracing: Add variable reference handling to hist triggers")
>     0d7a8325bf33 ("tracing: Clean up hist_field_flags enum")
>     100719dcef44 ("tracing: Add simple expression support to hist triggers")
>     30350d65ac56 ("tracing: Add variable support to hist triggers")
>     442c94846190 ("tracing: Add Documentation for log2 modifier")
>     5819eaddf35b ("tracing: Reimplement log2")
>     7e8b88a30b08 ("tracing: Add hist trigger support for variable reference aliases")
>     85013256cf01 ("tracing: Add hist_field_name() accessor")
>     860f9f6b02e9 ("tracing: Add usecs modifier for hist trigger timestamps")
>     8b7622bf94a4 ("tracing: Add cpu field for hist triggers")
>     ad42febe51ae ("tracing: Add hist trigger timestamp support")
>     b559d003a226 ("tracing: Add hist_data member to hist_field")
>     b8df4a3634e0 ("tracing: Move hist trigger Documentation to histogram.txt")
> 
> v4.4.193: Failed to apply! Possible dependencies:
>     08d43a5fa063 ("tracing: Add lock-free tracing_map")
>     0c4a6b4666e8 ("tracing: Add hist trigger 'hex' modifier for displaying numeric fields")
>     0fc3813ce103 ("tracing: Add 'hist' trigger Documentation")
>     52a7f16dedff ("tracing: Add support for multiple hist triggers per event")
>     5463bfda327b ("tracing: Add support for named hist triggers")
>     76a3b0c8ac34 ("tracing: Add hist trigger support for compound keys")
>     7e8b88a30b08 ("tracing: Add hist trigger support for variable reference aliases")
>     7ef224d1d0e3 ("tracing: Add 'hist' event trigger command")
>     83e99914c9e2 ("tracing: Add hist trigger support for pausing and continuing a trace")
>     8b7622bf94a4 ("tracing: Add cpu field for hist triggers")
>     b8df4a3634e0 ("tracing: Move hist trigger Documentation to histogram.txt")
>     c6afad49d127 ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
>     e62347d24534 ("tracing: Add hist trigger support for user-defined sorting ('sort=' param)")
>     f2606835d70d ("tracing: Add hist trigger support for multiple values ('vals=' param)")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

