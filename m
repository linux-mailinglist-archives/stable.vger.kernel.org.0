Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6CA6E7E37
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjDSPZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbjDSPZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 11:25:32 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CCF8A45;
        Wed, 19 Apr 2023 08:24:57 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f178da21b2so16632345e9.1;
        Wed, 19 Apr 2023 08:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917524; x=1684509524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ELqnbwuz+LrPiogbtSnG5EdZLRNbC7Jdxy/V2VEh/U=;
        b=Tmi1e9er1PHK+cUx+o2H3KvZIM2wvYkDy13ATzQXMA75vq1TdjFCM2eaO8eDzHPQT2
         eRXUc3PU9Mjhnla0cDYgBNGrhfOvPujed9e7/nGpaqJQgNgbjkXAyMpj1k5e3EHh2MAD
         RDGIQNrv3UClpZck9dC6lMfyo5h2nqtQhZCSmaPJxgXpXUKcaqliNBGc5f6ZnDewoENc
         MCxMJFmPlEj0o3opkp6KbmH/isyGGbzK0SVNiOWjV39rsVqHdjQdlzuTI2B5075t7erY
         uHmeA+aYIumtIc/MnLYzl+LMJBzBuJ+4eT4SbnddCY14fCPuA7GlNKR9JAsHhFSIeg6z
         j2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917524; x=1684509524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ELqnbwuz+LrPiogbtSnG5EdZLRNbC7Jdxy/V2VEh/U=;
        b=FSl/TX+Y3jfiC9pmIdUVgrgtFs1EejNZa6j//FWdFVPCnk9Kkbtzt2Z2ZeJzD1XYg0
         5mz9dt+lBRv+ajD9KXLN0PfERlp+VVSC1ZR201fyUnukjAYWVfnvSWRHlt5IeWYarQf7
         ngT1wEKDDmyyXZ9K2V4TIdL1KfbtEY30Q7okCxmkE3LcvskGpzUEARSdQObuzEXh/2kx
         vuTiTP+QEKjElxcSbpP8SSvHc63kavxFq8fVgDugJVBcVuvq9AHiGIu40OstvOUp8eGp
         J076/pST5wid3RCr44U6VQNfHAMkMx6oHb2LDn5/ivFltDIZJ4kx04DZzfzIr4NI98BH
         Fddw==
X-Gm-Message-State: AAQBX9dhfKIZbJNZ9yIOIGJ05yp9JgpLQ8RN8W0xsM22Q3gnuskjzkJz
        2i6or8/rQCF8eJCckJHbnnR1UR5xocZssw==
X-Google-Smtp-Source: AKy350Ztu3EFW2CXOSKYzHUVRn8id3ZeWU2ThLFlpgBpRIA6d5tVt9OaKuZlVu5ZwECO1K6NtNGUNQ==
X-Received: by 2002:adf:da48:0:b0:2fd:1a81:6b0e with SMTP id r8-20020adfda48000000b002fd1a816b0emr5157012wrl.33.1681917523760;
        Wed, 19 Apr 2023 08:18:43 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id b15-20020adfe64f000000b002f00793bd7asm15977174wrn.27.2023.04.19.08.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 08:18:43 -0700 (PDT)
Message-ID: <c8be79ff-6296-c365-5422-02c6746f78fb@gmail.com>
Date:   Wed, 19 Apr 2023 16:18:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] wifi: ath9k: Don't mark channelmap stack variable
 read-only in ath9k_mci_update_wlan_channels()
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@toke.dk>
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
References: <20230413214118.153781-1-toke@toke.dk>
 <168191429286.18451.14816485203241143280.kvalo@kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <168191429286.18451.14816485203241143280.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/04/2023 15:24, Kalle Valo wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> 
>> This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.
>>
>> Turns out the channelmap variable is not actually read-only, it's modified
>> through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
>> so making it read-only causes page faults when that code is hit.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217183
>> Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap static const")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> 
> Patch applied to ath-next branch of ath.git, thanks.
> 
> b956e3110a79 wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()
> 

Thanks. Apologies for the regression. My bad.
