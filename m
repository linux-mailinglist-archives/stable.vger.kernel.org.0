Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E7D73438
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGXQu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 12:50:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44000 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfGXQu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 12:50:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so21503087pgv.10
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 09:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I4WVMYQRX4kt5i+RJEPD9hd50TU3ciYeycTWWfmLtFI=;
        b=aLLrZOFJvcpQV2exlwxVIjZ77RHlDRci+vHe961r+bqAqWt8HeKZH+8xjmkLD6Ex8k
         o4IIy2BKsWL79Dp5mqywkQOfVmGuyDxIs3yHSaGSwNdJesJihjgSR99njLWpP/80nUGp
         9+BmeAIGqmmfc5Mov7tjuPyQVp7NO6YErJzXCdWGS5D3PPtSOVBM3AQK27RR8u+XS5sW
         sexhkHEH3PczorSKiZoUO6wXbbtf9iNmGq4F1gkoRkd8/nBbmyqkTpL3mf980eiccbbO
         iEHv0JYUhlTZzjJsz4TNl9Jb60buH6Bq2Yba9zvzW3VKaNW1gsBmH7JMmKR9BkWfnW6y
         BFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I4WVMYQRX4kt5i+RJEPD9hd50TU3ciYeycTWWfmLtFI=;
        b=Do3mzUQZr+1jwtp4VTBQnsLOL8AmjZwOgo+SCDXSQN/6BMa4c6OGctZ/eB2wquancP
         TLAgxPjJVhndnfz+cem9/4Sp9Sn414f34VMeLepriZg6VMficaLfhmfYApIxab48+YeC
         5MoSHpnGxJkDrLW2xG9o5j9FjiyzxSFpDQpsS+82syVCOXvLy9Je3rOK08USXDWlM0qE
         lpha638Z5cf/q9FNGHrprt1pNuVdbLM989hDhtznx65xtKAtA+eVHi0zSIIFPrqUi7BR
         Z/ZIRwaAPInryMtDMZK8QHSKDvheuSfxUxGMy+B1AAwHO8aCQnDxbWqm9IfJx5fsUOMX
         hMWQ==
X-Gm-Message-State: APjAAAW7t88sR5a0FyQq36u1N6DyRuOPVKpHnTZyKZ/TMwaDYLQ6SD9L
        +haY1o+a6Ll9lT+ymjmqRUFAdVgq
X-Google-Smtp-Source: APXvYqwcGAnpwyad9dtC0pTwOOD18AhNlqQM3fdTbC9C9aho6Z+fG8HgFS1VF9Wf0JFB68aE4lJRyw==
X-Received: by 2002:a65:4546:: with SMTP id x6mr81102958pgr.266.1563987056381;
        Wed, 24 Jul 2019 09:50:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 81sm41541032pfa.86.2019.07.24.09.50.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 09:50:55 -0700 (PDT)
Subject: Re: btrfs related build failures in stable queues
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Cc:     stable <stable@vger.kernel.org>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
 <20190724154039.GB3050@kroah.com> <20190724161534.GA10454@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8d039d25-7e88-2de7-00d9-de2c30e11c82@roeck-us.net>
Date:   Wed, 24 Jul 2019 09:50:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724161534.GA10454@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 9:15 AM, Greg Kroah-Hartman wrote:
> On Wed, Jul 24, 2019 at 05:40:39PM +0200, Greg Kroah-Hartman wrote:
>> On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
>>> v4.9.y to v5.1.y:
>>>
>>> fs/btrfs/file.c: In function 'btrfs_punch_hole':
>>> fs/btrfs/file.c:2787:27: error: invalid initializer
>>>     struct timespec64 now = current_time(inode);
>>>                             ^~~~~~~~~~~~
>>> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
>>
>> Oops, no, this looks like a 32bit issue, let me dig into that...
> 
> Ok, this makes no sense.
> 
> A few lines above this we do:
> 	inode->i_mtime = inode->i_ctime = current_time(inode);
> 
> And here we are now doing:
> 	struct timespec64 now = current_time(inode);
> 
> 	inode_inc_iversion(inode);
> 	inode->i_mtime = now;
> 	inode->i_ctime = now;
> 
> 
> And current_time() is defined as:
> 	extern struct timespec64 current_time(struct inode *inode);
> 

v4.9.186-108-g5b3c7cd16340 and v4.9.186-126-g97ad1fbc1478, line 1489 of fs.h:

extern struct timespec current_fs_time(struct super_block *sb);

Your code base seems to be different :-(.

Guenter

> 
> I have no idea what is going on :(
> 
> This is caused by Felipe's patch: 179006688a7e ("Btrfs: add missing
> inode version, ctime and mtime updates when punching hole").  Felipe,
> any ideas?
> 
> thanks,
> 
> greg k-h
> 

