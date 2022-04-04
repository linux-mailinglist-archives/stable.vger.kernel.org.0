Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4454F1277
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 11:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiDDKAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355583AbiDDKAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:00:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCB53C72B
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 02:57:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u9so5264578edd.11
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=51RIadb6uMG8qQNL2W77cS297AVcIqUghNiTlwSKJng=;
        b=N1aAqukkvmsYDIL2zPIzuwpeAq+TuKJuB/VlumdyVyp6dZZKFfM3ZztovuBXgIgoaL
         ojsufx+eNtu5hVHhS9E7hzRBNfNJRDR+wyoBdcVZac8WmzkGHgWcropN+UgRAnSyBGu8
         eO6xxopmVPFPaULAU1Bub0STdkmJbMAMoHhJJtCbbIKPE3Nt3AzsqHNHmrV+yjmynGgw
         VbAOy8lPZs9JIFhsHO0LBdqldN1DyW5ADGvN631n5f9ylJZuKbr2rRGjPkz5eaEn7qOU
         s6n/wfP2wkMq5GFpKr3c5bAF05xs+CUpPdHDSwDde5lbVe1ubSCN6aNdhM/tynwpScRq
         DHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=51RIadb6uMG8qQNL2W77cS297AVcIqUghNiTlwSKJng=;
        b=bgPQSLt6OzX3Ri9eJ0hP96QlL3xmUH+cMl4l1McFK2awbqr55X1ae6FhA4iMOtF9O7
         7RKh3OhOAGwH6PBYPMbGx6pGEv3JctSNkNgjY+TP5pDyeEKlYWueEiTcm8IedIAgKtdP
         3I8OSYgHtWD0Iz56c92aUWdUmm/UPAF+gq90FJNXQImeEwiRDkDfSdUXfEYlqiH5NE3X
         sG0oVFET7jCalGS3Q0wm0zwhYqEGjATiuo210w0zqhczzgvljwfgDkuOzBFh2hVACTMJ
         sLvECQgCtQgVYbk8Q4H5Bs4gyeccK187fJtjcbaPjiDT+A+9BsLxOYxiIWai2D3lIwRr
         GSYw==
X-Gm-Message-State: AOAM530yjhPV3Lxdsllv7MfMzrCMUOQWR7A0YjRloxNCPiWGCr9+VdL7
        uzsf2nA+voy4N5UiASIxVPKNqJ8spk85OuVnAos=
X-Google-Smtp-Source: ABdhPJyNPiZSSXY8DKqP/fNk9+iBbmWVBRdd8YpC9vdg2nwXh7zpa7Ldb+uiI6NIl8hOODXu630hw7OAZzmPwTYia3Y=
X-Received: by 2002:a05:6402:40c4:b0:419:135b:83ac with SMTP id
 z4-20020a05640240c400b00419135b83acmr32403678edb.321.1649066276494; Mon, 04
 Apr 2022 02:57:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:178e:0:0:0:0 with HTTP; Mon, 4 Apr 2022 02:57:55
 -0700 (PDT)
Reply-To: nelsonbile450@gmail.com
From:   Nelson Bile <cstrokim9@gmail.com>
Date:   Mon, 4 Apr 2022 11:57:55 +0200
Message-ID: <CAJc=xiMRj+rwUzOis1K2PRpTka9J_tv6jF+2fDbj4nzaZ+TZPw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5017]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:529 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [nelsonbile450[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cstrokim9[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cstrokim9[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo, ich habe dir vor ein paar Tagen eine E-Mail geschickt. Hast du
meine Nachricht erhalten? bitte um dringende antwort
