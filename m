Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D201C8A4E
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJBN43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 09:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfJBN43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 09:56:29 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36DB321783;
        Wed,  2 Oct 2019 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570024588;
        bh=pz0g03rKOosq9FV129z2fbWdb5hH8GUPu6jRMWPuVaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ufle2BdgQRNBABz3KREZ/nCVKM77avHcfDyhteZmZIT4asjh5+gBewU4jit06xFl+
         fSe+mKhyY94tc3ZURZFfHby7B/vadbkVDQaQcG5EVWcoQsmueVB6p4rXksJbCSbl/j
         QeK7BBx8fNC15CBNAaVJcoiNd+2j6HoA49hLVci8=
Date:   Wed, 2 Oct 2019 09:56:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel?5.4.0-rc1-643b3a0.cki (stable-next)
Message-ID: <20191002135627.GN17454@sasha-vm>
References: <cki.7E7289C905.6I9MGQOO2V@redhat.com>
 <20191002053202.GA1450924@kroah.com>
 <1062039737.2099822.1570016073892.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1062039737.2099822.1570016073892.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 07:34:33AM -0400, Veronika Kabatova wrote:
>
>
>----- Original Message -----
>> From: "Greg KH" <greg@kroah.com>
>> To: "CKI Project" <cki-project@redhat.com>
>> Cc: "Linux Stable maillist" <stable@vger.kernel.org>
>> Sent: Wednesday, October 2, 2019 7:32:02 AM
>> Subject: Re: ❌ FAIL: Test report for kernel	5.4.0-rc1-643b3a0.cki (stable-next)
>>
>> On Wed, Oct 02, 2019 at 12:27:24AM -0400, CKI Project wrote:
>> >
>> > Hello,
>> >
>> > We ran automated tests on a recent commit from this kernel tree:
>> >
>> >        Kernel repo:
>> >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
>> >             Commit: 643b3a097f86 - selftests: pidfd: Fix undefined
>> >             reference to pthread_create()
>>
>> That is 5.4-rc1?
>>
>> Why are you sending those results to the stable list?
>>
>> confused,
>>
>
>Hi,
>
>Sasha has requested to have stable-next tested and results sent to this list:
>
>https://gitlab.com/cki-project/pipeline-data/commit/16e0c06addbe62c689782357673f69bb7dff4d9a

Greg, this is the stable-next thing we talked about at LPC; it's just a
subset of linux-next of stable tagged commits to help us identify issues
before it actually hits upstream.

I can drop the mails to stable@ if you'd like, but ideally it should
only be one mail a day.

--
Thanks,
Sasha
