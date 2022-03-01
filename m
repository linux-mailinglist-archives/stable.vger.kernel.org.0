Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A979D4C882D
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiCAJjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiCAJi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:38:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF721AF06;
        Tue,  1 Mar 2022 01:38:19 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x18so13675711pfh.5;
        Tue, 01 Mar 2022 01:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=At8FPdv8UCsuq3gVBhwkPc9hsGAJQA4H5pdSb7HsIvA=;
        b=Kw8h0yAzVtCt7gKatYtbEWH8EoViVTwlYXvBxYAoU5VmcWTcr+GfwF1CcY5jayDjhv
         khA1W6QUkOQl+TiAHJeqWzZrnYzJBGYu7khXpHTjrFyRw0STlOE4ax5oXXcvSOzOMcSs
         Eb2rP1Gb3MT+//InWmFRi6IWwK0DgvxmTwOzXJ+UwzEqXUqdJ1Iz+eeds+Sb9amdt/Xd
         PQhMTk22nF42JjDSnxxJm6KEJKOosF1Z3o5Nnfp2r8XrK82BY5N4lr6R+CTdlOmsu+45
         su48PWeygLzpvLBLhsJ3ZfqJCrOqTyfenpFp8Bp+qHUqgWYGnez9fXdb/PZWqqEWFaO+
         to1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=At8FPdv8UCsuq3gVBhwkPc9hsGAJQA4H5pdSb7HsIvA=;
        b=GQnMnWYA2HgqFvnNZEgD/m/JiLJK6n5wppxcEYTMma2HeWO5JUePD8aFZ2VC7TASK4
         6UrB8qcX5JG1FHWB+O5/m6WLefO3c7bbZkq1eWqCzimOf6whWFbN43kt/KyorR/qvYDc
         83davUzwkwSSec8ZRU1i1ezPUkKRxoNm+JWgmLzMnnO8/mRDdB+xMyYKwWbSFodsjnKW
         e8R/VT3A34P4zVVF9oTYOFzymHe5aplFxnTOeQyFQN4+6Y8kwaWjnGgq1q+b0/gbr4pW
         ZDfvXcU1RriXV+SpubH0fj3d3lyHitop3/vyagxmFst87u0vX8jRfp4x2JeNxMzoKc4z
         R2Tw==
X-Gm-Message-State: AOAM533HY0JsIlv4SP5xRe/CKscw8aammCgNV6eWNp7TrMOrz6nJIkLH
        GHquTYvkdT8lIRsjPCwi7y6W5Ms5VWw=
X-Google-Smtp-Source: ABdhPJzVMRv46d0Gory1U0HGh7DSenjYZf0NpbRRACTUMg+N1Ewj7OY5TfX7FXwnn5nynv82EA3Zpw==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr26222671pfu.59.1646127498890;
        Tue, 01 Mar 2022 01:38:18 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id p27-20020a056a000a1b00b004f3f63e3cf2sm10251130pfh.58.2022.03.01.01.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 01:38:18 -0800 (PST)
Message-ID: <6f288ce6-432f-a0ae-00bb-1809ce7194ed@gmail.com>
Date:   Tue, 1 Mar 2022 16:38:13 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220228172311.789892158@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/03/22 00.23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
