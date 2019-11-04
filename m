Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1BEE761
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 19:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfKDS14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 13:27:56 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:56290 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDS14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 13:27:56 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 13:27:55 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=664; q=dns/txt; s=iport;
  t=1572892075; x=1574101675;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6eYi3wjyJDjYDvEnI2nl2Du9wgudJvIY7ANx7M1zMok=;
  b=lZlF6RzDCbzmPeeiW+OAN/NYSEtmr/XTNFZrOiLfEMgPaI3L+WH/V8e0
   lXuSPPk/rNUNv129pbjFRKPfZ4dpUKOPxdAMBExbAeiTi07aA69YnXjbS
   foZfYxG7N5KMD9KxsRPXIW4rgbcYXdIaYIIcJyfS/HAJrziARtTNz86//
   Y=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0C2AAB7asBd/4sNJK1mDgsBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBAREBAQEBAQEBAQEBAYF9giBsVTIqkzaRFYR+hTyBZwkBAQE?=
 =?us-ascii?q?MAQElCgEBhECEECQ4EwIDCwEBBAEBAQIBBQRthTcMhhI/GyE0BSghARKDI4J?=
 =?us-ascii?q?3D7FdgieJBoFCBhQOgRSMExiBQD+BEYMSPoQtBINWgiwEjHBEiUqHcI8Egi5?=
 =?us-ascii?q?thiSOGScMmVktjhWILpEpAgQGBQIVgWkiKoEuMxoIGxWDKBI9ERSMDYUEXCA?=
 =?us-ascii?q?DMQEBAYwrgj4BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,267,1569283200"; 
   d="scan'208";a="365533773"
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Nov 2019 18:20:48 +0000
Received: from zorba ([10.154.200.29])
        by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xA4IKkpK001680
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:20:47 GMT
Date:   Mon, 4 Nov 2019 10:20:44 -0800
From:   Daniel Walker <danielwa@cisco.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: usb-storage: Set virt_boundary_mask to avoid SG overflows
Message-ID: <20191104182044.GF18744@zorba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.154.200.29, [10.154.200.29]
X-Outbound-Node: alln-core-6.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is a stable defect report.

We're tracking v4.9 stable for some of our products (i.e. Cisco Systems, Inc.)
We noticed a speed degradation of roughly %30 on writes to a /dev/sdaX device
over USB (no file system). We bisected the issue to this commit from Alan Stern.
We also found a prior report of speed degradation on NTFS,

https://lore.kernel.org/linux-usb/Pine.LNX.4.44L0.1908291030400.1306-100000@iolanthe.rowland.org/T/

We have the patch reverted in our v4.9 tree on top of stable. It seems Alan was
planning to remove these lines. If the lines are planned to be removed is there
an reason why they haven't been ?

Thanks,
Daniel
