Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B264068175F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbjA3ROm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 12:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbjA3ROl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 12:14:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D9A2BEE3;
        Mon, 30 Jan 2023 09:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 807A6611F3;
        Mon, 30 Jan 2023 17:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4049CC433D2;
        Mon, 30 Jan 2023 17:14:37 +0000 (UTC)
Date:   Mon, 30 Jan 2023 17:14:34 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/34] selftests: arm64: Fix incorrect kernel headers
 search path
Message-ID: <Y9f6+jkfE+zRWR+Z@arm.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-2-mathieu.desnoyers@efficios.com>
 <d44aa330-5767-58e0-77af-c6541252040b@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44aa330-5767-58e0-77af-c6541252040b@linuxfoundation.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shuah,

On Mon, Jan 30, 2023 at 09:09:42AM -0700, Shuah Khan wrote:
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
> > Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> > building against kernel headers from the build environment in scenarios
> > where kernel headers are installed into a specific output directory
> > (O=...).
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: <stable@vger.kernel.org>    [5.18+]
> > ---
> >   tools/testing/selftests/arm64/fp/Makefile   | 2 +-
> >   tools/testing/selftests/arm64/tags/Makefile | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> Adding arm maintainers.
> 
> Would you me to take this patch through kselftest tree? If you
> decide to take this through yours:

Are you taking the whole series? If yes:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(otherwise I can pick this up)

-- 
Catalin
