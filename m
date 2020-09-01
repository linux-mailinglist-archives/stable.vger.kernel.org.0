Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B0225993B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgIAQgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729301AbgIAQgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:36:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FA5C061244;
        Tue,  1 Sep 2020 09:36:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so794645plk.10;
        Tue, 01 Sep 2020 09:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6LJNp3SfPZQzgGoLbBE6N8TqVacFA/OYrfyGljmiagI=;
        b=ICh1zf3zGn7XnEwLtLXWBXdrXz03RkOwx69AHgL9W4kNO36ZTyq4x0oYmzBehu8awg
         H4s2r0Y5X6xbC/FNLDnAb4GVLCb9yQdELSo/Q8tZoz5VxuM8t5v027lrHZfB1+jP7Fo7
         dRkz81Zj6At5l+CA1aYdgCtRFFvWKsv0tjeGrrTSsJtP0EvC3uuvIl7/xaUtH4rcE9zV
         HfK+Ue8YUa95CemaV+ILl9zRx3EnJ9mykPNSuoC6YwuXh0rEGidwyZdP2l8rfr8kytTk
         nc3KvUvz21A03NC6SBXoZEdnC74IcgDh8hpd3eC1/ESEi3+YI5lYKq4kbyrz28E0LEIB
         kLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6LJNp3SfPZQzgGoLbBE6N8TqVacFA/OYrfyGljmiagI=;
        b=Kt080CfEFZ4mbSheKf2P4tNa5zRn/janx73a4edNJzeGKzDPe1fcVTaAOxS7ST9cCV
         TLEsAqNZ7+Td0FsWbhC9uiz5lSPd91o2JDVdRlgfg1eCW7zHQ9uFPSOfcINYiE2y172C
         kSGpPQlGatHB3QMJ0TA5Wm2GyUYW9fKoW/gKB7K+qDCmpEO2GBrCkrsr9DiFF7DR8hH1
         mboxqTJ4qALm7iHgOJXhwe6XxsmtChrRh0o7R44INS7qTDTIB8ljO5vYxzvs76656WjV
         mWOEWHts7OqP5ZmmKnvNk0ZFnEM4aTiHlf3YtkpPvnXyzl9AMx12RPdM02l/v0UXIPex
         twsg==
X-Gm-Message-State: AOAM533OmNqv7bue68WcYgBmZEzae0InmlTWVL+HOwNv1a/RAbdpWwmG
        4MP8hp2aOdVu4kz3xqYYIYs=
X-Google-Smtp-Source: ABdhPJwjKrOK7WaCiEzd+HbASOS0a4uBs7I11ulx5TrI35FSx0o5kfHkjravTXJH/V/xrrCIgPhiAg==
X-Received: by 2002:a17:90b:110:: with SMTP id p16mr2361655pjz.98.1598978198498;
        Tue, 01 Sep 2020 09:36:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y7sm2452654pfm.68.2020.09.01.09.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 09:36:37 -0700 (PDT)
Subject: Re: RFC: backport of commit a32c1c61212d
To:     Doug Berger <opendmb@gmail.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <98f2309c-e674-c3fc-0c13-0bf85f123f8c@gmail.com>
Date:   Tue, 1 Sep 2020 09:36:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <4eb51ae0-427d-5359-2439-b38dc0d3b2e5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2020 9:06 AM, Doug Berger wrote:
> On 9/1/2020 7:00 AM, Greg Kroah-Hartman wrote:

[snip]

> Sorry for the confusion, but thanks for the reply.
> 
> There is functionality that exists in Linus' tree, but it is not the
> result of a single commit that can be easily backported. I have been
> unable to find anything in the documentation for submitting a patch to a
> stable branch that covers this type of submission so I have sent this as
> an RFC about process rather than a patch.
> 
> The upstream commit that ultimately results in the functional change is:
> commit a32c1c61212d ("arm: simplify detection of memory zone boundaries")
> 
> That commit is dependent on other commits that aren't necessary for the
> stable branches.
> 
> In my downstream kernel I would apply the single line patch included in
> my original email, but it is not appropriate to apply that patch to
> Linus' tree since the problem does not exist there.
> 
> This creates the situation where a simple patch could be applied to a
> stable branch to improve its stability, but there is not a clear
> upstream commit to reference.
> 
> My best guess at this point is to submit patches to the affected stable
> branches like the one in my RFC and reference a32c1c61212d as the
> upstream commit. This would be confusing to anyone that tried to compare
> the submitted patch with the upstream patch since they
> wouldn't look at all alike, but the fixes and upstream tags would define
> the affected range in Linus' tree.
> 
> I would appreciate any guidance on how best to handle this kind of
> situation.

You could submit various patches with [PATCH stable x.y] in the subject 
to indicate they are targeting a specific stable branch, copy 
stable@vger.kernel.org as well as all recipients in this email and see 
if that works.

Not sure if there is a more documented process than that.
-- 
Florian
