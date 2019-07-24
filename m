Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94F73379
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfGXQP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 12:15:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43513 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfGXQPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 12:15:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so21459242pgv.10
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 09:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2/X8d+N2SL13GFtWKeqQ/BIm7RYLDW1CqQYyQJCUeBc=;
        b=efx2kjDpxdBQWRKbLrNffdIQYUrkv28DbY7Z53o5yLK6VSIdho9LeF+wFcir2Ioa1T
         N6LYYjvskqj+ZeeZMTG4RArk3YHUwfUN2t8SM1n4m49RQG8KY/4/md8HH44KIDZ/iO1D
         zJk/fA8h/DSB0/fHo+HNsfnHLAWRdq4QwOqHKwFlbo4vvMbTIw0HeYlLwtR2wtdgn1DJ
         Rfcu3e6QvnZKaVTtXNiMInpUGtISSyw8uy24ZeBpXdw+n29uU3MDqEmiXWh7z+8/PpRc
         e2pjft1iYwVag1TzTNgW+hzXDDyriT1iHix1/Lyj4oRh5xWbH2gPWk4tRaqkWNBIzDKE
         DiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2/X8d+N2SL13GFtWKeqQ/BIm7RYLDW1CqQYyQJCUeBc=;
        b=ZIe05Uc4Ov1clLg7Wj/ImrAoNK4Wp9MMroF/Egfy0gSeDy5hcTAzHyyWb8Qe6SfE79
         l0bTFINIUWiNxNpDbrZXX+/A5DtKAhWrVriZ4vmkCgDwRmoTwoXWv0z5xiUiAEbkGhnL
         LR0YOmZWN2xdI2ft0ssrwaMPM42eGySo0YgIn2EMpDtCuG2VS0WqkedlU9UPSSwmGGXW
         G+KcLYGKYYnpEH1mZ5WvfbF60dFkiNS+w8yBvr3p5xtY0yGmgBIpMashMRW5UbQo1HM1
         SFp2VLieXOjjZcGXE+0SHT14F6VmpDhTm3eSyFI+pEBOBcVB66CmDWKU3hcw4rm5CXX5
         DGxA==
X-Gm-Message-State: APjAAAXEFAKbpL5QFIoiCo/j506YxeSmi9r1oLZoDf0XGXhW0rcskP+Y
        OhTPEFJmuzIznNivhpkBanUj0bqP
X-Google-Smtp-Source: APXvYqwAAAVn7bbYOiHCK3C1lzVwORIxvse5pNvNuxBOZ+eVRWuQFQ+QAshg5rsbetOaOS21bQLscg==
X-Received: by 2002:a63:f304:: with SMTP id l4mr81335670pgh.66.1563984954844;
        Wed, 24 Jul 2019 09:15:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y12sm55412970pfn.187.2019.07.24.09.15.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 09:15:54 -0700 (PDT)
Subject: Re: btrfs related build failures in stable queues
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
 <20190724154008.GA3050@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <6db43a01-2d84-9bda-4856-e5ee10120ca2@roeck-us.net>
Date:   Wed, 24 Jul 2019 09:15:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724154008.GA3050@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 8:40 AM, Greg Kroah-Hartman wrote:
> On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
>> v4.9.y to v5.1.y:
>>
>> fs/btrfs/file.c: In function 'btrfs_punch_hole':
>> fs/btrfs/file.c:2787:27: error: invalid initializer
>>     struct timespec64 now = current_time(inode);
>>                             ^~~~~~~~~~~~
>> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> 
> This was reported, only seems to show up on arm64, right?
> 

 From the 4.9.y build:

Failed builds:
	arm:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	m68k:allmodconfig
	mips:allmodconfig
	parisc:allmodconfig
	xtensa:allmodconfig

It also affects various qemu builds, such as malta_defconfig, with btrfs enabled.
It looks like it may affect all 32-bit builds with btrfs enabled. I _don't_ see
this problem with arm64, actually.

>> v4.19.y, v5.1.y:
>>
>> fs/btrfs/props.c: In function 'prop_compression_validate':
>> fs/btrfs/props.c:369:6: error: implicit declaration of function 'btrfs_compression_is_valid_type'
>>
>> My apologies for the noise if this has already been reported/fixed.
> 
> Odd, I thought I fixed that, maybe I need to push out an updated git
> tree, sorry about that.
> 

It is reported with v4.19.60-243-gb06e2890aa3d and v5.1.19-346-ge63e6fbad916.

No worries if it is already fixed.

Guenter
