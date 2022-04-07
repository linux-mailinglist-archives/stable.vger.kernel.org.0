Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65DA4F760D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbiDGGb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241108AbiDGGb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:31:58 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D695A1C;
        Wed,  6 Apr 2022 23:29:57 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b13so4636147pfv.0;
        Wed, 06 Apr 2022 23:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u4lQcQZ+imfh4MOd3QbHlEhGcU+MXHsvZG3cns0j61I=;
        b=PtK+H/wNq3rQ5sO4Mqv5ubwsI1yYLTeEYOIMwJdA5gHw0a7Xo6TmwRXvE2LaxxWTR0
         PUZitLSTJwTOMhBvu6cQusooOR6xNNaP/Pg0W4+IhUooVP+NBtadeK4yziBgJtxEP4As
         BWDfdQmMC59LDxcItRfbwn3aB+rh7A7TME72elj5Ggg5DZH0eXiV5WnFnlVyJq4X8493
         8LAmMakshla4gOCYlw/8GwVChtXIyy3K/8PWlivO4eokgtk70Zo8+SSytJi1oXomC1EE
         mHR2qDJtkijjXuJgp3b9ZCE4vTX2nCocHwpOTISt1ny0YazxUSbBfzDyYg+t+Ik7Y3jm
         apuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u4lQcQZ+imfh4MOd3QbHlEhGcU+MXHsvZG3cns0j61I=;
        b=xD30nnZKzzgpnqDu+0yDTJd4Urnsz3IvyuRdH4Ml/TjcoLbMkHQSkOUXvTsNs9G7X4
         3TEMd/Q46DSxRKiu0oirOMud0btPzVfNY0W/XWz3nX2UyRwJ3ibrlXVsXokBZGsY6GcW
         BQgvWJry2283w9qwONMqtlsQA8eyGWjOOOFHHr/1AhmChhFyR9qDt/U+C3uIW4Vnil9a
         FMznbdsQwpEikz3sdzblBvP3O7+pDSao7Uc8ubBctV8ZX6EXLtaFIQcMfZe/p0z95rcB
         28ekHd1qEhq+atip/FIF4hr/rmpyNuWIttt9bKI3liAcCWVTzwm4Fsabh+hF/lGDpAtP
         GMKA==
X-Gm-Message-State: AOAM532K0oi6s6zAkx93i/5/utTJNHj0dFO5EAZxIOYN//gdDsTxNEhQ
        6X9NoOzoBwPLkycVDwwNgaY=
X-Google-Smtp-Source: ABdhPJx85dSiQq8G/bk7DU/YIFh9rLxqvhmLvXUFpqV8rzlof7o74FSVy50mxPp+46/kzJcLP2Tnsg==
X-Received: by 2002:a62:cf82:0:b0:4fa:e33e:4225 with SMTP id b124-20020a62cf82000000b004fae33e4225mr12686946pfg.25.1649312997448;
        Wed, 06 Apr 2022 23:29:57 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-70.three.co.id. [180.214.233.70])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090aaa9600b001ca7a005620sm7212668pjq.49.2022.04.06.23.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 23:29:57 -0700 (PDT)
Message-ID: <f221d055-4888-6994-59cd-4397820d4073@gmail.com>
Date:   Thu, 7 Apr 2022 13:29:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220405070258.802373272@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/04/22 14.24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
