Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52844D951C
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 08:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiCOHWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbiCOHWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 03:22:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869DD49F9C;
        Tue, 15 Mar 2022 00:20:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so1638496pjb.1;
        Tue, 15 Mar 2022 00:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Rf2NrOUVJi6U2o8Z1rQZMlR5ZQcqQyfV8Nc0B4ZmLfs=;
        b=nNiYl6lrnHkjoYlnQ0bxN0Qj9TXN6W3VudBQ4knUfVEFwWd7esBmLPVSu1bennBWtQ
         XauLrZ91WyaEkehE6gwi36de8WYHS25SndsdMEN/ly4E62Z9MDGRo4SjC25vwHtkPuxw
         nmCzxdMge+HBZva6q7+Jq19b7X9bKWexaeaZiHf988aR0Dwjmdb9wHxv0CQOWf9J3EUR
         Shz0T630JppUYdQ8i3MKToesmm7cF/AznN4ga+Ukr/B5f+LUoaJSviEBrIX0tqf/M1gb
         p1psLQBa9ysM1ff99s1WrGv/yuLoVKWYlthdmLwPYSRyQzIvXG/dzRU790OGTvAlek4P
         OSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rf2NrOUVJi6U2o8Z1rQZMlR5ZQcqQyfV8Nc0B4ZmLfs=;
        b=INW9ptr3zhdSAPHDVu2UUFNnP1xfNqBX2lzIfbHq3NLOIf56xhObszMzxpS9strIbW
         KW+o7cBjoVFraWD37CVZLWZlkNowChxp9SBo1Xz+NoTTMZLoFMpVbI7VxGjfwNwdVBRq
         BUoOaLS7/G5cIDx6qSMuNqpwhnuoZaDkhpt+Vg89HvYGYjNHD015E48BwnosfOhQCJa3
         tQknKTu6pCSVZsjzXMlByIfGEorYQD+9GvAH6U3D+V5UCxZhzSDQOiBypiV3TmVxljyo
         YvZs7b/w6km2hAvTcoipRJsu/oMPewvDkLE1Zw9IpIGx69IE4FTgDVNtWVNnTu/2QJVX
         SpfQ==
X-Gm-Message-State: AOAM530arYHEv/AQAcPtdmZawVln6Og6+wHhxh0Yc6WZNvTxdpo301j6
        Fqb7M/GIollUpts5TAhrSUE=
X-Google-Smtp-Source: ABdhPJzlIeO19O/Sl80FuHi+9CohVLm7nHy72uufpXhSU4Rp3uZBDL0xdtebMEhd5KX0YnSL5cyBHw==
X-Received: by 2002:a17:902:8b87:b0:14b:47b3:c0a2 with SMTP id ay7-20020a1709028b8700b0014b47b3c0a2mr26621881plb.51.1647328856045;
        Tue, 15 Mar 2022 00:20:56 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-94.three.co.id. [180.214.233.94])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm24750186pfu.202.2022.03.15.00.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 00:20:55 -0700 (PDT)
Message-ID: <68f2a7ca-40ce-4d4a-1660-9d3e5e9e95f7@gmail.com>
Date:   Tue, 15 Mar 2022 14:20:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220314112737.929694832@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
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

On 14/03/22 18.52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
