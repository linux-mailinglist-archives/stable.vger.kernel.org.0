Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C542B5046EB
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiDQHSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 03:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiDQHSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 03:18:23 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C7745530
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 00:15:48 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id m14so10278475vsp.11
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 00:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=q15MJ9flU9HefmxhxkmdCROKR3AIWCJnQATZxfhMaA3j5H8EHZncpiCfir+jyPhXmW
         L3GOFE8xEjzCnPlD0QZN4T5gdiVts/y52gg3y6vfwdFgqbVLnqIcw77+PHUexsLynfQL
         H44g+kHyYzl08FOQlSyokuvMD+d534RHG84L5+aau2HwchmsNaXsErgI7tPv0R7pfi5W
         KDWZ8/sivpVvF3M5IRUpGtoaIK8DE/+WtAIJrP2rcKyeMVMqca4O5j0A3eIT9E6VDDvG
         SJ7J5wreImoUPIVqN3hHv0wxr7ROikEBcsKpe70eLSXSL1/tcU3gq/h5JhceFYrRiNf0
         RxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=wLVe5oxJZZOStIQ9Ru9Yr92LWEd7qpJEXUR3qB7JhNuXe2aBB3I8KGokI0Th9nRO+Q
         ioVtqihztoHJqsIni2T604CYrpjDvp1Wx+m4pzB7g9OnjEqXrG84WYfVMzLCL/ahGK/b
         wDqRerACKL6bm8eR72cXwGuMJl0vrfG4MKAJsApMiYclwC2jZ4RBeUryGsQLLXRFnobl
         Hxjb/W4ltalnSwcFKbd7Odg8sIzILmMNKkgTiSDOPaEgxaVnnHMu9kV8ak/V6qd3f2vW
         CcATzUJ0UYZZbZ3E4olTzJcMyovt4DHypcqRsSl4sa6Qo3TzOyp+9Fk7cJhzRL3yW5w3
         5z/g==
X-Gm-Message-State: AOAM531DUV+XKYdnH6UnNY2CzHlgvbAphCdeD+nOhSfTHbAT8Y1BTWUW
        le5V9O+5JhYttGrMjtLvTZGLXJptMJ+82CpbJQs=
X-Google-Smtp-Source: ABdhPJwz8wotik6Ap+ud+wWwttiQHnmfpZu95ffGPdcQzngNU3wMMwDgIvOppWS4Gr/Qz0qI8EF9zgkboC8ycu1P79A=
X-Received: by 2002:a67:dc82:0:b0:325:58cc:51c7 with SMTP id
 g2-20020a67dc82000000b0032558cc51c7mr1698290vsk.63.1650179747534; Sun, 17 Apr
 2022 00:15:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:76d9:0:0:0:0:0 with HTTP; Sun, 17 Apr 2022 00:15:46
 -0700 (PDT)
Reply-To: daniel.seyba@yahoo.com
From:   Seyba Daniel <hadissawilliams@gmail.com>
Date:   Sun, 17 Apr 2022 09:15:46 +0200
Message-ID: <CAAC2S9=BpRHJwHnFWVAqC-CatenMe3sjUSqSXKtuQYw+=-QTZg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hadissawilliams[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
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
