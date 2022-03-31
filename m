Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2B4ED0FA
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 02:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiCaAnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 20:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiCaAnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 20:43:45 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9102433A8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 17:41:59 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o67so24306436vsc.0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 17:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8ImU4aahvjo+EBoib/gHaXA3xSjqXljW+S9x3JJbdKs=;
        b=aN28njkKeLpuZ/HBuUe+SzKumZwFu+xmjSsX7dYq0asv1Z4vysq0+GtvMB6cIwl86g
         LuTws521G+5rHjqpHhOg1FGly/15o8UdzFmu4cPjhtbpRJnX2Je9W0GvfI0ryNlftWZF
         mfm2Ra6PQ/DYf9GTIUQnovRL89cjtOs6XNLsJ9mGWtXxptI/jIehJM69y4Fr1a/hC6lq
         j4242ZLV0skiAPc4c1hX1GKNnDIx11ZzexeMjVh0EPsVG2jBr/D4Hw//aNmmQ3oqkqsZ
         rY0uY1tche/OhClR8k5KkQ0YlHADjODSv6RKnSW6cXZ4mNe4KvP+EhMhNbLotuY1+9YZ
         ovHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=8ImU4aahvjo+EBoib/gHaXA3xSjqXljW+S9x3JJbdKs=;
        b=J5kqQV+JY0qWQabof8mGAeX03wOCon4G191sjOtoXhJUgCNY0M8NhE9K1RdK31RQ43
         cJydNv9mOmNzfp8T6OCgpn2u1P4wxWZDwVVnz++aSLQTp7VhG3RBYaD2GLT5GEJCTPoC
         SVuA8i+o638uMet09PFt6bSC4VlqENm53z8Br6o9f96Cjup/L4fbLzi215Sq8ROR2LRL
         ZhIZ5QKLRsdUBlXZ9AmbqRpkB5SBcGnmQajNkvUzdVnW5A6Ui0/xt7ND/lORRdudsH+E
         fOO2Sqoq+xrrfTf/eANPWDs1adttn8RR0rgSW4MPMilZB0Y51ZB87SuOwEI2Ta5v5rGz
         RMQA==
X-Gm-Message-State: AOAM532HZ9ildxgNxnTTLIykAAChQN4tJA2Mxb9aY6iH4r5aZhxLJfzO
        fcEOcTfpNfSIQR8SqzCWv9+HuCDGYNqWh6XWfjI=
X-Google-Smtp-Source: ABdhPJzi75w4m/eln8aEWlLFkX2/r2iYhW8nPvzkyxY2QDYWZDxXuZ2xDZIM7qO2Kko8vBUywb3ywWURQP+Hbw83fk8=
X-Received: by 2002:a05:6102:a4c:b0:325:a54d:7f3e with SMTP id
 i12-20020a0561020a4c00b00325a54d7f3emr897941vss.71.1648687318593; Wed, 30 Mar
 2022 17:41:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:10cd:b0:281:c6a6:1301 with HTTP; Wed, 30 Mar 2022
 17:41:58 -0700 (PDT)
Reply-To: Ubagroup.tgo12@gmail.com
From:   Kristalina Georgieva <tatianaamousou@gmail.com>
Date:   Wed, 30 Mar 2022 17:41:58 -0700
Message-ID: <CAEHHN=+YnP7Qgf6JGvGyN-cwV4DJJMdhy2hEDe9bbkESyw6EjA@mail.gmail.com>
Subject: =?UTF-8?B?2KPYrtio2KfYsSDYrNmK2K/YqQ==?=
To:     ikechukwu4125 <ikechukwu4125@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2LnYstmK2LLZiiDYp9mE2YXYs9iq2YHZitiv2IwNCtmE2YLYryDYo9ix2LPZhNiqINmE2YMg2YfY
sNmHINin2YTYsdiz2KfZhNipINmC2KjZhCDYtNmH2LEg2Iwg2YTZg9mG2Yog2YTZhSDYo9iz2YXY
uSDZhdmG2YMg2Iwg2YTYpw0K2KPZhtinINmF2KrYo9mD2K8g2YXZhiDYo9mG2YMg2KrZhNmC2YrY
qtmH2Kcg2Iwg2YjZhNmH2LDYpyDYo9ix2LPZhNiq2YfYpyDZhNmDINmF2LHYqSDYo9iu2LHZiSDY
jA0K2KjYp9iv2KYg2LDZiiDYqNiv2KEg2Iwg2KPZhtinINin2YTYs9mK2K/YqSDZg9ix2YrYs9iq
2KfZhNmK2YbYpyDYrNmI2LHYrNmK2YHYpyDYjCDYp9mE2YXYr9mK2LEg2KfZhNi52KfZhSDZiA0K
2LHYptmK2LMg2LXZhtiv2YjZgiDYp9mE2YbZgtivINin2YTYr9mI2YTZii4NCg0K2YHZiiDYp9mE
2YjYp9mC2Lkg2Iwg2YTZgtivINmC2YXZhtinINio2KfYs9iq2LnYsdin2LYg2KzZhdmK2Lkg2KfZ
hNmF2LnZiNmC2KfYqiDZiNin2YTZgti22KfZitinINin2YTZhdit2YrYt9ipDQrZhdi52KfZhdmE
2KrZgyDYutmK2LEg2KfZhNmF2YPYqtmF2YTYqSDZiNi52K/ZhSDZgtiv2LHYqtmDINi52YTZiSDY
s9iv2KfYryDYp9mE2LHYs9mI2YUNCtix2LPZiNmFINin2YTYqtit2YjZitmEINin2YTZhdmB2LHZ
iNi22Kkg2LnZhNmK2YMg2YXZgtin2KjZhCDYrtmK2KfYsdin2KoNCtin2YTYqtit2YjZitmE2KfY
qiDYp9mE2LPYp9io2YLYqSDYjCDZgtmFINio2LLZitin2LHYqSDZhdmI2YLYudmG2Kcg2YTZhNiq
2KPZg9mK2K8gMzgNCsKwIDUz4oCyNTYg4oCzINi02YXYp9mE2KfZiyA3NyDCsCAyIOKAsiAzOSDY
utix2KjZi9inDQoNCtmG2K3ZhiDZhdis2YTYsyDYp9mE2KXYr9in2LHYqSDZiNin2YTYqNmG2YMg
2KfZhNiv2YjZhNmKINmI2LXZhtiv2YjZgiDYp9mE2YbZgtivDQrYp9mE2K/ZiNmE2YogKElNRikg
2YHZiiDZiNin2LTZhti32YYg2KfZhNi52KfYtdmF2Kkg2Iwg2YXYuSDZiNiy2KfYsdipDQrZiNiy
2KfYsdipINin2YTYrtiy2KfZhtipINin2YTYo9mF2LHZitmD2YrYqSDZiNio2LnYtiDZiNmD2KfZ
hNin2Kog2KfZhNiq2K3ZgtmK2YIg2KfZhNij2K7YsdmJDQrYsNin2Kog2KfZhNi12YTYqSDZh9mG
2Kcg2YHZiiDYp9mE2YjZhNin2YrYp9iqINin2YTZhdiq2K3Yr9ipINin2YTYo9mF2LHZitmD2YrY
qS4g2YLYryDYo9mF2LENCtmI2K3Yr9ipINiq2K3ZiNmK2YQg2KfZhNmF2K/ZgdmI2LnYp9iqINin
2YTYrtin2LHYrNmK2Kkg2KfZhNiu2KfYtdipINio2YbYpyDYjCDZhdi12LHZgSBVbml0ZWQgQmFu
ayBvZg0KQWZyaWNhIExvbWUgVG9nbyDYjCDZhNil2LXYr9in2LEg2KjYt9in2YLYqSDZgdmK2LLY
pyDZhNmDINiMINit2YrYqyAkDQoxLjUg2YXZhNmK2YjZhiDZhdmGINij2YXZiNin2YTZgyDZhNiz
2K3YqCDYo9mD2KjYsSDZhdmGINij2YXZiNin2YTZgy4NCg0K2K7ZhNin2YQg2YXYs9in2LEg2KrY
rdmC2YrZgtmG2Kcg2Iwg2KfZg9iq2LTZgdmG2Kcg2YXYuQ0K2KfYs9iq2YrYp9ihINmF2YYg2KPZ
hiDYp9mE2YXYs9ik2YjZhNmK2YYg2KfZhNmB2KfYs9iv2YrZhiDZgtivINij2K7YsdmI2Kcg2K/Z
gdi52YMNCtin2YTYqNmG2YMg2KfZhNiw2Yog2YrYrdin2YjZhCDYqtit2YjZitmEINij2YXZiNin
2YTZgyDYpdmE2Ykg2K3Ys9in2KjYp9iq2YMNCtmG2LTYsS4NCg0K2YjYp9mE2YrZiNmFINmG2K7Y
t9ix2YMg2KjYo9mGINij2YXZiNin2YTZgyDZgtivINiq2YUg2KXZitiv2KfYudmH2Kcg2YHZiiDY
qNi32KfZgtipDQrYqtij2LTZitix2Kkg2YXZhiBVQkEgQmFuayDZiNmH2Yog2KPZiti22YvYpyDY
rNin2YfYstipINmE2YTYqtiz2YTZitmFLiDYrdin2YTZitinDQrYp9iq2LXZhCDYqNmF2K/Zitix
INio2YbZgyBVQkEg2Iwg2KfYs9mF2Ycg2KfZhNiz2YrYryDYqtmI2YbZig0KRWx1bWVsdSDYjCDY
p9mE2KjYsdmK2K8g2KfZhNil2YTZg9iq2LHZiNmG2Yo6IChVYmFncm91cC50Z28xMkBnbWFpbC5j
b20pDQrZhNil2K7YqNin2LHZgyDYqNmD2YrZgdmK2Kkg2KfZhNit2LXZiNmEINi52YTZiSDYqNi3
2KfZgtipINmB2YrYstinINin2YTYtdix2KfZgSDYp9mE2KLZhNmKINin2YTYrtin2LXYqSDYqNmD
Lg0KDQrYqNil2K7ZhNin2LXYjA0KDQrYp9mE2LPZitiv2Kkg2YPYsdmK2LPYqtin2YTZitmG2Kcg
2KzZiNix2KzZitmB2KcNCg==
