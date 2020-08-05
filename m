Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D743323C99C
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgHEJyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgHEJvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:51:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C5732173E;
        Wed,  5 Aug 2020 09:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596621112;
        bh=Eqk7MjvnWxQK1x/nn99iki3wP79uGrG2FxYKqg58rEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hGaHdttDj4rGsig6k6PFI/0xrX/Oya19Ddh3RNXrG25Z36vB16NIJIXKUv7914Gas
         WKe6TW6tKh+ny13k2jD+AHF63SyDmdrJWQ99GGAufbuAMCcTG5DQJ+lBLnc38Xa02N
         JuwNWIGBUbUo1upZg05Ld7gLBavXHJl0Hc+G3yB0=
Date:   Wed, 5 Aug 2020 11:52:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Garry <john.garry@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        yanaijie <yanaijie@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 01/51] scsi: libsas: direct call probe and destruct
Message-ID: <20200805095202.GA1634853@kroah.com>
References: <20200803121849.488233135@linuxfoundation.org>
 <20200803121849.564535738@linuxfoundation.org>
 <8743227b-adb3-ed1f-3559-e562555ac045@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8743227b-adb3-ed1f-3559-e562555ac045@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 01:57:14PM +0100, John Garry wrote:
> On 03/08/2020 13:19, Greg Kroah-Hartman wrote:
> > From: Jason Yan <yanaijie@huawei.com>
> > 
> > [ Upstream commit 0558f33c06bb910e2879e355192227a8e8f0219d ]
> > 
> 
> Hi Greg,
> 
> This patch was one of a series from Jason to fix this WARN issue, below:
> 
> https://lore.kernel.org/linux-scsi/8f6e3763-2b04-23e8-f1ec-8ed3c58f55d3@huawei.com/
> 
> I'm doubtful that it should be taken in isolation. Maybe 1 or 2 other
> patches are required.
> 
> The WARN was really annoying, so we could spend a bit of time to test a
> backport of what is strictly required. Let us know.

Ok, I'll drop this for now, if you want to submit the patch series fully
backported, we will be glad to review it.

thanks,

greg k-h
