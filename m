Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2460B3B7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiJXROZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiJXRNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:13:30 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07909E31B6;
        Mon, 24 Oct 2022 08:48:52 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h185so8973146pgc.10;
        Mon, 24 Oct 2022 08:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=01FAQUXDHWGT0pvN08Zd2Y4vQUI1Ndzq/JvwPrJDnDg=;
        b=qohQLIGoUpc53llOnkTVnVoO1UnsHU9EVAEF3wcxjFtTDCUeUYPQtNA28CPFzV0M1B
         Ev1Ud+7z8uSDrpcc1gXBUYHgna0/+84q59ghGiq+3kRHQOImfT8MH9EkjEj7ovh1z5zb
         k+ulIPxh90FiS5nQT1y/1ETiUEsy8i6IegC5TrDbRI22hEt7ku+wISLkKjdd4mTzxdLr
         D7iz9cCn7jTVqQGhuoAUuj4rZMvZ3inoisTRxog3r0KmlVprlvqnwQNWV4y8wyk2DWjR
         c8NZV1Uc1BPDl+L0lb0lNqv52MXjX3sy2rRTceYMFRrzxYECg5HNIg1oOXVTOoexRgma
         MV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01FAQUXDHWGT0pvN08Zd2Y4vQUI1Ndzq/JvwPrJDnDg=;
        b=WfY602gpVqtNHWfuKgGywqRVbgDnCjX42mU19aUDoNiKX2FaoWMvIZwYQ0BniR8AWs
         QeX0LGT3mgAbsm1NMngHZwA75ubSWVqfkN5YsxDsUX/4YY65tIgq/w1B7V2MyPXSSBKN
         qYKz6zC5y5Y34ntsVA3+g0T6qTP4whnst9gY4/cK1RbTykkZwmHmBToAe2OnMdARemaC
         WhfCXPHSycyUxmcbojmyNkz5Rmak3Dw8rC1pc9drfTf4t5G9CwTExvMPIu6bboJ86ZlT
         DYvHJlpz4T1+JNH32ImiRVlGmz/Qoyu9UoqxfvAYQs1GKwGpiBmD5LSebsFH2tZT6WWU
         Htgg==
X-Gm-Message-State: ACrzQf0vAP2TtS99HCWEGI77p/RFs7Wk4cgzBtyelzEAnRy+O/bYb+NW
        9Ix+4FjSEWAC69zyDlu8CwqrENg1zUliruRMwdE=
X-Google-Smtp-Source: AMsMyM7c8Nrrtt96/WRD5Tp7wlJmOuqwQRjHvonhiJU/OoYKvAzMylG2U1aj4OLKnhJvecVk81/wFr8syc9PMO6g1UA=
X-Received: by 2002:a05:6a00:1488:b0:563:9d96:660f with SMTP id
 v8-20020a056a00148800b005639d96660fmr34312292pfu.0.1666626447083; Mon, 24 Oct
 2022 08:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112934.415391158@linuxfoundation.org>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Mon, 24 Oct 2022 17:47:15 +0200
Message-ID: <CADo9pHhjFRSE6tiwtFQ1ku+o4rTJaezF0f3bs_4+-2KvpuOAtQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luna Jernberg <droidbittin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Works on my Arch Linux Server with Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz

Tested-by: Luna Jernberg <droidbittin@gmail.com>
