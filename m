Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D52549A53
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 19:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbiFMRo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 13:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbiFMRoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 13:44:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D98D168D15;
        Mon, 13 Jun 2022 06:18:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a10so5603330pju.3;
        Mon, 13 Jun 2022 06:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GqcjIBiZHdkiFQqTyaXjMxy6knKrlT2JCmzywSrR6F4=;
        b=W6Stz7yNDgHrafTk7QMKI2bwWX8VJq3RL1tKe0dtoZAC9IKwoc/ga5MzReVsIFu4Dz
         QoY+auFOsQVCqFHQcxwPsDgQy5Pwug8khg+wJ2WWNLvM3i+EGKDlsuniQV8NDUjs/ihC
         dqOE/gWGix6+NgoklW5oEQIujMeaKFeaDq84mzvNsyDvF3CHYRlZbMWAMurZoQMp1cQI
         QXH3Jxx6UxNCdAy1wHPu4flkEOtDc945/d9jZQG5rQL/nq6L6WNsxHUJVW5POUOADclk
         1MpfYPYrDuqQmYuZxyVds9SVpa1AVLhhp0wzgctFpTbcaKb9KUU6dyNw8XW464wT9nPj
         hf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GqcjIBiZHdkiFQqTyaXjMxy6knKrlT2JCmzywSrR6F4=;
        b=I38iXnN8g4bnC4Dm+Rkikg6jK73LhpqcibB/6Usdp0DCmjVXIza0MsZYLryrCJxt4E
         IssC5+cPnIghh915MPpNdajUQQPypA7Dbl/R56bGkSiCQbHfD+9lcwtgnxh3kQr5unOk
         ihahJqaFft8pHgbkxSlOdtT/cvSVJQ28GQ6nYo508wxHMK8wHowaWi2hVddyRhWL4zTy
         LrirjoBfxRFkAFu7lvgaIb5J0E39bY2BRFluXCf+euGbOrGdnjK0mu9qA/cFdNUBak5y
         O+pIoHX7osRTd7xsuvLj5BPT71D1w0lFtWyBqM+ioAyREm5anCelkad/JRI+DLOzJKJu
         KALw==
X-Gm-Message-State: AOAM530DYUXScd3TexBKkUqPTx5YOKZjebzMc8ecdsmG1/C7vGAg0oT2
        7eTmu7SOaARh9JTS0MELK2k=
X-Google-Smtp-Source: ABdhPJxSXN3t0e9qsGy4v9kZozVl7y++GOeJiSptH8f6Zw38nYb+LQeHXkHR2poHPSudLwd9DSR4RA==
X-Received: by 2002:a17:90a:5409:b0:1e8:664e:41dd with SMTP id z9-20020a17090a540900b001e8664e41ddmr15785311pjh.173.1655126320488;
        Mon, 13 Jun 2022 06:18:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902e9d300b001639f038250sm5070965plk.220.2022.06.13.06.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 06:18:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Jun 2022 06:18:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/247] 5.15.47-rc1 review
Message-ID: <20220613131838.GA3571788@roeck-us.net>
References: <20220613094922.843438024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:08:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 

Early feedback:

Building arm:allmodconfig ... failed
--------------
Error log:
In file included from include/linux/kernel.h:16,
                 from include/linux/crypto.h:16,
                 from include/crypto/hash.h:11,
                 from lib/iov_iter.c:2:
lib/iov_iter.c: In function 'iter_xarray_get_pages':
include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast

This will likely affect affects all branches where commit 6c77676645ad
("iov_iter: Fix iter_xarray_get_pages{,_alloc}()") was backported.

The fix is upstream commit 1c27f1fc1549 ("iov_iter: fix build issue due
to possible type mis-match").

Guenter
