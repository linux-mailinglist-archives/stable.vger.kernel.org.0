Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA436C45E4
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 10:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCVJNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 05:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCVJNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 05:13:39 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986FD252BD;
        Wed, 22 Mar 2023 02:13:37 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1peuXH-00045z-Jf; Wed, 22 Mar 2023 10:13:35 +0100
Message-ID: <fc081e0f-2b58-b169-5ac1-f7845f48d1bf@leemhuis.info>
Date:   Wed, 22 Mar 2023 10:13:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        Hans de Goede <hdegoede@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
To:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [regression] Bug 217225 - can no longer alter /proc/acpi/ibm/fan
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1679476417;ce60d401;
X-HE-SMSGID: 1peuXH-00045z-Jf
X-Spam-Status: No, score=0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developers don't keep an eye on it, I decided to forward it by
mail (note, the reporter *is not* CCed to this mail, see[1]).

Note, it's a stable regression, so it's a bit unclear who's responsible.
I decided to forward it nevertheless, as some of you might want to be
aware of this or might even have an idea what's wrong.

Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217225 :

>  runrin 2023-03-21 17:49:34 UTC
>
> I occasionally manage my fan speed manually by changing the `level' in
> `/proc/acpi/ibm/fan'. As of upgrading to 6.1.20, I am now getting the
> following error when attempting to change the fan speed:
> 
> $ echo 'level auto' > /proc/acpi/ibm/fan
> echo: write error: invalid argument
> 
> While troubleshooting, I tried double checking that fan_control had been
> set to 1 as noted in the documentation.
> 
> I recently upgraded my kernel a few versions at once, so unfortunately i
> can't be sure when this bug originated. It was working with 6.1.15, and
> since upgrading to 6.1.20 it is no longer working.

See the ticket for more details. The reporter was already asked to
bisect. I'll ask to consider testing latest mainline.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.1.15..v6.1.20
https://bugzilla.kernel.org/show_bug.cgi?id=217225
#regzbot title: platform: thinkpad: can no longer alter /proc/acpi/ibm/fan
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

[1] because bugzilla.kernel.org tells users upon registration their
"email address will never be displayed to logged out users"
