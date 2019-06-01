Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1425531B89
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfFALCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 07:02:50 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:33274 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfFALCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 07:02:50 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hX1mh-0001op-Aa; Sat, 01 Jun 2019 13:02:47 +0200
Date:   Sat, 1 Jun 2019 13:02:47 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
Message-ID: <20190601110247.v4lzwvqhuwrjrotb@linutronix.de>
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
 <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
 <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-01 12:50:08 [+0200], To Soeren Moch wrote:
> I will look into this. 

nothing obvious. If there is really blocken lock, could you please
enable lockdep
|CONFIG_LOCK_DEBUGGING_SUPPORT=y
|CONFIG_PROVE_LOCKING=y
|# CONFIG_LOCK_STAT is not set
|CONFIG_DEBUG_RT_MUTEXES=y
|CONFIG_DEBUG_SPINLOCK=y
|CONFIG_DEBUG_MUTEXES=y
|CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
|CONFIG_DEBUG_RWSEMS=y
|CONFIG_DEBUG_LOCK_ALLOC=y
|CONFIG_LOCKDEP=y
|# CONFIG_DEBUG_LOCKDEP is not set
|CONFIG_DEBUG_ATOMIC_SLEEP=y

and send me the splat that lockdep will report?
 
> > Thanks,
> > Soeren

Sebastian
