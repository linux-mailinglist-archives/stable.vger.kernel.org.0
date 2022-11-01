Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE9615283
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 20:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKATpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 15:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiKATpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 15:45:04 -0400
X-Greylist: delayed 578 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 12:45:03 PDT
Received: from mx2.mythic-beasts.com (mx2.mythic-beasts.com [IPv6:2a00:1098:0:82:1000:0:2:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBFA1DF24
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 12:45:03 -0700 (PDT)
Received: from [217.155.36.16] (port=40428 helo=[192.168.1.22])
        by mailhub-hex-d.mythic-beasts.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john-linux@pelago.org.uk>)
        id 1opx2k-00EEPU-Ra; Tue, 01 Nov 2022 19:35:27 +0000
Message-ID: <8497a3bb-be33-ba8e-b31b-f59bf9eca5dd@pelago.org.uk>
Date:   Tue, 1 Nov 2022 19:35:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106
 devices
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <6239ff94-c587-b2ac-9b8b-cdf5e65d0157@pelago.org.uk>
 <Y2F0IR6YchEOjaYT@kroah.com>
From:   John Veness <john-linux@pelago.org.uk>
In-Reply-To: <Y2F0IR6YchEOjaYT@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BlackCat-Spam-Score: 0
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/11/2022 19:31, Greg KH wrote:
> On Mon, Oct 31, 2022 at 01:12:21PM +0000, John Veness wrote:
>> Hello,
>>
>> Please can you consider my "ALSA: usb-audio: Add quirks for MacroSilicon
>> MS2100/MS2106 devices" patch, with upstream commit ID
>> 6e2c9105e0b743c92a157389d40f00b81bdd09fe for inclusion in all -stable
>> kernels. Apart from the device IDs, it is a copy of the similar existing
>> patch for MS2109 devices, which is already present in -stable kernels.
> 
> That commit is already in the 5.15.56 release.  If you wish to have it
> added to older stable kernel trees, please provide a working backport as
> it does not apply cleanly.
> 
> thanks,
> 
> greg k-h

OK, thanks Greg. I wasn't sure if backporting was something I had to do, 
or that someone else would do for me! I am very new to kernel dev, but I 
will see what I can do.

John
