Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F57529F29
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiEQKRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344156AbiEQKQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:16:19 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46AE4C432
        for <stable@vger.kernel.org>; Tue, 17 May 2022 03:13:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id o22so20327671ljp.8
        for <stable@vger.kernel.org>; Tue, 17 May 2022 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=EVvMMF/737DP4oZUPkCKm6aS7atrkBqzDr1atMySeSzTtLwrBVX6pDXpUc92UXf3yr
         5k45QrsKVKA631qS8/s2fNHxM0/XRIQYVCIHbH80yLf3H3GW7YaIformpHVIQ06NhY26
         btNmY1tDI0zlE0zpJr/nm7rOP78R/B7ah4Y9/fQ5U+8O72X+IZOOFU7OaWqmbBUVRRhZ
         zMNNIl2FMSbmPZ0x2NhBosQyCEonmZKafljpJwY1MXn/36o2WPTjMiiJxK1bmzxJiGx9
         F2HZKmJJ8hMCH+POHJD0CeKpCITmaO7tbVAlvHVLR4+6CgR+jW2t5f52wEWy8HoRQ7zC
         MaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=HKbL1MSKQLPtNCHQookiEmaZb4TrMSrRAtN/zZJYZI6WvaHSJ4TnpGezJKjDh/FaVN
         cOI5xpY6nLGA+habbnP9A3aKGWIGJac4n7Ua2Clwc/c9iBIWBsmktei7uupCfN1C6buJ
         gUCYkEMEZ07j4+thOgd62OFSTrSYbA3FfWUmY7eJLbvLLI0DEknUgj41EHdhqKNc68gZ
         r96Kur0F3UF487jB/m9TCpN9mpOKZIqqDT9oUDFtSsa67ANLjUcJMUKZCqemlY1+NjVq
         h2fJrh3H24vfCC+ynr6Hbs9oR5Fb863VtB4tX7kOQMFaCbaX9tBP1pzn3ov5lbnlBtJO
         i7Bg==
X-Gm-Message-State: AOAM530snpc0wTClp7+2ikQxLp4tj5P+/0N1xKPeUMCSuMGMmZS8JGqU
        2uoPDR7uZwCZnBqQYbO9MP4CB7sbfsOAtW9P17rx8zo/WtE5yw==
X-Google-Smtp-Source: ABdhPJzs5+ZZ91seUamYwtNcqKJIm4slfZd0XsW+wgJM0Oo4zaycd/z6Q4PyEjcd3iI6rt8i/5Fv0EE1SB0/RpCXoMs=
X-Received: by 2002:a2e:a78b:0:b0:250:5d3e:562e with SMTP id
 c11-20020a2ea78b000000b002505d3e562emr13953141ljf.372.1652782404935; Tue, 17
 May 2022 03:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193625.489108457@linuxfoundation.org>
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 17 May 2022 15:43:13 +0530
Message-ID: <CAHokDBn=T9FksqGHZHE5cLJgyetnvHz2fZyDFFHToAiTtVDXpA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
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

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain<fkjainco@gmail.com>
