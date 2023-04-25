Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE4F6ED985
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjDYBFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjDYBE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:04:59 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E55AF11;
        Mon, 24 Apr 2023 18:04:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a6817adde4so56267755ad.0;
        Mon, 24 Apr 2023 18:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384675; x=1684976675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FARWeYOPpB4n6dDxng+zXr9ela4FGRNet1WYVOEHIGk=;
        b=MZJEJzgRxL+pwRL2J45JRGzJYxx0w2AWiMaTSJLaYje3PVn81jEFIIJCw+Rut7LXMI
         eYsBT2xlINCXJ5T0tuiY9GkFiBt+W7fp+hX2XiET1VpyYADpIvIddjmxHYYF1mrSaK8x
         3t5CvKWQ2vyOwIinTsfTdvWCxby9Xz1wsboNfJPFvDt4apQ+w9vSqCIh1F6vRr4Z8mF4
         NDifR15PGnolE5EDcKJ4wqJWXo7taw0yN+l2M2Y8JzhhsiSJNpmL+A6ZEYSIBVvQa40Q
         KCCxby9HnsZ5dhIACI2lbBruCtN4Hyv8XQ2HA/9xfardLmWXlyAUJ2LVnHhOELXYu7Xr
         YEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384675; x=1684976675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FARWeYOPpB4n6dDxng+zXr9ela4FGRNet1WYVOEHIGk=;
        b=ICVD2OF20X8ATt62qlxh3r5LcqoYr2iO59pMNE1JBStsZEUujGfX5DiDn39Daal9Fq
         9owxZuWbFJWZ7HBCQAW6+h3+n1pa6gvlD1FOlGSmUJ9DUN7VWvhSh5R6IrKnXuq1gBsf
         y7bjE3C+yxD7/ZIgG3BKKmj/zIVubAT+wbkQNyvrzF8wo7TH5LOnIML/ZOBtqDMa+aHz
         8oVJQEe3MtfyzulT6lzHA1OcCXoC+gAS9GuGo1F30pAENm8Q1b0p5wD1jb7cGraBnX7y
         +iSz2lag36oRj0ypzV54FZyxKI9wM7tvBkFa2/U9OhFcTNVUtlz+3bBF9XFjZY39UN4a
         k5Ug==
X-Gm-Message-State: AAQBX9fMBpqD509dF0jc4rkMYbVMpq+7UjMqnqMKFHTqQbi3kDwb+M25
        z9jhqd8wXQRTuvCFW6U+tTU=
X-Google-Smtp-Source: AKy350ZF1ND6/05UJhKnnCCHDMNjFl5lNdDvX0H8Ab7WJxbquc2uHHpXj6OKO7jkZ+5h6lJe70HKpw==
X-Received: by 2002:a17:902:fa90:b0:1a2:c05b:151c with SMTP id lc16-20020a170902fa9000b001a2c05b151cmr13529878plb.34.1682384675643;
        Mon, 24 Apr 2023 18:04:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902988100b001a1fe40a8dasm7049000plp.262.2023.04.24.18.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:04:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
Message-ID: <b2bf3e7a-be03-42ca-93aa-3520e3b961fb@roeck-us.net>
References: <20230424131123.040556994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
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

On Mon, Apr 24, 2023 at 03:17:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
