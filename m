Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FFA5963DE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiHPUnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 16:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiHPUnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 16:43:01 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF7680359
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:43:00 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id j3so11737007ljo.0
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=LG38cMRxIh/kI3pGAdkBBa3W3lBHK+zUvqIhmUjbSLOf38y2AdbEoZkiizIpvzY2Kc
         4LT8SwJk1Mc0ni3gqSz49i6PTW87r8hJUL20zmRBDNb4qsxHkTC5a6WK0h6jVQQAJQKz
         2mNydGTon2itIN1pCfYBRRXSbNyfBqbnVQM/lGiIpF3HU5/adEj6kQfws5qgzz2EuC/l
         LNchr5F8cjq+dcUUWis4b658rZtyAlAU/036gPyErhhMpFEpCN9Apu1U9Cvt5TWLhDAK
         BKfKtp/a0chI2AZ22TzKlvpLiGq0pFrDW/4JHPydkDINMKHCqrXlTCR0cbu/jK9R5qW3
         IuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=S+V1yA1ay2KcsXAyg0PLJDT6K7Kom562xStMcL8x6QvEJpx+iUqEmfQmBya0EoBikl
         uC5zvUk5bP0WbUPkPCmAhYtDKhH+fHQyesb4FrLvHs1oyzLnng2X2ZSpL1uu/6O1Bu2X
         DlCtLmP4tJIdKX5iXHfheFIetXpAaFtQbNQIgowFTgsKIcnIHYcBt9hMGAHVy4s0UCEj
         A3DE4orTGunFBXnb1Ks/mVB3TvRmdp79BfEd+an1BRndVGuuA3PtKI9XQWO1IfEb/me0
         UxwPCN49M3WBBtpdUnvOL9BUqJlKIdiVFa0KOmKWKFDqgzQt9Qb1JsW2VdpawbqTddDU
         PkAw==
X-Gm-Message-State: ACgBeo2tfoLXF7KHp0Kk3EhgRkGXBTPMx1DuUvU35iDRiGnE9qOgqaHx
        Yo3fa+7/6kKThiAb8cAaFmpiW2U3/8VBslXyx0Y=
X-Google-Smtp-Source: AA6agR6cTBoZvebRRuzKPOKKPTvC7yOIwNe9i8vM+L/wYobpG0BVZVYSPt0pXSPDDySMiZTtjIJQV9nq/ZFUjZNVPDM=
X-Received: by 2002:a2e:8606:0:b0:25e:51c1:4cfe with SMTP id
 a6-20020a2e8606000000b0025e51c14cfemr7295935lji.33.1660682578855; Tue, 16 Aug
 2022 13:42:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:187:b0:1fe:cc8a:4342 with HTTP; Tue, 16 Aug 2022
 13:42:58 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Prof. Chin Guang" <depatchdeliveryimf@gmail.com>
Date:   Tue, 16 Aug 2022 13:42:58 -0700
Message-ID: <CAAeqwM-sVw+CUS1-T8Uf_e_3nxw_qYxov1+WQjELkd3Tt5P1WQ@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Prof. Chin Guang
