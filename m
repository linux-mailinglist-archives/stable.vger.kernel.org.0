Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E197F4EB5EB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiC2Wb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 18:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiC2Wb0 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 29 Mar 2022 18:31:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13469491
        for <Stable@vger.kernel.org>; Tue, 29 Mar 2022 15:29:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a1so26767065wrh.10
        for <Stable@vger.kernel.org>; Tue, 29 Mar 2022 15:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=oIcWmI7I2nQTzcgQLzdva6MScyV3SZ9WynIWpDd4N4BOwbwaVRqpIZ6LKXsW+9Mcdv
         gDz9P6bPGabLbopR9QCjb1M5M1X1u9mRzStu3Ur/E6MlYwTSB5dx4E/75ChpwGFtBkv0
         MCuI+4f6rTfqNLXdRNBk6elkJA0h6nUZsEtDkZmReGHLV8LJwB7SG7TIC4rl5LqUWncr
         m2nGpxZoE2kkgeoi2egxFYnPZdYXSkQBLMMgYn7v7Owtf+/qxJbU/GfD8sBmqLAwRIeo
         qdTHqfPuF+ZhmbTGEkBHLWDPAbr7ogjBB+5lMn+Be64A7gqDzq2aSCsl2oAO1yeCM0Sm
         cEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=zvbOqYCJD945G+mzfOpPyr3VAeQ1hUXHvXlPwQ/hk0okAX9jhPXnLYlbLGOfJBJemm
         XwKCP/HHe1Zu8I7nn/g/5xmqNQGAwy+R3zUZ0cNgm/Kj6t04QVG6sG2lCqx3n5mf1LWj
         oiueZm9mEHqPf+3s6yR9J+epz2zIvJkVf9mg3gWZ6HWcSeThdzSNNs7GDKqj09oYKISL
         hi/gHtxwwFE01pwSCQuBS/e8UbGhROj+L/aKJiium+ji1QOe+SGm8dmK1EuRMYNdDifW
         qqE7U02JVBg5MWbGAMwdPm/NK6gB7IcIrfzvwPR869vhzoog+tDRPTNszk9Ox6AKNoqw
         NAaw==
X-Gm-Message-State: AOAM531wbdKEWWesLoUYeXe0rAuxoSDHlAaKxlFeXD6dbkvvGpytZQDi
        eFn5O5i7hsTzr6KEv3mf0BM=
X-Google-Smtp-Source: ABdhPJw/g0MJDMI8qwxbEwDCRjoukuLFOlWkgO81RkF1W3h88NLoWHxToErlhIqmW19G99se52F6cA==
X-Received: by 2002:adf:dd0c:0:b0:203:f0c0:f1a5 with SMTP id a12-20020adfdd0c000000b00203f0c0f1a5mr33931663wrm.523.1648592980031;
        Tue, 29 Mar 2022 15:29:40 -0700 (PDT)
Received: from [172.20.10.4] ([102.91.4.27])
        by smtp.gmail.com with ESMTPSA id n18-20020a5d6612000000b00203fbd39059sm16004923wru.42.2022.03.29.15.29.34
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 29 Mar 2022 15:29:39 -0700 (PDT)
Message-ID: <62438853.1c69fb81.4d4fe.f2d1@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Gefeliciteerd, er is geld aan je gedoneerd
To:     Recipients <adeboyejofolashade55@gmail.com>
From:   adeboyejofolashade55@gmail.com
Date:   Tue, 29 Mar 2022 23:29:29 +0100
Reply-To: mike.weirsky.foundation003@gmail.com
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_US_DOLLARS_3 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Beste begunstigde,

 Je hebt een liefdadigheidsdonatie van ($ 10.000.000,00) van Mr. Mike Weirs=
ky, een winnaar van een powerball-jackpotloterij van $ 273 miljoen.  Ik don=
eer aan 5 willekeurige personen als je deze e-mail ontvangt, dan is je e-ma=
il geselecteerd na een spin-ball. Ik heb vrijwillig besloten om het bedrag =
van $ 10 miljoen USD aan jou te doneren als een van de geselecteerde 5, om =
mijn winst te verifi=EBren
 =

  Vriendelijk antwoord op: mike.weirsky.foundation003@gmail.com
 Voor uw claim.
