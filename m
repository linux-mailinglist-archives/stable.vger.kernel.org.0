Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2FF00D5
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbfKEPJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 10:09:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44980 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725385AbfKEPJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 10:09:55 -0500
Received: (qmail 2356 invoked by uid 2102); 5 Nov 2019 10:09:54 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 5 Nov 2019 10:09:54 -0500
Date:   Tue, 5 Nov 2019 10:09:54 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Oliver Neukum <oneukum@suse.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
In-Reply-To: <1572964580.2921.21.camel@suse.com>
Message-ID: <Pine.LNX.4.44L0.1911051007140.1678-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Nov 2019, Oliver Neukum wrote:

> Am Montag, den 04.11.2019, 22:45 +0100 schrieb Greg Kroah-Hartman:
> >         Since commit ea44d190764b ("usbip: Implement SG support to
> >         vhci-hcd and stub driver") was merged, the USB/IP driver can
> >         also handle SG.
> 
> Hi,
> 
> same story as 4.4.x

I'm not sure about uas, but it was reported just yesterday that the 
corresponding commit for usb-storage caused a 30% speed degradation:

	https://marc.info/?l=linux-usb&m=157293660212040&w=2

Given this information, perhaps you will decide that the revert is 
worthwhile.

Alan Stern

