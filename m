Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB25711A8
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 07:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiGLFDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 01:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLFDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 01:03:30 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A988C74A
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 22:03:29 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id y3so8630463qtv.5
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 22:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=Ok0nh9jZHc1v4qyiXvDScCMtsPyOk2EvYbni+5iDishXoZWABNQkwCA/8djmFTbkhx
         ZQ0RFRI++KT+QGFqt/Peh9kAEBeafJCwlopoBPmj6LWgoKG049C4oVEWlqzXKnc/9kdA
         t3Y0bhLUoe1e/CoaAYsnrJDfdYs3mY9Qop0HtgN0Vcv4Qf/2+Syugdk4Fs14CHtHS5gR
         gMctjjgNih9GcZlyuwFl6vpJxfct2g6F19sNFYZ7S8RfgGv2cqFTIvhCfoK/Xfa9R9rd
         uZFGx1tpur4FeCrk1gG+rdqtBDodQVn/L1CPb2tXTrhMZHZtHqzShjjVIlrw3+Bn2jcm
         LoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=rlx2nWf7NJH//wdkfo0+881yIKCML/xareeXEpRALECieUQwjEURIdxusTmadIgm8U
         MeknfNVtrUVZmGMNcnawmrveR5jgCOUQXNt2emj8wBwaQRhzWR/ub0eiSJnsPFNyzpHM
         pd94XAuR9wOvS8XuN9pJDkYdd8EUhnnzRk9uL4Uv9qoA60C4HkdeyhYxFb4qFQY15UCD
         BVasIRBIKYmslVMkMfDWhyHSdPkeYBb4jqzCBWiN8coveaUiFraDrxsKrKQ308WZj9w4
         oyt+scssFRQX/ElyN0K3xXcHkgHqH4NX6FuGmlcX88htuSU9nUxOMgi1f5JN8BNrKvIe
         pARA==
X-Gm-Message-State: AJIora/SEK4nAWBNJHjZA4ORWXxmwyeYVFkMgP4ApFW09klzhfHpWMzb
        OFTKYPBnCLxg5YlFWusPJ6GCOyUQtEdctK/PLvAT4qJW0I0=
X-Google-Smtp-Source: AGRyM1sCz5R7CGXUdLnZlxwywO25jGgKyx/9QfqGjqgpkF2ojB/l4Yr6rpQ0XyLvYTaNvUO2aVoLQ+j2rPbuP9LU0Oo=
X-Received: by 2002:ac8:5e0a:0:b0:31b:f15f:76b with SMTP id
 h10-20020ac85e0a000000b0031bf15f076bmr16554610qtx.502.1657602208394; Mon, 11
 Jul 2022 22:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090549.543317027@linuxfoundation.org>
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 12 Jul 2022 10:33:17 +0530
Message-ID: <CAHokDBnTej5cQPMgUf-f2zD5PNM_Rd=2mUvMM3XVMHoJhKSTrw@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
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

Tested-by: Fenil Jain <fkjainco@gmail.com>
