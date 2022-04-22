Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38D50B0C3
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 08:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444344AbiDVGpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 02:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386580AbiDVGpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 02:45:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D480750B38;
        Thu, 21 Apr 2022 23:42:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q19so6607711pgm.6;
        Thu, 21 Apr 2022 23:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=c+gzw+0PvYZSlG9cMDMGgPLdz5HZryLTxEZXxTc5seY=;
        b=nlgY8tR7FS+bFmv97mL5xtjWhH+prdlEhMS5IXF//j7p1dhcwtK+0DlsVnU7ogNOyo
         D6c9Er2LInxJ255oLzcnN7ooMg/bSEcrHUi67fMdVUcMRDzUEqXXBfI3Qqrbmop6yoII
         jpEschh7uL159eXhPCgh0QAGLfeEWlPK3KxD4inmHPEeECtZ24RN9GYrlHSnCl/JevXb
         8ZZgSwZno9AgCzWI0/I/hEHMKRYmRwlqD5oWgJ74yI+AldPcYCOX11UAbz37GitKDzh6
         3nkYmW1e5mSrpaik5yORd+wl49Qh9OCLwiEAEtWrIn2YT0NHYJKMiVSIQJ5Df/86cD81
         iSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c+gzw+0PvYZSlG9cMDMGgPLdz5HZryLTxEZXxTc5seY=;
        b=MIfja/mRXO5wnUGvNxK2zN1acE3ZnTW3LvnXuIfgnaqQ7X0qRytOgDiQ2MCeOwaJIG
         9pRYY33bvsDJwU70i5+PFk8eZlDoduHopusKgH/QXaO3HvxM+6ykbl6G43rDlmhOsUSx
         I3O3AO6Sg/bfP/Sdc7kORucErY16rb/7f+vnn0KUmeA7y25uNN41V6+0BsMf/0q3oL8B
         a+cRJ262A/SOPx6JdYtju9aYTp9fCWw7YszTkOW8iFPKZk/9M/HdlOhdsKrVFusIOsqy
         Xcd1KCGtsD4sIlsoOUyw+pDCpMO6Z5ZMk0v7uRGY5WKnXf3mM/cwvIetxG+vonXGML7D
         7apQ==
X-Gm-Message-State: AOAM5303stVdbbHZF+3pMC1AdHuKeQgCjYfvAEbJ2tZAegGCIhdIWbG7
        vDlAMkB1TI6llQZ9XIkkZ6Y=
X-Google-Smtp-Source: ABdhPJyHxM7+wdYNkoEvKbKTXkP70PL5rio+o7MYxr+tAHCnsTFSXHQ9+fGn5ORDVK6Zdaygvvttfg==
X-Received: by 2002:a05:6a00:1354:b0:50c:e672:edfc with SMTP id k20-20020a056a00135400b0050ce672edfcmr3080981pfu.50.1650609770282;
        Thu, 21 Apr 2022 23:42:50 -0700 (PDT)
Received: from [192.168.123.123] ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id 8-20020a056a00070800b004e14ae3e8d7sm1178734pfl.164.2022.04.21.23.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 23:42:49 -0700 (PDT)
Message-ID: <99546b13-44f1-3dbf-aeb4-86c76ce74626@gmail.com>
Date:   Fri, 22 Apr 2022 14:42:41 +0800
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
 <YmGKL05dnA+q/HAM@kroah.com> <f3f6ea7d-2051-7a7f-61e0-8a5bba8ca8f2@gmail.com>
 <YmI4I9MCLBheMyvr@kroah.com>
From:   Hongyu Xie <xy521521@gmail.com>
In-Reply-To: <YmI4I9MCLBheMyvr@kroah.com>
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


Hi greg
On 2022/4/22 13:07, Greg KH wrote:
> On Fri, Apr 22, 2022 at 10:35:59AM +0800, Hongyu Xie wrote:
>>
>> Hi greg,
>> On 2022/4/22 00:45, Greg KH wrote:
>>> On Tue, Apr 19, 2022 at 02:54:08PM +0800, Hongyu Xie wrote:
>>>> From: Hongyu Xie <xiehongyu1@kylinos.cn>
>>>>
>>>> pl2303.c doesn't have reset_resume for hibernation.
>>>> So needs_binding will be set to 1 duiring hibernation.
>>>> usb_forced_unbind_intf will be called, and the port minor
>>>> will be released (x in ttyUSBx).
>>>
>>> Please use the full 72 columns that you are allowed in a changelog text.
>>>
>>>
>>>> It works fine if you have only one USB-to-serial device.
>>>> Assume you have 2 USB-to-serial device, nameing A and B.
>>>> A gets a smaller minor(ttyUSB0), B gets a bigger one.
>>>> And start to hibernate. When your PC is in hibernation,
>>>> unplug device A. Then wake up your PC by pressing the
>>>> power button. After waking up the whole system, device
>>>> B gets ttyUSB0. This will casuse a problem if you were
>>>> using those to ports(like opened two minicom process)
>>>> before hibernation.
>>>> So member reset_resume is needed in usb_serial_driver
>>>> pl2303_device.
>>>
>>> If you want persistent device naming, use the symlinks that udev creates
>>> for your for all your serial devices.  Never rely on the number of a USB
>>> to serial device.
>> Let me put it this way. Assume you need to record messages output from two
>> machines using 2 USB-to-serial devices(naming A and B, and A is on
>> USB1-port3, B is on USB1-port4) opened by two minicom process.
>> The setting for A in minicom would be like:
>> 	"A -    Serial Device      : /dev/ttyUSB0"
>> The setting for B in minicom would be like:
>> 	"A -    Serial Device      : /dev/ttyUSB1"
>> Then start to hibernate on your computer. When your PC is in
>> hibernation, unplug A. After waking up your computer, "/dev/ttyUSB0"
>> would be released first, then allocated to B. The minicom process used
>> to record outputs from A is now recording B's outputs. The minicom
>> process used to record outputs from B is now recording nothing, because
>> "/dev/ttyUSB1" is not exist anymore. That's the problem I've been
>> talking about. And I don't think using symlinks will solve this problem.
> 
> Yes, symlinks will solve the issue, that is what they are there for.
> Look in /dev/serial/ for a persistent name for them that allows you to
> uniquely open the correct device if they can be described.  Using
> /dev/ttyUSBX is almost never the correct thing to do.
Thanks for letting me know this. This patch is useless. I still have one 
more question though, since using /dev/ttyUSBX is almost never the 
correct thing to do, what is /dev/ttyUSBx used for then?
> 
>>>> Codes in pl2303_reset_resume are borrowed from pl2303_open.
>>>>
>>>> As a matter of fact, all driver under drivers/usb/serial
>>>> has the same problem except ch341.c.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>
>>> How does this meet the stable kernel rule requirements?  It would be a
>>> new feature if it were accepted, right?
>> It's not a new feature at all. struct usb_serial_driver already has a
>> member name reset_resume, there is no implementation in pl2303.c yet.
>> And ch341.c has one(ch341_reset_resume()), that why I said "all driver
>> under drivers/usb/serial has the same problem except ch341.c"
> 
> Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for what is valid stable kernel changes.
> 
> thanks,
> 
> greg k-h
thanks,

Hongyu Xie
