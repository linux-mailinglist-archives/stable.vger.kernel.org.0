Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E8522738
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiEJWu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbiEJWu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:50:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652C024EA05
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:50:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id bo5so408816pfb.4
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LQpLllgONrrjRjbzd5pzMpCmxzKfwBycUBev+97SkuU=;
        b=z21WwdqiIt7hG8RyC6XRgynBysMtLb4WUdBq3R4mmAUOSwun5PMZQV8A2j2dARpDOT
         lTWlb2Q289lKNj9oFMH0leEp9HAZhnc5PB6nP7hBYlQXjuW4WWPesoYdraA+4V1cmudM
         JF9pRhLXnLDbWBmT23bGm95w+YUBPdsOj6HR+L26np4nwSk/TSVATtQjZwXua5OSHTKe
         E6QtZ1Kxqa03O4vR1utHDoIooL1Ybic431X/sxQ4I/RMNae5TtJSFyLoac/lb89gRQ0T
         XcDSk6R5x6PR4MlsAHjnvkfqanFlo3rlsbFEjf52HzO4yUiY3cVlbsSP5gMqEA5vFdEJ
         UyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LQpLllgONrrjRjbzd5pzMpCmxzKfwBycUBev+97SkuU=;
        b=XpVH5wb0Di3nwejK/qZ6THgfUY/g0mQ3rejx19pi4B4EUU4Y3R3ne0+Juoh+SxzG97
         IoNa7d2uazR06Y9ajc7VETowTFudzzG+3aujvsK/2WhbMuLUr34W3HEhlQi1R49Hygqv
         I7TguTOxJMV42HK+6ye5/p9TK17EwOfHsNX1dieeSdYPSnAAk43Z3uMptUQW3wS/vGhh
         hOdq/DR4Ee5yYv9oAqgtFwcJh5Zb9Gr8vuaclmhfs+Wg3Qemi/jhV3rN6PTc0f36nvFK
         Ab5Ip1poFHUzzlfTt6QETBcNuICg2Acmpe/yVdaCYxjfDB/ej2Y74CwbVZHs2gFIpjwZ
         TG9A==
X-Gm-Message-State: AOAM530ScG6Wfbsvh9gn74F1pqJYWV2hIgh1HBO0m+Or9Nnh+91lYOCp
        m6Y30SSsaxL1XP627zvqjTou/A==
X-Google-Smtp-Source: ABdhPJwki9DMZm5zvN7+V4rQQ7syaEnadJxZTu4l9mmW5NhMxkDW4LiJFBV8Wl+u9JHhr/3ILqfxGA==
X-Received: by 2002:a05:6a00:1991:b0:50e:697:53f9 with SMTP id d17-20020a056a00199100b0050e069753f9mr22516734pfl.22.1652223021711;
        Tue, 10 May 2022 15:50:21 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id x12-20020a62860c000000b0050dc762818fsm74576pfd.105.2022.05.10.15.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:50:21 -0700 (PDT)
Message-ID: <7c5a9967-b5b6-50f3-2492-cbcdffa24080@linaro.org>
Date:   Tue, 10 May 2022 15:50:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] exfat: check if cluster num is valid
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
References: <20220418173923.193173-1-tadeusz.struk@linaro.org>
 <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jeon,
On 4/21/22 22:54, Namjae Jeon wrote:
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
>>   print_address_description+0x81/0x3c0 mm/kasan/report.c:233
>>   __kasan_report mm/kasan/report.c:419 [inline]
>>   kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>>   exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>>   exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>>   __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>>   exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>>   exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>>   notify_change+0xb76/0xe10 fs/attr.c:336
>>   do_truncate+0x1ea/0x2d0 fs/open.c:65
> Could you please share how to reproduce this ?

Sorry, I missed this.
The reproducer [1] can be found on the syzbot report website [2]

[1] https://syzkaller.appspot.com/text?tag=ReproC&x=1353dfdf700000
[2] https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
-- 
Thanks,
Tadeusz
