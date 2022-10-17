Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E2600D46
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJQLAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 07:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiJQLAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 07:00:07 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E986261DB6
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 03:58:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d26so23972846ejc.8
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h6TAvh2KhlPwZbZl975on9cPhNtC4Qh0FGtOTBu2EFs=;
        b=l1L4m0Oo+Orh5CsD3yb+RKgIYhMKQr12O9nBiQJBniBP33RX9Khdqcu0lE9FK4kp0D
         YhNEypaoMvWKyH4a/eUKYiVV+9sus+Rv7tTF0xRhlEK1m4em9R3uSUykFFMgYUBkeg+0
         vuIVL65/XWxwOdbkBgErl/jJu58OQrImc0ThdKp4lA85l8fUuWsbG5+JrN7oH6WWHTGD
         Jzx0BYncaqWA0TaKop1h9hwxg9axuuXa5jKX2jpN+DWssZNR6+NKH89+nyIoXzFKO/kW
         rv1ffpAI431dLpV8+jq8jyrGY9g1yTtb6O0DUSWAeKW9fQ3Yj5+idxLCbMVEUD5SOx+W
         RYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6TAvh2KhlPwZbZl975on9cPhNtC4Qh0FGtOTBu2EFs=;
        b=xck8yFmnOQkIVX3j1H6cfE7JAaTRKntTM1fb4Xi+Ygt46NG0g9qBSlzFYvlmKz5ShC
         PE+8Alv81uo8XAbpvqSLvsyiM0quOzLL4N5jyXPGAZmK1qlSakdcS2aRXgZtu5bKnsud
         EMrtLInJZ3KqEeAv9a8fNJNZU61/W++2+uWjMDc+Qm3HG22xQA6tBGO4xP2xpnd6kajo
         DTWeA8sA4bluhWt2qLutNNDdMd8mAVxLyKslVWlDunTdypaFrZ29xchtsMwxmjh8IMQT
         1Kz0WVBW/XPXeu9HwQ6MFcAZ1fA7GeUhkX40FWnLImsF+FhBregSHok799zemkfoyRsY
         NhnA==
X-Gm-Message-State: ACrzQf1fMCJcEkjvWuEqp9rHzZQ9P72xPUem0e/SMF0HOIv8XzcY7z/E
        IR03W2g5r317QJxfqV/9KIviDbXyfiM/HDo3Q2o=
X-Google-Smtp-Source: AMsMyM6S8GNSkms3dLd6OuUfzPaEfkntDQdFkszV0xlUacI4Ep0jV9eYQLGVQ2l/ELhVKMyAdNGZHoiSyvufZYcb8+U=
X-Received: by 2002:a17:906:770d:b0:73c:a08f:593c with SMTP id
 q13-20020a170906770d00b0073ca08f593cmr8514654ejm.182.1666004308445; Mon, 17
 Oct 2022 03:58:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:71a:0:b0:1df:c5cd:1b43 with HTTP; Mon, 17 Oct 2022
 03:58:28 -0700 (PDT)
From:   M Cheickna Toure <metraoretk5@gmail.com>
Date:   Mon, 17 Oct 2022 11:58:28 +0100
Message-ID: <CACw7F=Zx3X=LhF8THzw+5F_JBFyN1AR+B+shPN=MfP5i5hQx_g@mail.gmail.com>
Subject: Hello, Good morning
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
Good morning and how are you?
I have an important and favourable information/proposal which might
interest you to know,
let me hear from you to detail you, it's important
Sincerely,
M.Cheickna
tourecheickna@consultant.com
