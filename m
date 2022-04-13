Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8BA4FEFA1
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 08:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiDMGQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 02:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiDMGQQ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 13 Apr 2022 02:16:16 -0400
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBBE52B14
        for <Stable@vger.kernel.org>; Tue, 12 Apr 2022 23:13:56 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-2eba37104a2so11787387b3.0
        for <Stable@vger.kernel.org>; Tue, 12 Apr 2022 23:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=Hn5TQrYVe68oVahWLM8K8lxFOLWOctQXXZOGL11jab6RZ0AV0E/+Lt3dgFhg6UZAny
         RZ8QRMfIwgg4tr7qUCT9YdWe6ca4D/3x/+xcURavVebnRSQL6UZaK7ep4zMtgO3kfkK0
         qpKVscWpPhS39MCuPi9fqlN/mFIf/SFsqQiDagOXxGwK5SFLLmW74Ifga662ipAqN2kF
         RnYt7z8givI0TyNrJDwhOS74ZSjXoMASd+QM/IXqyXg7Mj/eihAkmJj8osnUx+MCaGea
         cDoaviVcLQQJJ8CNWbR32/MLk+Di4cUzGovBidmpkEEfQl/PxrxQGIrHXMHcTw5vR5bX
         AH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=e5RsVlu4EjvxnN39b2ga9HYI5eE0znW0QreMoAgj1Om+QmfZdbyHGoyAZr+uZ0ijCo
         FgDxjg28j7LiP5+xGzi+RZd2lJW6xNwRX/6+vzeaYbE29IV6gNbJE2IhHTSUDcQg+Aua
         lk/p59sQIpjOtRyoAeAVIqgm1ZnkQHO20c/NW7Z+TVBlRS0nVctS0Ic1Y0S/bI8g9AMn
         ivAGybnvQXyS+QI7T4GYXCHBoIk4xNSscP+Q/ZWdlTUYe8JWCzmOoJLudNrTn/9hGRIn
         NNKjkAwJWO2iXyhfslSRDx+KW8azxKU7QUGrL2DBMXXTJ0qXm2CcGVWjfW0SQ/f0hUJT
         DxCw==
X-Gm-Message-State: AOAM533j4nxaENuFnZPE9sp33mNgcoMAqd4XXNHjfzqf9CNV15karrew
        jltStbCabCatNcE3N7e8TnAIUwMhC7vnvY1FK0Y=
X-Google-Smtp-Source: ABdhPJwsERG8OCiWc9j7N9Ygsev+Dua1LBzcak2D6/j3N73XyULsRauKRUkqaynWJgh+kiFcvcexNdYNRGJMJurMsXo=
X-Received: by 2002:a81:25d2:0:b0:2ec:459d:ca2b with SMTP id
 l201-20020a8125d2000000b002ec459dca2bmr8932296ywl.489.1649830434979; Tue, 12
 Apr 2022 23:13:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:309:b0:236:45c1:4d6a with HTTP; Tue, 12 Apr 2022
 23:13:54 -0700 (PDT)
Reply-To: danielseyba@yahoo.com
From:   Seyba Daniel <bellomouse33@gmail.com>
Date:   Wed, 13 Apr 2022 08:13:54 +0200
Message-ID: <CAC0qSW5-VgbzFNYuXC2=qLOT-M3iZ0CCRx2W-AfMRDjatc=Xvw@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1144 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bellomouse33[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bellomouse33[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
