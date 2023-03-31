Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64ED6D2986
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjCaUe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbjCaUeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 16:34:22 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE89822214;
        Fri, 31 Mar 2023 13:34:18 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k14-20020a9d700e000000b0069faa923e7eso12505234otj.10;
        Fri, 31 Mar 2023 13:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680294858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=brFv5oN0skZ/bF4RL1YQ1vEswxmq2yM1DSYlqK5YHVA=;
        b=I6e0Aq0hY16HKwhA7NUR7JRNjlXWTeeeFKm+Ic83qo/+nU4VH/tgPbCXaRpnJOx7EM
         OnAG4fOQxRq4Xy02Kqb8d2T/LP4U845iAZ91mdrHNambRiOpnOtKV991yeYKx2g6enCs
         m4d1iraxg0YHxv9a0PgtdJA5p0dhmYHRYwWNw7dGq1cbqMf9fjwFE+iQ6ynYnIhGNRVa
         WvBAiItMPN3WRRavcdNexMXYvQOLkqs1yVcw4B5neYG8oWV5yVJZUPjtAJfFsRPxSJa2
         CqHsI0HZ44gYFtejspAvb2G3TgJ53cLLWlGpYaX908YYJUeWtrZDDmCdoPIKWNbpo4MR
         vqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680294858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=brFv5oN0skZ/bF4RL1YQ1vEswxmq2yM1DSYlqK5YHVA=;
        b=oHWvxMSAowS1vJXFRVvpWmYI/Jih3QyepnDral498aeunLDEwDuj1fStWTWfx4nvvO
         WdzPk3S9ssZq7TXbvArcNu75ZWVLhz110BbN4v04nHKUU7KWcDyO0WttcqjIfjzjo+9y
         2HkZqovGYu9LO/fmAj4YybhQNNYuBfsDBmmXURK9NVm05Ln68Mmr3yBSdQKq8824exEE
         IDkydWZEYsmAPayVKo3yPRxtSZm+L5RFFKv16udZX14+Ri5uvbN2btq7uXP7PqMFht4T
         DzDvUPLP1hAo1Fi2p1swKQHgj7OBZnMMdm57OCWoGS2fjaBpemiC0OwVsdK9EQ+WxtUC
         USJw==
X-Gm-Message-State: AAQBX9dMlmHQg0R70Oh1ZHBAfQxAHJ28RNW7tKH8ql1S5Gt5iXPj4ryc
        DH+85jnmPHecWoWiVdJkb01/CVVo0z083Q==
X-Google-Smtp-Source: AKy350be+E5TUItSNS4XPytOyba2NHdLEYytfb3vKWHMniFeY3QJ/2OSz2lXlxBD+9k5LSna8gFZYA==
X-Received: by 2002:a05:6830:114c:b0:6a1:3cc7:170d with SMTP id x12-20020a056830114c00b006a13cc7170dmr9422096otq.10.1680294858139;
        Fri, 31 Mar 2023 13:34:18 -0700 (PDT)
Received: from [192.168.7.168] (c-98-197-58-203.hsd1.tx.comcast.net. [98.197.58.203])
        by smtp.gmail.com with ESMTPSA id k24-20020a056830169800b0069f95707335sm1490833otr.69.2023.03.31.13.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 13:34:17 -0700 (PDT)
Message-ID: <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
Date:   Fri, 31 Mar 2023 15:34:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 0/2] RTW88 USB bug fixes
Content-Language: en-US
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
From:   "Alex G." <mr.nuke.me@gmail.com>
In-Reply-To: <20230331121054.112758-1-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/23 07:10, Sascha Hauer wrote:
> This series fixes two bugs in the RTW88 USB driver I was reported from
> several people and that I also encountered myself.
> 
> The first one resulted in "timed out to flush queue 3" messages from the
> driver and sometimes a complete stall of the TX queues.
> 
> The second one is specific to the RTW8821CU chipset. Here 2GHz networks
> were hardly seen and impossible to connect to. This goes down to
> misinterpreting the rfe_option field in the efuse.

I applied both these patches, tested an 8821CU, and the news are good:

The number of kernel warnings and adapter hangs has gone down considerably.

The signal levels on 2.4GHz bands have improved noticeably. There is the 
occasional station coming in 30dB lower than on nearby adapters. I 
wasn't able to find a pattern here.

I can now run these adapters in IBSS and 802.11s modes on the 2.4 GHz 
band. That was not possible before.

I am impressed with the improvements in these patches. For the series:

Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
>
> Sascha Hauer (2):
>    wifi: rtw88: usb: fix priority queue to endpoint mapping
>    wifi: rtw88: rtw8821c: Fix rfe_option field width
> 
>   drivers/net/wireless/realtek/rtw88/rtw8821c.c |  3 +-
>   drivers/net/wireless/realtek/rtw88/usb.c      | 70 +++++++++++++------
>   2 files changed, 48 insertions(+), 25 deletions(-)
> 
