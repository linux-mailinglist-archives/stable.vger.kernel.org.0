Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3FD50ADDA
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 04:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377431AbiDVCjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 22:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245153AbiDVCjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 22:39:07 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFCD4B438;
        Thu, 21 Apr 2022 19:36:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c12so7804240plr.6;
        Thu, 21 Apr 2022 19:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NInoTFaAyZRuauQMMQjY3rA274hRk27KZ6AEIVYKuOA=;
        b=GQXDMQRrLeDM3mPZ0LJZJ1wxI/vUkxbfTgCZKCw+le9UtpMEhgkLxzJp3xEE1EQhmJ
         +C/eY4H7/fvzvXHBbKiyLRIiisg55B6myVfV+QYgyn5TPP970s9p6FaUzk5gulc15ZJg
         H7onk5n9Jpdgjia6PEhdeVKgN61DJmEHh1DiKp/qeuPjxTcCa7bPOfjBUxeePEFpV4Lo
         xSTq3tqIoP+pUCUeInAmqstAQvaRVwTRGrIeOqeTM075b9XAzRLrMI7AsrG+rWn3QQRA
         brvOkh0r2ji5jlNB2lKZnH03O/O8wI0gzXk34y8ZgxToK2IqY7sI5dHfyXw00kpwCdlP
         iH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NInoTFaAyZRuauQMMQjY3rA274hRk27KZ6AEIVYKuOA=;
        b=DhrKB1ZhL5e09zYph3jFRNP/Q1VEtoSFJWs1gZD2y2vaB2QnLoi0N8ocp2QHHyuizJ
         RXv6wo8G+Iq+NHV6kXSLQUDgJ5KsI0OALXSGM1hCsmV+TL9GDAWSDVAddj8livg5HjMn
         7hRgI+eB8xI4O4mrJjfeiLiv2MRtfV4moF7CIsKDx1vwh60mXGMgPEcd9XZJM1tMxvm5
         s0/64IlFIjMIIsOTso1U4VFm2SMrt1R4JxxwYC5fLDj3XTLcJUXc/tHeduDCk8BTLvsg
         tKICBhNSzP0hbVGtqTXuXQcWSkGIPU9PGfYyWX5+Z9n/i6aKOKB2IOf55hoz1PrWaUyc
         pVbw==
X-Gm-Message-State: AOAM531WrGx+Dn+bb2QywywucB3d4MRPPHxqIbT9GeMHQ2ugUka9x5JF
        pEKvClIGLIlLuU904vfU21YqauiiaZzhH07ijKEMWg==
X-Google-Smtp-Source: ABdhPJwaqvTuD+iq5uqXUKoLg9Odi3L70fhwFMqS+0j75ICm0l9+Si5Z9DqqL2B+kJsMOvNjYHXLaQ==
X-Received: by 2002:a17:90b:4b84:b0:1d2:add6:804c with SMTP id lr4-20020a17090b4b8400b001d2add6804cmr2869826pjb.107.1650594975225;
        Thu, 21 Apr 2022 19:36:15 -0700 (PDT)
Received: from [192.168.123.123] ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id 23-20020a621917000000b0050ab87c15e7sm473345pfz.53.2022.04.21.19.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 19:36:14 -0700 (PDT)
Message-ID: <f3f6ea7d-2051-7a7f-61e0-8a5bba8ca8f2@gmail.com>
Date:   Fri, 22 Apr 2022 10:35:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RESEND PATCH -next] USB: serial: pl2303: implement reset_resume
 member
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        stable@vger.kernel.org, "sheng . huang" <sheng.huang@ecastech.com>,
        wangqi@kylinos.cn, xiongxin@kylinos.cn
References: <20220419065408.2461091-1-xy521521@gmail.com>
 <YmGKL05dnA+q/HAM@kroah.com>
From:   Hongyu Xie <xy521521@gmail.com>
In-Reply-To: <YmGKL05dnA+q/HAM@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi greg,
On 2022/4/22 00:45, Greg KH wrote:
> On Tue, Apr 19, 2022 at 02:54:08PM +0800, Hongyu Xie wrote:
>> From: Hongyu Xie <xiehongyu1@kylinos.cn>
>>
>> pl2303.c doesn't have reset_resume for hibernation.
>> So needs_binding will be set to 1 duiring hibernation.
>> usb_forced_unbind_intf will be called, and the port minor
>> will be released (x in ttyUSBx).
> 
> Please use the full 72 columns that you are allowed in a changelog text.
> 
> 
>> It works fine if you have only one USB-to-serial device.
>> Assume you have 2 USB-to-serial device, nameing A and B.
>> A gets a smaller minor(ttyUSB0), B gets a bigger one.
>> And start to hibernate. When your PC is in hibernation,
>> unplug device A. Then wake up your PC by pressing the
>> power button. After waking up the whole system, device
>> B gets ttyUSB0. This will casuse a problem if you were
>> using those to ports(like opened two minicom process)
>> before hibernation.
>> So member reset_resume is needed in usb_serial_driver
>> pl2303_device.
> 
> If you want persistent device naming, use the symlinks that udev creates
> for your for all your serial devices.  Never rely on the number of a USB
> to serial device.
Let me put it this way. Assume you need to record messages output from 
two machines using 2 USB-to-serial devices(naming A and B, and A is on
USB1-port3, B is on USB1-port4) opened by two minicom process.
The setting for A in minicom would be like:
	"A -    Serial Device      : /dev/ttyUSB0"
The setting for B in minicom would be like:
	"A -    Serial Device      : /dev/ttyUSB1"
Then start to hibernate on your computer. When your PC is in
hibernation, unplug A. After waking up your computer, "/dev/ttyUSB0"
would be released first, then allocated to B. The minicom process used
to record outputs from A is now recording B's outputs. The minicom
process used to record outputs from B is now recording nothing, because
"/dev/ttyUSB1" is not exist anymore. That's the problem I've been
talking about. And I don't think using symlinks will solve this problem.

> 
>> Codes in pl2303_reset_resume are borrowed from pl2303_open.
>>
>> As a matter of fact, all driver under drivers/usb/serial
>> has the same problem except ch341.c.
>>
>> Cc: stable@vger.kernel.org
> 
> How does this meet the stable kernel rule requirements?  It would be a
> new feature if it were accepted, right?
It's not a new feature at all. struct usb_serial_driver already has a
member name reset_resume, there is no implementation in pl2303.c yet.
And ch341.c has one(ch341_reset_resume()), that why I said "all driver
under drivers/usb/serial has the same problem except ch341.c"
> 
> 
> thanks,
> 
> greg k-h
