Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E81BA0A0
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 06:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfIVEWY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 22 Sep 2019 00:22:24 -0400
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:40186 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbfIVEWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 00:22:23 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2019 00:22:22 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 547161801DBD1;
        Sun, 22 Sep 2019 04:12:55 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 0E38F18029122;
        Sun, 22 Sep 2019 04:12:52 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:152:355:379:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1513:1515:1516:1518:1521:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2895:3138:3139:3140:3141:3142:3353:3865:3867:3868:3870:3871:3872:3873:3874:4184:4362:5007:7652:7875:7903:9036:9040:10004:10400:10848:10967:11232:11473:11658:11914:12297:12740:12895:13069:13095:13255:13311:13357:14096:14097:14180:14181:14721:14777:21060:21080:21433:21451:21627:21819:30022:30026:30054:30070:30083:30090:30091,0,RBL:185.81.136.21:@goodmis.org:.lbl8.mailshell.net-62.14.175.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: wish09_530bb02a28129
X-Filterd-Recvd-Size: 2444
Received: from [10.102.230.9] (unknown [185.81.136.21])
        (Authenticated sender: rostedt@goodmis.org)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun, 22 Sep 2019 04:12:50 +0000 (UTC)
Date:   Sat, 21 Sep 2019 15:23:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20190921192108.GB8171@sasha-vm>
References: <20190919232359.825502403@goodmis.org> <20190921120618.DF81120665@mail.kernel.org> <20190921082035.4fc9ccc5@oasis.local.home> <20190921192108.GB8171@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [for-next][PATCH 3/8] tracing: Make sure variable reference alias has correct var_ref_idx
To:     Sasha Levin <sashal@kernel.org>
CC:     Tom Zanussi <zanussi@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        stable@vger.kernel.org
From:   Steven Rostedt <rostedt@goodmis.org>
Message-ID: <DF859F5E-4DBB-43C8-BD25-7E261240AE8C@goodmis.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On September 21, 2019 3:21:08 PM EDT, Sasha Levin <sashal@kernel.org> wrote:
>On Sat, Sep 21, 2019 at 08:20:35AM -0400, Steven Rostedt wrote:
>>On Sat, 21 Sep 2019 12:06:18 +0000
>>Sasha Levin <sashal@kernel.org> wrote:
>>
>>> Hi,
>>>
>>> [This is an automated email]
>>>
>>> This commit has been processed because it contains a "Fixes:" tag,
>>> fixing commit: .
>>>
>>> The bot has tested the following trees: v5.2.16, v4.19.74,
>v4.14.145, v4.9.193, v4.4.193.
>>
>>
>>The fixes tag is 7e8b88a30b085 which was added to mainline in 4.17.
>>According to this email, it applies fine to 5.2 and 4.19, but fails on
>>4.14 and earlier. As the commit was added in 4.17 that makes perfect
>>sense. Can you update your scripts to test when the fixes commit was
>>added, and not send spam about it not applying to stable trees where
>>it's not applicable.
>
>The script already does that. What happened here is that it got
>confused
>with your previous "Fixes:" statement in the commit message and went
>haywire.
>
>I thought that something like this shouldn't happen because I grep for
>"^fixes:", but looks like something is broken. I'll go fix that...


Thanks!

-- Steve

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
