Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32D2D6EFC
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 05:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgLKEBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 23:01:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60481 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392205AbgLKEBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 23:01:35 -0500
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <nivedita.singhvi@canonical.com>)
        id 1knZbw-0008J5-LD
        for stable@vger.kernel.org; Fri, 11 Dec 2020 04:00:52 +0000
Received: by mail-pj1-f72.google.com with SMTP id z21so1693258pjq.2
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 20:00:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t8uVN7KLIEPUNJTf7G8pJTTWEvUUwF5HGPRIiWkPRNU=;
        b=QxelG5j8LsS0pFtS393BgTvVDYjoRY9O1FPu4V3GTP6p2eXSwDKO7F3PB9HTIWvs13
         U+fydbQuxbJ5ar9U/nbagMQHorzsbv1EIdXQzOQWmPPdmxUqB3VALT+iPfil1vfj9jEX
         gbDSVVr3GFDWiPM0wGKOfBm56Hyj75IH+InhtumIb2JndFUandyJzULgTSB4fVlVXTOw
         r98UwQOpwF4aj1acf4eHWR+SYJO8oV7y8X63xgR928pSjyDXQ/h+8ocE7/COTOPz5huq
         tlsKj/x0kxSqK3o6lugLZfWLxFRJKQfCWfWcVfWc7jbz2xDU1HttR4Uu65RqFlmAFCz0
         e6Pg==
X-Gm-Message-State: AOAM533zJZK0gihEVNDewMt1kHSUZqdltnN8F8+wqQWAU+Znsn19KiFD
        Z4qwTrRyA9Hzc/R9KA6xeE/PIA+OHeaKGCy7uiJlyVpWZL1r2S9FcyvN3bblThJ4HOn1B66Qf4y
        AccvICB0BhPf6jYBUOuXbywhGzGc77BS2eg==
X-Received: by 2002:a62:37c2:0:b029:19b:499e:cc5d with SMTP id e185-20020a6237c20000b029019b499ecc5dmr9717295pfa.17.1607659251095;
        Thu, 10 Dec 2020 20:00:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRk7Wh/PT7mZJCvGKZXEBJKIGa5Zt0HhJX4c23nqH/KqJWbc6cz08rdh6q2xAWBV3MD/VmOQ==
X-Received: by 2002:a62:37c2:0:b029:19b:499e:cc5d with SMTP id e185-20020a6237c20000b029019b499ecc5dmr9717274pfa.17.1607659250791;
        Thu, 10 Dec 2020 20:00:50 -0800 (PST)
Received: from ?IPv6:2409:4042:705:3341:c41e:5777:32ad:5ae2? ([2409:4042:705:3341:c41e:5777:32ad:5ae2])
        by smtp.gmail.com with ESMTPSA id e29sm7986570pfj.174.2020.12.10.20.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 20:00:49 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        bsegall@google.com, pauld@redhat.com, zohooouoto@zoho.com.cn,
        stable@vger.kernel.org, Gavin Guo <gavin.guo@canonical.com>,
        halves@canonical.com
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <X8yrIKm/ODrrlwx5@kroah.com>
From:   Nivedita Singhvi <nivedita.singhvi@canonical.com>
Message-ID: <601f61a1-eabf-b29b-4928-535f8d31695d@canonical.com>
Date:   Fri, 11 Dec 2020 09:30:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X8yrIKm/ODrrlwx5@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/20 3:27 PM, Greg KH wrote:
> On Thu, Nov 19, 2020 at 11:56:01AM -0300, Guilherme G. Piccoli wrote:
>> Hi Sasha / Peter, is there anything blocking this backport from Vincent
>> to get merged in 5.4.y?
> 
> The backport doesn't apply to the tree.  How did you test this?
> 
> thanks,
> 
> greg k-h
> 

Thanks, Greg, Vincent, for sorting this out and committing
to stable upstream..

sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list
commit	294de8933adbdda78acaa3935971d26bb6de745e

I don't have a reproducer but we'll be testing this
to the extent we can beat up on it...


Nivedita


