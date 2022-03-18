Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA594DD8B5
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiCRLKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiCRLKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 07:10:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB50F3FAB;
        Fri, 18 Mar 2022 04:09:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q11so6693945pln.11;
        Fri, 18 Mar 2022 04:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lx7WFraWRqWFHLNMuz3nmP2HSXVxWZbem12hqNhYjZU=;
        b=jFP9n9CaSBOFMvqLz8WH0ZpJsYFJXndQiPHBbHQoU6JJaQr1euRdgamsJN94j2HZO1
         oAJ3NHIkK5HV9yW+7NQ5eMKKpAEtFnmX7CTes98+Y5FNTEXNsMjGTg0bpVXh7hSg/QFY
         mdvH8q8/vzAVzx3QQme+H8W/+pmPjB48PvOkrJE1cU0cbNOPdjZHHJAbkYxmu3ZWDYi+
         7TBhy3qrpCm251oSIdu4oBJA9Y6DhhZ92wBzKBntp/zg8qKGhu0dPq0aCmpGDd17Y3x0
         tCmFAmQ6P87wqediV/NiL3simAfjKUnb8LJi9q8OJOgtQnD5e6+rvIDvwnOlVMS7Pvbd
         PPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lx7WFraWRqWFHLNMuz3nmP2HSXVxWZbem12hqNhYjZU=;
        b=O/2mMH2TdPWVrFn9S+/y9sJ9uBjir+WKOjjTcu2NoXSDyqYPzsUCD7WhG1PpASow3W
         VZXEYtXG3P9OBEU5wIUKFSPVs3BGHUDbSPk0Ed6sgge4zCE5hsfQyjEil2NzsAGriPeF
         FxgxohBAAQof3PLuok+yJ5yBXgJUzdM6cEE58oNUBDEDN2WS9+cIIqIjFhYZEW/OFfIc
         VUPunfGdJgh6ReYeyQ/2zr8dJAAiVoXwGe4QQntgJBhkgymM2S4OkZTc4J6AsHuUye1t
         CxBZMVcAEk5pBtE/jz285xsCR79GkqjuXKSrLPhakFXqNM+wwtD80wTQF6vWR279mvVk
         9bFA==
X-Gm-Message-State: AOAM533ET/iHjrPzy3EV1DEk+DKiI/OxWM3KwaAxmKjKMrcvW3x11+Qs
        H7+GsQ4eya85bqh5NANqAXc=
X-Google-Smtp-Source: ABdhPJyN51mYsMtk4gYcjQzFCx+w3nbA4g+6vgTP6OcFdyj0KXwRdncIlFoIuyUNx8Dhubq6PyEWJQ==
X-Received: by 2002:a17:90a:d3d3:b0:1bf:2e8d:3175 with SMTP id d19-20020a17090ad3d300b001bf2e8d3175mr10814485pjw.2.1647601760038;
        Fri, 18 Mar 2022 04:09:20 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id h6-20020a636c06000000b00363a2533b17sm7204839pgc.8.2022.03.18.04.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 04:09:19 -0700 (PDT)
Message-ID: <e819ad8f-eec5-b571-43b2-2fea01de84a0@gmail.com>
Date:   Fri, 18 Mar 2022 18:09:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220317124526.768423926@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
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

On 17/03/22 19.45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
