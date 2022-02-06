Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E944AB0F3
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 18:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbiBFRcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 12:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBFRcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 12:32:46 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4550C06173B;
        Sun,  6 Feb 2022 09:32:45 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so11212012oot.4;
        Sun, 06 Feb 2022 09:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QjHen6OmxYmZmraosC3kIdd7lHywcpDr7IMXtC6KPtk=;
        b=RewyujGZgeFv48JLa5eXek4Te5TO+ekg9lL6MPdVdzfA36Jy6YRQEjTLJg12tgfxU0
         kOBukbSGKuwzkAeFYIY/PfAxjw/RWaLmxKXCOqOghmU4m6YjCDJPNzqOwnjpDhSJ2Tq6
         cBJTujVC2ZExRh4iHRy1dFqlNUa4SP1MQ3BvgjTf2teXMBZ1ekG/EdbH6s/v2I6kXN1o
         twHOuSxWnR5e4T4mwQYcd7l/bCFn02nTWqtfVorJb4YiwrbqbTthjlfiBsw2kd08wxT7
         Sht993jbaGl/888LJLXg2sFdn7ewna0pE/1ZBAcRSD73+ok2OciQMLN83Jos+1MKsbSm
         KQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QjHen6OmxYmZmraosC3kIdd7lHywcpDr7IMXtC6KPtk=;
        b=5Eu1h/Cp+dq0XH2C9T5DR4bnBtLE0AS0d6gO9/gy9GxtpeEzSqIGcEHJDe1luut85F
         Lau3c1S9vKN05wWNuGWGcrmNNBywRgCjvNm26OxtXayH2ZgKdF7SiK92FsHQe3r6ogiq
         stlEkNxsaPdJH2gcKfncnKDXnYd1SyZdGJkAfnOmNRKBYOzXFMtrsI84Y9w6bEEUuPMk
         KxD0VynpSMHhLzw8beU+X9XgH60tLDrWlzHLhCv6BwCxJRgBOTh1drP4wDIJq292uhQr
         LOrSljzbixDuQT68GMlqSu/8RJ7cV1OJ9L9lpzBFcBdk3zFSAO2wwhlOmn63hHzOvzlZ
         Rs7g==
X-Gm-Message-State: AOAM533c4MjN7fl3lRtivEcdVgtJgVA6GiElgwMLbhSG27i0anmQP+v0
        zriOR4sM8wuJJkymj6RtxUwOGHP2OIlCcQ==
X-Google-Smtp-Source: ABdhPJyJtywanNHbmDYLjsoy4PXeZvvmggx0s3aSm4sZ5s+9vd8L72cu2rkjdxBBP5Atf+7vxyEwOQ==
X-Received: by 2002:a05:6870:9484:: with SMTP id w4mr3149910oal.335.1644168765102;
        Sun, 06 Feb 2022 09:32:45 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d7sm2998029otf.66.2022.02.06.09.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 09:32:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5309198e-8ed0-4deb-6cd3-bd35732ed9b5@roeck-us.net>
Date:   Sun, 6 Feb 2022 09:32:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 05/32] drm/vc4: hdmi: Make sure the device is powered
 with CEC
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
References: <20220204091915.247906930@linuxfoundation.org>
 <20220204091915.421812582@linuxfoundation.org>
 <20220205171238.GA3073350@roeck-us.net> <Yf66Y2/N0nh9tMxT@kroah.com>
 <20220205184108.GA3084817@roeck-us.net> <Yf+6gxmQnlbngqwm@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Yf+6gxmQnlbngqwm@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/6/22 04:09, Greg Kroah-Hartman wrote:
> On Sat, Feb 05, 2022 at 10:41:08AM -0800, Guenter Roeck wrote:
>> Hi Greg,
>>
>> On Sat, Feb 05, 2022 at 06:56:51PM +0100, Greg Kroah-Hartman wrote:
>> [ ... ]
>>>
>>> Yeah, something is really wrong here.  I'm going to go revert this for
>>> now and push out a new set of releases with that fixed.
>>
>> If you pull a release for that, can you possibly revert 9de2b9286a6
>> ("ASoC: mediatek: Check for error clk pointer") as well ? It does not
>> realy fix anything but breaks pretty much all Mediatek systems using
>> the mtk-scpsys driver. I sent a revert request
>> 	https://lore.kernel.org/lkml/20220205014755.699603-1-linux@roeck-us.net/
>> but the it looks like the submitter keeps defending their patch. In the
>> current state, pretty much all stable release starting with v4.19.y won't
>> work for affected systems due to this patch.
> 
> I don't see anyone objecting to the revert in that thread (or any
> responses at all.)  I'll queue up a revert for the next round of
> releases until this all gets worked out.
> 

The discussion isn't easy to find, or at least I only found it
after writing the revert. It is at

https://lore.kernel.org/all/trinity-2a727d96-0335-4d03-8f30-e22a0e10112d-1643363480085@3c-app-gmx-bap33/

Guenter
