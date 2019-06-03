Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C033034
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfFCMuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:50:14 -0400
Received: from mout.web.de ([217.72.192.78]:51579 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfFCMuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 08:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559566206;
        bh=ncAOMhhFgsUF2XN16mQShqw1rNbF+Fdi8FKqT34/XD8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=rTDGsqGBj17yUQp7FoSiYHvT2c5Frz/uZlELQ++2O0a+WOwC8SWvZmz/KZE9bxrVZ
         VAzAn3ny5LMVyiCgjea1wByNeqi/CZmRYX479353Cf7rxbydNvQqSLgS5kvxjfJr2l
         57GVpkA6NkUg1AItoqddyalNnxtc5UrGauOKOV7M=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.58.28] ([80.130.118.25]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0McWnE-1hGFWn3zYe-00HcGC; Mon, 03
 Jun 2019 14:50:06 +0200
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
 <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
 <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
 <20190601110247.v4lzwvqhuwrjrotb@linutronix.de>
From:   =?UTF-8?Q?S=c3=b6ren_Moch?= <smoch@web.de>
Message-ID: <4c7bf7c6-ed59-e1b6-47a4-0f5623d35ba5@web.de>
Date:   Mon, 3 Jun 2019 14:50:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601110247.v4lzwvqhuwrjrotb@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:qFn9Y+T56/6+a/FEeIJmIMcxZPT2LFJxYX2NkrgnS7uJ/mDJ2/K
 q/i2foJDu60xNCTkCWPc3PK7G1TI4KdvqwiiZ0AXGcONuJS6hqlcG/8hLOG9vid38cwVU1B
 ARFbVdaVTVY3NfTDHXFgQ25csXXWd0mpUC88ZWvoMH/t9RAXCjQGnil5GkBI6/+rCvdIAqu
 3FHFIVoF6knn2YhZRCrMQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4Cm5CqzsTSA=:F6v3mYZtH5Bz9b2q26Sa5q
 c3LITnLLJbEYanijSZ5IBbPBc1SX9Jhc9hNea/0IrrGD3BEZ5/f5TRzTgux4zTK1FwbnozN99
 N6wHiLZT6yPds1iAv7GkaNSQaMQgqpVG1x9tSQp1Sly/8N4F4I5orbcWHj5O5f+6KthmAeuTY
 wO+fceg6+sM5WyEEGRKRAMSFnlNykBDb4dXNe8wiGa4210kBtA2gyfveyeAdgdJ9QaYlqT0y2
 pEGxJ66WSzseFJdycAlmJ/eFlsLu1tSLXlMaoVTlY121I7KzhsiTLoBtp5qB0fm/wSOhiT8TR
 1sCckS5naQBhGb8YErdogmE7mm/dmoNP41UQCHirqZNeSvtg0dUdUH4UD8pywactecFBMMODx
 rcYF0KHuk+2Oxp9Zpr+0jKuOc09mSRhDYNbsJRbvnLyUOWWlANJMT/C+8RiL1fzZhUkxFxac+
 5jGCnA5Ltt7SRyro/lWPeMrpH9jCJI/NaXJzJT9GQxFqjSzoOXmMB11dqsJzrQGWWlFC71BFE
 oaVPooC57TQ14T+K7mST213fW0qPkk24KLoAKFmQxwHjWmvB4gXEPnKbeR/BEQUmAR4h0PF7T
 sC/9KGF1L5knuqApH+tEFIe+T/AWUIqcz1CIjnViiCfA2ApiLHvNb/dRtu7Q5NpvUJOjrr0CT
 rgg/o+UMtc3DGSIbsJkbs9Vw6DEBpx9HwoZUSkASuHLm5jvZlF3W9+OmyjOQsXcvsI7Bp5GFM
 tXbx0ZHCF/OCSro3WhwuNZf06HXRCsCi/FBwwrcTylUVARu/OtJzYg2aXe8KsGdG2gcIaAo3m
 UtIeMyFkaxgm3uAzIrqVtcP+jETVFI0vOt18KkgcMUJVZtqkhM4kGIkpc9DnMardhFOqkpqRH
 LSNgsEiObbv/gjpp3Wivwt0ljje2mkucNxLug7oI4RVVqgeq3qpNRdP8Igcrj29nMR67IPTKn
 jkWyZI2YSHoSPWKjMba6oS/3prZ2P9Jw=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01.06.19 13:02, Sebastian Andrzej Siewior wrote:
> On 2019-06-01 12:50:08 [+0200], To Soeren Moch wrote:
>> I will look into this.
> nothing obvious. If there is really blocken lock, could you please
> enable lockdep
> |CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
> |CONFIG_PROVE_LOCKING=3Dy
> |# CONFIG_LOCK_STAT is not set
> |CONFIG_DEBUG_RT_MUTEXES=3Dy
> |CONFIG_DEBUG_SPINLOCK=3Dy
> |CONFIG_DEBUG_MUTEXES=3Dy
> |CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
> |CONFIG_DEBUG_RWSEMS=3Dy
> |CONFIG_DEBUG_LOCK_ALLOC=3Dy
> |CONFIG_LOCKDEP=3Dy
> |# CONFIG_DEBUG_LOCKDEP is not set
> |CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
>
> and send me the splat that lockdep will report?
>
I will do so. I cannot promise, however, that this will happen within
the next few days.

Thanks for your suggestions,
Soeren

