Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E6319AA5B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 13:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbgDALGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 07:06:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40700 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732201AbgDALGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 07:06:51 -0400
Received: by mail-qt1-f193.google.com with SMTP id y25so2275804qtv.7;
        Wed, 01 Apr 2020 04:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=2EOiDIA2nQVdUSu0VgNzpqDQxBBVebCxPYBUqBEintc=;
        b=aOfYvUbmqcgzNNykOAPmcWovFz7SJHVwbwBbs0FBFgKGzpdaBg3gprbwnrVUV0b7mm
         Iz3P5DM4XOV5sdAUYGQ/sj8qaOGAP0e8GuN15foN7DLrnxmsTETEZKc5e88ptGGygplv
         /3sUnDLx/NGheVpg9FQ6Bqi2iseiYdYj+52dtEDUAghudJ2ab7dHa3+Lo+B1ZRaTPjTv
         urtbOa1LHMC223jkKVnhAHeQJ0CCcQQPFVghy66UupHA05h3yOlTL2GbG9sEi/bljBD5
         e7mXqiRQfa4FVnwOQy8sdG9u0b56l7JkmgVGZ6PDH1hvXy5ngSAOy+R42kD1K8a5Ntkg
         etkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=2EOiDIA2nQVdUSu0VgNzpqDQxBBVebCxPYBUqBEintc=;
        b=jsJpFEACYIl1/9lWyKUqLY+KLN6QiPBN3mUqE1qb5U4RXVD3jAZqxPDNzYkVORtBqQ
         kXhDwEQwZhhCXz1RGSuarJwj8c9NDp9o6k4BSmuiQW6zyC0VHFjwDOHbKZ6pSJl4LRwg
         zoHV83K7e4qejek9xKNMq+k3eLAkUgy2aY+Ka24ZvAb1ZWks8wRE6yROil1f8udtLHDX
         3qQ7iERoed7+/dUA7kjgtJ4qv+Fgba+bHeYyik8a8OxcSlxaC08FzufGwxYthTrLgAt4
         0eMM4mBlk/1Fi1Wj5hpk3+MOmaamnEfzmpSldOadUHHOZxABePLT88DG3Z3nPDfitJ4j
         HGkg==
X-Gm-Message-State: ANhLgQ1BGLywPYMHaCVEC2poxpoFDCVuhnSmPoY7v1LD0ZISULkImRE0
        MthjW5ilm6KAQoAuj6/uZF50IvEjWQmh
X-Google-Smtp-Source: ADFU+vsQnVTHWhQy8mdKFIoSVS3izJL5rjT1VKecRgDsh7sOob5kpB4YE8fxOwcWWcREqBHLZi7UOw==
X-Received: by 2002:ac8:a09:: with SMTP id b9mr9761292qti.190.1585739209958;
        Wed, 01 Apr 2020 04:06:49 -0700 (PDT)
Received: from [120.7.1.38] ([184.175.21.212])
        by smtp.gmail.com with ESMTPSA id t53sm1191260qth.70.2020.04.01.04.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 04:06:49 -0700 (PDT)
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20200331085308.098696461@linuxfoundation.org>
 <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
 <20200401055152.GA1903194@kroah.com> <20200401055309.GA1903746@kroah.com>
From:   Woody Suwalski <terraluna977@gmail.com>
Message-ID: <2e853806-264d-cf74-4298-146900ab32a1@gmail.com>
Date:   Wed, 1 Apr 2020 07:06:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101 Firefox/60.0
 SeaMonkey/2.53.1
MIME-Version: 1.0
In-Reply-To: <20200401055309.GA1903746@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Wed, Apr 01, 2020 at 07:51:52AM +0200, Greg Kroah-Hartman wrote:
>> On Tue, Mar 31, 2020 at 11:06:16PM -0400, Woody Suwalski wrote:
>>> Greg Kroah-Hartman wrote:
>>> I think you have missed the
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240
>> It should come in soon, in another release or so, when the next set of
>> networking patches get sent to me.
> And also didn't hit Linus's tree until after this set of -rc patches
> went out, so it's not like I missed it or anything :)
>
> thanks,
>
> greg k-h
My bad. It was supposed to be: I think that that patch should be 
considered soon...
Thanks, Woody

