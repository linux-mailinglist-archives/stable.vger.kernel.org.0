Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2F736DD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfGXSqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 14:46:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39468 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfGXSqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 14:46:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so21653849pgi.6
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 11:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fahCVmIl/uIgSMC2UckUBQExsfkDADYaB6lHqYCnzWM=;
        b=jGBrquEgZYhKlBH/0JSQfNd72Sm1hxOzyCZk5hc3PA9kXhYZ6ftB1w9BZxlyUTSmkY
         vzGRS+HwvDNNjPy7jkEQlDWp6jUAl/f1imyDW/kkYq1Gu17N8d7MZ239gCGUivptRvgB
         hHL4VTxappX6r213rQjWhHz+XczI8aKYW3uCMPJA8vhOmVcoDQOoqni1h25pW2fuw+4q
         y4P4m8qHPBmPl5b7CKJUxVlBEb4o6Idb09iaGwByUeBALTNhHL+BI+uEXRE0C9CKPZeQ
         eC2jEXI+SZI08TETORnNzo1YCS88p1GGb8QzS6e8ivXmt6gZeqaxN1EavTYj+2felLu7
         VApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fahCVmIl/uIgSMC2UckUBQExsfkDADYaB6lHqYCnzWM=;
        b=BQ1qcjH7Um2b4bCOoNMcjxt7x336Mis2MHbPOc+JAQJMHAtWX4HZyrjsMWaDjSR340
         WmwghpO1pvqHUDjy7Zbq7vvDfnohlWUtk7Cr6ipsvBL27GWfpJNkuL+4IWV+wKcXEIrr
         wwRxztmEtkxpmhao3wykZdggX8EdOOwcoGK6deglgfT/FzBDb7f51dso7+27TmmdJEqC
         WW9I18+7ffmEwjJfFJlL/hgv+JXG7K8NM3QvZA2VknHNIMY1RpTKMnLGyuwShNbNK4m3
         +dSQ8+1kiOxLdjEjhwYJmZ2EYgnlTnHyiK4HI8MpnkRluL05bXS1KtMVs5mdtUIKO7vT
         POXg==
X-Gm-Message-State: APjAAAUbGEsbFYaAMjfyV/e87CLwZE5/Y1oMRV9Jy702d3MVT2vNvrVf
        2F0uQQohHvBuQS6Kyasj7DV8HR+3
X-Google-Smtp-Source: APXvYqyHgYF2mVOJLLFpkZ6IZfGogWg4NkOQhgc/wWZhjZJNhF7xwBSPYyGTzu5Ns6A2R8LfIt22Fw==
X-Received: by 2002:a17:90a:1ae2:: with SMTP id p89mr84239134pjp.26.1563993967785;
        Wed, 24 Jul 2019 11:46:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm78750366pfq.88.2019.07.24.11.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 11:46:06 -0700 (PDT)
Subject: Re: btrfs related build failures in stable queues
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        stable <stable@vger.kernel.org>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
 <20190724154039.GB3050@kroah.com> <20190724161534.GA10454@kroah.com>
 <8d039d25-7e88-2de7-00d9-de2c30e11c82@roeck-us.net>
 <20190724183148.GA23045@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0e3f152e-de4c-fd61-eb88-944205939875@roeck-us.net>
Date:   Wed, 24 Jul 2019 11:46:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724183148.GA23045@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 11:31 AM, Greg Kroah-Hartman wrote:
> On Wed, Jul 24, 2019 at 09:50:54AM -0700, Guenter Roeck wrote:
>> On 7/24/19 9:15 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Jul 24, 2019 at 05:40:39PM +0200, Greg Kroah-Hartman wrote:
>>>> On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
>>>>> v4.9.y to v5.1.y:
>>>>>
>>>>> fs/btrfs/file.c: In function 'btrfs_punch_hole':
>>>>> fs/btrfs/file.c:2787:27: error: invalid initializer
>>>>>      struct timespec64 now = current_time(inode);
>>>>>                              ^~~~~~~~~~~~
>>>>> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
>>>>
>>>> Oops, no, this looks like a 32bit issue, let me dig into that...
>>>
>>> Ok, this makes no sense.
>>>
>>> A few lines above this we do:
>>> 	inode->i_mtime = inode->i_ctime = current_time(inode);
>>>
>>> And here we are now doing:
>>> 	struct timespec64 now = current_time(inode);
>>>
>>> 	inode_inc_iversion(inode);
>>> 	inode->i_mtime = now;
>>> 	inode->i_ctime = now;
>>>
>>>
>>> And current_time() is defined as:
>>> 	extern struct timespec64 current_time(struct inode *inode);
>>>
>>
>> v4.9.186-108-g5b3c7cd16340 and v4.9.186-126-g97ad1fbc1478, line 1489 of fs.h:
>>
>> extern struct timespec current_fs_time(struct super_block *sb);
>>
>> Your code base seems to be different :-(.
> 
> I was looking at 5.1 as you said it failed there :(
> 
> I'll go fix up 4.9 and I think 4.14, but the other kernel versions
> should be fine.
> 

Oops. Yes, you are correct, only 4.9 and 4.14 are affected by this problem. Sorry.
Guenter
