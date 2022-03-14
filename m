Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23694D8A3B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiCNQ7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbiCNQ7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:59:40 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1576E0DB;
        Mon, 14 Mar 2022 09:58:29 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id h10so18020890oia.4;
        Mon, 14 Mar 2022 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e7emgToOYLyrqE4LWnE5OaJ65U3Cke+K2ktOlbWX7Hs=;
        b=g9j5YdkjI4Iccj3VTZlC4w2cAU8GxI7g5cAxQSlsguh9cn3BjhSiG1u5Eo4F5gLChO
         YQSsgehem1lcT9eGdEH2Nygb2BZNG3QhcyAq04O2r4nJKovCfsqd5mX/V1WVDqaJ+4Ft
         23JvWnLg3MfYz9slBiBxc1ByplvJzXghqcm8BDB5uxP5mlNEOFwslSRtMLnwCmNerYP2
         lgR7vpK/LaVwzsgd2gh4V5+tfNGrQQFQ8/Cn2gBn66o5mjC+NBkxiibRn7NERCPplgEw
         CKeEayAe5yXRBVyoMdp/4brolTRoorYo1FuhUWw1lB1IVDp4KyZwJV+ecE2fWMDUQ58s
         Kqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e7emgToOYLyrqE4LWnE5OaJ65U3Cke+K2ktOlbWX7Hs=;
        b=4Vsi0jzLi7SIsl1yOXzJofe1s5IueN6AFg2g4NcVNRuQIYSpSILAtjt3sNNbMSq1wO
         SlL6c5M9bIH28ZLMeX/yHMXXoh05mowZ+7dsVLyK7XOLD1k8H6+4fWzv5tyJGJITjYEG
         1TK97YfwOExI5g5cTjjDCoDVVrgBe53s6UtjNuXkmmYEvfKajnmQ29lkqeDrdzUP/w+8
         3Y55cuseqK8fCFT9c3nLNEfUJz07+SOCZ7OTqnZ0l+i2fdK1fmp3e/mlJHYfvSlW3B71
         snalkpAkfEvCL5SOSzcgRa3N6qp4hsEFqBGFNhZp0KjkPaXlWpz5mPBum+njnAGvlaWl
         XKnw==
X-Gm-Message-State: AOAM5307R7qbTyB3jdfcijGH75jSlQvwD+gmJnWZx/1mcTKxxcEvUodT
        rEqvIWA3FA0frdIGhQE52qHkjXq6oSY=
X-Google-Smtp-Source: ABdhPJxVnSF4o+WJIKwCHtFsHLbrVjWwjVw/XYMvUE1trnLE/H7tGt3NrnB8Uf9tfCpAHXBa21oCSA==
X-Received: by 2002:a05:6808:15a2:b0:2d9:df7f:e6f2 with SMTP id t34-20020a05680815a200b002d9df7fe6f2mr118707oiw.94.1647277108766;
        Mon, 14 Mar 2022 09:58:28 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::1064? (2603-8090-2005-39b3-0000-0000-0000-1064.res6.spectrum.com. [2603:8090:2005:39b3::1064])
        by smtp.gmail.com with ESMTPSA id q11-20020aca5c0b000000b002ecaf985db8sm3960524oib.14.2022.03.14.09.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:58:27 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <bb2abb66-f3f3-c5b8-cebd-2157a8e2e35f@lwfinger.net>
Date:   Mon, 14 Mar 2022 11:58:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
Content-Language: en-US
To:     Pkshih <pkshih@realtek.com>, "kvalo@kernel.org" <kvalo@kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220313164358.30426-1-Larry.Finger@lwfinger.net>
 <9ae5780119e24142bffd855d915a5e92@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <9ae5780119e24142bffd855d915a5e92@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/13/22 19:21, Pkshih wrote:
> 
>> -----Original Message-----
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>> Sent: Monday, March 14, 2022 12:44 AM
>> To: kvalo@kernel.org
>> Cc: linux-wireless@vger.kernel.org; Larry Finger <Larry.Finger@lwfinger.net>; Pkshih <pkshih@realtek.com>;
>> stable@vger.kernel.org
>> Subject: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
>>
>> The rtl8821ce with RFE Type 6 behaves the same as ones with RFE Type 0.
>>
>> This change has been tested in the repo at git://GitHub.com/lwfinger/rtw88.git.
>> It fixes commit 769a29ce2af4 ("rtw88: 8821c: add basic functions").
>>
>> Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions").
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: stable@vger.kernel.org # 5.9+
>> ---
>> Kalle,
>>
>> This patch file was prepared a couple of months ago, but apparently not submitted
>> then. It should be applied as soon as possible.
>>
>> Larry
> 
> Hi Larry,
> 
> This patch has been merged [1]. The git link of wireless driver next has been
> changed [2]. That may be the reason you can't find the patch.
> 
> [1] https://lore.kernel.org/all/164364407205.21641.13263478436415544062.kvalo@kernel.org/
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git

Ping-Ke,

Thanks for the heads-up. I have re-cloned my repo.

@Kalle: Ignore the noise.

Larry

