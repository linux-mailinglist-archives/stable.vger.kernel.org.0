Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E444553E0BB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 08:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiFFFdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 01:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFFFdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 01:33:39 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050A917048
        for <stable@vger.kernel.org>; Sun,  5 Jun 2022 22:33:37 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id a15so21594897lfb.9
        for <stable@vger.kernel.org>; Sun, 05 Jun 2022 22:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=C0quy8Oo/HrBLNIumPaM9ESsXHvXsH0OTV4jilMSKok=;
        b=gHK2/jMBiurOGZhy4H8uxwplnWfDH2UOK15oHvQuBdyP7f+Jw9b/oQfmowOcLSSwJQ
         m1DVNN+7seMVyxt6ZJIj0x36qMS92Y19HjBFA7CEilf+gY6CXri2sU97Ngx0Pd0KgsB6
         qvJsReHUeQv+2t+k2rBLGtr3YnAJbwGCtbo1+KbqpylOcKUGPdqKPIZalRs9O0f8vrCD
         i4m66m3ncqVPM33rUygZbd53rsJKgl+2/+DNscDO8QU8PRt9rH+1cGjdeQEWTSSf4aX3
         +z4N2tDvfbdWPL0kaW/9PpOtPwnoEdwtnqBR5K0pWyDLFsSNW6SnkYhUrsUm4YyQyhjD
         c76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=C0quy8Oo/HrBLNIumPaM9ESsXHvXsH0OTV4jilMSKok=;
        b=K2uoxzsV5O3saELLJs6gDrQQX6hgsrEw2JrDuke+uCkS4r3sMPRvZYsKQV9ufZJjeS
         lv2WdVaUfN6YZ2R5P/nwq9zQYNjPeeFSdjiW7aeXSuZZEChqzODJKuLTdXeyoEhfO/qu
         2K2S7aG4M8TNw/zxrWwCQs314U+D4fYByOJ+UFqNH0LSJbpIDPIHCsUKhCvo0b8c6K5p
         F7RG+ptxcZgPOcJ05g/c6aISEWRts5M07dpW4Cz8b7ZXlhMg3sv9ANhYjdnnVuABPKwo
         /8lddmtmRDeubH0hUVfL8EfMTnMkTWVk/Mepf0106WKz3zsTmshmkjFxwZJo++pfIPR3
         btaA==
X-Gm-Message-State: AOAM531u9rbgHPx31Rl7oOIVC2v5PrKpoqiMM2kfUAhSFy16Q52oy2vv
        8ZPsBhAMLOh4wKFhURnfUtGIMp7YHksqyFneQrb4XTCE/3E=
X-Google-Smtp-Source: ABdhPJyzo1rLO6UefQO1naH70TBS8GjjCE+bZ/k9JR5bsNAwG/OEZJi5qHbCaHV9GxMSeGLx7riKmMj16kajt/EZGFw=
X-Received: by 2002:a05:6512:b17:b0:478:d66d:f747 with SMTP id
 w23-20020a0565120b1700b00478d66df747mr27769857lfu.447.1654493615122; Sun, 05
 Jun 2022 22:33:35 -0700 (PDT)
MIME-Version: 1.0
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Mon, 6 Jun 2022 11:03:24 +0530
Message-ID: <CAHokDBk-0qSmx5JqAOohocWb5QRq2XmXkiU=fcZ4yvsoev589w@mail.gmail.com>
Subject: 
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain<fkjainco@gmail.com>
