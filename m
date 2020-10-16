Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D602906C2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408486AbgJPOCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:02:15 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55478 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408484AbgJPOCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:02:14 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id BE45F20B4905;
        Fri, 16 Oct 2020 07:02:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BE45F20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602856934;
        bh=qcbjJMCp7USFDVcj8iNq//oHYBSyiNoJF1E9EF+q3A8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=U5FRoc47LmlvrbwzyFOo/iQ0hIEjfYiEJWz6OAOBUmk5JOylXoMEl7Htz/NB4vngf
         ovdugxUvZICE0qoDqpmu712BFaQY1t6Fkox63sEU0CQQezrsyamVM2/0rZO/Y5W7mf
         LVX/jdR8wbpBqE5puvT/UqR+1GmM/Yv3V1CYjCn4=
Subject: Re: [PATCH v5.4 0/3] Update SELinuxfs out of tree and then swapover
To:     Paul Moore <paul@paul-moore.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        sashal@kernel.org
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
 <20201016050036.GB461792@kroah.com>
 <9aeaa66d-d369-a1eb-7a07-08d9244585f3@linux.microsoft.com>
 <CAHC9VhR_WG13wLT-rJs0AdDgh6kwN_ei46btyXp5KusUdzuOag@mail.gmail.com>
From:   Daniel Burgener <dburgener@linux.microsoft.com>
Message-ID: <56101ae4-62fa-bff8-d24a-bb31c00a33e7@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 10:02:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhR_WG13wLT-rJs0AdDgh6kwN_ei46btyXp5KusUdzuOag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 9:55 AM, Paul Moore wrote:
> On Fri, Oct 16, 2020 at 9:05 AM Daniel Burgener
> <dburgener@linux.microsoft.com> wrote:
>> Yes, thank you.  I will fix up the series with the third commit
>> included, and add commit ids.  Thanks.
> Greg and I have different opinions on what is classified as a good
> candidate for the -stable trees, but in my opinion this patch series
> doesn't qualify.  There are a lot of dependencies, it is intertwined
> with a lot of code, and the issue that this patchset fixes has been
> around for a *long* time.  I personally feel the risk of backporting
> this to -stable does not outweigh the potential wins.
>
> My current opinion is that backporting this patchset is not a good
> idea; it gets a NACK from me.
>
> Daniel, in the future if this is something you want to see backported
> please bring this issue up on the SELinux mailing list when the
> patchset is originally posted so we can have a discussion about it and
> plan accordingly.
>
Noted.  Thanks for the feedback.  I will make sure to bring such things 
up with the selinux list in the future.

-Daniel

