Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8817C842
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfGaQMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:12:43 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42392 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564589562; x=1596125562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FT0gsydchF82cS68STA6wiyM9uu6tySzq/9/ZLT4AwE=;
  b=s40UYZ/MsgT0rP5+rgL7Zn8gLMIXyrHv9p1zRMn3KXAbjlug1Salh3Gz
   NVLKqmHpuIJ1tLuxu+yH9D9RAPejrbW0/yWhbjZ65DI2Uykudq4K4ab4K
   A5qj1qKysPwHm8nISvciWt6R2aGoKahqtmfDRWkpM9rERKL8vrjHoEiks
   w=;
X-IronPort-AV: E=Sophos;i="5.64,330,1559520000"; 
   d="scan'208";a="815364065"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 31 Jul 2019 16:12:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 894B1222412;
        Wed, 31 Jul 2019 16:12:40 +0000 (UTC)
Received: from EX13D17UWB003.ant.amazon.com (10.43.161.42) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 16:12:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D17UWB003.ant.amazon.com (10.43.161.42) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 16:12:39 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 16:12:39 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id C200A87438; Wed, 31 Jul 2019 09:12:39 -0700 (PDT)
Date:   Wed, 31 Jul 2019 09:12:39 -0700
From:   Qian Lu <luqia@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>
Subject: Re: [PATCH 0/4] Fix NFSv4 lookup revalidation
Message-ID: <20190731161239.GA8365@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
References: <20190731071327.28701-1-luqia@amazon.com>
 <20190731093456.GE18269@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190731093456.GE18269@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 11:34:56AM +0200, Greg KH wrote:
> On Wed, Jul 31, 2019 at 12:13:23AM -0700, Qian Lu wrote:
> > Hello Greg,
> > 
> > Can you please consider including the following patches in the stable
> > linux-4.14.y branch?
> > 
> > The following patch series attempts to address the issues raised by
> > Stan Hu around NFSv4 lookup revalidation.
> > 
> > The first patch in the series should, in principle suffice to address
> > the exact issue raised by Stan, however when looking at the
> > implementation of nfs4_lookup_revalidate(), it becomes clear that we're
> > not doing enough to revalidate the dentry itself when performing NFSv4.1
> > opens either.
> > 
> 
> You can not just ignore the 4.19.y kernel tree for these patches, as
> when you all finally move forward from 4.14.y to 4.19.y, you would have
> hit these same exact issues :(
> 
> I have also queued them up to 4.19.y.
> 
> Well, except for the last patch, that's not needed at all.
> 
> thanks,
> 
> greg k-h

Thanks for catching that.

Thanks,
Qian
