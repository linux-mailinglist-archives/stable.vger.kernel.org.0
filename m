Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903153B96AA
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhGATnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 15:43:42 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:57654 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233671AbhGATnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 15:43:41 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2021 15:43:41 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id D68D1181179C7
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 19:35:31 +0000 (UTC)
Received: from omf06.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id C82ED182CF666;
        Thu,  1 Jul 2021 19:35:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 6CD962448B8;
        Thu,  1 Jul 2021 19:35:30 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 01 Jul 2021 12:35:29 -0700
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paul Burton <paulburton@google.com>,
        Joel Fernandes <joelaf@google.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
In-Reply-To: <20210701142624.44bb4dde@oasis.local.home>
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
 <YN38D3dg0fLzL0Ia@google.com> <20210701140754.5847a50f@oasis.local.home>
 <YN4Fpl+dhijItkUP@google.com> <20210701142624.44bb4dde@oasis.local.home>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <51babd56c2fe53ba011152700a546151@perches.com>
X-Sender: joe@perches.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.90
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 6CD962448B8
X-Stat-Signature: 8b1988hbxa8dkbeondchxrn7teat51ri
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19G+PKuYMGNpgor/GEopWJcjhvhoKlY1NU=
X-HE-Tag: 1625168130-156347
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-01 11:26, Steven Rostedt wrote:
> [ Added Joe Perches ]
> 
> On Thu, 1 Jul 2021 11:12:54 -0700
> Paul Burton <paulburton@google.com> wrote:
> 
>> > not to mention, we don't
>> > use '//' comments in the kernel, so that would have to be changed.
>> 
>> D'oh! Apparently a year away from the kernel melted my internal style
>> checker. Interestingly though, checkpatch didn't complain about this 
>> as
>> I would have expected...
> 
> Joe, should the above be added to checkpatch?
> 
> I do understand that there are a few cases it's acceptable. Like for
> SPDX headers.

C99 comments are allowed since about 5 years ago.

And if you really want there's a checkpatch option to disable them.

https://lore.kernel.org/patchwork/patch/1031132/

