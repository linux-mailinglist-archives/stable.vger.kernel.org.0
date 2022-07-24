Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2013757F533
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGXNZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 09:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGXNZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 09:25:13 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BD4E57
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 06:25:13 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id u11so3488850ual.6
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=LIYkXsh8NuZ+kWZJQV6Z3UgDflGRM7baotKUMbx/XVo=;
        b=VXGHwBNU4Cf3NHlXgzlMvskW38MJVoFZHDYOSHC4sz8kKvXYXyHoZqXx1x7JyRDVya
         skdVqqY5VjKJtATO4C9Wdoznm2NwHbmUUDw3+5spyVwuUnCB7YXz72CVdxGaS700gRj1
         8b4cjDHCPHutVqzv1rfo+L0sx0xzBAApcsj2gCT9uJQR/1F9XLiCVAGiUkGkE7vUa3W3
         rVfWbXPx/eg0Yp82MGj/a3k28NtDit1hE8jQ4q7xrAP1XiEdCxVLgiNwjbCf5n0fKVgj
         YLkU86WvMSos4ZB4lcx1YBoLee1iENMuHB+9GMOmhhdnwYeurn+mywgVVOP/qxq0rctp
         d09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=LIYkXsh8NuZ+kWZJQV6Z3UgDflGRM7baotKUMbx/XVo=;
        b=q8IUWMmQZ65TO+cWydyyvAb6oS7jisOP6tDMxczZaGGY+uD3Vu1amtEM8Y6IrIGm30
         5/4GjfLmxKkhVeRmY0JvmcNn+GKomQJUURvoS53HLeAHtmfJUTy7sBOjEJU/R03fjfLA
         q7vN6vLm8jo2QBosFQuVSeOCzTYx9ux44tvsPq0hvRVoC2SLsD27SbjAlrN9XSwxkCKA
         7M4XyHZpsvou/7H9+7mzomI85Fzlpr6qklnCOrkbEbFptwUWHhiCe8NwJH1I4iKMo5H8
         i3wiEnxB6hy32TzdngIZLdbC7LDf+c2HH5wfgvt+PslGFcazV+1ttF+heX5jv82HQ/CF
         siCg==
X-Gm-Message-State: AJIora9Wiy8pFaGlh8ecl7kyXny71pC65QRjc3ZfLZPNFsvncoO+MTdr
        RESTw9W64NHQiiSYiET2Glek39VZpoc3V1yzmIk=
X-Google-Smtp-Source: AGRyM1ttFD5DPwVODm6bcgkjUSpkFQvCoeWIPfi7NDczyAdOfBFqHw+cc6c81YORXsBtBNl89csDj14zKEQeoyYN3Wg=
X-Received: by 2002:ab0:69cf:0:b0:384:b1a:521a with SMTP id
 u15-20020ab069cf000000b003840b1a521amr2189968uaq.30.1658669111536; Sun, 24
 Jul 2022 06:25:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d088:0:b0:2d6:1571:aac5 with HTTP; Sun, 24 Jul 2022
 06:25:11 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Mr. KAbore Aouessian" <kiboraouessian@gmail.com>
Date:   Sun, 24 Jul 2022 06:25:11 -0700
Message-ID: <CALGXYcSq22vLTtHRdbQw02YgCRaSPUm51vF7k2_NGgx+WPOpvA@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
I'm Mr. KAbore Aouessian, how are you doing hope you are in good
health, the Board irector try to reach you on phone several times
Meanwhile, your number was not connecting. before he ask me to send
you an email to hear from you if you are fine. hope to hear you are in
good Health.

Thanks,
Mr. KAbore Aouessian.
