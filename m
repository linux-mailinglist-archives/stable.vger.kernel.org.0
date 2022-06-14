Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE954A72C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353762AbiFNC5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354891AbiFNC5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:57:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BBD3F30B;
        Mon, 13 Jun 2022 19:48:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id e9so7293020pju.5;
        Mon, 13 Jun 2022 19:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CRbO+eOwNrtEzNm1umOFthQyHIYadiriLN7qcDzqwQY=;
        b=hndWB0ZVsytJPGL77dROqa0dY0aM6xZ0Zu0KpRT0y6hZwkv4MVy6MkKhYxBLwDMkPD
         lR8jPr6ku83xuSAT+r1OigTO/ZFQ7ebTTzbZ42yEHAo9NYaVwkJ2VwKY/kz7ySbffhu+
         ol8A6aixLGr/KivfGZvHXwSCUB1ieRKf5aDS364efkqPyImEoiLieU9a6bcVUVhRCQxy
         0M/D4qzZi9pFn8PiROuRGlE25P6oQXLyrFWLOzV6Q+mb+Trfz+Pe1T5hEp84BWhj75E7
         pZcW5txnCnxw3uer76w+H9UZKDjs3GM6U2uQfQ5zG60lmYjx4/imPi/Bn1rP5B9AK5zf
         4IAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CRbO+eOwNrtEzNm1umOFthQyHIYadiriLN7qcDzqwQY=;
        b=BVqf8wKAfxrdJQXr4hh6ZRVgHQq/15pr6ZgngaKJTMKc8qnLBKyec1Lb2CDmnmzoJN
         Nih7k5XXpNwhj6Zoum5jgq8YptANEGvAMOTiaXQSXgJ0G66CqUFVie+aeB3lsJwNU+yj
         kqDVk7cVyNDZSfa0GvJ6LuvkyxLth+huboeDmp7rrTMaewLIy/ebOab7wShA1/juYC+Q
         fxzaOXfRPgeqXwhYNeKO3JOkKRpIibcMrRIDbLd0llUSyXk+bT1TOp6faj1wLEB6Mgoq
         PPaVvf4Nd6bEsqzoLI8QRwipFdn9a0LCrjRmiShN1gLCZtNEZqi975exQpeTMu3EYCv/
         zwWQ==
X-Gm-Message-State: AJIora8wMHqpCrsjkFV8SOYRXBd7LEAkv/gBcXcUOHypC+cCIF8o39ve
        ar+dEg0GpthltpGEUqBnCZE=
X-Google-Smtp-Source: AGRyM1sd/kSRsmMZUEUoLZYojSUyh9KAplJSDdIxU5qJRr/ruGh31o9aCZm+4+Yr09KT0QCC4bJAcA==
X-Received: by 2002:a17:903:187:b0:166:4360:a4fa with SMTP id z7-20020a170903018700b001664360a4famr1995749plg.87.1655174884778;
        Mon, 13 Jun 2022 19:48:04 -0700 (PDT)
Received: from localhost (subs02-180-214-232-19.three.co.id. [180.214.232.19])
        by smtp.gmail.com with ESMTPSA id oe14-20020a17090b394e00b001d95c09f877sm5948737pjb.35.2022.06.13.19.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 19:48:04 -0700 (PDT)
Date:   Tue, 14 Jun 2022 09:48:01 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/247] 5.15.47-rc1 review
Message-ID: <Yqf24Y5Fz+LOrVX9@debian.me>
References: <20220613094922.843438024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
ARMv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
