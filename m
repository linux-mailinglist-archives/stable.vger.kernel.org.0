Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85365656CB9
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 17:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiL0QBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 11:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiL0QBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 11:01:05 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C53B5F
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 08:01:04 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z11so3660036ede.1
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 08:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iY8iXopDRSVyXmalVYnXSEmT3eIhTZabRznlhejI1tM=;
        b=Ejw0F2i3PvVjE68XLXRKyjWrXFhqPKIIP3OdfBgmBX/V+2DlAaXmNHGdYFSiDky/fH
         8ciTGL9WNr95NcMnrSxjHFAIsOEagPTZgq38V9S/UR5+bgL6Fpgm8lCmNs8hRY9s8oqK
         OpgVSaKnUnId0ACPwuTUNwCn/M0l7bShBVsyInfsO/tbcL8wyfvseH7InJuQfb08fABv
         6ueLAoi9J0TZJ50ZP2kcv2gE7JNAUYguxoQC+5QY+FNl8hsSAUdzDuj0+Mty0IppocDi
         IFyR3eavyM8VRVahRp6YUutNiPw+6wV3D6WhxCvkBSTp3GMOCqxjUmMof/Fp9Xy/egqG
         cJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iY8iXopDRSVyXmalVYnXSEmT3eIhTZabRznlhejI1tM=;
        b=au/TvvafiF1L5+vo25WR5+4Z4klBvRT5YsYS73UQIEF7YGyvFxoVtfhEKJLc6htL0O
         hXrHPiN5G0zM9jiTLuKl+JyMKqFbe38dHKxavLPBfK2e3IlgjLxdQ35PZOhOVqWmhPKB
         T1GZ0DzG+q2ayccSiTqvzFLZ52RAhjOPTQ/etU9mpunXvo3Wbxuw+rPu6/Bq89kFKeSz
         ZvXz/ZiHTMSbqLNvhtaCmsz7Y9KgoD/1J0qRP+FCO0/KDCEnXWsnAbFrBWFfWwr/bdoQ
         WGXQdYkUxxQ0pcMc0NzImv8NRFkUIbqUz5fwedZ76N0js1lgQoQAvh5iluCnPoNZTS2x
         gX5g==
X-Gm-Message-State: AFqh2krq3shifbFy3zW3FWfjsy2AbNM3zAQPkj6hiO0z69tPOxxI/1AW
        XreDWgmTAK1xuaSc0w2YjRYPBDCsFMMVMw==
X-Google-Smtp-Source: AMrXdXtc35Hnk2kbuAjp4xr9ish/Zx3MfNPiFFMS8iQpF4r7F32lOoG7dx+UEP/KRvvjBLGyfY4JSA==
X-Received: by 2002:a05:6402:1770:b0:461:8be6:1ac5 with SMTP id da16-20020a056402177000b004618be61ac5mr17047329edb.3.1672156862558;
        Tue, 27 Dec 2022 08:01:02 -0800 (PST)
Received: from [192.168.10.127] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id h25-20020aa7de19000000b00463b9d47e1fsm5989995edv.71.2022.12.27.08.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 08:01:02 -0800 (PST)
Message-ID: <693990ed-d0cd-a57c-c71d-116a8fa01e06@gmail.com>
Date:   Tue, 27 Dec 2022 17:01:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop (issue identified and patch already available)
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
 <Y6W6Qxwq94y9QGFl@kroah.com> <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
 <8c3034f1-bedd-0e43-46e5-1e1fdca238a5@leemhuis.info>
 <18216b2c-d5f8-ada5-6110-192895772cbf@gmail.com>
 <39289e9a-2afa-1d1e-dda0-7958c66c73c2@leemhuis.info>
 <0f6e9e95-af42-fbdd-7efb-50cf3b1ba890@gmail.com>
 <9b979a1e-e876-6b6e-ea3e-90004b69476d@leemhuis.info>
From:   Sergio Callegari <sergio.callegari@gmail.com>
In-Reply-To: <9b979a1e-e876-6b6e-ea3e-90004b69476d@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/12/2022 16:28, Thorsten Leemhuis wrote:
>
> The fix has to be reviewed and merged to mainline first. That will take
> a few days -- or more given the time of the year. That aspect makes it
> even harder that usual to predict how long it will take exactly; but I'd
> say 6.1.2 is pretty unlikely at this point.
>
> Ciao, Thorsten

Just checked and found out that the patch has already been discussed on 
linux wireless, both in the original post and in 
https://lore.kernel.org/linux-wireless/Y6rffzYy5hgIQKSE@localhost.localdomain/T/#m9a15f5ce5db2b585e4d9b6f708e01c58dedded8c, 
so I am sure they are aware that there are lockups without patching and 
that the patch will be reviewed. Also good to know that for now the 
lockups appear to be limited to machines using mt76 wireless.

Thanks again,

Sergio

