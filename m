Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D5B55B1E5
	for <lists+stable@lfdr.de>; Sun, 26 Jun 2022 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiFZMYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jun 2022 08:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiFZMYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jun 2022 08:24:11 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60E9101FB
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 05:24:10 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31780ad7535so62346197b3.8
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 05:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=iyNq6ingqoLMUnUPtciJvqIhDMC/q+G6ZLDoaWWECo8=;
        b=pHyc1jgIfNh5ZUlIH/kR0EtdexAv2TPoEX8gSxuADvuDFvGUCjPM75n3oEbrIAh7DR
         61Zr4Yt0EtTEt0fvgpVHiuvReIDJtXkqjo08Js0ZlWlLY4KxHEep0++uW14Aej9E4SLO
         TxbV+z9Z1cekXiNgAy96NVdv/FmGM8U+eeeonGrr8Mm2LFAlsO1ypjWNPgPp4PK+JuXq
         NbzVTJlkbw22sDuDQvjDnATbyAybo4EeOJHqE8TyBptDqCnNnPs32oTYaLoEe7YzRh9W
         dlfG4dmK8czr+LFkA2vgwIELc2s+ARs0L3pqpfrRVYjcna4nbOk5m6I44er6V3QUwk8A
         cKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=iyNq6ingqoLMUnUPtciJvqIhDMC/q+G6ZLDoaWWECo8=;
        b=ZEBGMSuvlWZhuiFJ4f9Xxva/vTEr78qAmuLTgozWSZOmsfq97kjYmpk5pADm15mmkS
         QTgWOM/vYmznyRTvzqZDNieZ2XKVRpSDp6/6MaNCmyKNoWUy/c6JflBfDBSZeCTpNmQz
         j6s8dB/+rsXtBGPbhKUVaprV51pl2BHrMfB/qzF/RrQzdiJjxz1ONkM8DWwB+IO4TBd6
         btf2ShL5ChiBs9V0QKij+Z0fbolUailXT3M8iqORy7YZXeqXxUKB+FaU76pNCqr2x28c
         c8H7aJXnPD58dOlT/ogpzJQwFiOhysMvx25KiXCjhALyDuzO1N6LEZf6wIbTxczIgwE6
         iT0A==
X-Gm-Message-State: AJIora+kOSy1IUEuCQy3EAijC/O98nKukv374NG2Du/0AaHdatjdHZfX
        Ua9QZ+Y4Ee4eysOI4pWbFhg/vdjnsgWEL5oiG+E=
X-Google-Smtp-Source: AGRyM1tWzABuuNJGVP5sIsgPi9A0Eg8L8goTiHwCvjNlFzfI5ewlzaipUpi5ahDQjpqDuYTPOcOPY1JcurjrptdSHWM=
X-Received: by 2002:a81:5745:0:b0:318:99e6:3279 with SMTP id
 l66-20020a815745000000b0031899e63279mr8908462ywb.311.1656246250147; Sun, 26
 Jun 2022 05:24:10 -0700 (PDT)
MIME-Version: 1.0
Sender: madjatomwarga@gmail.com
Received: by 2002:a05:7010:9828:b0:2e1:e99b:8ade with HTTP; Sun, 26 Jun 2022
 05:24:09 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Sun, 26 Jun 2022 12:24:09 +0000
X-Google-Sender-Auth: rhjwBHaXZL9TXrp4OAH3XNRwApA
Message-ID: <CAJ3F4K-hxemXxTfSZbX0yEF0q5FGP0QRjNvr29nmPoxXdxzBag@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings, I hope you are good. I have not received any response from
you regarding my previous emails, please check and reply to me.
