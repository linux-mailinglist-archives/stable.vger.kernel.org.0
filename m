Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278B7532251
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 06:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiEXExz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 00:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiEXExw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 00:53:52 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072C8CCC5
        for <stable@vger.kernel.org>; Mon, 23 May 2022 21:53:50 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id e144so7986349vke.9
        for <stable@vger.kernel.org>; Mon, 23 May 2022 21:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=pbCVlee58SNRljTVR7wTvz7D3A0MvcLCtUjVncuzsEg=;
        b=ZucOiA704/kiegQUwY21uyWXptQEVV8Kg6q+mVKq7jP1fTHU1PnecuUEcWtJocY0kO
         R2cGaZOyjvj8GTAHkBQjlfSI0Uzr+nRFc10ZmxxiBU+yBNWmBmJFLKybTKMnkd8b6k5v
         j/ATrc9SgSFqsMxK+Q5ZZZv8Ll+jfkElpaXlIzvqIMsD/fYp7L93B1ZPjqdD5XVibknm
         BypvOKZ4ce8/pM6QjCWLMSaEnNjVg2BzIWVtil51Cm8kF0D7AcN7TKIi30SxjTJf1HGo
         p17epA8CgedEUWpAuGKqzQDr8ATqF6bLvUbsWoOxJnatHt1Y20mQh967YnI0nkYhIPCm
         oJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=pbCVlee58SNRljTVR7wTvz7D3A0MvcLCtUjVncuzsEg=;
        b=yYiFEZvnCxzN+Nn2g2kzGa+3B0EPtObwo3mXCTgiWVIq/YZAVb9VbHAtYQGsVpkM0d
         9fwxgR5Hsjx3GazTdxaeYG7E/8XLnpYGwmoLYfiXcCt0DJrJSoK72a1fECwxBQrID4lC
         Kc5fOUlrqpMYsYM/XvDZcazdbAqTMvz3H/4s/p8cXu2PhA1YR9jGucaUtVnZXtkInOUa
         UNLOPxF7fER0Llhg6Zpo+ZbhuXa5N5RKOk99poz4pTUm8TKIGMQE8bLijc+DFa+wryDi
         19OI2YTZDaGuD5rOSBYBUT8wO9jOGOB7Zl38Jgp64TZ2nC0VwDHogXttcLe4Fokivxfe
         KLBg==
X-Gm-Message-State: AOAM533+Zio2sYgxpeifZL9nvoeTOJbCt4rNAfLPeQLXcXIw7iH0emZ0
        Az1x0IhC3sHtWX7pwVQVI88cIGF1GfZkcwbntDA=
X-Google-Smtp-Source: ABdhPJyUVWDM1wQnX64fy0Nw77os7iYcl6ap2HITqrVxn5+YVOtUWoQuj3lF1Tp8LvYgLNzH213qIvaNAQwG7+8iFcY=
X-Received: by 2002:a1f:9c08:0:b0:357:ab57:fd67 with SMTP id
 f8-20020a1f9c08000000b00357ab57fd67mr2487466vke.10.1653368029371; Mon, 23 May
 2022 21:53:49 -0700 (PDT)
MIME-Version: 1.0
Sender: bcharle3w@gmail.com
Received: by 2002:a59:9b12:0:b0:2ac:5553:4416 with HTTP; Mon, 23 May 2022
 21:53:48 -0700 (PDT)
From:   Charles Anthony <banthonylawfirm01@gmail.com>
Date:   Tue, 24 May 2022 04:53:48 +0000
X-Google-Sender-Auth: eNcMruBYTs2PVLx0kB2tVQ3kDiU
Message-ID: <CAKram-2XmqNXhX9c4XgsgEW0jBwAwn4cjoHvKeviggMrmoYdbw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello

My Dear, I am Barrister Charles Anthony, I am contacting you to assist
retrieve his huge deposit Mr. Alexander left in the bank $10.5
million, before its get confiscated by the bank. please get back to me
for more details.

Barrister. Charles Anthony
