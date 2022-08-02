Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253C4587BFF
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiHBMKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 08:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiHBMKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 08:10:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6C326108;
        Tue,  2 Aug 2022 05:10:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id iw1so13254649plb.6;
        Tue, 02 Aug 2022 05:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=cmB25PFL10++aK91jk9vUd2FanNg0aRKpDcRtxq0uPI=;
        b=CXH+jr1j1fttnvwdJf4loNtAFS0U6qK7Bi7aCni5NbdI7wJaoiouB5lw1U0K5/krOD
         lXmKA6WRsVEHWO9iN3fKEpADOORNMRWzFSKXSVtnIxHE9eGf3v840N827Waj4KrHKgwf
         DnEoNsuhQiiCG1w28nSnmMA1YOy0IPkFyLrtMBP74sKUL6sm5p80jBQ+OnNLtQfyTFt5
         ocoRiGO27hc0cLhwNCL6bEyzk4LwfahXEuTHHzHVZshi28tereJutpJYKEaWDOpEQLxs
         bAFYRXEgOapwJ3OBX4MzD94w05I76X2qPHou8FpgsJl2UNKGUQBNgYrZ9noB02hQMw7i
         Q+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cmB25PFL10++aK91jk9vUd2FanNg0aRKpDcRtxq0uPI=;
        b=ryWTk+KD4lartxTnPCdwQK59oZZCx6Kf9Fir3Z69R0ja+X4aC62FIb5qfrQdJKYEfA
         iYoeAeViFjqKVJIuOmxcUQxbWKoliB6XgzfN26B7+d2FlK01HMiJ0ulSoRJPCD2hXZRm
         NLBd6RHL17Cz4Xu2IqNTF/7ONNH5+h4EwQRlmP3AKqONFbS3uM0GYHnzBEIpk9HOue3b
         4pEd3OAON0Z6OxsEZti3kGq4aHSgfsiByYEd7jC5z/yozzwneWbzvOLow8rhm+85VzQB
         rC/MIKTVSDncXj73jCXC0m70kPJmDOP4RCKaDoxVdD5VqX6lmvFgzBHafCYXWGHeYtpT
         gYvg==
X-Gm-Message-State: ACgBeo1rMqm0a4d9JEQs9MbqzaJRLgultVHDWKoZW1b1E9ai+L53DRWa
        lrcFctX6Y1NMsauspmxq3dU=
X-Google-Smtp-Source: AA6agR6Hw1+Xna3gyOLt+ETO6ZLjDbMmPWbyEClThJRRY2w5XbSNNv4B3bav544l+pxpFl6TyWWbWg==
X-Received: by 2002:a17:902:7448:b0:16e:e3f8:7683 with SMTP id e8-20020a170902744800b0016ee3f87683mr10943112plt.74.1659442240813;
        Tue, 02 Aug 2022 05:10:40 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090341c400b0016d93be285asm11882630ple.173.2022.08.02.05.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 05:10:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7860E103A10; Tue,  2 Aug 2022 19:10:36 +0700 (WIB)
Date:   Tue, 2 Aug 2022 19:10:35 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Message-ID: <YukUOzNwe83HWwwU@debian.me>
References: <20220801114138.041018499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
