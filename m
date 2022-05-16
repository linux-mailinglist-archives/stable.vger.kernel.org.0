Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2493D528577
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiEPNfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbiEPNfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 09:35:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604BC25EA
        for <stable@vger.kernel.org>; Mon, 16 May 2022 06:35:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so502010pjb.2
        for <stable@vger.kernel.org>; Mon, 16 May 2022 06:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=FxWAnJzjzm93GuuyhXPzYRKczG/RaJ+fiLEyQm/hGTY=;
        b=E+XekOx+fBpLOd2dIcXSo/K8LokN6sGXHgER/rSG9YZY8pveklnFXxvWfbCQgRkVqI
         JFYhDHTHVTC2efkJzcUEavyKVKzo9MB91516w6NP49oyRzRCLsodCCrWu+jbu2jPQ54T
         l8FxaI9qyjsizx4nT9jYaVlQBBmocbIQ3FONBYSV2BK0is2bKANwYcNgg6DybT/o/J0f
         /KOrT54g4Cv10fvXmkhrON7CDinm0wNsEjsmJI+LMMCvw41KWOeLrKCaQUjBTowIHngC
         6TRtFkQamKJ+ThA/qAdBJ76Oheioy2RVbgL+54EsF5QiIWRziGwDpwLzqubVyefViNse
         7cKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=FxWAnJzjzm93GuuyhXPzYRKczG/RaJ+fiLEyQm/hGTY=;
        b=iIQzGlNZzDIRUc9aoWD8mqmrUgL5iu+14I60ze2etqhxGjB1rbrugEyv/KjPR40WvQ
         xE5cSGMv3+FFIrDVEHqiPDxCw+/jrsfnjMVrfiS0NLOMPnxWmL/PMB8X9nwjCYruFr+d
         xiXzLSTi90DpQAgmCDExrnZZo5d3e7bwQ58Z9nxIx63uuL5Vq7bm8RI5rL+ygIXw4L40
         AfT3mbHtSsuYuQ7LPncQ+iB7bu2jD29tjcIXdEvnWwbgktUxu8YNEiRnAeFr/KjiBddR
         M4Ph1t9R+NarIaaTfJ/0pZS5SefM/S6nDm+s9L7tWixjWuLlUtyNAUJv5dcSRCUfTVAP
         OhLw==
X-Gm-Message-State: AOAM5303nx50zqGZ4A2JEDyTutEUwsdbhfZjZZzi9iAAKn/zjGbyya6p
        5g+brPnaU+x3mhLm5IiOJTRll/0yUcJNhb2DA6o=
X-Google-Smtp-Source: ABdhPJzS4TW+80fvXMRkdfwM2UfRX0wBFlEoJyvD00K/4991OAK7ZrXyDgKL3nYCGrW6a2LSPi4W+/Wc4TvoXg8w6i8=
X-Received: by 2002:a17:903:2042:b0:161:53e9:c7b7 with SMTP id
 q2-20020a170903204200b0016153e9c7b7mr10587206pla.122.1652708144834; Mon, 16
 May 2022 06:35:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:8c1c:0:0:0:0 with HTTP; Mon, 16 May 2022 06:35:44
 -0700 (PDT)
Reply-To: mohamadsala926@gmail.com
From:   Mohamad Sala <porgobiukare@gmail.com>
Date:   Mon, 16 May 2022 14:35:44 +0100
Message-ID: <CAMR6DAOTACzXCAcCbQQ5Hu8Gtqsn+HkXTh06xz-MNtfUrmdHuw@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1043 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [porgobiukare[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mohamadsala926[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
We are the Global financier  Investment  Sarl ,

I am Mr.Mohamad Sala, a native of Burkina Faso . I hereby contact you to know
If you want any financier in Africa base on any investment or gold and
diamond band
Older precious mineral  you want  to export to your destination.

I am the consultant to the direct financier ready to support you or
finance any delivery from Africa to any part of the world based  on
the agreement on the percentage between my company and your Own
company.

NOTE;   you are welcome to contact me in this regard if there is any
need , I am always
Ready to give my best support.

Regards
Direct  Consultant
Mr.Mohamad Sala
