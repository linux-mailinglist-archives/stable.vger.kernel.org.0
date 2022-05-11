Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0856E523E9F
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 22:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbiEKUPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 16:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiEKUPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 16:15:36 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1515DD2F
        for <stable@vger.kernel.org>; Wed, 11 May 2022 13:15:35 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id 8so157372uau.12
        for <stable@vger.kernel.org>; Wed, 11 May 2022 13:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=cGqzklWXWDVELhuS+xgTophtvKPosdcmMHaKUXqQOh0=;
        b=KDC8zXqjdU1TTMEQWozzhM2MGLmqQqwBbHcUhD9HOFNZ7qpoZFa0aIz5zXRUBr50o4
         +z8nNzRXBT/tF8eNQWCNb1wJY4ClAartL9CumVHFN11sXSyqV00jEsfcbShHwwStn/Gm
         TH0kydu5DkOKRL9j2bbmT4tUs/DaO/Tfhvs45fmpSsLvCK2E0GIUomFWThNWhnw4doow
         as4oz6mM5DCVj8t1HsbTfYjl3rahAHYDQ/Czg53/Vw/2wMpgzbSsol0Ml/fpoGtuPag5
         9zHiyaPovFt53+MyB1DZRvYRaw1qPZpW+ht/JvQSo67f4VK9pBrt19wCOrya9wVdhaIY
         aWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=cGqzklWXWDVELhuS+xgTophtvKPosdcmMHaKUXqQOh0=;
        b=vz2NzT5AEsZJBV22lKKc6HTCxufbH4CUakxowWb8oFqPpf1Pji2GoXmokLITp1JQA4
         sXQtfQu1e8OiMLHsE54q8xwGUA+p4ozrH/BM/hAREQOjsw8n18PD9NWSAPdTzrAkjmd4
         rlu6jUGuFY9HGzEOxiHTngZB0KXp8bu2aDDEEkWN9Pvi9jsHfw8Oq8qjgZsOyVAKX8AG
         clLPlqYHSp/j23B1Ax6iPbaiCe/QWJiz8i6xBh40hpAr4QLk4/cp0j5Lq2lTda1U7Qsz
         lcD3cB60viE+MGHeOx8YrU3mdtDgMA3vqmbeWfcd86Fp9OGo48XFZpPHSPymeg0WHgcX
         aZ7A==
X-Gm-Message-State: AOAM530vvvXXjQAqK0FAEGXmf6xCZncNyy3DxHm+fDSkHwpbdiRGfhyt
        ddmYjjlFccJC0Se79SWMfBkoVvs4zU5WcgbOBxI=
X-Google-Smtp-Source: ABdhPJxtgOw8DrWhdylbnbjdA10z12KN6Cl9oFJfVytaZ6t0Ww2ci1DbIQHOnLTojIe0KMx8iXHfvOivvWQSQ2Azifk=
X-Received: by 2002:ab0:6f95:0:b0:362:8cb3:36f3 with SMTP id
 f21-20020ab06f95000000b003628cb336f3mr14772296uav.46.1652300134590; Wed, 11
 May 2022 13:15:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6122:255:0:0:0:0 with HTTP; Wed, 11 May 2022 13:15:34
 -0700 (PDT)
Reply-To: frankmorsonn@aol.com
From:   Barrister Frank Morrison <arth5jhson@gmail.com>
Date:   Wed, 11 May 2022 21:15:34 +0100
Message-ID: <CAON3qUhgcU9oBgG0awZ1nxszgLcdVY8Vdcnu-RgLNCdJh-u_ww@mail.gmail.com>
Subject: Lkd
To:     arth5jhson@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
I'm Barrister Arthur Johnson. Please I wish to have a communication with you.
I am waiting for your answer.
Regards,
Barr.Arthur Johnson
