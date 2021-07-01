Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD723B97F7
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 23:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhGAVJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 17:09:51 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:56280 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234151AbhGAVJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 17:09:50 -0400
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id E3D8F182CED5B;
        Thu,  1 Jul 2021 21:07:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 77068315D74;
        Thu,  1 Jul 2021 21:07:18 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 01 Jul 2021 14:07:17 -0700
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paul Burton <paulburton@google.com>,
        Joel Fernandes <joelaf@google.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
In-Reply-To: <20210701155100.3f29ddfb@oasis.local.home>
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
 <YN38D3dg0fLzL0Ia@google.com> <20210701140754.5847a50f@oasis.local.home>
 <YN4Fpl+dhijItkUP@google.com> <20210701142624.44bb4dde@oasis.local.home>
 <51babd56c2fe53ba011152700a546151@perches.com>
 <20210701155100.3f29ddfb@oasis.local.home>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <5666edba28107559db23ba0f948c1f82@perches.com>
X-Sender: joe@perches.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.90
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 77068315D74
X-Stat-Signature: 7ezs15xuepy81mreabkq3bga6aqa5ixg
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18QJBnlgCIF4CcCd9WYonRkxvguCApxAec=
X-HE-Tag: 1625173638-534825
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-01 12:51, Steven Rostedt wrote:
> On Thu, 01 Jul 2021 12:35:29 -0700
> Joe Perches <joe@perches.com> wrote:
> 
>> C99 comments are allowed since about 5 years ago.
> 
> Really, I thought Linus hated them. Personally, I find them rather ugly
> myself. The only user of them I see in the kernel/ directory appears to
> be for RCU. But Paul's on the C/C++ committee, so perhaps he favors 
> them.
> 
> The net/ directory doesn't have any, except perhaps to comment out code
> (which I sometimes use it for that too).
> 
> The block/, arch/x86/ directories don't have them either.
> 
> I wouldn't go and change checkpatch, but I still rather avoid them,
> especially for multi line comments.
> 
>  /*
>   * When it comes to multi line comments I prefer using something
>   * that denotes a start and an end to the comment, as it makes it
>   * look like a nice clip of information.
>   */
> 
> Instead of:
> 
>   // When it comes to multi line comments I prefer using something
>   // that denotes a start and an end to the comment, as it makes it
>   // look like a nice clip of information.
> 
> Which just looks like noise. But hey, maybe that's just me because I
> find "*" as a sign of information and '//' something to ignore. ;-)

May I suggest using something other than an amber vt220?



