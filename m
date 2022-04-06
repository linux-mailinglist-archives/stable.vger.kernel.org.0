Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03914F5843
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 11:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiDFJB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451947AbiDFI6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 04:58:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F24C46F055;
        Tue,  5 Apr 2022 20:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A378561583;
        Wed,  6 Apr 2022 03:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F77C385A1;
        Wed,  6 Apr 2022 03:24:15 +0000 (UTC)
Date:   Tue, 5 Apr 2022 23:24:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220405232413.6b38e966@gandalf.local.home>
In-Reply-To: <20220405230812.2feca4ed@gandalf.local.home>
References: <20220405070258.802373272@linuxfoundation.org>
        <20220406010749.GA1133386@roeck-us.net>
        <20220406023025.GA1926389@roeck-us.net>
        <20220405225212.061852f9@gandalf.local.home>
        <20220405230812.2feca4ed@gandalf.local.home>
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

On Tue, 5 Apr 2022 23:08:12 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Here's a thought, if you decide to backport a patch to stable, and you see
> that there's another commit with a "Fixes" tag to the automatically
> selected commit. DO NOT BACKPORT IF THE FIXES PATCH FAILS TO GO BACK TOO!

Seriously. This should be the case for *all* backported patches, not just
the AUTOSEL ones.

Otherwise you are backporting a commit to "stable" that is KNOWN TO BE
BROKEN!

-- Steve
