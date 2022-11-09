Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B680B622634
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiKIJFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKIJFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:05:12 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C90D1E3D5
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 01:05:11 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id 128so15971495vse.6
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 01:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=Rwy8aoL9nTeRBWNbKrWzIhzin/WTpJAexo6Wec91FipBdrz3Wi8+ZwbTnBQgsASwWR
         AJylNTe8lDS0SVQRvdvGp8DzAr65OJz28pRXmeSR/eL5+/OMjQqt7krHj15i5TSZ0M31
         HJGYDWTSBfoXUlreXheDhOF4htiHGeNzsEVOKOQmlJW58jwV5T2kHaIxPrmNfvUtvaWM
         oiPYzgPh7JWGCGGYSy+voYVfb5NjILpd0fTJOEay57kyLoHLb2wd0t4bwPPcjpaE8cQc
         ZbV38RmRxgXFl/VmizFT9PON6pQzd3SC+cCikaZYdMqDHL3ZKU4Xay3imcH1QpH14SBP
         xrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=Ix4IJmw/YHL6aG7tnFk2GtihF1eZYpMu3PWTJxSdfqLvp477VlK1TlQKRKvPC6yuUo
         9cHeEvCq58jN5bxexefONK1w62Wi+WmctO/m4JJNfg/Lh4VPve64WYrJ8gg+YoAja9F8
         zoHckSuBP29Lm4ikTC3LjECjj7j/RiT5LPjQiVS2Gr7lADu7QdIwTAt94JLNQFzT8gMl
         iAYSO9LPza76z69c8bBryRx3ud9hWRx8Z+Vu3vQwOfjXSZ+mi/T2OIRLnhGHwTi5uMVZ
         pcQr6/Q2NIHYSEF+wI8FQhACKKG6PCJNXajaOg3SdS4C7bh532qkM4BNr8NlpVwfgRaW
         k7+g==
X-Gm-Message-State: ACrzQf3jyewMpVlbDFdnkI6YXCrKgJnxUZOs9q2cMcYEcPvGgcwwfIso
        83zB9hxPUJhEYIEcE3zJluTYD+az1YuZdpzG0pCPhfxkOTM=
X-Google-Smtp-Source: AMsMyM549d89G27Yi9F79go2C8M9iBa5o5EEI8zkToXl44BE+qnxPT7eAknQbrAJ76b3Hay6L868DSqJarNjtNT7PCc=
X-Received: by 2002:a05:6102:4420:b0:3ad:19b6:4ef9 with SMTP id
 df32-20020a056102442000b003ad19b64ef9mr21973640vsb.37.1667984710408; Wed, 09
 Nov 2022 01:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20221108133354.787209461@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 9 Nov 2022 14:34:59 +0530
Message-ID: <CAHokDB=nY=wU-jvC853XvXBJuh6Wzq6t=eAXCxw_OxOBh=RRVQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
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

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
