Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E1B47ED12
	for <lists+stable@lfdr.de>; Fri, 24 Dec 2021 09:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351957AbhLXIYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Dec 2021 03:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351955AbhLXIYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Dec 2021 03:24:07 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DC5C061401;
        Fri, 24 Dec 2021 00:24:07 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n0fru-0007sC-JA; Fri, 24 Dec 2021 09:24:02 +0100
Message-ID: <b4470632-9209-ce77-937f-656566d333b3@leemhuis.info>
Date:   Fri, 24 Dec 2021 09:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        mmokrejs@gmail.com
Subject: iwlwifi: loosing connection to AP (regression from 5.4.143) (fwd from
 b.k.o bug 215401)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1640334247;04d431dd;
X-HE-SMSGID: 1n0fru-0007sC-JA
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

Forwarding a regression reported in bugzilla.kernel.org, to ensure
all the interested parties are aware of it, as quite a few (many?)
subsystems don't react at all to reports in that bug tracker.

https://bugzilla.kernel.org/show_bug.cgi?id=215401

> Martin Mokrejs 2021-12-23 20:25:45 UTC
> 
> Created attachment 300133 [details] dmesg-5.4.167.txt
> 
> Hi, I jumped from 5.4.143 to 5.4.167 but the connection to wifi was
> so unstable I had to reboot to use the old kernel. I never used git
> bisect and am not sure I have that much time to play with that.
> However, let me say that I lost about 5x connection to AP. Sooner or
> later after each situation I disconnected from the AP using nm-applet
> and re-connected. That has helped for a short while, liek a few
> minutes, then I again lost network connection. Maybe you can find the
> event in the dmesg output.
> 
> Once, for some reason, there is also a stacktrace from the kernel.
> Why just onceinstead of about 5 times I have no idea.
> 
> I could provide the same kernel messages supplemented with daemon
> messages from syslog.
> 
> Hope this helps to some extent,

Feel free to either continue discussing this here or in the ticket, I
don't care.

To be sure this issue doesn't fall through the cracks unnoticed, I'm
also adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot introduced v5.4.143 to v5.4.167
#regzbot title: net: iwlwifi: frequently loosing connection to AP
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215401

Reminder: when fixing the issue, please link to this mail and the bug
entry with a link tag.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave thus might sent someone reading this down the wrong
rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c
