Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E334F5B57
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbiDFKT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243468AbiDFKRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 06:17:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95742140DF;
        Tue,  5 Apr 2022 19:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0DBB7CE208B;
        Wed,  6 Apr 2022 02:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EEFC385A4;
        Wed,  6 Apr 2022 02:52:13 +0000 (UTC)
Date:   Tue, 5 Apr 2022 22:52:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220405225212.061852f9@gandalf.local.home>
In-Reply-To: <20220406023025.GA1926389@roeck-us.net>
References: <20220405070258.802373272@linuxfoundation.org>
        <20220406010749.GA1133386@roeck-us.net>
        <20220406023025.GA1926389@roeck-us.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Apr 2022 19:30:25 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> > s390 tests crashed. Other failed qemu tests did not compile.  
> 
> Bisect points to commit 93fe2389e6fd ("tracing: Have TRACE_DEFINE_ENUM
> affect trace event types as well"). Bisect log attached. Reverting the
> offending patch fixes the problem. Copying Steven for comments/input.

Do you have this commit?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=795301d3c2899

-- Steve

