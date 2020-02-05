Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B251528B5
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 10:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgBEJyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 04:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgBEJys (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 04:54:48 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B64C2051A;
        Wed,  5 Feb 2020 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580896488;
        bh=FbsLcLxrgywvb4AqmGU0GXUNyPg1tOpALfiZanC9iOk=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=0AJA63T7SrPMGZjNYjHb2jJioL3UucJSleYm9GFi3bLiYBg9tGAH37CxeF/zyDkqc
         JBc3a/tgAEC0qzzu1X/OaWDvS5vEoxq53m3ZVamtMPsMm49nVQq2zJv5nxmTBPUiWH
         yWoK6CjcKy0Ui54LNKY2xSOD/OLL4UoFAcfOpmhg=
Date:   Wed, 5 Feb 2020 10:54:44 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Enderborg, Peter" <Peter.Enderborg@sony.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com" 
        <syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
In-Reply-To: <08ff9caa-0473-fae3-6f98-8530ed4c3b1a@sony.com>
Message-ID: <nycvar.YFH.7.76.2002051053060.26888@cbobk.fhfr.pm>
References: <20200114094352.428808181@linuxfoundation.org> <20200114094356.028051662@linuxfoundation.org> <27ba705a-6734-9a92-a60c-23e27c9bce6d@sony.com> <20200205093226.GC1164405@kroah.com> <08ff9caa-0473-fae3-6f98-8530ed4c3b1a@sony.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Feb 2020, Enderborg, Peter wrote:

> >> This patch breaks Elgato StreamDeck.
>
> > Does that mean the device is broken with a too-large of a report?
> 
> Yes.

In which way does the breakage pop up? Are you getting "report too long" 
errors in dmesg, or the device just doesn't enumerate at all?

Could you please post /sys/kernel/debug/hid/<device>/rdesc contents, and 
if the device is at least semi-alive, also contents of 
/sys/kernel/debug/hid/<device>/events from the time it misbehaves?

> > Is it broken in Linus's tree?  If so, can you work with the HID
> > developers to fix it there so we can backport the fix to all stable
> > trees?
> 
> I cant see that there are any other fixes upon this so I dont think so. 
> I can try.
>
> 
> Jiri is in the loop. I guess he is the "HID developers" ?

Thanks,

-- 
Jiri Kosina
SUSE Labs

