Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1903D3B01
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 15:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhGWMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbhGWMkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 08:40:20 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEA8C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 06:20:48 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id jz6so1316171qvb.2
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 06:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JDgRgmChcEJr1PN5eAOZivpQ+36V1qAe0wUaZdSyEFU=;
        b=rNVm+yDO7jkaRA3M4MefpXFvaj1mX9BQRfSUqgnlU0SKUFYk1gaH1DkEFrsSmHg6hX
         lMaptpxR/Gb5FIvnD4pWLdaZ2JeSjRhPWgzu9jRoERLPLPof1x0aEUUxfGXIr5rlbIC/
         shEsWdtCreOgDHRoJXGMLwVKL6DAmwx/W79+5Jy52yf7BDUQcpHnOI6W7vbWOPcSNmnt
         3by1td19iGDW5krv45jhYGszDWs3BdaljIdND7lsICQxrJaOMsQcXNvSPjp1Ssl46jpQ
         SF8DuYrEtjaQfn5jE8JF2k/plew4lcnOieW0N/4uLuHT9260bK/1/N4zr3p0quLfYP1e
         suWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JDgRgmChcEJr1PN5eAOZivpQ+36V1qAe0wUaZdSyEFU=;
        b=q+paNckFD5TNrJT4Yhsa+xNQ1rklufnL8VfyKY2t1AhlR1DBEAzzGjxHBIhnwKT7vM
         RV2wuNLQWyiWXkFEi57FDIVASUUqkNQlDXLrwcoWjS8d3GpwsfLuAi0fOS2fyV3dEgPj
         7c1VYDdNPQbKlvevnU/92KVNF5BPgmsa2ffSoAq6l5SXb0kFFl93DFQqaCEZfwqQAF5h
         VOrSVhOVJQRudbRqaz9RUnIxYqlWE/6pNhcL/csGto0JMTUw2tNs/iYLutArs2/BqW4R
         3N1vXqu2gtY+ipwfwajSx8s+VcQ0umoHDo3Jsvx+cdKlPlc3JvK4ErCaiUmu8AenjZ62
         okFA==
X-Gm-Message-State: AOAM532FCRKXXkhUYZMkuATwAfyWDqJAQMr6OBBL/ZOYQVsd8OHkp6WI
        FBw2eM54sY8Yiu8ZWav/435rMrt5NfY=
X-Google-Smtp-Source: ABdhPJzc3CJXy0rkf6427qirbVf3bd++tmUjTh6vsQ+LJoI51/dRlyLJGXqHIkoYOswAAZ4umUWzOQ==
X-Received: by 2002:a0c:8e09:: with SMTP id v9mr4768422qvb.15.1627046447636;
        Fri, 23 Jul 2021 06:20:47 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id h66sm7997095qkc.47.2021.07.23.06.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 06:20:47 -0700 (PDT)
Subject: Re: boot of J1900 (quad-core Celeron) mobo: kernel <= 5.12.15, OK;
 kernel >= 5.12.17, 5.13.4, slow boot (>> 660 secs) + hang/FAIL
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <5b5d1b7f-7327-52a2-5221-de39206a07a3@gmail.com>
 <YPppToU9X3LZYwoe@kroah.com>
Message-ID: <6a2784d4-c348-1bef-063c-a7db2ffb1248@gmail.com>
Date:   Fri, 23 Jul 2021 09:22:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPppToU9X3LZYwoe@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/23/21 3:01 AM, Greg KH wrote:
> On Thu, Jul 22, 2021 at 05:10:02PM -0400, PGNet Dev wrote:
>> My servers run Fedora 34, with latest kernels.
>>
>> Updating to any of minimally- or un- patched 5.12.17 or 5.13.4 hangs/fails, as follows.
> 
> Can you use 'git bisect' to find the offending change?
> 
> thanks,
> 
> greg k-h

unfortunately, not simply.

These are rpm installs, from unpatched builds,

> updating to any of minimally- or un- patched,


> 
>     Fedora (5.12.17-300.fc34.x86_64) 34 (Thirty Four)

>         https://koji.fedoraproject.org/koji/buildinfo?buildID=1780670


> 
>     Fedora (5.13.4-200.fc34.x86_64) 34 (Thirty Four)

>         https://koji.fedoraproject.org/koji/buildinfo?buildID=1782334

> 

>     Fedora (5.13.4-250.vanilla.1.fc34.x86_64) 34 (Thirty Four)

>         https://fedoraproject.org/wiki/Kernel_Vanilla_Repositories

>         https://repos.fedorapeople.org/repos/thl/kernel-vanilla-stable/fedora-34/x86_64/

>         https://fedorapeople.org/cgit/thl/public_git/kernel.git/tree/?h=kernel-5.13.3-250.vanilla.1.fc34

available at stable release versions, not my own source builds.

and, of course, this issue appears only on this J1900/Celeron hardware *production* server.

Is there a specific set of kernel rd/systemd/etc debug logging flags that would shine more light on the problem?

