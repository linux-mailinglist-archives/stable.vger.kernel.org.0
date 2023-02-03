Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14FB6894D4
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjBCKMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBCKMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:12:49 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3C18F536;
        Fri,  3 Feb 2023 02:12:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 144so3176559pfv.11;
        Fri, 03 Feb 2023 02:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xc4zNEQSLGBYVVdCnHoQd3NA3HSHi+8rouHFV7QJuGY=;
        b=JOzDvd5LsZ3EgbZD6gWg9Z/8vRuOVfXiUDAGQ8fTpQnjcmoI/JgG6mL5wvZLjqsm2X
         gg6cKvU8zD6Nt2gEZUM0930bwkX04ce1yQG29AwWmb8Ris45jL7B/8cEYKqFBTxGAUb/
         FuZ+e2plaVIGRtqoIsUEWL7+wK6XzPssZK3LMf/aJqMVPIlnU41n4//WYXzOkyLFLj7C
         uzlADp9OQPCoccvUrmDHktkLpsAOrOG5j9FkxoGI7BCkTPtZgmHsjQx5gmzpjeTUp2jp
         raaw96NvBl6Ft/Nm2+qFUFh9Ox8aPcIM0vvBt4HilPi5VjAT3+3yg+c9hRkzLV9ZatzS
         VMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xc4zNEQSLGBYVVdCnHoQd3NA3HSHi+8rouHFV7QJuGY=;
        b=j4AssNqfAOR1s3Jdk4a8ZDzIqLzF+w0g4Bkb/03rTzS8OBl6lZG17UKYW0hRTt26ps
         BBIejq/NN/bFwqQDl8tLGjbOlw/nNaDlL7jl2njzgo5/IVS59nus0RoXO015y7VCyjkr
         Kgyqf2oZc+Wx8g5CdI0IXwFT2BA8KRzOngjofO1BLq93TEx0rtQZQaRBU+S6BT8dWcy8
         jRzJR0/iW0EN1qOHNGlN/1vHEeuRi2hligkh9re9NvmhA4rp8K8zIWgLetfYvrY1wITF
         vC0j1xODGKoqUGpp2AdVAUCkZCv1lLdH+ieXpnvRec/ex8IuTIB9V9b6PPyMPDIgc1zG
         wsOw==
X-Gm-Message-State: AO0yUKXThLCtapIRLGfQ8Z96JJltJlu+AvodeTPYb9+MHC6049nyRJeW
        7hQxmjlP9CA55hdXeQYUpMk=
X-Google-Smtp-Source: AK7set/fxwU5SJgZPEBZHeBE7gfBXk4CftDHur76XonH+IliZOsNtCTkSx2c8mHryCianb91rX489g==
X-Received: by 2002:a62:4ec1:0:b0:593:dc7e:9882 with SMTP id c184-20020a624ec1000000b00593dc7e9882mr9516107pfb.27.1675419168266;
        Fri, 03 Feb 2023 02:12:48 -0800 (PST)
Received: from [192.168.43.80] (subs10b-223-255-225-232.three.co.id. [223.255.225.232])
        by smtp.gmail.com with ESMTPSA id b23-20020aa78717000000b00585cb0efebbsm1341448pfo.175.2023.02.03.02.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:12:47 -0800 (PST)
Message-ID: <48e1ae98-8f29-96d2-61af-d79ce22dcc62@gmail.com>
Date:   Fri, 3 Feb 2023 17:12:42 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Linux 6.1.9
Content-Language: en-US
To:     Vinayak Hegde <vinayakph123@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Justin M . Forbes" <jforbes@fedoraproject.org>,
        Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>,
        Ronald Warsow <rwarsow@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Allen Pais <apais@linux.microsoft.com>,
        Fenil Jain <fkjainco@gmail.com>, Ron Economos <re@w6rz.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@vger.kernel.org>
References: <20230203093811.2678-1-vinayakph123@gmail.com>
 <CAJesESYM1URn3_hMjPoMkfFo=5k-Yb9HZuyy9__kyKoZPoAsRA@mail.gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CAJesESYM1URn3_hMjPoMkfFo=5k-Yb9HZuyy9__kyKoZPoAsRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 16:42, Vinayak Hegde wrote:
> Hi Everyone,
> I was going through A Beginner's Guide to Linux Kernel Development (LFD103) course and was trying out a few things
> mistakenly sending this mail.
> 

Hi and welcome to LKML!

Some netiquette tips:

* Don't top-post when replying; reply inline with appropriate context
  instead. Some people (like me) tends to cut quoted reply below
  if you top-post.
* Don't send HTML emails - many kernel development lists (including
  LKML) don't like them for being common spam method.
* Wait for at least a day before replying - people may respond to
  your message at different pace.
* Use git-send-email(1) to submit patches (see
  Documentation/process/submitting-patches.rst for how to do that).

Regarding your patch, I think Greg has already bumped SUBLEVEL
whenever new stable release is made, so no need to send separate
patch just for that.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

