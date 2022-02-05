Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2999B4AACB2
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 22:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiBEV2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 16:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiBEV2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 16:28:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959F6C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:28:11 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o30-20020a05600c511e00b0034f4c3186f4so11817982wms.3
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 13:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=4D2XO13bmKH6KEZ3rCIFVRJ29Rca69+/OJs6jQDOjGo=;
        b=UgcP4TP3uGh6qytD7iT3awSx5sRZ46xareCobWM0iOHXgqqTho1m4vFCJu6OftpGgH
         AuUBrdmteimuVeYksK+0MCMKO7nXDczjRlbo6NGnXtzjGIv2MfKgvPme2E84/f+AudQP
         ENdZPxL/AFEr87fCibVXs7ZuxTEC1FX/O84atcpJKSL8UWwqrx83RyNAPJyRobAgTlxe
         zPYcTR0L7YGZR9KIaP7dFrJylLnAym4YBKDWowe6j6oBhqpbvcu5piw13/qs8tMMYbTh
         o7dhWyXEvWH4Qj+4D/A4mz6GfhPz0DMkCbKx7eTgogjxKL59lZP0+gPQYMPafAr8QfCU
         nJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=4D2XO13bmKH6KEZ3rCIFVRJ29Rca69+/OJs6jQDOjGo=;
        b=H08Jr/gCt81OPPOA6U0WYtxtCG30zvdSvssOmS/BZl0cKl7ktz1q3xwtcgzOAyhUGp
         AIkKmooB+MyDgKvNcbCt84U3xe+4WrCVZ0p/VWd0L3t/hS2Q5mxsyN4XoUspXKdfSSoC
         lmkGOqC4jN/UY5EkpD9c6WFC4k6cgiougvf/Hbs/COiARMax/f1Ze9x+kOQPM0X1PqOc
         Bu9mYqBxmrP41S+2EQZReZeRmbSd7z7sn5O10Se0lqllwvCPmB9GsaW5TGJEt/UUV0PT
         HB41XfgEe28gppEl6VsrTwC0120/mjwiorPO9LAcYOe6/g5sWa2eoV/Mee0gAduwNkmt
         DnjQ==
X-Gm-Message-State: AOAM530LhlErhZEfWFhqDAQskdZhcBZUynDFweEwl4r2CNaYacvX6SAx
        mjh0z9kg7tk6AAoXAkDNQO93QH79Iyqsg2ko/TY=
X-Google-Smtp-Source: ABdhPJxqbEWnt/mFtparkXS5vZw6lD1Eeax9bJ03FodbXqofHDYvHRP+KIH8m00W5LMSutPjLgkGpqaz4dW9DiKNLHk=
X-Received: by 2002:a05:600c:4f53:: with SMTP id m19mr8090452wmq.150.1644096489704;
 Sat, 05 Feb 2022 13:28:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:4ec8:0:0:0:0:0 with HTTP; Sat, 5 Feb 2022 13:28:09 -0800 (PST)
Reply-To: mmd475644@gmail.com
From:   "Dr. Irene Lam" <confianzayrentabilidad@gmail.com>
Date:   Sat, 5 Feb 2022 13:28:09 -0800
Message-ID: <CANrrfX4MFeTYWXGtP_8rStVS0-vqqxUjgB3gjvVihJ2aMZMfig@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_20,DKIM_SIGNED,
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
I'm Dr. Irene Lam, how are you doing ope you are in good health, the
Board director
try to reach you on phone several times Meanwhile, your number was not
connecting. before he ask me to send you an email to hear from you if
you are fine. hoping to hear from you soonest.

Sincerely
Dr. Irene Lam
