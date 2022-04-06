Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19824F6605
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbiDFQs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiDFQrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:47:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9342747D93E;
        Wed,  6 Apr 2022 07:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D8EECE23F3;
        Wed,  6 Apr 2022 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10884C385A1;
        Wed,  6 Apr 2022 14:10:06 +0000 (UTC)
Date:   Wed, 6 Apr 2022 10:10:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220406101005.25d1f915@gandalf.local.home>
In-Reply-To: <Yk1Op5c0mbtR0VLw@kroah.com>
References: <20220405070258.802373272@linuxfoundation.org>
        <20220406010749.GA1133386@roeck-us.net>
        <20220406023025.GA1926389@roeck-us.net>
        <20220405225212.061852f9@gandalf.local.home>
        <20220405230812.2feca4ed@gandalf.local.home>
        <20220405232413.6b38e966@gandalf.local.home>
        <Yk1LMYzEOv7vmEHR@kroah.com>
        <Yk1N5Vg+YrGxrfVo@kroah.com>
        <Yk1Op5c0mbtR0VLw@kroah.com>
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

On Wed, 6 Apr 2022 10:26:15 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> Wait, no, I did catch this!  And I sent you a "FAILED" email about it, 4
> of them:
> 	https://lore.kernel.org/r/164905985821176@kroah.com
> 	https://lore.kernel.org/r/16490598521299@kroah.com
> 	https://lore.kernel.org/r/1649059845215213@kroah.com
> 	https://lore.kernel.org/r/16490598398133@kroah.com
> as the commit applied, but broke the build:

Yes, I know, that's how I knew it was an issue ;-)

> 
> But I didn't drop the offending commit, I should have done that.

Correct.

Oh, so I guess it got in because it applied, but broke the build. Thus,
your scripts catch when a Fixes does not apply, but doesn't handle the
"broken build / boot" case?

> 
> I'll go and drop the offending commit here, if you could submit both of
> them as working backports to stable@vger if/when you want them queued up
> there, that would be great.

The patch that got backported only fixes an issue with new events (hence
why I did not mark it for stable). If those events are not backported,
there's no reason to backport this one.

-- Steve
