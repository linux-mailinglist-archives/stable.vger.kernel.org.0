Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF92620B45F
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgFZPVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:21:14 -0400
Received: from cheddar.halon.org.uk ([93.93.131.118]:53658 "EHLO
        cheddar.halon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFZPVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 11:21:14 -0400
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1joqAA-00039I-HM; Fri, 26 Jun 2020 16:21:10 +0100
Received: from steve by tack.einval.org with local (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1joq9b-0000vt-0G; Fri, 26 Jun 2020 16:20:35 +0100
Date:   Fri, 26 Jun 2020 16:20:34 +0100
From:   Steve McIntyre <steve@einval.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jann Horn <jannh@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        963493@bugs.debian.org
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+
 onwards
Message-ID: <20200626152034.GA2950@unset.einval.com>
References: <20200626113558.GA32542@unset.einval.com>
 <20200626134132.GB4024297@kroah.com>
 <20200626134518.GB32542@unset.einval.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626134518.GB32542@unset.einval.com>
X-attached: unknown
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 02:45:18PM +0100, Steve McIntyre wrote:
>Hey Greg,
>
>On Fri, Jun 26, 2020 at 03:41:32PM +0200, Greg KH wrote:
>>On Fri, Jun 26, 2020 at 12:35:58PM +0100, Steve McIntyre wrote:
>>> 
>>> e58f543fc7c0926f31a49619c1a3648e49e8d233 is the first bad commit
>>> commit e58f543fc7c0926f31a49619c1a3648e49e8d233
>>> Author: Jann Horn <jannh@google.com>
>>> Date:   Thu Sep 13 18:12:09 2018 +0200
>
>...
>
>>> Annoyingly, I can't reproduce this on my disparate other machines
>>> here, suggesting it's maybe(?) timing related.
>>> 
>>> Hope this helps - happy to give more information, test things, etc.
>>
>>So if you just revert this one patch, all works well?
>
>Correct.
>
>>I've added the authors of the patch to the cc: list...
>>
>>Also, does this problem happen on Linus's tree?
>
>Just building to check that now...

Current head here (3e08a95294a4fb3702bb3d35ed08028433c37fe6) works fine.

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
The two hard things in computing:
 * naming things
 * cache invalidation
 * off-by-one errors                  -- Stig Sandbeck Mathisen

