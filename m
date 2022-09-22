Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61CA5E5A04
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 06:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIVEEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 00:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiIVEEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 00:04:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11376AF4A4;
        Wed, 21 Sep 2022 21:02:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f23so7619988plr.6;
        Wed, 21 Sep 2022 21:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=UGQQRO32II6TD/xGERxjlGRI57xmZxRC4vM9QR9B5uI=;
        b=W1c2w0lg/ZJ671DcHDRUumlwKGkq9/GSXT331/7RySB5hye8SSGSWHtrfBv/X5rR/Y
         uSc27k1qSXbXw3q3/exwJfOVncI3LaCb+H6mqYPz/bGc8YLdNwWJ1vTaitaNbzF04vXQ
         M0zONt88ZzGfd0RKVqLOxXf9Qknl/2BKutz+88rnTkxOo8HJtkdcAWyhxKOXDqPUY8LY
         YUyDU4aDGihgFxTqbL3oniy+q3TqG6dCNzRmtOzLjyQSsCpcR+p7sIQH3PYmjThoZ29W
         4MylO5qEYdJ/ZplMI7B9vBCDCGairixzNllFPckTIi9Z6y94GhTWLlAM0nDUMFcnZ5BH
         8r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UGQQRO32II6TD/xGERxjlGRI57xmZxRC4vM9QR9B5uI=;
        b=BmQsj93BrHx1cQb3BI57kCBBU4eeJ0BpHQ5GuJh04lCV5sLL95BUbuVoCRCjZuA12s
         d7TRt5GA9GnaDF5Yf1A5DoLkl3CbZFWcgipFBOPRzqxlnvtusEjhAZj2EV8k8fxvq7ZJ
         HhRdDIuZJsecLV6OS0pyvpKHR7YJnfwl8UTEWFTphZQu8pQSKAImA29vm1PGtqLUoWiE
         F0npbg/vcfm/CLxv/edyCXH/CYk5sVJHxy7kagX4JE6cQmjYpSnuN09lf1nPDNs6EqCe
         XlCNI4bYFnAdR4gtpynKlVKboSK2EkBlpoIw2rZKL7e6IkaEX/2UJD6kItxtm+BdvDtN
         vSeQ==
X-Gm-Message-State: ACrzQf1LzZmj+qG64Hbq2E96EdOV+1Gjs5Ib7Nv/gqrGnoJ5gcO0IuSz
        ypPGWTX9R327i3MYOhnXfOg=
X-Google-Smtp-Source: AMsMyM4miMb2cX9pcNVnCXoWkK996EOIDIOtjJ/lQQLwLEeFzlVjRUC+lWoBo56kfJAo6qLIUZ0MzA==
X-Received: by 2002:a17:90b:1c09:b0:203:af4d:ed6 with SMTP id oc9-20020a17090b1c0900b00203af4d0ed6mr12684679pjb.243.1663819348802;
        Wed, 21 Sep 2022 21:02:28 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id p63-20020a625b42000000b0053e80618a23sm3080737pfb.34.2022.09.21.21.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 21:02:27 -0700 (PDT)
Message-ID: <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
Date:   Thu, 22 Sep 2022 11:02:21 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: Linux 4.14.294
Content-Language: en-US
To:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz, Jason Wang <wangborong@cdjrlc.com>
References: <1663669061118192@kroah.com> <1663669061138255@kroah.com>
 <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 01:03, Joe Perches wrote:
> On Tue, 2022-09-20 at 12:17 +0200, Greg Kroah-Hartman wrote:
> []
>> diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
> []
>> @@ -118,7 +118,7 @@ struct report_list {
>>   * @multi_packet_cnt:	Count of fragmented packet count
>>   *
>>   * This structure is used to store completion flags and per client data like
>> - * like report description, number of HID devices etc.
>> + * report description, number of HID devices etc.
>>   */
>>  struct ishtp_cl_data {
>>  	/* completion flags */
> 
> Needless backporting of typo fixes reduces confidence in the
> backport process.
> 

The upstream commit 94553f8a218540 ("HID: ishtp-hid-clientHID: ishtp-hid-client:
Fix comment typo") didn't Cc: stable, but got AUTOSELed [1].

I think we should only AUTOSEL patches that have explicit Cc: stable.

[1]: https://lore.kernel.org/stable/20220910211938.70997-2-sashal@kernel.org/

-- 
An old man doll... just what I always wanted! - Clara
