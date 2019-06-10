Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484A33B7A1
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbfFJOmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:42:47 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:9580 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389178AbfFJOmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:42:46 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 10:42:45 EDT
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
CC:     Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
 <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
 <20190610074840.GB24746@kroah.com> <20190610063340.051ee13b@lwn.net>
 <20190610140528.GA18627@kroah.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <f53d2786-a857-d69c-2ead-6e4c19708d6c@mageia.org>
Date:   Mon, 10 Jun 2019 17:27:39 +0300
MIME-Version: 1.0
In-Reply-To: <20190610140528.GA18627@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C020A.5CFE6C66.0018,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 10-06-2019 kl. 17:05, skrev Greg Kroah-Hartman:
> On Mon, Jun 10, 2019 at 06:33:40AM -0600, Jonathan Corbet wrote:
>> On Mon, 10 Jun 2019 09:48:40 +0200
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>>> Hm, 2.1 here:
>>> 	Running Sphinx v2.1.0
>>> perhaps Tumbleweed needs to update?  :)
>>
>> Heh...trying 2.1 is still on my list of things to do ... :)
>>
>>> Anyway, this should not be breaking, if Jon doesn't have any ideas, I'll
>>> just drop these changes.
>>
>> The fix for that is 551bd3368a7b (drm/i915: Maintain consistent
>> documentation subsection ordering) which was also marked for stable.  Jiri,
>> do you somehow not have that one?
> 
> It's part of this series, which is probably why it works for me.  Don't
> know why it doesn't work for Jiri, unless he is cherry-picking things?
> 

Actualliy it is not.

This patch Jiri responded to / points out to break stuff is part of 
5.1.8, but the fix in in review queue for 5.1.9 :

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-5.1/drm-i915-maintain-consistent-documentation-subsection-ordering.patch?id=29167bff7a1c0d79dda104c44c262b0bc4cd6644

--
Thomas
