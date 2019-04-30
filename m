Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A753FAAC
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfD3NmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfD3NmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 09:42:02 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB95F21670;
        Tue, 30 Apr 2019 13:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556631722;
        bh=/90F4eiHADPr/PeBRxzyJ8YiGWRn0dPTeMIByqScb3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O02fL2NnREybVHgWKQ5NT4xa6J1e13n+BNWF0+2/D5xRK+2H0xA58MYSXETrcShFj
         9vVIRQsUwbZxLaw8q+EPAFXk7MzskmBBrVRjVzKBQHeiaz2V626Gg06E4KEIwfb4vq
         TraWSrqh7hZ4hiH9fsE9JVehA5dT7KPP9FTR3zfI=
Date:   Tue, 30 Apr 2019 09:41:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Major Hayden <major@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190430134159.GB6937@sasha-vm>
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
 <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
 <20190430130331.GA6937@sasha-vm>
 <20190430132700.GA12407@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190430132700.GA12407@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 03:27:00PM +0200, Greg KH wrote:
>On Tue, Apr 30, 2019 at 09:03:31AM -0400, Sasha Levin wrote:
>> Hello CKI folks,
>>
>> A minor nit: the icon added before the subject text gets filtered out on
>> the textual email clients most of us use, and ends up appearing (at
>> least for me) as 3 spaces that cause much annoyance since it gets
>> confused with mail threading.
>
>
>Really?  It's just a "normal" emoji character, perhaps you need a better
>email client or terminal window?  :)
>
>What are you using that you can't see this in a terminal?

Um, mutt on xterm...
