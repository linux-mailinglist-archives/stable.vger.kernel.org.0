Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FA029074B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408886AbgJPOg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:36:58 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60020 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408874AbgJPOg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:36:58 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8A02020B4907;
        Fri, 16 Oct 2020 07:36:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8A02020B4907
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602859017;
        bh=QdB6hOLIafPBVzYZzrgl4ZkzYOSFRgWbJR+dtVU32yE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=J3nyzUL1+BZSwre+3T3Xkg6psxeRrOjRAwMAI1lAiifS7yO5kk52Ct8ppAQRifGng
         K8Vd4lbQI53/4dh/WulZxf9BvZfTeKK+yuAxL/PXrsjITvuHx4sAvR/cPqidjaW7D2
         KWb8nft/swoPTLcksqnlB5ta+T4eILdCgDfr+H2Y=
Subject: Re: [PATCH v5.4 0/3] Update SELinuxfs out of tree and then swapover
To:     Sasha Levin <sashal@kernel.org>, Paul Moore <paul@paul-moore.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
 <20201016050036.GB461792@kroah.com>
 <9aeaa66d-d369-a1eb-7a07-08d9244585f3@linux.microsoft.com>
 <CAHC9VhR_WG13wLT-rJs0AdDgh6kwN_ei46btyXp5KusUdzuOag@mail.gmail.com>
 <20201016142213.GV2415204@sasha-vm>
From:   Daniel Burgener <dburgener@linux.microsoft.com>
Message-ID: <b6e32678-ce2e-733d-5de1-dc7f2c00111c@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 10:36:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201016142213.GV2415204@sasha-vm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 10:22 AM, Sasha Levin wrote:
> On Fri, Oct 16, 2020 at 09:55:25AM -0400, Paul Moore wrote:
>> On Fri, Oct 16, 2020 at 9:05 AM Daniel Burgener
>> <dburgener@linux.microsoft.com> wrote:
>>> Yes, thank you.  I will fix up the series with the third commit
>>> included, and add commit ids.  Thanks.
>>
>> Greg and I have different opinions on what is classified as a good
>> candidate for the -stable trees, but in my opinion this patch series
>> doesn't qualify.  There are a lot of dependencies, it is intertwined
>> with a lot of code, and the issue that this patchset fixes has been
>> around for a *long* time.  I personally feel the risk of backporting
>> this to -stable does not outweigh the potential wins.
>
> My understanding is that while the issue Daniel is fixing here has been
> around for a while, it's also very real - the reports suggest a failure
> rate of 1-2% on boot.

As a point of clarity, I think that the issue occurs much less 
frequently on boot than it does with a policy load during ordinary 
operation, since there are a much higher volume of userspace policy 
manager lookups on a policy_load once the system is up.  I think 1-2% is 
roughly accurate for what we're seeing in the environment I'm working on 
for a policy load during normal steady state operation.  I don't have 
hard numbers on policy load during boot, but I would expect it to be 
quite a bit lower.  We have seen it, but it's not the common case we're 
seeing.

>
> I do understand your concerns around this series, but given it was just
> fixed upstream we don't have a better story than "sit tight for the
> next LTS" to tell to users affected by this issue.
>
> Is there a scenario where you'd feel safer with the series? I suspect
> that if it doesn't go into upstream stable Daniel will end up carrying
> it out of tree anyway, so maybe we can ask Daniel to do targetted
> testing for the next week or two and report back?
>
I believe my team will intend to carry this out of tree, yes.  If 
additional data from that would be helpful, I'd be happy to provide it.

-Daniel


