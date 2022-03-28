Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5564E9F92
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbiC1TOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiC1TOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:14:47 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E2F66F83
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:13:06 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id z8so27738524ybh.7
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=VtL1vRHVrL2R6uqHYgXlRb5Ta6JPmAKz26gFmkhuNdbWITn28OueFgBOmaCyHIr1Oq
         BaLwdaVj1hnZftxaKo48LZPt9vvvtBTY7rhdyFy8pkg1SXZtNKgCEWccuWsKCzqi8kCM
         VFQ9gHg19Zy0+Kr+BKJiQWExLwN07UMLbtrrPOiG0wAMmVmRtHZbmNYpcP7556PijB4K
         OJkoHSx1z7kXwLnelrM7XBrc2tk1NybmcBOc61Z4lahn5rkcbtvu+BcAZWRA1UnUH5hy
         PQtsJBfPQDPYbGO+4SQDlZIOpRJAYxhxzzNagEiy6WiDmG+TojnE9+a3N3l0uzxe9Obp
         WXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=Bf8HHIllx9Ug7WxYXmRJlUbL1rLyhfa554bslMqob8f7SCCHZ8cY6QJJPa8VUVjREe
         NEvrPjBNeA2q7HAt0MO4C/SoWfzKgtE/Tk+bz0o8SBmfCYI5deccpQudnGL5OsxkILaZ
         0ursKOSlQx2LFKBtXStIXyVEophANY4vwUutVDjzYdi5z8kATAaZaFAyi+4AWG9kcaMV
         4gVVKHnXAVc6VqYIOaAGaMMO12H8y3+m+/k11mGfQX/OFFYpAwDR9i4QpZo2oSjBqsd5
         4TF0l5fL9W0E8STtzWNeCE8GPJeF7b1Y4QDD9DYt78Hx3752O09+6eDfRE0IePcaa6S8
         7NYg==
X-Gm-Message-State: AOAM532F8/6fgEF38yazO/c2f8SCLvawWAUBORQjqrc2s+U7x6Z/vD0V
        2ly4LMcVlQvCK6iLLgPaQ55H9IxbFApR02UpG/Q=
X-Google-Smtp-Source: ABdhPJwI7s/MMSeHCpsofVYvB4JaSGiyViBXrqzhXxEJWBjTXFpPTwm44ufaEbC8YERzPmbJ4eUOnvZ2bqWoy7ETd3A=
X-Received: by 2002:a05:6902:91e:b0:621:b123:de46 with SMTP id
 bu30-20020a056902091e00b00621b123de46mr24778703ybb.76.1648494785898; Mon, 28
 Mar 2022 12:13:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:614b:0:0:0:0 with HTTP; Mon, 28 Mar 2022 12:13:05
 -0700 (PDT)
From:   Lomax Chambers <lomaxchambers9@gmail.com>
Date:   Mon, 28 Mar 2022 20:13:05 +0100
Message-ID: <CAF7J=3QiyH6uhztbnJU2YsvZMgQv+7-jG=5stJVmP__sX6f4Nw@mail.gmail.com>
Subject: Dearest
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dearest,
I sent this message to you before without responding.
please,confirm this and reply for more
instruction.(jerryesq22@gmail.com or wilfredesq23@gmail.com)

WILFRED Esq.
Telephone +228 96277913
