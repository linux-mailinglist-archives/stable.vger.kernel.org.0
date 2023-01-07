Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA9660CBA
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 08:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjAGHNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 02:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAGHNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 02:13:38 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E85C53;
        Fri,  6 Jan 2023 23:13:37 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pE3OX-0004hI-QT; Sat, 07 Jan 2023 08:13:34 +0100
Message-ID: <a7bba4b9-e24e-0214-0fa7-a7f738afde25@leemhuis.info>
Date:   Sat, 7 Jan 2023 08:13:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Content-Language: en-US, de-DE
To:     Tyler Hicks <code@tyhicks.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230104160511.905925875@linuxfoundation.org>
 <Y7cmMKUr//oYKWXb@duo.ucw.cz> <Y7fGpYyaJWym1BxW@kroah.com>
 <Y7i0ZukMa9CX+fzo@sequoia>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Y7i0ZukMa9CX+fzo@sequoia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673075617;021b1813;
X-HE-SMSGID: 1pE3OX-0004hI-QT
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.01.23 00:53, Tyler Hicks wrote:
>
> 2. Do you (or anyone else) happen to have a list of the known
>    regressions? I see one specific to linux-6.1.y in the regzbot list:
> 
>     https://linux-regtracking.leemhuis.info/regzbot/stable/

That page only lists regressions that where introduced in stable (e.g.
say in a range like v6.1.1..v6.1.2) which might need to be handled by
the stable team (for example if a regression is caused by incomplete
backport).

All that where introduced in mainline (e.g. v6.0..v6.1) are listed on
the mainline page, as those need to be fixed in mainline by the regular
developers (e.g. never by the stable team) before they can be backported
to the stable series[1]:

https://linux-regtracking.leemhuis.info/regzbot/mainline/

There are plenty for v6.0..v6.1 currently, which is unusual, but that
can happen this time of the year. I hope the situation improves somewhat
over the next two weeks when more people are back from the holidays.

Ciao, Thorsten

[1] which is true for some of those that are introduced in the stable
series as well. That's one of the reasons why I'm not really happy with
how rezbot exposes those regressions and will improve this sooner or
later, but there are more important things on the todo list for now.
