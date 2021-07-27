Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651B43D844D
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 01:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhG0Xvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 19:51:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:60744 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233790AbhG0Xvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 19:51:52 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.132])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CF5291C006B;
        Tue, 27 Jul 2021 23:51:49 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8F297500026;
        Tue, 27 Jul 2021 23:51:49 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1396213C2B1;
        Tue, 27 Jul 2021 16:51:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1396213C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1627429909;
        bh=gIFJS9/gCegSoCP5IF+7rJ0J4kAmlx0Z/idf+Fua/ZQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=O4UY7IEeyTQdH+6lOWiPUhf9Uum+fGwReWji76fde7lN/sZFNdcSIxIA7H3JJJP3n
         B8IiBCynsC5u7U7RyG5LdeLzvChDpvnM6artLnoEEUdxZR4+64qviTrApdTmyddbPf
         egBDI5NQN2Yvds5FLj6YBEGgnHyDWg9M9ijxKCx0=
Subject: Re: very long boot times in 5.13 stable.
To:     pgndev <pgnet.dev@gmail.com>
Cc:     stable@vger.kernel.org
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
 <CAHv26DhDYNYGmQa7Dt4NoAz74J89pi8+4yuEprFO0bjuN9G7gg@mail.gmail.com>
 <f8be86d0-28ac-3e5b-1969-9115e5e0472c@candelatech.com>
 <CAHv26DjBqX__YYdqJEfMVZKFomuW8+mid5grAvUfMNmXMtC8pA@mail.gmail.com>
 <f3593f21-11e5-c568-c8e7-45b3f6657a02@candelatech.com>
 <CAHv26DjS0iuQ636tZfgYDo9EGmZ9n-ZwB9AaXvrdUUkWyL5ORw@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <db5517bf-35fb-a18c-47cc-d083b0d32304@candelatech.com>
Date:   Tue, 27 Jul 2021 16:51:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHv26DjS0iuQ636tZfgYDo9EGmZ9n-ZwB9AaXvrdUUkWyL5ORw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1627429910-Ku85FsXL8NhP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


I bisected to same suspect acpi commit, though it is in 5.13.1, not 5.13.2.

commit bf155b2eaab40e7d9862ce89ffe2b8a80f86703b (HEAD -> master, refs/patches/master/acpi-resources-add-checks-for)
Author: Hui Wang <hui.wang@canonical.com>
Date:   Wed Jun 9 10:14:42 2021 +0800

     ACPI: resources: Add checks for ACPI IRQ override

     [ Upstream commit 0ec4e55e9f571f08970ed115ec0addc691eda613 ]

     The laptop keyboard doesn't work on many MEDION notebooks, but the
     keyboard works well under Windows and Unix.
...


Thanks,
Ben


On 7/27/21 10:11 AM, pgndev wrote:
> https://lore.kernel.org/regressions/3491db05-3bb4-a2c9-2350-881a77734070@gmail.com/ 
> <https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_regressions_3491db05-2D3bb4-2Da2c9-2D2350-2D881a77734070-40gmail.com_&d=DwMFaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=HYKqseB9xg-u2kz3egvegqfgyXnEBhQotXfR3iCfdgM&m=m6VJWo5K-8IUBgIaUajtEduR0T8ibHTet6JPL0UgNe4&s=fNVbxFG4v5p_9mhPxGZGgAP4wRKzfiS3vod8SxBw6Dg&e=>
> 
> On Tue, Jul 27, 2021, 1:06 PM Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>> wrote:
> 
>     On 7/27/21 9:50 AM, pgndev wrote:
>      >         embedded. checking...
>      >
>      >
>      >         iiuc, it's got an i2c.  possible a uart is on Irq4 thru the i2c?
>      >
>      >
>      >         if so, might wanna take a look here:
>      >
>      >
>      > https://bugzilla.kernel.org/show_bug.cgi?id=213031
>     <https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D213031&d=DwMFaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=HYKqseB9xg-u2kz3egvegqfgyXnEBhQotXfR3iCfdgM&m=m6VJWo5K-8IUBgIaUajtEduR0T8ibHTet6JPL0UgNe4&s=3nSHI1S9N0Ma6h-6sL6W2bRjDD49EHbQ7rwW4N_p09o&e=>
>      >       
>       <https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D213031&d=DwMFaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=HYKqseB9xg-u2kz3egvegqfgyXnEBhQotXfR3iCfdgM&m=gCRilkIAaKYuJwLWOT7O5ttfWG5rta0-6eYjPBdnTz4&s=VSfJDrJPSqVtQuCoCZGazYrmnWTe6xldTkWT_Bq7vwo&e=>
>      >
>      >
>      >
>      >         maybe related?  at least shares symptoms...
>      >
>      >
>      >         ACPI subsystem lead sez in offlist thread re: that
>      >
>      >
>      >         "It looks like commit 96b15a0b45182f1c3da5a861196da27000da2e3c needs to
>      >
>      >         be reverted."
> 
>     I don't see that commit in linus tree nor my stable tree, can you check that hash and also
>     show me the commit message and other info so I can track it down?
> 
>     Thanks,
>     Ben
> 
> 
>     -- 
>     Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>>
>     Candela Technologies Inc http://www.candelatech.com
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

