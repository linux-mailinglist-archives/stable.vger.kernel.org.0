Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADE553855D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbiE3Pt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiE3PtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:49:12 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2675A95A0B
        for <stable@vger.kernel.org>; Mon, 30 May 2022 08:08:37 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id t13so9506090ljd.6
        for <stable@vger.kernel.org>; Mon, 30 May 2022 08:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=elQ8ovHeePfEyvDpZZSAHdlwsc5opTR17fDgZ+MZlI4=;
        b=G+JEkGkIb/z2sNEqJCYGJ5wLRAXy//9cmj/RoePJ7laPmY0gZ4OYlxNknCg3moq98z
         y6U0lgHJhFUQ0vMegkZIb5CYNOrFMYki411WkR8w5zDt/9HiWVflEvNqAJkWsMl2+ggs
         kMYsVR9Fe1HGji9tosS7J9uH/Runp+nrl9ShYrsck9rbeXsHI00FferGMhteZwMgC6iV
         +pDnnOJZqCclhJ7SGNpAX/lbIAtAs/t8GbA20vNg503jbfdUjNN3WoehCNJJK+42ZohP
         AEU08vwC3yWm8qErZJ/4Zfdp/UZMJqLqy+Qlt3VipMk8TUkHLeC8RIDBhrZMoqwFyrIi
         d0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=elQ8ovHeePfEyvDpZZSAHdlwsc5opTR17fDgZ+MZlI4=;
        b=5QFjlDf5m32UlvOP980c86u+B/MCEudJWaNYXzvYN79pustVQKzLT0oWt7/FGzpvDM
         imZbEdjHMDb/KD3/BMGIIsdeKUkxXtg7Fvtm66IKEMujZaTbJ5hjkAh9DbdrG1ZBlsxl
         REZ+UsRCXuK8JQo5dVxkTw/mZ+/TME72z7r4KTzGbeCCFFcgqzadK9DYQX+N59IC88IX
         WZ/PXjHyPLQw8VbLld0akUhRdy4C3XDLS2urNB3bp14ebQmj8i8jRefT1KFQD9kA1/Kx
         faBIA56rEhn42mhQsWbKBjsOrTwHyUD6O8X64cFQ6moCP5nRlXedK+00Pm76NLjUKeNH
         iAlw==
X-Gm-Message-State: AOAM533dS7En6TntEJYEI2pMgjKci6BBP+IzcVbYkQatUTlHpW6gtPrW
        NjBvmCuwIwsN0Ot5Ue5vabHjyz1w9rYiwN1ANBk=
X-Google-Smtp-Source: ABdhPJyHsNO3LLF4JSv9dzL2OwtWrQM4gX3+OvNGp4DwEofP0/d+TQwE9+eZrUwBynCMmSXZc6ih41yUX6EI5DPoJpg=
X-Received: by 2002:a2e:58f:0:b0:255:4e2f:a7c9 with SMTP id
 137-20020a2e058f000000b002554e2fa7c9mr4351334ljf.127.1653923315486; Mon, 30
 May 2022 08:08:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:561a:0:0:0:0:0 with HTTP; Mon, 30 May 2022 08:08:34
 -0700 (PDT)
Reply-To: sgtkayla2001@gmail.com
From:   Kayla manthey <sonouke.victor@gmail.com>
Date:   Mon, 30 May 2022 15:08:34 +0000
Message-ID: <CAA+ANJ+Sej9gErPw0qduhg64mYCLVvDVTMuyEybNXLN48mN8Uw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hallo mijn liefste, ik wil graag weten of je mijn vorige bericht hebt
ontvangen, bedankt.
