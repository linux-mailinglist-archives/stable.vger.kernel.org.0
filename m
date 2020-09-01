Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1991259BBF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgIARGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgIARGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 13:06:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5FC061244;
        Tue,  1 Sep 2020 10:06:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m8so1157557pfh.3;
        Tue, 01 Sep 2020 10:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PwNRndak15FLf6udHGPDXV3xJclmFk58fcQPrWISEyg=;
        b=u82f5+1anvYlYHJs/pJvG3+NLXqCVZH3FiTol6fLHW1d3wmBNBgerRa4yBh73/LOQr
         JJOrhtRUVUP2xuQVN5Ydp6AmboX0BMO4ziQXoNB7AickRbwiT1QTlIa9n+2cEWVRefjP
         Dkjj/Icu7TrDSd79eTW1qGRWm7ZPAQUi3M6Cwuib+RNoGzm64F7tFXAKuyDddMODzoc8
         kwDn1jUuDQcF4+TicXIKRz6ayPVb+6XuC5JyXjKfAGiB65AlCo1Yy9qG0r8d6RtMuDAR
         bVtOu2k3HcIlVHGAL2LgWrTe/HXhHAbRQ4PLruDD/wVJU85WGEPbQ48qCxVr5+Dg3d9z
         TP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PwNRndak15FLf6udHGPDXV3xJclmFk58fcQPrWISEyg=;
        b=lcaEaFq6i5sO62wmt1gawR/L6aOOZMI/zo5x9mPg/yxPU+9VeAb1cI5Abc71YaUe0P
         NcpuvENtL/46jKZgtMCoZACVw7+lcvAJ7UdR1ilS/gjxZu+yqgdVpmWtfBlv/RdqNhp6
         LG/x+Qim/2j4J21/yLI2yhNSIQGYcylWqnZcPSD9FHQjnR7C42Mn34t/o5l5fnuRgGTv
         Gwz6+j5PtMhP9+re5VhrRzcUI5mYbsT8+bteQ41OU0+lN7Yg/DFcK51nTgPvgiOfMFob
         +65D7ljHOiykelh0S+OPp+ZerJARWSUtEKX1550O13Qb99bR+JVj6EArjkogbjjmXV7t
         6cLw==
X-Gm-Message-State: AOAM531sTj6DEepIlooxQDH9DJSa5pb42BzDPHjiQxZWx/2/oHBNmbx/
        DVam7ai2NWozzx7o27quuK8=
X-Google-Smtp-Source: ABdhPJyy7JOa3sxonsjDIcIjoW7WMS7fwqpw3kiqxp+QzUYZE4hxNju76g8xRz1QZ/Dl2wBypUzyhg==
X-Received: by 2002:a63:4418:: with SMTP id r24mr2281840pga.8.1598979995594;
        Tue, 01 Sep 2020 10:06:35 -0700 (PDT)
Received: from [192.168.219.31] (ip72-219-184-175.oc.oc.cox.net. [72.219.184.175])
        by smtp.gmail.com with ESMTPSA id 13sm2603359pfp.3.2020.09.01.10.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 10:06:34 -0700 (PDT)
Subject: Re: RFC: backport of commit a32c1c61212d
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Hocko <mhocko@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        zhaoyang <huangzhaoyang@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Baoquan He <bhe@redhat.com>
References: <bd960a80-c953-ad11-cdfd-1e48ffdce443@gmail.com>
 <20200901140018.GD397411@kroah.com>
 <4eb51ae0-427d-5359-2439-b38dc0d3b2e5@gmail.com>
 <98f2309c-e674-c3fc-0c13-0bf85f123f8c@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <62fef535-199b-9b62-c206-c92d2d929be3@gmail.com>
Date:   Tue, 1 Sep 2020 10:09:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <98f2309c-e674-c3fc-0c13-0bf85f123f8c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/2020 9:36 AM, Florian Fainelli wrote:
> 
> 
> On 9/1/2020 9:06 AM, Doug Berger wrote:
>> On 9/1/2020 7:00 AM, Greg Kroah-Hartman wrote:
> 
> [snip]
> 
>> [snip]
>>
>> My best guess at this point is to submit patches to the affected stable
>> branches like the one in my RFC and reference a32c1c61212d as the
>> upstream commit. This would be confusing to anyone that tried to compare
>> the submitted patch with the upstream patch since they
>> wouldn't look at all alike, but the fixes and upstream tags would define
>> the affected range in Linus' tree.
>>
>> I would appreciate any guidance on how best to handle this kind of
>> situation.
> 
> You could submit various patches with [PATCH stable x.y] in the subject
> to indicate they are targeting a specific stable branch, copy
> stable@vger.kernel.org as well as all recipients in this email and see
> if that works.
> 
> Not sure if there is a more documented process than that.
Yes, that is what I had in mind based on the "Option 3" for patch
submission. The sticking point is this requirement:
"You must note the upstream commit ID in the changelog of your submission"

My best guess is to use a32c1c61212d, but that could easily cause
confusion in this case. My hope is that now I can reference this
discussion to provide additional clarity.

Thanks,
    Doug
