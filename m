Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF65B1C15
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 14:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiIHMBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 08:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIHMBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 08:01:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA5BE229E
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 05:01:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z21so13941872edi.1
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 05:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=61JNgHFLNVCOHtS3GBlVT+sTDzg02TjYElOUCZQYEf8=;
        b=fj2W/v8gXinFqwSgjH75MLGwh072XIdUBlDUyem68NKMk2xzzzLe0+ynO7dg7VS7rW
         lAPrjkCLmdjDEO/CWDHlMz+43vyaN2HrEmMtbatgbxkaVpMVug0APzavVR0SknZx9f9y
         DGTzeE4CRiKotc9vvrtXfos9mxmwEDlhQnF7NZr2w1mXS488CHhFvYze493GQopnvaSh
         +p/9pLcoF2THYx5rkFN4Ggu38VPMwC95qrzI3NZQAe1Ypm1kBbZgJQ9/3Hm2QmKdM7Ne
         hDWzDUsKch2KYp+fjInooaOGNwVH4nvezAMLFqAg0D8/+dXxPiyhE2ydZ46FDW5Mg4I6
         XXiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=61JNgHFLNVCOHtS3GBlVT+sTDzg02TjYElOUCZQYEf8=;
        b=cCQQBLq6CgkOcdmv1/7EtbX/U83unMCAua/fst44vU7IaMpKYJfKSOiAoN6iycrkDj
         blrm0i7dpgbF1GHehb854C7u7zo7hpaumRpFdM5de3K1868Y+ycd2vv4YU2WpgLlbp4N
         0XmuCD0snVqFTouVI8mgKizhDSN0ZZK/btrBLvYeApAtB+hlR+zqunI0lSc8gfKCH5wz
         GCY2kIOtAD4itV0uEOFwY8y4CYxKOiuHpMZs92yV4yzVwUWGt+Eq0F64tr8PwVva7tLn
         AnJFA/omTsraxLjeBhoBz0pKkTA71ODnswnELoVa5FUfKWhLNBWe0Ka7Bd+V5HBZfzTb
         4Gfg==
X-Gm-Message-State: ACgBeo23Hw4Vv41P9HxdsyHb8sv+wc4HwJrOtsx/BYx2pSjY61fKv64/
        pPlZnF+tB7ABlbfTdPjOBfelrW75ui9rY1QUTLs=
X-Google-Smtp-Source: AA6agR7832b5kv5zHADHnBBqMZ7jwLE33KA7zJ7OxHb8YMFdZQr3gCjYHUv/lyvffrgEZTcP1p3JRm9czvM6fptHBJI=
X-Received: by 2002:a05:6402:1a4f:b0:44e:f731:f7d5 with SMTP id
 bf15-20020a0564021a4f00b0044ef731f7d5mr6762301edb.357.1662638502049; Thu, 08
 Sep 2022 05:01:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:749d:b0:743:2e24:e8cd with HTTP; Thu, 8 Sep 2022
 05:01:41 -0700 (PDT)
Reply-To: mrtonyelumelu98@gmail.com
From:   "Mrs. Cristalina Georgieva" <nastyanastya88889@gmail.com>
Date:   Thu, 8 Sep 2022 13:01:41 +0100
Message-ID: <CADsX60B+-_p4Rxowu564WnZ1waWQ61xr=tSTj2jHYd6+TkjXZA@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2LXZhtiv2YjZgiDYp9mE2YbZgtivINin2YTYr9mI2YTZiiAoSS5NLkYpDQrYtNi52KjYqSDYpdiv
2KfYsdipINin2YTYr9mK2YjZhiDYp9mE2K/ZiNmE2YrYqSDYjA0KIyAxOTAwINiMINi02KfYsdi5
INin2YTYsdim2YrYsw0KDQrZhdix2K3YqNmL2Kcg2KjZg9mFINmB2Yog2LnZhtmI2KfZhiDYp9mE
2KjYsdmK2K8g2KfZhNil2YTZg9iq2LHZiNmG2Yog2KfZhNix2LPZhdmKINmE2YTZhdiv2YrYsSBJ
Lk0uRi4g2YPYsdmK2LPYqtin2YTZitmG2Kcg2KzZiNix2KzZitmB2KcNCg0KDQrYudiy2YrYstmK
INin2YTZhdiz2KrZgdmK2K8hDQoNCtmE2YLYryDYs9mF2K0g2YTZhtinINmI2LLZitixINin2YTY
rtiy2KfZhtipINin2YTZhdi52YrZhiDYrdiv2YrYq9mL2Kcg2YjYp9mE2YfZitim2Kkg2KfZhNit
2KfZg9mF2Kkg2YTZhNiz2YTYt9ipINin2YTZhtmC2K/ZitipDQrZhNmE2KPZhdmFINin2YTZhdiq
2K3Yr9ipINio2YHYrdi1INin2YTYo9mF2YjYp9mEINin2YTYqtmKINmE2YUg2KrYqtmFINin2YTZ
hdi32KfZhNio2Kkg2KjZh9inINmI2KfZhNiq2Yog2YTYt9in2YTZhdinINmD2KfZhtiqDQrZhdiv
2YrZhtipINmE2K3Zg9mI2YXYqSDYp9mE2KPZhdmFINin2YTZhdiq2K3Yr9ipINiMINmE2LDZhNmD
INiq2YUg2KfYqtmH2KfZhSDZhdin2YTZg9mK2YfYpyDYqNin2YTYp9it2KrZitin2YQuDQrYp9mE
2YXYrdiq2KfZhNmI2YYg2KfZhNiw2YrZhiDZitiz2KrYrtiv2YXZiNmGINin2LPZhSDYp9mE2KPZ
hdmFINin2YTZhdiq2K3Yr9ipINiMINmI2YHZgtmL2Kcg2YTYs9is2YQg2KrYrtiy2YrZhiDYp9mE
2KjZitin2YbYp9iqDQrZhdi5INi52YbZiNin2YYg2KfZhNio2LHZitivINin2YTYpdmE2YPYqtix
2YjZhtmKINmE2YbYuNin2YXZhtinINij2KvZhtin2KEg2KfZhNiq2K3ZgtmK2YIg2KfZhNiw2Yog
2KPYrNix2YrZhtin2Ycg2Iwg2YHYpdmGDQrYr9mB2LnYqtmDINmF2K/Ysdis2Kkg2YHZiiDZgtin
2KbZhdipINiq2LbZhSAxNTAg2YXYs9iq2YHZitiv2YvYpyDZgdmKINin2YTZgdim2KfYqiDYp9mE
2KrYp9mE2YrYqTog2LXZhtiv2YjZgiDZitin2YbYtdmK2KgNCti62YrYsSDZhdmP2LPZhNmO2ZHZ
hSAvINi12YbYr9mI2YIg2YrYp9mG2LXZitioINi62YrYsSDZhdiv2YHZiNi5IC8g2YjYsdin2KvY
qSDZhtmC2YQg2LrZitixINmF2YPYqtmF2YTYqSAvINij2YXZiNin2YQNCtin2YTYudmC2K8uDQoN
CtmC2KfZhSDZhdiz2KTZiNmE2Ygg2KfZhNio2YbZgyDYp9mE2YHYp9iz2K8g2Iwg2KfZhNiw2YrZ
hiDYp9ix2KrZg9io2YjYpyDYp9mE2YHYs9in2K8g2YXZhiDYo9is2YQg2KfZhNin2K3YqtmK2KfZ
hCDYudmE2YkNCtij2YXZiNin2YTZgyDYjCDYqNiq2KPYrtmK2LEg2K/Zgdi52YMg2KjYtNmD2YQg
2LrZitixINmF2LnZgtmI2YQg2Iwg2YXZhdinINij2K/ZiSDYpdmE2Ykg2KrYrdmF2YTZgyDYp9mE
2YPYq9mK2LEg2YXZhg0K2KfZhNiq2YPYp9mE2YrZgSDZiNiq2KPYrtmK2LEg2LrZitixINmF2LnZ
gtmI2YQg2YHZiiDZgtio2YjZhCDZhdiv2YHZiNi52KfYqtmDLiDYp9iu2KrYp9ix2Kog2KfZhNij
2YXZhSDYp9mE2YXYqtit2K/YqQ0K2YjYtdmG2K/ZiNmCINin2YTZhtmC2K8g2KfZhNiv2YjZhNmK
IChJTUYpINiv2YHYuSDYrNmF2YrYuSDYp9mE2KrYudmI2YrYttin2Kog2YTZgCAxNTAg2YXYs9iq
2YHZitiv2YvYpyDYqNin2LPYqtiu2K/Yp9mFDQrYqNi32KfZgtin2KogVmlzYSBBVE0g2YXZhiDY
o9mF2LHZitmD2Kcg2KfZhNi02YXYp9mE2YrYqSDZiNij2YXYsdmK2YPYpyDYp9mE2KzZhtmI2KjZ
itipINmI2KfZhNmI2YTYp9mK2KfYqiDYp9mE2YXYqtit2K/YqQ0K2YjYo9mI2LHZiNio2Kcg2YjY
otiz2YrYpyDZiNit2YjZhCDYp9mE2LnYp9mE2YUg2Iwg2K3ZitirINiq2KrZiNmB2LEg2KrZgtmG
2YrYqSDYp9mE2K/Zgdi5INin2YTYudin2YTZhdmK2Kkg2YfYsNmHDQrZhNmE2YXYs9iq2YfZhNmD
2YrZhiDZiNin2YTYtNix2YPYp9iqINmI2KfZhNmF2KTYs9iz2KfYqiDYp9mE2YXYp9mE2YrYqS4g
2YjZitiz2YXYrSDZhNmE2K3Zg9mI2YXYp9iqINio2KfYs9iq2K7Yr9in2YUg2KfZhNi52YXZhNin
2KoNCtin2YTYsdmC2YXZitipINio2K/ZhNin2Ysg2YXZhiDYp9mE2YbZgtivINmI2KfZhNi02YrZ
g9in2KouDQoNCtmE2YLYryDZgtmF2YbYpyDYqNin2YTYqtix2KrZitioINmE2LPYr9in2K8g2YXY
r9mB2YjYudin2KrZgyDYqNin2LPYqtiu2K/Yp9mFINio2LfYp9mC2KkgVmlzYSBBVE0g2YjYs9mK
2KrZhSDYpdi12K/Yp9ix2YfYpw0K2YTZgyDZiNil2LHYs9in2YTZh9inINmF2KjYp9i02LHYqdmL
INil2YTZiSDYudmG2YjYp9mG2YMg2LnYqNixINij2Yog2K7Yr9mF2KfYqiDYqNix2YrYryDYs9ix
2YrYuSDZhdiq2KfYrdipLiDYqNi52K8NCtin2YTYp9iq2LXYp9mEINio2YbYpyDYjCDYs9mK2KrZ
hSDYqtit2YjZitmEINmF2KjZhNi6IDHYjDUwMNiMMDAwLjAwINiv2YjZhNin2LEg2KPZhdix2YrZ
g9mKINil2YTZiSDYqNi32KfZgtipIFZpc2ENCkFUTSDYjCDZiNin2YTYqtmKINiz2KrYs9mF2K0g
2YTZgyDYqNiz2K3YqCDYo9mF2YjYp9mE2YMg2LnZhiDYt9ix2YrZgiDYs9it2Kgg2YXYpyDZhNin
INmK2YLZhCDYudmGIDEw2IwwMDAg2K/ZiNmE2KfYsQ0K2KPZhdix2YrZg9mKINmB2Yog2KfZhNmK
2YjZhSDZhdmGINij2Yog2YXYp9mD2YrZhtipINi12LHYp9mBINii2YTZiiDZgdmKINio2YTYr9mD
LiDYqNmG2KfYodmLINi52YTZiSDYt9mE2KjZgyDYjCDZitmF2YPZhtmDDQrYstmK2KfYr9ipINin
2YTYrdivINil2YTZiSAyMNiMMDAwLjAwINiv2YjZhNin2LEg2YHZiiDYp9mE2YrZiNmFLiDZgdmK
INmH2LDYpyDYp9mE2LXYr9ivINiMINmK2KzYqCDYudmE2YrZgw0K2KfZhNin2KrYtdin2YQg2KjY
pdiv2KfYsdipINin2YTZhdiv2YHZiNi52KfYqiDZiNin2YTYqtit2YjZitmE2KfYqiDYp9mE2K/Z
iNmE2YrYqSDZiNiq2YLYr9mK2YUg2KfZhNmF2LnZhNmI2YXYp9iqINin2YTZhdi32YTZiNio2KkN
CtmF2YYg2K7ZhNin2YQ6DQoNCjEuINin2LPZhdmDINin2YTZg9in2YXZhCAuLi4uLi4uLi4uLi4u
Lg0KMi4g2LnZhtmI2KfZhtmDINin2YTZg9in2YXZhCAuLi4NCjMuINin2YTYrNmG2LPZitipIC4u
Li4uLi4uLi4uLi4uLi4NCjQuINiq2KfYsdmK2K4g2KfZhNmF2YrZhNin2K8gLyDYp9mE2KzZhtiz
IC4uLi4uLi4uLg0KNS4g2KfZhNiq2K7Ytdi1IC4uLg0KNi4g2LHZgtmFINin2YTZh9in2KrZgSAu
Li4uLi4uLi4NCjcuINi52YbZiNin2YYg2KfZhNio2LHZitivINin2YTYpdmE2YPYqtix2YjZhtmK
INmE2LTYsdmD2KrZgyAuLi4uLi4NCjguINi52YbZiNin2YYg2KfZhNio2LHZitivINin2YTYpdmE
2YPYqtix2YjZhtmKINin2YTYtNiu2LXZiiAuLi4uLi4NCg0KDQrZhNiq2K3Yr9mK2K8g2YfYsNin
INin2YTYsdmF2LIgKNin2YTYsdin2KjYtzogQ0xJRU5ULTk2Ni8xNikg2Iwg2KfYs9iq2K7Yr9mF
2Ycg2YPZhdmI2LbZiNi5INmE2YTYqNix2YrYrw0K2KfZhNil2YTZg9iq2LHZiNmG2Yog2KfZhNiu
2KfYtSDYqNmDINmI2K3Yp9mI2YQg2KrZgtiv2YrZhSDYp9mE2YXYudmE2YjZhdin2Kog2KfZhNmF
2LDZg9mI2LHYqSDYo9i52YTYp9mHINil2YTZiSDYp9mE2YXZiNi42YHZitmGDQrYp9mE2KrYp9mE
2YrZitmGINmE2KXYtdiv2KfYsSDZiNiq2LPZhNmK2YUg2KjYt9in2YLYqSBWaXNhIEFUTSDYmw0K
DQrZhtmI2LXZitmDINio2YHYqtitINi52YbZiNin2YYg2KjYsdmK2K8g2KXZhNmD2KrYsdmI2YbZ
iiDYtNiu2LXZiiDYqNix2YLZhSDYrNiv2YrYryDZhNmE2LPZhdin2K0g2YTZiNmD2YrZhCDYp9mE
2KjZhtmDINio2KrYqtio2LkNCtmH2LDZhyDYp9mE2YXYr9mB2YjYudin2Kog2YjYqtio2KfYr9mE
INin2YTYsdiz2KfYptmEINmE2YXZhti5INin2YTZhdiy2YrYryDZhdmGINin2YTYqtij2K7Zitix
INij2Ygg2KfZhNiq2YjYrNmK2Ycg2KfZhNiu2KfYt9imDQrZhNij2YXZiNin2YTZgy4g2KfYqti1
2YQg2KjZiNmD2YrZhCDYp9mE2KjZhtmDINin2YTYpdmB2LHZitmC2Yog2KfZhNmF2KrYrdivINin
2YTYotmGINio2KfYs9iq2K7Yr9in2YUg2YXYudmE2YjZhdin2KoNCtin2YTYp9iq2LXYp9mEINij
2K/Zhtin2Yc6DQoNCtin2YTYtNiu2LUg2KfZhNmF2LPYpNmI2YQ6INin2YTYs9mK2K8g2KrZiNmG
2Yog2KXZhNmI2YXZitmE2YgNCtil2K/Yp9ix2Kkg2KrYrdmI2YrZhCDYo9mF2YjYp9mEINin2YTY
qti52YjZiti22KfYqiDYjCDYrNmH2Kkg2KfZhNin2KrYtdin2YQg2KjYp9mE2KjYsdmK2K8g2KfZ
hNil2YTZg9iq2LHZiNmG2Yog2YTYqNmG2YMNCtil2YHYsdmK2YLZitinINin2YTZhdiq2K3Yrzog
KG1ydG9ueWVsdW1lbHU5OEBnbWFpbC5jb20pDQoNCtmG2K3Yqtin2Kwg2KXZhNmJINix2K8g2LPY
sdmK2Lkg2LnZhNmJINmH2LDYpyDYp9mE2KjYsdmK2K8g2KfZhNil2YTZg9iq2LHZiNmG2Yog2YTY
qtis2YbYqCDYp9mE2YXYstmK2K8g2YXZhiDYp9mE2KrYo9iu2YrYsS4NCg0K2LXYr9mK2YLZgyDY
p9mE2YXYrtmE2LUNCtin2YTYs9mR2YrYr9ipLiDZg9ix2YrYs9iq2KfZhNmK2YbYpyDYrNmI2LHY
rNmK2YHYpw0K
