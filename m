Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8D2153395
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgBEPBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:01:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37892 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726334AbgBEPBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 10:01:00 -0500
Received: (qmail 1623 invoked by uid 2102); 5 Feb 2020 10:00:58 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 5 Feb 2020 10:00:58 -0500
Date:   Wed, 5 Feb 2020 10:00:58 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Jiri Kosina <jikos@kernel.org>
cc:     "Enderborg, Peter" <Peter.Enderborg@sony.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com" 
        <syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
In-Reply-To: <nycvar.YFH.7.76.2002051053060.26888@cbobk.fhfr.pm>
Message-ID: <Pine.LNX.4.44L0.2002051000050.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Feb 2020, Jiri Kosina wrote:

> On Wed, 5 Feb 2020, Enderborg, Peter wrote:
> 
> > >> This patch breaks Elgato StreamDeck.
> >
> > > Does that mean the device is broken with a too-large of a report?
> > 
> > Yes.
> 
> In which way does the breakage pop up? Are you getting "report too long" 
> errors in dmesg, or the device just doesn't enumerate at all?
> 
> Could you please post /sys/kernel/debug/hid/<device>/rdesc contents, and 
> if the device is at least semi-alive, also contents of 
> /sys/kernel/debug/hid/<device>/events from the time it misbehaves?

Also, please post the output from "lsusb -v" for the StreamDeck.

Alan Stern

