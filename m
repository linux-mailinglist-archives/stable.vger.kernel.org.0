Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DAF66409D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 13:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbjAJMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 07:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238478AbjAJMfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 07:35:54 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10E59D18
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 04:35:48 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id vm8so28200436ejc.2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 04:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ejAEU/uYOJqQyUwZTjniW6zFl+uOEA/ypj8OnR/TRWU=;
        b=cY3HKMsvok55eJRtDoOu0Wf9xEyv3aWMNBHubxQAnEL/Ou4UpXxu4T/RmCmr7DVY/S
         /6kaOaYRAEqz5yvreZsxqIJMBTu46OOMXpY+9XkDbMtwucYF8vuQMfce1do3kLtGEORv
         X04ClYwGAVJ9NPtq27sBHUFGsyznjVNlcrJ/ESiAdEvwVX/fZ8RB9v31+K7DV2riXJVW
         xhc9sez9il1HgIBzyQN/vD8P/kiaL2w37EI2WRk5cLZXk5ChHtojqXsNWB1qhgyIepAJ
         MxHtpodXTY+C7SXw7ExFGRmivxByoo0BeatNr1RQBJU2RyRaF6TH/zPnnPyoyYEOfhw3
         3VZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ejAEU/uYOJqQyUwZTjniW6zFl+uOEA/ypj8OnR/TRWU=;
        b=CItXgax6PWGxNRj7x5ATV1dbCOz2aM64xnEMcFw3a5zBUTHkwoatS84MdKBBQntpi4
         4CW6SX/JqwD2vqSX22ITqTLYzJCcSXjlkGn/3aF9NT4YMxdWC5OvRhCfP7076evvsJQk
         nMiQgjPQb010960mruAST8ZIhgbxpnL7L8kbGOUATGG+UzoXQbjAXQsnkrF++1nmunOr
         r59d5ttEeKMumvbg9bZvkJB00JOtaw9DckYNK4w2j2j2Z4ON+PMdYGcq2mRapMfPVvp7
         eqH4219MzSbAJDrUJbNYHacwMO5zRYcrXTiUuPrvvf9gbiMq7ZteNFnGHbNgm1ihdCwB
         mdIw==
X-Gm-Message-State: AFqh2ko2CDdLkMGffnaAc1tQP79L5m3x3UqMB8ojD9ooZCvZIe5PV4WC
        RK3Q/w7Dom/81ZwvpoigOio=
X-Google-Smtp-Source: AMrXdXs2oUDdToHOLQeSwqmpZVrIBbkHCZP7G+/ovCxkFUp3X15E0klxgW5HhWwXf+XqtcDC0IozDw==
X-Received: by 2002:a17:907:8a20:b0:7c0:cfb2:40d2 with SMTP id sc32-20020a1709078a2000b007c0cfb240d2mr74251411ejc.64.1673354146629;
        Tue, 10 Jan 2023 04:35:46 -0800 (PST)
Received: from [192.168.8.100] (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id gc20-20020a1709072b1400b007c09da0d773sm4928138ejc.100.2023.01.10.04.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 04:35:46 -0800 (PST)
Message-ID: <d811f22a-6b22-ca62-bb5a-b3635356b48d@gmail.com>
Date:   Tue, 10 Jan 2023 12:33:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: FAILED: patch "[PATCH] io_uring: fix CQ waiting timeout handling"
 failed to apply to 5.15-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>, axboe@kernel.dk
Cc:     stable@vger.kernel.org
References: <1673338181165182@kroah.com> <Y70e5r6T7SzaT7cV@kroah.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Y70e5r6T7SzaT7cV@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/23 08:16, Greg KH wrote:
> On Tue, Jan 10, 2023 at 09:09:41AM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.15-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
> 
> Nevermind, I fixed this up for all 3 trees.

Awesome, thanks Greg!

-- 
Pavel Begunkov
