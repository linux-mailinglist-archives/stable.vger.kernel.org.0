Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6552DD69
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiESTFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiESTFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:05:02 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0F3532FC;
        Thu, 19 May 2022 12:05:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j6so5878154pfe.13;
        Thu, 19 May 2022 12:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=WCT0hzIW4BRC4ihOSuYMd7vmc8qyUUY0/7ETmCstrKQ=;
        b=I5gizDUP9eFXALtskq8wtDRs1FF6xcWct/dwquOJmp5R6jdqySzPeyfd2YxLETggTe
         zsoETshmZoPWJC9HX3OG+LKhvu+Owlj1Xyqt3WTVMGKx5ioHEHRrxMvdh5dOnnw2+R7L
         /qxA4wPUTMSLCv6DoIblAn1M7Hkz/LQT1/sf/HgPVnh/uhYbCrrwn2DyOEIk7J75vhlW
         bJE8Hy/I8G5KabtGjcySdIRg4P1RezIgELEU8DITWIletQpyk2hGx8I7AOfnrOiMDlU7
         o8cMCqCiX1MY0G9E0ioRLsMR8OkQvwFgKcw1W5RWxcIth4nFgKXryPfvdgu6lEtlDtT0
         jkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=WCT0hzIW4BRC4ihOSuYMd7vmc8qyUUY0/7ETmCstrKQ=;
        b=CW4WzDw9IRvxhSd6PaMuM0CRFHMCfEL3ixq0hoZRp+tlGmO9JehzGofpHAs26olSav
         HS9/huInyf7IONvPeKJJQ4HiJjRkVGdX3dTiV3BnGFTbfXHt42KRGD23+EIK9MsxEg76
         u4ZI/Cyj/6Y8hN5Pjl9dx6ApPim9KpzgOjdMCc7zPHV65ROS+i8XtpARCX0yhNobncIm
         um/OHRENXeCYFgJPd6Spq9PG0F7oa8pKx4AojvBUuV0sJ5OcmDmXp5INEro9EyhcBpp5
         hj+stWyQfLbbq3KD2nod8rlSfpQvY8iRbXu4fUVHrq4jp9IRULIFLrDypihcUCcFQ6r4
         3cMg==
X-Gm-Message-State: AOAM533/lf2KKdui9o1XUb4EnwRuHRNSt0M5nmhLrzYEY+d8E+6aakem
        sAXZIuH3VDZrO0uR7L3/2HeLbNGJLuE=
X-Google-Smtp-Source: ABdhPJxdsHDeOkVdzSo/tSvdzpUUjx/GOlwlHb2IfakWPr418DyzIYgfDQ8C0Jrctgm2Oc9RaBBmuQ==
X-Received: by 2002:a63:5446:0:b0:3db:b1a0:ddca with SMTP id e6-20020a635446000000b003dbb1a0ddcamr5221703pgm.518.1652987100996;
        Thu, 19 May 2022 12:05:00 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a13-20020aa7864d000000b0051829b1595dsm23972pfo.130.2022.05.19.12.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 12:05:00 -0700 (PDT)
Message-ID: <1892af53-5d83-ac8a-1180-970bf07e8889@gmail.com>
Date:   Thu, 19 May 2022 12:04:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH stable 4.19 0/3] MMC timeout back ports
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?Q?Christian_L=c3=b6hle?= <CLoehle@hyperstone.com>,
        "open list:MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND..." 
        <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, alcooperx@gmail.com,
        kdasu.kdev@gmail.com
References: <20220517182211.249775-1-f.fainelli@gmail.com>
 <1392eba8-d869-aa1a-b154-cec870017115@gmail.com>
In-Reply-To: <1392eba8-d869-aa1a-b154-cec870017115@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/19/2022 10:38 AM, Florian Fainelli wrote:
> 
> 
> On 5/17/2022 11:22 AM, Florian Fainelli wrote:
>> These 3 commits from upstream allow us to have more fine grained control
>> over the MMC command timeouts and this solves the following timeouts
>> that we have seen on our systems across suspend/resume cycles:
>>
>> [   14.907496] usb usb2: root hub lost power or was reset
>> [   15.216232] usb 1-1: reset high-speed USB device number 2 using
>> xhci-hcd
>> [   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
>> [   15.525328] mmc1: error -110 doing runtime resume
>> [   15.531864] OOM killer enabled.
>>
>> Thanks!
> 
> Looks like I managed to introduce a build warning due to the unused 
> timeout variable, let me submit a fresher version for 4.19, 4.14 and 4.9.

Only v4.19 and v4.14 required a v2, you can find both here:

https://lore.kernel.org/lkml/20220519184536.370540-1-f.fainelli@gmail.com/T/#t

https://lore.kernel.org/lkml/20220519190030.377695-1-f.fainelli@gmail.com/T/#t

Sorry about that, I will build with W=1 in the future to notice those 
set but unused variable warnings.

Thanks!
-- 
Florian
