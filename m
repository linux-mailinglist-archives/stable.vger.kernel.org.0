Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B17CEE795
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 19:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDSpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 13:45:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55324 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727998AbfKDSpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 13:45:12 -0500
Received: (qmail 5423 invoked by uid 2102); 4 Nov 2019 13:45:11 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 4 Nov 2019 13:45:11 -0500
Date:   Mon, 4 Nov 2019 13:45:11 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Daniel Walker <danielwa@cisco.com>
cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        <xe-linux-external@cisco.com>
Subject: Re: usb-storage: Set virt_boundary_mask to avoid SG overflows
In-Reply-To: <20191104182044.GF18744@zorba>
Message-ID: <Pine.LNX.4.44L0.1911041344050.1689-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Nov 2019, Daniel Walker wrote:

> Hi,
> 
> This is a stable defect report.
> 
> We're tracking v4.9 stable for some of our products (i.e. Cisco Systems, Inc.)
> We noticed a speed degradation of roughly %30 on writes to a /dev/sdaX device
> over USB (no file system). We bisected the issue to this commit from Alan Stern.
> We also found a prior report of speed degradation on NTFS,
> 
> https://lore.kernel.org/linux-usb/Pine.LNX.4.44L0.1908291030400.1306-100000@iolanthe.rowland.org/T/
> 
> We have the patch reverted in our v4.9 tree on top of stable. It seems Alan was
> planning to remove these lines. If the lines are planned to be removed is there
> an reason why they haven't been ?

See https://marc.info/?l=linux-usb&m=157167288816325&w=2

Alan Stern

