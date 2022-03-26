Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9764E80AE
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 12:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiCZL5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 07:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiCZL5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 07:57:04 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4812779
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 04:55:27 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id l128so10921216vsc.7
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 04:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uc-cl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WkL+4HqaqGPobhai7qUB51B8QkT2s6IVHuPU1bTF3is=;
        b=ETCFzuEDSO3QgSDZSHxWFEQa72MuiNVdJ0nkEnjZ3B7bB0WLdIz5xQKTyt6Eot/A6R
         X+CkJFcctDll5wTp2YwyQzU+b5ByrgLzKWWuutV1OYUPY1PeDIWF/UhjOyMTh03jgWlT
         MauvUhqzHRpEoGkBbXtFQkU6RzAaCDeWvwUc/JflOetzAA+25CFzwveVbdReu107jvFB
         U6CLhzUlqPQp+gChWECUCjQUu/R2UE0yqJA04zZZhyRb8BVaUD+Bh9fHTssBMzs7nJiM
         SnDa+yNrvl3QfyqmkhwLHe/sD/tEx7bHcHEAbJWWpCadq/jOvtUjRmDu8AaL7m0TO4hc
         EJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=WkL+4HqaqGPobhai7qUB51B8QkT2s6IVHuPU1bTF3is=;
        b=gC7iQSQyJxrVeHXxIHps4Vud/WN3occa/Ek9epcquo6m1u1+4cUKnxeG6QLdJoQcVh
         TVP+dOXvDfk7x2EE/BEN53XKwuUPpXPZnCSc4JRj1EMP5ja2mPu1Cb5mZEz885Hh6+C8
         ZVwMxVIdd8WQZOD8jXeKS6Xtw+ApC2sxSC0Pu4g3sa2eY8cve9vRygPy5QjE+K7tGIuk
         W75g2UPWerybYOfcmv5g/nJGLj4zYOcjSKA2rPTLWpT0RfK6sXIj5+ROsozDvtQW3sjE
         j81taradMiAw7+3u3jiltNl3xTCbC1dOk2fEgJnjTu0nzr5f76CRbIhts30Hxr54Ib7j
         8EKQ==
X-Gm-Message-State: AOAM532+8FjnWWNYPsboFov2tjNs1fAPYi8HkDxHy1vat1pGRNF2LPUt
        c3zBPpLQPtZx6mXYMEdK1XKgGT6CxF6ayldJfR9vLwp4LGfEOu0exO2MfHCdHV5lRaHqJyf9j/Q
        T4fUf0cK1H9Gy5hewGLBylYjf
X-Google-Smtp-Source: ABdhPJyTuNRQE9q9VEnpNhB08CdqsHSaYOrp9/8Vf94bfd16vvK9khXK37h5QwaxumVycb4RhEKcFTeSyFT8I5u7kDo=
X-Received: by 2002:a05:6102:2922:b0:325:7818:866b with SMTP id
 cz34-20020a056102292200b003257818866bmr2638732vsb.30.1648295726269; Sat, 26
 Mar 2022 04:55:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:b809:0:b0:2a0:100b:1dbe with HTTP; Sat, 26 Mar 2022
 04:55:25 -0700 (PDT)
Reply-To: chrtyfndtlisa@gmail.com
From:   Lisa Robinson <rrondane@uc.cl>
Date:   Sat, 26 Mar 2022 04:55:25 -0700
Message-ID: <CACK-=173=a_BrU_EePnDRsm+Bgjw-Fz3K0SXPACaB5NQqmd0MQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,HK_RANDOM_REPLYTO,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_US_DOLLARS_3,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e36 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 HK_RANDOM_REPLYTO Reply-To username looks random
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 T_US_DOLLARS_3 BODY: Mentions millions of $ ($NN,NNN,NNN.NN)
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hello, I am Lisa Robinson, you have a donation of $1,200,000.00 USD. I
won a fortune in the Power-ball lottery and i am donating part of it
to ten lucky people and Ten Charity organization. Your email came out
victorious so contact me urgently for claims: chrtyfndtlisa@gmail.com

--=20
No sienta la obligaci=C3=B3n de contestar este mail fuera de horario labora=
l.
Direcci=C3=B3n de Personas UC

