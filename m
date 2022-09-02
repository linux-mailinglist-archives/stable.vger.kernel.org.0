Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A893F5AB8D8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiIBTYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 15:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiIBTYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 15:24:20 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3281FCA16
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 12:24:18 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id w19so3205230ljj.7
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 12:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=eMVCF1fPAuqmYegJoCJUJU7da8MHPWujB10GZ78eaYE=;
        b=fNR+Mf5eQDIx615BOisYbxd+oM+RngWssXUcTip7lixU/8LGfAPKOa4RZ5hNJCjRJi
         Red3e36gVM9wbI8vY1DUKz78m1cJstDr81Tsyb2bPZ84RNeryaNOiXMdlEmhK948GQ0E
         fff9xIOboPIWQ1+eY8mOjk4j4GJKTaZ2yaNAhvPXXVqS1pwiTQHWFNlZpKy52hZTWfFy
         9cW6RkALP1f5l/EP4bcJHOYFa5y3uchkPLclzbZfq7M+lrM5gobeG5S0fgwN/7UCuBWG
         Rp3mYI231nwM81mclByMG9VEKVN0YMBwWG2xHXuwsMmhoROuwqWfnUQCZ6Mgg5xX3ot9
         YDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eMVCF1fPAuqmYegJoCJUJU7da8MHPWujB10GZ78eaYE=;
        b=JgXZibyTTW1FyVJwyLU8jvhofwSn9ofqOxFuhCEweFcT4KBtaXIENKUWjGOR3kvU1t
         SUDzq8kFxJpISnu+i4NMuYwiJ2M4YQ7t9DrMFqWsOK3Vp3oCX0M1RIax6Xn24EhmzMea
         8wtQaCkidPptYUqJrC/Ajj1wDFm4x/B7WQAhrJgT3eifk3feH7Vdnq3vZjk/9Yq9Eo2F
         FBa5jAMPmI1FNxzvLCitAj1CbC4nMRbG0ZzE+0lI5CU0Imya1iG8ODNuEsm3jR4RamDW
         Qlfwfi8kAEa5sORRfJiTz8AA/EF9ULVeyACHFKYc+jCTdj2oX6TiETi24rbdL0IIXv96
         Z3AQ==
X-Gm-Message-State: ACgBeo2QSfXnJwjfxpY4ZKMG4td8BvkYFY6KpD3NqOkjILP86hFiYtgJ
        RXkoaPEXc9Bs2G3T8+0adZmutdyEULJDdvHe/4I=
X-Google-Smtp-Source: AA6agR5uhYIpngtibXKhYjbPPBqIGBuka4esQpKB3YbEzqBF31mh/lzrqwNU8IimlIqNGobiKf4eGSHHmtGpL+coMYM=
X-Received: by 2002:a05:651c:b26:b0:267:18e2:2024 with SMTP id
 b38-20020a05651c0b2600b0026718e22024mr6096808ljr.409.1662146657295; Fri, 02
 Sep 2022 12:24:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:5d4:b0:20f:1586:b51 with HTTP; Fri, 2 Sep 2022
 12:24:15 -0700 (PDT)
Reply-To: officeeemaf@gmail.com
From:   "Chester R. Ellis" <offficcemua@gmail.com>
Date:   Fri, 2 Sep 2022 20:24:15 +0100
Message-ID: <CALY5DG9jtLAeiHeTcWA6AU9VYzAtQZLQjtEzM2dKNZ0=T+c2kQ@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings

I have sent you emails, but still have not receive a response. Kindly
get back to me for a mutual benefit transaction.

Thank you.
Chester R. Ellis
