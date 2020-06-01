Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BD21EA7FD
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 18:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFAQw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 12:52:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:2755 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgFAQw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 12:52:57 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 051GqjAu032016;
        Mon, 1 Jun 2020 09:52:46 -0700
Date:   Mon, 1 Jun 2020 22:22:45 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200601165244.GA2809@chelsio.com>
References: <20200521140642.GA4724@chelsio.com>
 <20200526102542.GA2772976@kroah.com>
 <20200528074426.GA20353@chelsio.com>
 <20200528083403.GB2920930@kroah.com>
 <20200601162143.GA917@chelsio.com>
 <20200601162750.GA887723@kroah.com>
 <20200601164520.GA29339@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601164520.GA29339@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, June 06/01/20, 2020 at 22:15:20 +0530, Dakshaja Uppalapati wrote:
> On Monday, June 06/01/20, 2020 at 18:27:50 +0200, Greg KH wrote:
> > On Mon, Jun 01, 2020 at 09:51:44PM +0530, Dakshaja Uppalapati wrote:
> > > On Thursday, May 05/28/20, 2020 at 10:34:03 +0200, Greg KH wrote:
> > > > On Thu, May 28, 2020 at 01:14:31PM +0530, Dakshaja Uppalapati wrote:
> > > > > On Tuesday, May 05/26/20, 2020 at 12:25:42 +0200, Greg KH wrote:
> > > > > > On Thu, May 21, 2020 at 07:36:43PM +0530, Dakshaja Uppalapati wrote:
> > > > > > > Hi all,
> > > > > > > 
> > > > > > > Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
> > > > > > > 2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
> > > > > > > 1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 
> > > > > > 
> > > > > > What issue is that?  Your url is wrapped and can not work here :(
> > > > > 
> > > > > Sorry for that, when I tried to format the disk discovered from target machine
> > > > > the below error is seen in dmesg.
> > > > > 
> > > > > dmesg:
> > > > > 	[ 1844.868480] blk_update_request: I/O error, dev nvme0c0n1, sector 0 
> > > > > 	op 0x3:(DISCARD) flags 0x4000800 phys_seg 1 prio class 0
> > > > > 
> > > > > The above issue is seen from kernel-5.5-rc1 onwards.
> > > > > 
> > > > > > 
> > > > > > > In upstream issue is fixed with commit b716e6889c95f64b.
> > > > > > 
> > > > > > Is this a regression or support for something new that has never worked
> > > > > > before?
> > > > > > 
> > > > > 
> > > > > This is a regression, bisects points to the commit 530436c4 and fixed with
> > > > > commit b716e688 in upstream.
> > > > > 
> > > > > Now same issue is seen with stable kernel-5.4.41, 530436c4 is part of it.
> > > > 
> > > > So why don't we just revert 530436c45ef2 ("nvme: Discard workaround for
> > > > non-conformant devices") from the stable trees?  Will that fix the issue
> > > > for you instead of the much-larger set of backports you are proposing?
> > > > 
> > > > Also, is this an issue for you in the 4.19 releases?  The above
> > > > mentioned patch showed up in 4.19.92 and 5.4.7.
> > > > 
> > > 
> > > Yes, on 4.19 stable kernel too issue is seen. By reverting 530436c45ef2 issue
> > > is not seen on both 4.19 and 5.4 stable kernels. Do you want me to send the
> > > reverted patch?
> > 
> > Yes please.
> 
> Attached the reverted patch.PFA.

Sorry, was hurry in replying. will send out as a kernel patch.

Thanks,
Dakshaja
