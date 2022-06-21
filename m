Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD4552FCD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiFUKf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFUKf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:35:26 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968AB13DD1
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:35:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id n144so19660880ybf.12
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=9JyN4vcdBHeSOip4uJWIp/6fUP6jK/W1bnUguqxYVyo=;
        b=Xo0bUA2OdtfXqqOhy9IaTrgv3JdUWInIjgWtfWoqKlDiAg+JhHKr5udNio0TLY54UP
         pCMSXWckLTZunk7DS57uCV9vu6cV0PFxIIr1VESBkhteD8Qeku7ESNYhU0p9OhvhXgzH
         feifKb31qzWs71xSsy38A62tvgQtrZ8qmWwj2FNqpswrVNR6EkqnQdU2uHyOUw+hDKJD
         SKnWARgsVk0hH+eTk632JDG9/0p+dB1lP8QyQDE4prU7gUCHJv6btV3xV71wagtAzZQ2
         3IPbkICxNQ5WMrLXPJpR83feMzq3sr39E2/M39rHpEPpr6hD4dhW0RpT8frkUiS8EG6l
         1z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=9JyN4vcdBHeSOip4uJWIp/6fUP6jK/W1bnUguqxYVyo=;
        b=jYT/m7x20om2JtIggpO72E39HyRajcn1rKGFw3abnd0sCQIwsCigvSYpzh23F3AxJf
         ybgP7YHTvGerWz7Xfc1xMEsZB5poqZLemisQrw2ZkR/BpMOXLl8hkZqLlxKlCkfCGMsN
         vnbjwHjHGhlEC6TcUXFJb6B4BMhU4n3FK2B6KwmRUbbm+0aeojy19Zr/HaSounZbc1Qi
         DMzWwSUxQrC7ltUEvtWQCZkSM19G3f1UiQxWiRm23FG0A4yNwCqCQ+UwW90/1dG4j2Dz
         lN3f+JH20hs/14dLzmKn8BPEJWZ88P2AxosA3cQo8QdxRIpKVooGKAKLYOwK0PV2WApr
         smug==
X-Gm-Message-State: AJIora/UQQ/tQBqi3ufu6zvkNJXJtogR7O2vXEo+B/Gk9ntGVW74zDDd
        36fYtgWpAKvHzC06jZeO7Bjk0AHZdyrozq/eRsw=
X-Google-Smtp-Source: AGRyM1utWf4xqk4kMfn1nx/z5dKkZdx9jEUeIL02rgCOfwIuy/veSmqfetteclW//PGzmFCcBY44ohB1C3a1UJWbIcU=
X-Received: by 2002:a25:ba84:0:b0:669:7107:bd07 with SMTP id
 s4-20020a25ba84000000b006697107bd07mr576768ybg.77.1655807723841; Tue, 21 Jun
 2022 03:35:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: oliverbaruch6@gmail.com
Sender: oliveredde2@gmail.com
Received: by 2002:a05:7000:b685:0:0:0:0 with HTTP; Tue, 21 Jun 2022 03:35:23
 -0700 (PDT)
From:   Mr Oliver <oliverbaruch6@gmail.com>
Date:   Tue, 21 Jun 2022 11:35:23 +0100
X-Google-Sender-Auth: amkTga3leG3RCbLBMNyojci3BJY
Message-ID: <CALGDVD3K2Mn3NxXG2xsw4CHmCzfmx0KnHSYkLHeB7TjWZkAH7A@mail.gmail.com>
Subject: Business Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Premier Oil Plc,
23 Lower Belgrave Street SW1W 0NR.London.
Attention: Account/Finance manager

Hello, My name is  Mr Oliver Baruch,  Account/Finance manager in
(Premier Oil PLC).
I have a business proposal that will be beneficial to you and me.
please contact me for more details of the business to you. thanks.

Forward your response to this email:  email: oliverbaruch6@gmail.com
