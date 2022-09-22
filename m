Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54F5E57A9
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 02:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIVAza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 20:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIVAz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 20:55:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A3E89925
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 17:55:25 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v1so7296988plo.9
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 17:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=8rveiCO2s2ifRGP5UYnMLmArTRslMD6kGGFT4wMrtos=;
        b=pnQ0ZVXUSO1pmHdgcTc75xX2M5oRUfZQSNH6DGCfYFvWpjVScyu0MU4rkWUpkX5Xc5
         DzFEMSKGwpO+OdKzYMRBV0omGcCmzlD9CIwYn9tGJLVIcqdhP7noShMPZl6/zD7FTFlR
         0nw2MedS19DC+DfHnxA2Sd/fYJp/yRQPKld3ypLVvXkLIWI6L+pWIX/GOgF2IzAY8C3H
         HuQLLulzF+EcNQw7C6QlS+eTz/oS2WuZgZDSjn0vMWCwcWnkn2VQBUTA1o8wxwkE8/Cs
         sqXfnp0+gx3A2sO7KUdSUGHpibKVChN062giw2SvrjfAxCdz/iO3vefnwmuUQx/hd1in
         ZLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8rveiCO2s2ifRGP5UYnMLmArTRslMD6kGGFT4wMrtos=;
        b=ZG7sh07hvt+3g7XexWYWGqShQ7SlytIOwOn7x6576F0hwlyfxfVnTk+PN7Vy5IPHY1
         nqGPT52KDKBDGQ2cxmMejEZsE4qr3nSYk+H0Yof9szxblPzZXD37Om0+vtYwm811qn4A
         mItfgoNqHrwxWtiyn1xBNoubDKyvO6ZUNoTsDIzQtk7UQ/vMm64AEi6NFuMcpRDDPTY9
         KunTsP+8egIekjk6STicOVyjITcmI7Roh/Q+dXtf9C0hkiT9SfEyY+2XMGvf2OwrO87m
         LHTXj/YF6xJjrzVpIXMrWX3lqYF3iYbzvssxZGlHPCW0SE8XBJwXbqdAXOFJL2cvFjmV
         Vjrg==
X-Gm-Message-State: ACrzQf2Q6aPAPJ2cvq/apfrBz0wZdAyc15bF3pktyNpoEteRwEY5I0dH
        UAaF+qpoH8mZdDyyVS2tt6zBfjkcibo2GkbhSno=
X-Google-Smtp-Source: AMsMyM4tIJ7I414SchQyW3J2DitG2ptgt06FSSjkif7p6oK7DVAfC5RtoXB08uCzVnM+PcJ08cyQKlllU9c6BANUx78=
X-Received: by 2002:a17:90a:2fc9:b0:202:5605:65ae with SMTP id
 n9-20020a17090a2fc900b00202560565aemr898187pjm.167.1663808125069; Wed, 21 Sep
 2022 17:55:25 -0700 (PDT)
MIME-Version: 1.0
Sender: otubarpavilion@gmail.com
Received: by 2002:a05:7022:e05:b0:45:5ad7:3a99 with HTTP; Wed, 21 Sep 2022
 17:55:24 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Thu, 22 Sep 2022 00:55:24 +0000
X-Google-Sender-Auth: T-9R_ZMFUex3A0uuNekpL8-q1Q4
Message-ID: <CAFEQ9ba47kvrqCgCTX4F53LvX9U6X_ZXv0V-zsvaQDn+-r48QA@mail.gmail.com>
Subject: Inheritance
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greeting
I wrote to you before, but you did not answer my mail.
How are you today and your family? I hope you are fine! With Due
respect, I am attorney Pavillion Tchi, I sent you a letter last month,
but you did not get back to me with response.& I have an important
information about your heritage worth $5.5 million, which has been
entrusted to you by your late cousin, from your country. I seek your
consent to present you as the next of kin for the claim of this fund,
because the bank has mandated me to present to them the next of kin to
enable them start the legal process for the transfer of this fund to
your bank account.

Your prompt response will be appreciated for more details.
Sincerely,
Pavillion Tchi
