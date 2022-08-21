Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DC259B116
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiHUAxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHUAxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:53:55 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255A418E27;
        Sat, 20 Aug 2022 17:53:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z187so7322496pfb.12;
        Sat, 20 Aug 2022 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=yO4s9x/aqAaxIqOYiGgMn5PZpwW9YpvO5iMm3tGO0u4=;
        b=m/Kbl3TDEcODHWTL/0+c/kGHq8nhnVCLB3ujQpr9Sc2SQ7J298x1N+NlZg9KCT4Kbi
         6QmlxNNPf8eX7hfW/gXkDPg9kSfxIciekLdtz49zG1kuTq7+fIso09M7GrYKI7z2guZ3
         AuEvg6ndFtyyFUlH2r9uvc71NdY5sy6X26XrBNgnctMEaT38nIeTFztyHT69NsfQUsD6
         JFzvj0UWuedN5UhpgLLQkgE8giVEfYAU8bqcVcqCXyg/qx+b0zR9hvYSvshcLUcwmrvl
         ZzDophJEq4uckircQ/00kHRZT/e9Bq9ItL+yPQqNxynYH/t1aa6ry4Ns22esg1Rm2EJv
         z5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=yO4s9x/aqAaxIqOYiGgMn5PZpwW9YpvO5iMm3tGO0u4=;
        b=8PRpGDWp892oTnqPYRrqueebQV3ER2XwLYx4U3cI23ZApwZWzF7hsZ4A6wUWdRUgD6
         tEMVUwxVqTcGUegQ07yxy+T+9s6GCBfufN94qnbVWeKWKQ7SvhZeuIbZ++vBFpIe9L2k
         Skqaw0FoAqZGHSKxPcOZKBE0IznEycnN7jqp+6FB44DSCW8ZU7AN8qqRdtQ7vfmU9jvH
         1oKxACN7Kb9JHXryOPjbmQiQJ7zqRKAQXB063p41rL5FYRwUs+HYR4uVQjtfGg/mokR7
         IsDxL06c+8ia/4aHK0dlbzpNpV72UwU0xSrDFbQ1xj1TQaukY8Tny9U1c8H0hk91+6/+
         2vBw==
X-Gm-Message-State: ACgBeo0iRxoF3Msbgi/6+lAsnjt4jY+/ml+lSE7IeqoMeEeBak5f/mT6
        UPSx6TCHb1KOO4f+tIEYwt0=
X-Google-Smtp-Source: AA6agR600xtb+s1bjU4tQWmOPdGum+bqBuK1zfPB+1gI6LjT7c1fFaE9fj/zfRrtcoNalW1uXqWMQg==
X-Received: by 2002:a05:6a02:207:b0:41c:9e7d:775e with SMTP id bh7-20020a056a02020700b0041c9e7d775emr11566367pgb.227.1661043233633;
        Sat, 20 Aug 2022 17:53:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7-20020aa79f07000000b0052dcbd87ae8sm5807958pfr.25.2022.08.20.17.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 17:53:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Aug 2022 17:53:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
Message-ID: <20220821005350.GA990187@roeck-us.net>
References: <20220819153829.135562864@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 05:36:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 545 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 161 fail: 2
Failed builds:
	powerpc:defconfig
	um:defconfig
Qemu test results:
	total: 474 pass: 451 fail: 23
Failed tests:
	<various ppc64>

Problems have ben reported already, so I assume I don't have to go
into details.

Guenter
