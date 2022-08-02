Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAEE5876A7
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 07:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbiHBF3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 01:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiHBF3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 01:29:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E433D5B2;
        Mon,  1 Aug 2022 22:29:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x23so3809191pll.7;
        Mon, 01 Aug 2022 22:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=RjkfDUdV4YahGDYGckGmi+yPpjW8Ys7+ZrAjypqGTCs=;
        b=ATn+vzFTlSiBatooQPRtxXi+5LApyIve2xQQS3c6RuT3kHOZ56zcB3jrHcEiRuBbmz
         Vn594ZJxWVp/mn9zv0nX4Vy+/YG45IsyamXlIHPmjMq3OOk5GcX+Dtm0n0m0OFkxxK42
         9Gi7XepWisf0M3CWGFF3zq2yV4ltX6bE9V/BufSEcKpvGxvAWHKD6rF9zZmhjbplRnAx
         ka1eRNzsPqgOU6Mi1TYVFddC0mb+zQb0DjmkvSJLZchjcKRl4wLkpVE6KreVb3GZGg3d
         68iBWfcCywMDyKQiy5euiCVxVUCs28WRrNeHg3z8EigUvrVAEnacYWZ3LfAHss10HRw7
         9mJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=RjkfDUdV4YahGDYGckGmi+yPpjW8Ys7+ZrAjypqGTCs=;
        b=GQ/ou95167I1X/oQdiQhGmjb9uUDTUjFouVPcSGvJJsOa2TQLZbSKgZ+DFkaqGUQu8
         CrpzQh8gNh9K7b94c27gZj84EAb0SUUTzjNmzwKWpoxJF8LaUL6zj+ZehDk4juvAshFD
         wn8x2Fp5YK18glRnOVgP4uZH9HZcsbyoEw1hvPgHTPCxgxXKWxPvrHahA7TOyAiHDjEC
         ie+B1pCteuqNO5sApMmvYmBa2eoJjEcf46z/aH3V+ozRW3O5sHUZ2vBGHCrcjYpCPdn3
         Sw4PHhXlqHgXwTKXzKrp1nE0kHXGU0nNhMmB6+3sUJ8O5xWfZvXGrZHpX5mq8cOqzLMN
         evTw==
X-Gm-Message-State: ACgBeo1IERdTPwdE0ybsX1kSc6lxk7JlhCsjTd+Y4juntGVnUo+RtjHi
        gAAAvzwGnLuK9HutEk/xwmo=
X-Google-Smtp-Source: AA6agR5AEoza8r4s2WYZ9drC5onZYOd7ipI3sJ9Z8jGT+GFSJmh11cG0Hwh4vZdCl4v/aaugKjKIDA==
X-Received: by 2002:a17:902:7e84:b0:16d:be50:f729 with SMTP id z4-20020a1709027e8400b0016dbe50f729mr19964606pla.16.1659418151489;
        Mon, 01 Aug 2022 22:29:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2-20020a632142000000b0041a8f882e5bsm8454216pgm.42.2022.08.01.22.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 22:29:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Aug 2022 22:29:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
Message-ID: <20220802052909.GC572977@roeck-us.net>
References: <20220801114134.468284027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
