Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B6215D1A2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 06:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgBNF2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 00:28:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36714 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgBNF2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 00:28:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id 185so4307324pfv.3;
        Thu, 13 Feb 2020 21:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l3WD5sUH0NW7+WFX+HcvDvKr2HC5pvM/+FcfMYuSh0k=;
        b=ox8hEdf4fbAGvEHTwvmxf7XyFrrzPCRqREclvJq7N6+xmB6ReQeRTeCBY0YXpes3TS
         kS1QwYxkQ2dc3LMF4LzgR1eTDZf9BAum2esOMf8xeEuaNSJKcdqpr7g8rWlGmix7jyHB
         Bja5oI8JvJc4s93kwiTFWDiRGijn3J0xPnYy+he9vD9P57VYCDiN5fPzr45TpRvlT6nB
         Wsrp1iI7q7I9w3698e33cd8nhOxVj/GAX/kS2iDgpcReluvLvxeI90JyR3kp8FGQYWXj
         9qWxyA6XbOIfaVNAGQUU3XFpO5fKHy+DPtk9c1WmySLO9hgHVZOAjz1gUkhBkmuq9uoY
         dvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l3WD5sUH0NW7+WFX+HcvDvKr2HC5pvM/+FcfMYuSh0k=;
        b=kJGwriElTiI444K1EQ5c2IU3eTNULOGOpTzBwjgWxyk41GWv7rgvFzYn7WVd5sXvfm
         HF9TvF7jbVIGYdIk03S/zEdLwWhwchevMA64SrppToZ2ed/SOte1VsTZl/snPfnb33Ki
         HuEvYht0OD3JGvDh5rF8fYWcG/MmTpcCkPUqtss+MkDe2anKWi1KnDTFsY2YyyViW8rO
         D1ayUstMnt6gS8ZfbGKihndxtjCvu9pgUrptTh+845Gx2GyPqYHrcxSPU7kZlgjM2aU8
         E7xidnAUWTx0GvvdvwTiUg0qDsUlfN49J06vdPpyayiMI2eyvUQtYx40xWY6s1smhQ1p
         N6gg==
X-Gm-Message-State: APjAAAUBX61eXZ1UEH1fLX6eouuXoMhZFrh0vCxRZp1dWS8xaoiH8Ap2
        Mnd2YNnILRfTBSHO5tHUOIO+K8kp
X-Google-Smtp-Source: APXvYqyW9/H8dGoatyDXCGvVC1Zbg3CxwceTsttSlGjNBq0XOd0AP0h4BSaN1GJSUPCiLT3l2+3LOQ==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr1623014pga.421.1581658125873;
        Thu, 13 Feb 2020 21:28:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a195sm5154929pfa.120.2020.02.13.21.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 21:28:45 -0800 (PST)
Subject: Re: [PATCH 4.19 00/52] 4.19.104-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200213151810.331796857@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e6392d0f-5677-a470-3dd9-a1ccb3ea8b6f@roeck-us.net>
Date:   Thu, 13 Feb 2020 21:28:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.104 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 386 fail: 4
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:mem128:zynq-zc702:initrd
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc706:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zed:rootfs

Failures as reported separately.

Guenter
