Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9A4F633A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbiDFP2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiDFP1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:27:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7593D0488;
        Wed,  6 Apr 2022 05:25:43 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t13so2061072pgn.8;
        Wed, 06 Apr 2022 05:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u4lQcQZ+imfh4MOd3QbHlEhGcU+MXHsvZG3cns0j61I=;
        b=akzK0B7lVqP4dRsVOS9uOB3iL0Vmy9LqMijzk47ODkF1PEUAI/jNHSGorvJnzT0Oy9
         AIKplwtBFlQhfUVC59dPSkfG08+pw8aAneA7b6IIHzS+lkjwZWlM0BSyhNtv3nra3nLl
         48SaenkFEFzBzVqMt/KKVRAm0GliPl3bZD3Udlu3zyd+2BTVXz5WPq0eJrWK/V7Ln1BB
         uk/wM07K5Cbl42WIsgszpAi6CjTHaA9rcdrXuiLuGYu1NwsHPTZ5zB9wsUsrq6zNw8hN
         d7mCD6Tfc2UdvWlDKJD2fsaQoeb3spbvsQL/5f6kWgBS/JOE6Cs83OTDhIx7irtIhvkC
         jaxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u4lQcQZ+imfh4MOd3QbHlEhGcU+MXHsvZG3cns0j61I=;
        b=dip8QsJg2ifl7petmidPedPJ1cSji1qaChWmHXPXVJww7Sy2IsntQEpxWv4cjk60km
         7hhdC2kuhCpXOjTW+ZwdDw3zCkhnqRFmJ9NupGnLdd1Ps9ZqEdFxuA+vgN/zwA5S9IRX
         RYt5WM/QEb8UNKyyAbMe/l+Djd/9najo9muVFwfXl6CyHMATmw5ftFffcvS51vN/gmTP
         qzendvkbVZw3pVdikmaK1U/sBHdF7/yZyIGcGtRTQNw/pPmFqhganUdojrx9U/yw8RvF
         IbF05vAwlMTFzHN8b/JlO8rFyKVNXBnhZp4TIA9KgChesSQm9+6nPZWv9AGMVQZwRqBp
         VjrQ==
X-Gm-Message-State: AOAM530Vh7Rc4J4jt1pYPtAyCH48eixC8zT9Uy/2NQ2Xszv9y7AljRXF
        0vrUG8V7P+lhLk4HD2pyNBk=
X-Google-Smtp-Source: ABdhPJwrI6Y3sTWFXFfeCG11f4zIUSmgc7dyqIIOa5b57L7PRX3o6IoiT3JbaF5nYjcItEDfOXFhHQ==
X-Received: by 2002:a05:6a00:4198:b0:4fa:8591:5456 with SMTP id ca24-20020a056a00419800b004fa85915456mr8592910pfb.81.1649247943521;
        Wed, 06 Apr 2022 05:25:43 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-45.three.co.id. [116.206.12.45])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm19332210pfl.15.2022.04.06.05.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:25:42 -0700 (PDT)
Message-ID: <1ea212ba-250a-66e9-37a5-f0022107b053@gmail.com>
Date:   Wed, 6 Apr 2022 19:25:38 +0700
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
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
