Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9734B8081
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 07:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiBPGRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 01:17:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBPGRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 01:17:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206CD181A7E;
        Tue, 15 Feb 2022 22:17:29 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m7so1592931pjk.0;
        Tue, 15 Feb 2022 22:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=g8AXXaCbWDKs31CgLebuGmStUm/FmRBk00TmO1ilxqk=;
        b=R6nU26LUyVGWcht213mcG0DzZPYJrA/r9XHRnfh0VrXRstESq1JU7dhPLXjABQTfQf
         XRnaTbExMVWuF4l6fBKKRF897bvQfTh8LbG/OeRARgMDAr/shIxij+6y6sbDncoHCuXr
         VDR9pYGQ8HLfA+qjc85STW58BZbSI6hBRToQXdsaw2xPrcZqY8xP3G3LwXzWbeF1BS3I
         15M6mOZ17tFn4bKQl7Q35KUneB7dfS8vifFA17EubwTm0qfpAEA4ga1xryir0vyNCk1b
         5D/SskQXUvlPW2tlse6HWGhFXXMnebn5BYeTybwuFGVhO3O/zL6z+VEoUAY/jwgmxpKH
         3ESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=g8AXXaCbWDKs31CgLebuGmStUm/FmRBk00TmO1ilxqk=;
        b=GLXwSRC7NRKr1EaZlLcBDRkNHq4yb/2HLPGrGkiSS9Faed+8WZ3Tz7R6lMpa290+pE
         bZ4F4bgQMSRkgxgX2hUY5z3LDo6jp1GG6u2JRicYSWYLDjOjv1TKyMt9Pe7+rwewBaUM
         DXNz72XBavegxpAGluBfV8P73P5CSrYT4vV1RE9ymNkMWceUnHtaFmn+Hz00GrSTdUgb
         PNhsdepmljUoRWUuvc7sT7xByyBaV2PmJtqKsiVy2yIu+UUOBZx5uyBZFDGbnTqQKdCZ
         ejiUYLI4PRHB8XjfXq0Ch2LJmWuPA3xdN5WrJs8NAusT2NneU/f5Q/ygenhBt1lx1Rui
         qJVw==
X-Gm-Message-State: AOAM530m3PHH3Aqft1fKqaw6KO+BZw7FaxkwB6XOzHYcA8iw7oDqZOkx
        r0P606LIddcj/qaxu9L91es=
X-Google-Smtp-Source: ABdhPJz4qCOhIHKQZlLMOdwf+jbGDDpDv/+LYhv3pmYR+wR13k8rTjkrKJ32IqrWI9FTLunrx02EkA==
X-Received: by 2002:a17:903:1249:b0:14e:e053:c8b6 with SMTP id u9-20020a170903124900b0014ee053c8b6mr1107309plh.132.1644992248523;
        Tue, 15 Feb 2022 22:17:28 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-81.three.co.id. [180.214.232.81])
        by smtp.gmail.com with ESMTPSA id h5sm636480pfi.18.2022.02.15.22.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 22:17:27 -0800 (PST)
Message-ID: <8e4d9a65-7da0-c79e-a3e9-792d30d141e7@gmail.com>
Date:   Wed, 16 Feb 2022 13:17:22 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220214092458.668376521@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
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

On 14/02/22 16.24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, clang 13.0.1)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
