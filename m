Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E041AE486
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgDQSMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730362AbgDQSMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 14:12:06 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3951C061A0F
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:12:06 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f2so3016354ilq.7
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=foA4DPbQhpo9xw/eOdopgrsDK8K+vfBDZATjTXoQh4I=;
        b=Z0MQ60xFZB3rug8cIA+FngZ0z5QTTaKj8L2zfDYreK5DCo9VyIQsbVvoQsEixaqASV
         Xe1eIj5eMACzhqFhfR1Ea39QY5PL+Hb/cv6dWzsZTHQF7sPy5VGNQ7qCbG/e1H2vfXzx
         f1QUhwZOxp3lfix1qIk/TZ32m/y8uoJ4+Rxk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=foA4DPbQhpo9xw/eOdopgrsDK8K+vfBDZATjTXoQh4I=;
        b=AxYq1nfzr9NmVmoLYxInWtv0H0JkLcKco1UI334rqGZKrv80CslVP7XoXXFJm7fkJN
         6BZmE4nTD7fBqXNhDamq1XR81WZU5bM7kRvJH0OA/xLspkaFpS7SnwpVjlTZjNjfQt82
         T4S5w2u7hQnvJkPQxNWAEPuZSfzcQogip/N2jiVI/vvGD5kFzxQxYicE1qglJJ9GLp+j
         n6FcXbBQLrkEN96q7B0MC8zMjLJonRHF+YSkW5RAuPXs9M0i8xqdY2b8AVd+5vvsYhif
         KCBQy3hMLi9Hpr/b1dj1qi0NnVum2F/5M4WByVVQXQiGDC3e7m/0jgKaflfqcyuPEXcL
         a6rQ==
X-Gm-Message-State: AGi0PuZbbZf1p/s2LL2wjHKlJP6gvq37dzYGxfktfgb7zTscflShOCtj
        sHn4JKRvyW9com17Td9wITIo4pxCkgE=
X-Google-Smtp-Source: APiQypK0O3NmNw3iIF83xy1VuEtCksGeLHf4dXqAZp+DSBugDnssGyEy4+rb78xy7abwBzrMsiAKyw==
X-Received: by 2002:a05:6e02:cd2:: with SMTP id c18mr4590069ilj.223.1587147125661;
        Fri, 17 Apr 2020 11:12:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v17sm8424124ill.5.2020.04.17.11.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 11:12:05 -0700 (PDT)
Subject: Re: Linux 5.7-rc1 reboot/poweroff hangs
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prike.Liang@amd.com, Alexander Deucher <Alexander.Deucher@amd.com>,
        stable <stable@vger.kernel.org>
References: <b8eaee2b-21dd-c0de-f522-d58bb9ae31da@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f6d5973a-286e-2273-cbeb-5c88707008d3@linuxfoundation.org>
Date:   Fri, 17 Apr 2020 12:12:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b8eaee2b-21dd-c0de-f522-d58bb9ae31da@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/20 12:05 PM, Shuah Khan wrote:
> Hi Linus,
> 
> Linux 5.7-rc1 reboot/powereoff hangs on AMD Ryzen 5 PRO 2400GE
> system.
> 
> I isolated the commit to:
> 
> Revering the following commit fixes the problem.
> 
> commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
> Author: Prike Liang <Prike.Liang@amd.com>
> Date:   Tue Apr 7 20:21:26 2020 +0800
> 
>      drm/amdgpu: fix gfx hang during suspend with video playback (v2)
> 
>      The system will be hang up during S3 suspend because of SMU is
>      pending for GC not respose the register CP_HQD_ACTIVE access
>      request.This issue root cause of accessing the GC register under
>      enter GFX CGGPG and can be fixed by disable GFX CGPG before perform
>      suspend.
> 

I can send a revert, however it appears this is a fix for a suspend
hang.

thanks,
-- Shuah


