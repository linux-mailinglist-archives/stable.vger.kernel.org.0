Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5CB656C61
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 16:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiL0PVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 10:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0PV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 10:21:29 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CE2E58
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:21:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qk9so32615861ejc.3
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhwqyIpFRJ8Auf1m2ZQmw8vhUt+lHN0JSOypFXT9tVk=;
        b=AGE3W/GLOEsq4L9S0zqECsM78K/Ti2v8ksmDKctS4J0C5754c7TldJXrVDxAvJ/JLi
         rETl7iMjwatFp6W5Ri1OiCWAqrEfZo35RfYahVAgY/OBnDkzp2+YOIAuzjOqg1iG5Ber
         q5/pLxRecfpGqjhn65I+UF+NR6DrnovPdHIVMG5l21seSAEa+mQCDZT+j+2EjcV+9tEY
         gjIYNkj+LWUQZHrIa0ud8kE8y+O7LZ/IKNsUPII39CMNlSsG3nvC7FxWwhxAiPQTfv6K
         8vEFV+j4sOHqZHSGF6j1qY9mw2r4+nJ8+WEz1DHK9x++w61nZCb3YdH/kvUwpy3aHjQb
         Naiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhwqyIpFRJ8Auf1m2ZQmw8vhUt+lHN0JSOypFXT9tVk=;
        b=sxx2S/4G50Cc0ZjswTuHXzs6COp7dlHscr/j4eo5fc+FuCZq6+re96Eas9jli4Y4gu
         HzypYsA5bNgk+oqSsbP86z9PGA6PgWfqwhB33wvh8HykpY1XwykTYmFKLx2IHxt/EMJI
         4LjjTjiSQ0LP0+wR188kCRu7KMukjs0gVG55jLZmiMbF3+BPV9/ial2YuL5gBH4vRTSQ
         LPpoHxgt5zAhAdGdlD90WbMua+SZGhhSOl8Hvn6zzCPDg1sz7cSRUZqbQIyv3P25KASq
         WhezKazOr8wwZWEA5OE0lhvik1k+JfOShRrqLwbTOZ6zDM68X0YGMT/+JTuadF5cQCbA
         pZHg==
X-Gm-Message-State: AFqh2ko4P61901AymGiZ+xaRhNDRXjvCPs2NjGVi/Pwi+awk1T+Q/oqQ
        /hgIAHMYDzadCIA0vZaoZ8o=
X-Google-Smtp-Source: AMrXdXtk01ZPxBN4hkI5GFsUjMvuUoiPYxuRNXbm3Eg2yIgtxKZFwFnVEp272hDZa//F4JIPh+Zd6g==
X-Received: by 2002:a17:907:a643:b0:83c:7308:b2ed with SMTP id vu3-20020a170907a64300b0083c7308b2edmr18793284ejc.17.1672154487213;
        Tue, 27 Dec 2022 07:21:27 -0800 (PST)
Received: from [192.168.10.127] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906145b00b007ad69e9d34dsm6198623ejc.54.2022.12.27.07.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 07:21:26 -0800 (PST)
Message-ID: <0f6e9e95-af42-fbdd-7efb-50cf3b1ba890@gmail.com>
Date:   Tue, 27 Dec 2022 16:21:25 +0100
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
From:   Sergio Callegari <sergio.callegari@gmail.com>
In-Reply-To: <39289e9a-2afa-1d1e-dda0-7958c66c73c2@leemhuis.info>
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


On 27/12/2022 16:12, Thorsten Leemhuis wrote:
> On 27.12.22 15:46, Sergio Callegari wrote:
>> My issue was
> Likely not important, but FWIW: I assume you meant "will be" here, as
> unless I'm missing something that patch is not even in mainline (and not
> even marked explicitly for backporting to 6.1.y; sigh :-/)
>
>> the one described in
>> https://patchwork.kernel.org/project/linux-wireless/patch/20221217085624.52077-1-nbd@nbd.name/
> Thx for letting us know. Ideally you want to rely to that mail (see
> https://lore.kernel.org/all/20221217085624.52077-1-nbd@nbd.name/
> ) to let the developer know that their patch fixes your problem.
>
> Ciao, Thorsten
>
> #regzbot fix: wifi: mac80211: fix initialization of rx->link and
> rx->link_sta

It was actually the arch developers suggesting that patch. I have 
already informed them that the patch fixes the freeze. Will ask them to 
report the finding to the patch developer. Will this be enough for the 
patch (or an improved version thereof) be considered for mainline and 6.1.2?

Thanks!

Sergio

