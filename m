Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C009012D25E
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfL3RDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:03:07 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:38018 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfL3RDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 12:03:07 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 52F5D72CCAE;
        Mon, 30 Dec 2019 20:03:05 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 13F784A4AE7;
        Mon, 30 Dec 2019 20:03:05 +0300 (MSK)
Date:   Mon, 30 Dec 2019 20:03:04 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] tools lib: Fix builds when glibc contains strlcpy
Message-ID: <20191230170304.btdoxtmods7d6ctq@altlinux.org>
References: <20191224172029.19690-1-vt@altlinux.org>
 <20191230005604.4FFA9207FF@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20191230005604.4FFA9207FF@mail.kernel.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

On Mon, Dec 30, 2019 at 12:56:03AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ce99091730c9 ("perf tools: Move strlcpy() from perf to tools/lib/string.c").
> 
> The bot has tested the following trees: v5.4.6, v5.3.18, v4.19.91, v4.14.160, v4.9.207.
> 
> v5.4.6: Build OK!
> v5.3.18: Build OK!
> v4.19.91: Failed to apply! Possible dependencies:
>     7bd330de43fd ("tools lib: Adopt skip_spaces() from the kernel sources")
> 
> v4.14.160: Failed to apply! Possible dependencies:
>     7bd330de43fd ("tools lib: Adopt skip_spaces() from the kernel sources")
> 
> v4.9.207: Failed to apply! Possible dependencies:
>     7bd330de43fd ("tools lib: Adopt skip_spaces() from the kernel sources")
>     96395cbbc7e9 ("tools lib string: Adopt prefixcmp() from perf and subcmd")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Yes, there is a trivial conflict when this patch is applied to stable trees.
Do you need any help in resolving it?

Thanks,

