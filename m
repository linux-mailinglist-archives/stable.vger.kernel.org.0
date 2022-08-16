Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D936596538
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 00:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiHPWK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 18:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiHPWKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 18:10:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AD21DA64;
        Tue, 16 Aug 2022 15:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A824B81B55;
        Tue, 16 Aug 2022 22:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BF2C433D6;
        Tue, 16 Aug 2022 22:10:50 +0000 (UTC)
Date:   Tue, 16 Aug 2022 18:10:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: Big load on lkml created by -stable patchbombs was Re: [PATCH
 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <20220816181058.3a3fb20d@gandalf.local.home>
In-Reply-To: <20220816115614.GB27428@duo.ucw.cz>
References: <20220815180439.416659447@linuxfoundation.org>
        <YvruPKI4dCyrXCp5@home.goodmis.org>
        <YvsocKly+n9S4CsB@kroah.com>
        <20220816115614.GB27428@duo.ucw.cz>
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

On Tue, 16 Aug 2022 13:56:14 +0200
Pavel Machek <pavel@denx.de> wrote:

> I'm pretty used to -stable patches going to l-k, so I got used to
> current workflow. OTOH ... -stable _is_ quite significant fraction of
> total lkml traffic, and I see how people may hate that.

The thing I hate is that this slows down the other mailing lists. It
doesn't just affect LKML. It affects *all* lists. Even the ones that just
get a dozen emails a day. But the emails that do come, are important.

Perhaps another answer is to dedicate the LKML emails to their own servers,
and let the other mailing lists run separately such that the patch bombs to
LKML do not affect any of the other lists.

That would be an acceptable solution for me ;-)

-- Steve
