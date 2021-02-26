Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8DB326227
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhBZLwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:52:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:43876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBZLwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 06:52:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F334AB8C;
        Fri, 26 Feb 2021 11:51:23 +0000 (UTC)
Subject: Re: Linux 5.11.2
To:     =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <1614334214168@kroah.com> <s1ak0f$p2g$1@ciao.gmane.io>
 <YDjVShQyMIVWfZU7@kroah.com> <s1ama6$14dl$1@ciao.gmane.io>
 <s1amhe$14dl$2@ciao.gmane.io>
From:   Jiri Slaby <jslaby@suse.cz>
Message-ID: <ea9dbd03-93c7-9244-caca-5535f89300e1@suse.cz>
Date:   Fri, 26 Feb 2021 12:51:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <s1amhe$14dl$2@ciao.gmane.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26. 02. 21, 12:37, Jörg-Volker Peetz wrote:
> Jörg-Volker Peetz wrote on 26/02/2021 12.33:
>> Greg KH wrote on 26/02/2021 12.02:
>>> On Fri, Feb 26, 2021 at 11:54:07AM +0100, Jörg-Volker Peetz wrote:
>>>> Hi,
>>>>
>>>> thanks for the upgrade.
>>>> There seems to be a dangling link in the git repository:
>>>> `scripts/dtc/include-prefixes/c6x`
>>>
>>> Is that new?  What commit caused it?
>>
>> I think it was a removal, commit 584ce3c9b408a89f, which forgot the link.
>> Introduced in 5.11.2.
> 
> Should be: introduced after 5.11.2.

IMO, it would be this commit:
commit a579fcfa8e49cc77ad59211bb18bc5004133e6a0
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Jan 18 12:45:46 2021 +0100

     c6x: remove architecture

targetting 5.12-rc1. So unrelated to 5.11.2 at all, right?

thanks,
-- 
js
suse labs
