Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6E24EBD8
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgHWGna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 02:43:30 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6737 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgHWGn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 02:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598165009; x=1629701009;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ucEbTgYy5hKDmBPLaGPNpMSSyIVMSObKnFKACTZJ9Q4=;
  b=i1WKUo6bcumR3dRNKRBHXy02Q1raKSQVxXV4kxw3Q66QJaHQklS/If3d
   x5Z+4Q3eNbiry1dKZlq+hgHGeLxW+wgIKhwDsDSWMjAgS+6/wvR7s6DCC
   +CozyjZYCT0CBT8m1Bl5vW1nKjqL8NKknIWIknXHzG3yJyFwqXB5gwePP
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,343,1592870400"; 
   d="scan'208";a="49394692"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 23 Aug 2020 06:43:28 +0000
Received: from EX13D19EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 7AC97A1E3D;
        Sun, 23 Aug 2020 06:43:26 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.162.40) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 23 Aug 2020 06:43:21 +0000
Subject: Re: [PATCH AUTOSEL 5.8 55/62] RDMA/efa: Add EFA 0xefa1 PCI ID
To:     Sasha Levin <sashal@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Shadi Ammouri <sammouri@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        <linux-rdma@vger.kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
 <20200821161423.347071-55-sashal@kernel.org>
 <20200821194036.GB2811093@nvidia.com> <20200821195322.GC8670@sasha-vm>
 <20200821201952.GB2811871@nvidia.com> <20200821203421.GD8670@sasha-vm>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <ff34f370-66c2-6c2d-89ea-5ebaf965b37f@amazon.com>
Date:   Sun, 23 Aug 2020 09:43:15 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821203421.GD8670@sasha-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.40]
X-ClientProxiedBy: EX13D23UWA002.ant.amazon.com (10.43.160.40) To
 EX13D19EUB001.ant.amazon.com (10.43.166.229)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/2020 23:34, Sasha Levin wrote:
> On Fri, Aug 21, 2020 at 05:19:52PM -0300, Jason Gunthorpe wrote:
>> On Fri, Aug 21, 2020 at 03:53:22PM -0400, Sasha Levin wrote:
>>> On Fri, Aug 21, 2020 at 04:40:36PM -0300, Jason Gunthorpe wrote:
>>> > On Fri, Aug 21, 2020 at 12:14:16PM -0400, Sasha Levin wrote:
>>> > > From: Gal Pressman <galpress@amazon.com>
>>> > >
>>> > > [ Upstream commit d4f9cb5c5b224dca3ff752c1bb854250bf114944 ]
>>> > >
>>> > > Add support for 0xefa1 devices.
>>> > >
>>> > > Link: https://lore.kernel.org/r/20200722140312.3651-5-galpress@amazon.com
>>> > > Reviewed-by: Shadi Ammouri <sammouri@amazon.com>
>>> > > Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
>>> > > Signed-off-by: Gal Pressman <galpress@amazon.com>
>>> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> > >  drivers/infiniband/hw/efa/efa_main.c | 6 ++++--
>>> > >  1 file changed, 4 insertions(+), 2 deletions(-)
>>> >
>>> > Wait, what? Why is this being autosel'd?
>>>
>>> Stable trees try to pick up device enablement patches (such as patches
>>> that add PCI IDs). I suppose that AUTOSEL get pretty eager to grab
>>> those.
>>
>> Is it so common that old drivers will work with new HW with just a
>> PCI_ID update?
>>
>> I would have guessed that is the minority situation
> 
> So keep in mind that a lot of it is not brand new HW, but rather same
> HW repackaged by a different vendor, or HW that received minor tweaks
> but where the old driver still works.
> 
> I suppose it's more common in the USB ID world these days, so I guess
> I'll give PCI IDs a closer look next time.

FWIW, Jason is right, this patch will break without taking the rest of the series:
https://lore.kernel.org/linux-rdma/20200722140312.3651-1-galpress@amazon.com/

Thanks Jason and Sasha.
