Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3DFD52
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfD3P6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfD3P6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 11:58:30 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C863620652;
        Tue, 30 Apr 2019 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556639909;
        bh=gLvUo0PVbsKWUhNTXoRz0q3JP79bPp+a6vmVaj32p7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E05n12pkbU3zIIkUKp3e1fvZPluLic7eyNZfwV417u0qiB26w95QSNK31nUHWi12w
         FEON5Rj/kPO2nsPEqE+LfP8CEnFHBnviWacXyP+RNxJFwhGSdOKtNkMxdHRAdXqRxG
         OPZ/4E9TKGHCUHtw+Tdr7jkVKLZerUUpnXIKKAGY=
Date:   Tue, 30 Apr 2019 11:58:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Major Hayden <major@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190430155827.GC6937@sasha-vm>
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
 <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
 <20190430130331.GA6937@sasha-vm>
 <20190430132700.GA12407@kroah.com>
 <20190430134159.GB6937@sasha-vm>
 <20190430140125.GA18765@kroah.com>
 <641778a3-be33-d07a-1120-4a49a5010c89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <641778a3-be33-d07a-1120-4a49a5010c89@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 10:17:17AM -0500, Major Hayden wrote:
>On 4/30/19 9:01 AM, Greg KH wrote:
>> On Tue, Apr 30, 2019 at 09:41:59AM -0400, Sasha Levin wrote:
>>> On Tue, Apr 30, 2019 at 03:27:00PM +0200, Greg KH wrote:
>>>> On Tue, Apr 30, 2019 at 09:03:31AM -0400, Sasha Levin wrote:
>>>>> Hello CKI folks,
>>>>>
>>>>> A minor nit: the icon added before the subject text gets filtered out on
>>>>> the textual email clients most of us use, and ends up appearing (at
>>>>> least for me) as 3 spaces that cause much annoyance since it gets
>>>>> confused with mail threading.
>>>>
>>>> Really?  It's just a "normal" emoji character, perhaps you need a better
>>>> email client or terminal window?  :)
>>>>
>>>> What are you using that you can't see this in a terminal?
>>> Um, mutt on xterm...
>> Use a "modern" terminal program please, that's the problem here.  I just
>> tried 4 different ones (gnome-terminal, terminology, tilix, and kitty),
>> and they all worked just fine.
>>
>> With mutt :)
>
>We can change the email format very easily. If removing the emoji in the subject line would be better, that's a really quick change for us.
>
>Our hope was that it would make it easier to identify automated CI results and make it easier to know the feedback when you're looking at a lot of email threads.

I thought this was an issue for more people than just me. I'll just use
a newer terminal emulator :)

--
Thanks,
Sasha
