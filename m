Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029106EF781
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjDZPIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241249AbjDZPIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 11:08:44 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4888F5FF4;
        Wed, 26 Apr 2023 08:08:42 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-38e04d1b2b4so4066724b6e.3;
        Wed, 26 Apr 2023 08:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682521721; x=1685113721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+0wUGEsG6neJ+5NAvtMB9CEdYBN8SKIspY+2lck0/+Q=;
        b=Pvbu1Qyjti/qLBrv1fuyBdgehVwQuLt7U6ncdUwr1KQyAaPduxUlLwOIXMCma3H0Qn
         f7PzyFXkxbV6/RSRBq2vfIS4c+eqzBn8SGYTz6LjwCLuFtbY4CYKsX77/GPqtAzUcDZe
         2oASolz5jHRtXdb3Yb23Mx5UqEHvnE/1Q/oAnhWhVjzqXYMA8acVrMNP0RVNnkQdBla4
         qtYEZ//xIAGcN6jOuza0Dme35qfT15Ij4P1r5Wigesgv8/41sqFOSeD82e+0bWthxNZX
         H2XrML6PC1OOMP6GCB+WadUFFqC2kS7g0PRHWzeJab+U6q3qBaS3t59Ve8qJqjkRhdGF
         E6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682521721; x=1685113721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+0wUGEsG6neJ+5NAvtMB9CEdYBN8SKIspY+2lck0/+Q=;
        b=dAi+ygDhjf++h+EhdLrMwGBYhHDSHkj1kmRqi1YnrZ+byrHh+wITkx1k3Q6e4CI36D
         XL2wc55s7B6diWPwX/dMQP92os38jCM6G0cE+10Z/UyDo+sKRX0VnjVnvSR8ey6BaXp7
         te6IkkyLwFkS51bh6pGDCdV3jHmAH9pKeYX4dN1uHf0sHhQO6ajVyt3o3GyTqX3KvtAQ
         XEybyL0v5xecyDksy2nijzpvcqcm4FggY3WN/DReP9dRwfwFoduhWypxhkpPim+l4Fb9
         YUMdAMomUsC34WZjEcFshQ85lURx0YTj+XAQjTPiXgy9LDCMv1otKkNYiHLuNYXo1iLo
         kzkQ==
X-Gm-Message-State: AAQBX9eYBCbz+LBXeeW7A0U1qELVniHbZMdyI/KV2C4bZDoa1xUimDvM
        uFwQt07xV10FG96LCugQTeE3s2Tj9PY=
X-Google-Smtp-Source: AKy350aEr5909KadLgxA/i4EIx1ixO70aeikULJkp6F73THSomKME4oeltiJDHKlNbhZCQxfeNrKEA==
X-Received: by 2002:a54:400f:0:b0:38e:8e39:51c6 with SMTP id x15-20020a54400f000000b0038e8e3951c6mr7380277oie.49.1682521721477;
        Wed, 26 Apr 2023 08:08:41 -0700 (PDT)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id v132-20020acade8a000000b00383eaf88e75sm6815886oig.39.2023.04.26.08.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 08:08:41 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <903aa497-e6d3-d396-22a7-74fe7382fc74@lwfinger.net>
Date:   Wed, 26 Apr 2023 10:08:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1
 caused by access null page
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20230426034737.24870-1-pkshih@realtek.com>
 <87r0s7teik.fsf@kernel.org> <b1c5e4f89ba843cd958f569547caa8e5@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <b1c5e4f89ba843cd958f569547caa8e5@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/23 00:16, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Kalle Valo <kvalo@kernel.org>
>> Sent: Wednesday, April 26, 2023 1:10 PM
>> To: Ping-Ke Shih <pkshih@realtek.com>
>> Cc: stable@vger.kernel.org; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
>>
>> Ping-Ke Shih <pkshih@realtek.com> writes:
>>
>>> Though SER can recover this case, traffic can get stuck for a while. Fix it
>>> by adjusting page quota to avoid hardware access null page of CMAC/DMAC.
>>>
>>> Fixes: a1cb097168fa ("wifi: rtw89: 8852b: configure DLE mem")
>>> Fixes: 3e870b481733 ("wifi: rtw89: 8852b: add HFC quota arrays")
>>> Cc: stable@vger.kernel.org
>>> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Link: https://github.com/lwfinger/rtw89/issues/226#issuecomment-1520776761
>>> Link: https://github.com/lwfinger/rtw89/issues/240
>>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>>> ---
>>> v2: add Fixes, Cc and Tested-by tags suggested by Larry.
>>
>> Should this go to wireless tree for v6.4?
>>
> 
> Yes, please take it to v6.4. People can get stable connection with this fix.

I agree.

Larry


