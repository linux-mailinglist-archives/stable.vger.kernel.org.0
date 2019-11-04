Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50897EE7D3
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 20:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDTBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 14:01:30 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:16219 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDTB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 14:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=905; q=dns/txt; s=iport;
  t=1572894089; x=1574103689;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W5OtNT7B9VKcYP2OwOf1wwXYIaKQw8WGW+dE86Fk86Y=;
  b=JgSKREJgd37JV60NNVDFFQKdKdPhGsrhr65b9n8GpW09f+xZGPzLtFIg
   /46q9dKEbpyuTAX6M+P3gDtYXbY+gJdKYaB4MhTdq/2Hy8KWzfmO3CBbu
   QuAEqcF9Ut7JFK63GM7Y1uupVcMEITPH9k1ZyJKvNS07LHoFwF4DaJAaG
   I=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0C3AAD4dMBd/4UNJK1mDgsBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBAREBAQEBAQEBAQEBAYF9giBsVTIqkziCEI8FhH6FPIFnCQE?=
 =?us-ascii?q?BAQwBASUKAQGEQAKEDiQ4EwIDAQMCAwIBAQQBAQECAQUEbYU3DIVSAQU6PxA?=
 =?us-ascii?q?LGAklDwUoIRODI4J3D7FmgieJDYFCBhQOgRSMExiBQD+BEYMSPoJiBBiBLwS?=
 =?us-ascii?q?GAgSMcESJSpZ0gi5thiSOGScMmVktlkORKQIEBgUCFYFpIoFYMxoIGxWDKBI?=
 =?us-ascii?q?9ERSCa4ZngjuFBFwgAzEBAQGMK4I+AQE?=
X-IronPort-AV: E=Sophos;i="5.68,267,1569283200"; 
   d="scan'208";a="372477450"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Nov 2019 19:01:28 +0000
Received: from zorba ([10.154.200.29])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id xA4J1PmS021404
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 19:01:27 GMT
Date:   Mon, 4 Nov 2019 11:01:23 -0800
From:   Daniel Walker <danielwa@cisco.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: usb-storage: Set virt_boundary_mask to avoid SG overflows
Message-ID: <20191104190123.GG18744@zorba>
References: <20191104182044.GF18744@zorba>
 <Pine.LNX.4.44L0.1911041344050.1689-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1911041344050.1689-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.154.200.29, [10.154.200.29]
X-Outbound-Node: alln-core-11.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 01:45:11PM -0500, Alan Stern wrote:
> On Mon, 4 Nov 2019, Daniel Walker wrote:
> 
> > Hi,
> > 
> > This is a stable defect report.
> > 
> > We're tracking v4.9 stable for some of our products (i.e. Cisco Systems, Inc.)
> > We noticed a speed degradation of roughly %30 on writes to a /dev/sdaX device
> > over USB (no file system). We bisected the issue to this commit from Alan Stern.
> > We also found a prior report of speed degradation on NTFS,
> > 
> > https://lore.kernel.org/linux-usb/Pine.LNX.4.44L0.1908291030400.1306-100000@iolanthe.rowland.org/T/
> > 
> > We have the patch reverted in our v4.9 tree on top of stable. It seems Alan was
> > planning to remove these lines. If the lines are planned to be removed is there
> > an reason why they haven't been ?
> 
> See https://marc.info/?l=linux-usb&m=157167288816325&w=2
> 

Ok .. Thanks.

Daniel
