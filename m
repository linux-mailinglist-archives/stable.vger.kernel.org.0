Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0312E74C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgABOi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 09:38:26 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53659 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbgABOi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 09:38:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so3327460pjc.3;
        Thu, 02 Jan 2020 06:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dDEL4xCv+XB3PtXbUiZpFi9F9tjNuKGarbsndcdWlAI=;
        b=IN6tujyeczsHq4JMfuS70Jsso8h8/MscT+uLnH2bUwQHkXyJYRN+Rb5Y+KavE6EfIn
         wC4wj0UYpqNCfo2ONSlcOMOo8HvI5pUyrQwW7M+pnkaMMgUYNSyuW0/khy9+sjLg+BHU
         RfeIdSibxonN40o4sCn9cIYREaUpWWA6icN8QxgUx+xweXC+B2dxDotYwNVRv8i/y12v
         Azo0EHtXlRaEOid5b8+s72zFsyhP+y+3zBASiTNFWRmJsW/iyowKae80PvmYur9sAmm2
         YrDxITMfc/pog1Gwu3zqv06e1O6QLgzdDXC9DGA9JStfxHllDd3Vmw+f/MM2ct104N/N
         tXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dDEL4xCv+XB3PtXbUiZpFi9F9tjNuKGarbsndcdWlAI=;
        b=TM7s6H5I+6u93M7zUvNQtUOnRc0qEBU/1pgDurUuCq/q3EJNxC5fe7qzXHqlrD6Bfc
         CZSfJLzE9uv+AF5BWN4+Zemyrwq/v4vih7cCuLhzw5sdbxTmLZh2xx9U6CkEK8UbssH5
         sd0JL2Xa3Z8hTLF5dx2Sn//ENHQRITif8xEd/zAhVdPmFOHk59rvbIUm9ajSkjKwOYXN
         /fbY62L/WTukzqyteAqXikJnR5ZHcTjZofaNWaG0o185w8krXHKceXVuz4JQ6UGPC+Pg
         LF7CoPkC0oylXLlphV2AhfOQ9cba/hHIPC9V4Vd92E/iioxAgVR6gmayQhspgPcAikfl
         X7tw==
X-Gm-Message-State: APjAAAWu0VnH++dGkXl+FM35ss7ToMCw6x/+ji3qNfY6yO+iqqVb0ktT
        rR8ni5lJzu9q5DqGXQI+ZTh3+IU3
X-Google-Smtp-Source: APXvYqymIsrCz06b+YYXTXBgzywmdTfrymeeAo3mHe6dSAip4TEmCCseUv+2AvKA/Frme1JjZpT/mg==
X-Received: by 2002:a17:90a:fb4f:: with SMTP id iq15mr20307474pjb.86.1577975905062;
        Thu, 02 Jan 2020 06:38:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d26sm58314003pgv.66.2020.01.02.06.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 06:38:24 -0800 (PST)
Subject: Re: Clock related crashes in v5.4.y-queue
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-clk@vger.kernel.org
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <5869f050-7b3f-b950-bfb6-5601d2b30fbd@roeck-us.net>
 <20200102073058.662A9215A4@mail.kernel.org>
 <63d158e4-14ce-279f-1e77-eb50cb07b465@roeck-us.net>
 <CA+G9fYsDEQwdE559dqDBe5bq5_fcAs0QYvYx0LNYMBEn+ij2Ew@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5f08fd73-10a0-1c5c-2bb3-46ac359a4c92@roeck-us.net>
Date:   Thu, 2 Jan 2020 06:38:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsDEQwdE559dqDBe5bq5_fcAs0QYvYx0LNYMBEn+ij2Ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 6:19 AM, Naresh Kamboju wrote:
> Hi Guenter
> 
> On Thu, 2 Jan 2020 at 19:45, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 1/1/20 11:30 PM, Stephen Boyd wrote:
>>> (Happy New Year!)
>>>
>>> Quoting Guenter Roeck (2020-01-01 19:41:40)
>>>> On 1/1/20 6:44 PM, Guenter Roeck wrote:
>>>>> Hi,
>>>>>
>>>>> I see a number of crashes in the latest v5.4.y-queue; please see below
>>>>> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>>>> leak in clk_unregister()").
> 
> Please share steps to reproduce this crash.
> 

With multi_v7_defconfig:

qemu-system-arm -M xilinx-zynq-a9 -kernel arch/arm/boot/zImage \
	-no-reboot -initrd rootfs-armv5.cpio \
	-m 128 -serial null \
	--append 'panic=-1 slub_debug=FZPUA rdinit=/sbin/init console=ttyPS0' \
	-dtb arch/arm/boot/dts/zynq-zc702.dtb \
	-nographic -monitor null -serial stdio

initrd from https://github.com/groeck/linux-build-test/blob/master/rootfs/arm/rootfs-armv5.cpio.gz

Guenter
