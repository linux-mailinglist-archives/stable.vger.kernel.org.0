Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679724D19B6
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiCHN4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiCHN4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:56:19 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41F249F0A;
        Tue,  8 Mar 2022 05:55:22 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id z4so16514008pgh.12;
        Tue, 08 Mar 2022 05:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=VoNEGv7bnl7zMN4H8UgaxOW/ZuDnRu2v9W16W9xAWuE=;
        b=RW5rMHMUewwdk/BPHoj78UMD6+bX5nVJeiNUc0fde/+WJmWppdAuqT05PWjNnp5MzQ
         Hxvb2zTil5xp0bP0qgw2H4wQPari1EbSLG/rRzEbt5nyLzPIELrVJ5s3V6bLDcbu7+Bt
         sh7jHBLnG2DzP3uyqmBtX0eDUx59JTICGjchxgJC+aZGgXa1G+k4K/i+AqR5l+kwXhfW
         CeU9zBxBTNgOEsIhQ5fwRUYmOdLKMUsEEEmZVv9zKoVw8osroRhdTNl9+z8kyCJPgjC+
         c1tDO3Ms3fo6C7tHlsclghCZOYqixg9pXk1s5T3FjXShkmqL8VuS7m8seHWIGHcz/EOx
         6Rvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=VoNEGv7bnl7zMN4H8UgaxOW/ZuDnRu2v9W16W9xAWuE=;
        b=1XkN3n6WtUaeIduSyE8m7vI7evJl3n8XuDvosNOcsWu/ELgWXaab5N30XZrFiwNOAU
         kgZ4P+1oTPKyB/y73DUMSlqJiKIcJAagbV0/OYfwslD51tuff50DbIyF8UniBaZreHsX
         87VK7c8FxrVezivr5SpH6Ykxt7GGvcgpXuNkEdeCzZ6v3lVgConrv8G9VJIUlEI/unG2
         xJrxs+14YU2wyfUhUEvoOaZ0wsV59dwNeFsrMNj1sIqxO1UKyt7LSrNvs6YbBVc0n5RN
         CTAnJPWptJzGEL4fo/Jw8E7ZcUW9p0zd1NT103R+Jz8AgDOKubyeyzxNObL9oj/emGll
         CSlA==
X-Gm-Message-State: AOAM532WiY2UWGLrEucdkSSQvKMKC8tBoOHecEeKlqrtrIo3lDYjrXhW
        SWkRDEbMOHIQo9E0O1J7v+s=
X-Google-Smtp-Source: ABdhPJwhE+zTebQG08NBnYkCCerW0zUfvq0NAnemG3vxg6xOXahiwXgS+mU+L+1gyHBoRsB0g2AOSA==
X-Received: by 2002:a63:4704:0:b0:373:bbb2:e0ed with SMTP id u4-20020a634704000000b00373bbb2e0edmr14419513pga.625.1646747722556;
        Tue, 08 Mar 2022 05:55:22 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id j6-20020a056a00174600b004f3e5d344b9sm20746611pfc.194.2022.03.08.05.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:55:21 -0800 (PST)
Message-ID: <98d6997f-264b-9f26-0c83-5033ac920cf1@gmail.com>
Date:   Tue, 8 Mar 2022 20:55:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220307162147.440035361@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/03/22 23.28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
