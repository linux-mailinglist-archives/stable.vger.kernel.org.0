Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41659AE3B0
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfIJG1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 02:27:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46147 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729518AbfIJG1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 02:27:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id d17so4826863wrq.13;
        Mon, 09 Sep 2019 23:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MDvvxlm4EPJtB9eDBS496uoPhxHiq1jejHiyH1JIX3w=;
        b=gbfGpBVwxLb3OM8f45S2s1YeSAa5lyhvkVJNbkgzI6wSrzp7sYwXHGzEZdw172CgJg
         m2uAr7g0irO5xJe7qyz24mLCbjo+Nb++VbHVnMEr3kh0wsTIZAIs+n2knElp0F0xu5xk
         QXa0E4FtZFGLueh6ICShw+3tLg67yzSJ5URQcvDK1gRDcYxXhjWY2ltzNfGVBqS1g7b+
         2nc73i5D3peBeCS8XBpovwPoudCBzfH7wLD2epolcb5J+5CtnGT0195IQunrP59DPUBE
         K8n+QNCEQqoBqKV9AQTB4Mgcn5tooYqz87rMpQ5nclai85aNjsGyREeTWdR5LRz9y5Jz
         YTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MDvvxlm4EPJtB9eDBS496uoPhxHiq1jejHiyH1JIX3w=;
        b=tFZVI6k6tuaj6lW9vY1arL3mMVl8wwUQmtdaxTZ4s6J2s7i4XDkBPrnvmemkFEzGWV
         PDKjcsjPG8JH2XWyirvnnOUCBEHAHsKmq21Qtq8KflQIorl04xyhZF3ta18/MAFWK1ao
         1oSy8Rn+YIqbgIrRsyqGBcMIkZ8oHzY2JY3TAuUgZ0x9I3Kr9ikNbrqRbXUlT0W6HR2H
         yvcuF53VxqCxtJAVaRENTsUxXeNa82IE8vGC3hg7e4it31+f25IVwbAYGE+Pts/8n7NB
         0QRaXrOGJFBd3th7b5wGy+IJ/phdLkA5LoegTUMnz8cpzj/CqqWFDdiW0Ldcz8b/lNUG
         +RTg==
X-Gm-Message-State: APjAAAXtY9VyQ/vr4FaGKdf9zOD3m/DWqF/96+JxmTqHUTrLXg5F5yjx
        ZHqctwEQ8jGqV51cEWye9dmCBeQAWuLN/w==
X-Google-Smtp-Source: APXvYqw8soMWKGbHP/fAAIX35fInxB9u8K5H1DveBH6z0hz2IhGtG8PVN68CzYYJSR8kIoPUbmY3JQ==
X-Received: by 2002:a05:6000:1101:: with SMTP id z1mr19069387wrw.332.1568096833318;
        Mon, 09 Sep 2019 23:27:13 -0700 (PDT)
Received: from ?IPv6:2a02:810d:8cc0:4ff8:6441:f1c4:968a:e9d0? ([2a02:810d:8cc0:4ff8:6441:f1c4:968a:e9d0])
        by smtp.gmail.com with ESMTPSA id b144sm1873123wmb.3.2019.09.09.23.27.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 23:27:12 -0700 (PDT)
Subject: Re: [PATCH 4.19 19/57] Bluetooth: hidp: Let hidp_send_message return
 number of queued bytes
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121132.859238319@linuxfoundation.org> <20190909121555.GA18869@amd>
 <8e7731e0-f0ad-8cbb-799e-dd585e6b7ed6@gmail.com>
 <20190909225929.GC26405@kroah.com>
From:   Fabian Henneke <fabian.henneke@gmail.com>
Message-ID: <c7aa8abe-86c1-e401-67b4-a9fbb85bf475@gmail.com>
Date:   Tue, 10 Sep 2019 08:27:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909225929.GC26405@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10.09.19 00:59, Greg Kroah-Hartman wrote:
> On Mon, Sep 09, 2019 at 03:00:46PM +0200, Fabian Henneke wrote:
>> Hi,
>>
>> On Mon, Sep 9, 2019 at 2:15 PM Pavel Machek <pavel@denx.de> wrote:
>>
>>> Hi!
>>>
>>>> [ Upstream commit 48d9cc9d85dde37c87abb7ac9bbec6598ba44b56 ]
>>>>
>>>> Let hidp_send_message return the number of successfully queued bytes
>>>> instead of an unconditional 0.
>>>>
>>>> With the return value fixed to 0, other drivers relying on hidp, such as
>>>> hidraw, can not return meaningful values from their respective
>>>> implementations of write(). In particular, with the current behavior, a
>>>> hidraw device's write() will have different return values depending on
>>>> whether the device is connected via USB or Bluetooth, which makes it
>>>> harder to abstract away the transport layer.
>>>
>>> So, does this change any actual behaviour?
>>>
>>> Is it fixing a bug, or is it just preparation for a patch that is not
>>> going to make it to stable?
>>>
>>
>> I created this patch specifically in order to ensure that user space
>> applications can use HID devices with hidraw without needing to care about
>> whether the transport is USB or Bluetooth. Without the patch, every
>> hidraw-backed Bluetooth device needs to be treated specially as its write()
>> violates the usual return value contract, which could be viewed as a bug.
>>
>> Please note that a later patch (
>> https://www.spinics.net/lists/linux-input/msg63291.html) fixes some
>> important error checks that were relying on the old behavior (and were
>> unfortunately missed by me).
> 
> As that patch doesn't seem to be in Linus's tree yet, we should postpone
> taking this one in the stable tree right now, correct?
> 
> thanks,
> 
> greg k-h
> 

Yes, please wait for the other patch if it's not in his tree yet and apply the two together.

Thank you,
Fabian
