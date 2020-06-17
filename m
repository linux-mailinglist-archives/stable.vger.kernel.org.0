Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508631FCEE1
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 15:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgFQNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 09:54:40 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:57711 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgFQNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 09:54:40 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05HDs0rp028106;
        Wed, 17 Jun 2020 06:54:05 -0700
Date:   Wed, 17 Jun 2020 19:24:00 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Cc:     stable@vger.kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Dakshaja Uppalapati <dakshaja@chelsio.com>
Subject: Re: [PATCH for-stable nvmet 0/6] nvme: Fix for blk_update_request IO
 error.
Message-ID: <20200617135359.GA10394@chelsio.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611155339.9429-1-dakshaja@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, June 06/11/20, 2020 at 21:23:33 +0530, Dakshaja Uppalapati wrote:
> The below error is seen in dmesg, while formatting the disks discovered on host.
> 
> dmesg:
>         [  636.733374] blk_update_request: I/O error, dev nvme4n1, sector 0 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> 
> Patch 6 fixes it and there are 5 other dependent patches that also need to be 
> pulled from upstream to stable, 5.4 and 4.19 branches.
> 
> Patch 1 dependent patch
> 
> Patch 2 dependent patch
> 
> Patch 3 dependent patch
> 
> Patch 4 dependent patch
> 
> Patch 5 dependent patch
> 
> Patch 6 fix patch

Hi all,

Gentle Reminder.

Thanks,
Dakshaja
