Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D691D655874
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 06:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiLXFW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 00:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLXFW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 00:22:56 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A66CE0BE
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 21:22:55 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p8wzl-0002Hq-0J; Sat, 24 Dec 2022 06:22:53 +0100
Message-ID: <8c3034f1-bedd-0e43-46e5-1e1fdca238a5@leemhuis.info>
Date:   Sat, 24 Dec 2022 06:22:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop
Content-Language: en-US, de-DE
To:     Sergio Callegari <sergio.callegari@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
 <Y6W6Qxwq94y9QGFl@kroah.com> <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671859375;e714ffe3;
X-HE-SMSGID: 1p8wzl-0002Hq-0J
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 23.12.22 20:51, Sergio Callegari wrote:
> On 23/12/2022 15:25, Greg KH wrote:
>
>> Reported to the distro, but seems serious enough to report here too. 

Out of curiosity: where?

>> Can you use 'git bisect' to find the offending commit?
> 
> Must learn a bit more about the distro I am using and what it requires
> for a custom kernel but I may try.

I'm writing a document I plan to submit for inclusion that might be of
help for you:

http://www.leemhuis.info/files/misc/How%20to%20quickly%20build%20a%20Linux%20kernel%20%e2%80%94%20The%20Linux%20Kernel%20documentation.html

It doesn't cover bisection, I left that for later (and maybe separate
document), as I want this one reviewed and merged first.

Ciao, Thorsten
