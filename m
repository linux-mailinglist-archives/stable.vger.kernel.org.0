Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F0F52339A
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243006AbiEKNCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 09:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242976AbiEKNCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 09:02:50 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1622310AA
        for <stable@vger.kernel.org>; Wed, 11 May 2022 06:02:45 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y32so3443898lfa.6
        for <stable@vger.kernel.org>; Wed, 11 May 2022 06:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=95MuJt8/5xkfU9O/tURNa9ZrWheUB9lAAuDXN9qGKtY=;
        b=QT7rwi+wKWvjRvhdXbfbV1peEgBYom3IFvEK/Pxp3KEZnBxpYoxCKJ9hXIpPgW7yhh
         6WmmfJQ9eL16ES0yVXNZVMxy1HhjVC6Yt32ixndjHWm8ydrsoMYg0w3NvzIjLfZEOHl2
         wk42DrxyziWjA3NIU/7rEij169TK5TQUBekKTGrl0XYszrApthy7LzQT21LCyR/uShRF
         nBZ8o5ua9V8pD/cK3dbiXFDH9oVaLFPGj8vzDxyyqGxmizHrrvsmow9aHtSORsJpJMOW
         YmJuMvRBaKFJx4n2Zd+yq6cWwlG9eVWT2FN8zsnUMRVMFfmkY1TYkz2KWHaXEg3YcKK9
         PPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=95MuJt8/5xkfU9O/tURNa9ZrWheUB9lAAuDXN9qGKtY=;
        b=OX3sfHYtS01PQbDGt+UkcqGm99vembfi9gSQHr+gTBSK5gGMo1MNKF6w+rlmTB5K+l
         m7JFXrBNp+sCp9cmfS91R3PemFOezdytU2jgRWZp5vXisbWpls4fpPPw52vHeJVj5eA1
         Vani2C71h2CID97igky7KqmqlSTtIfRJK0wnZKq7yCHwMDGYSA/gAWSv106cuK1gIZ4k
         FXH7+vTBwfiOMmEdTK6SDqrQdRA8c6zincwK9Sj68pM9Cl+DvMGi0DQPIG2WfkKtbSyi
         SL73xGlhY9dq/cGynx89+GBWgd4h6E68GlJf7nzUr2feTSgIxzNd4vB4Vh6zgCq3CpSz
         Tgzw==
X-Gm-Message-State: AOAM5307Tjf1XAEd1yYC14TTINekDjSwiDQWZ1EhzDXKCR7DOWo6vCdG
        XuM3NRvaqNjb6/cLX/PwJdSI7TD2zKQ4Obev3fc=
X-Google-Smtp-Source: ABdhPJw1WfyIvPQXJF1Sqxy4dB/mobdLl6U5GIRL3fAlvhfT2DpYPIMze/UhmBLIvpH/zwnDnBbNunkH7WkBNP27SrU=
X-Received: by 2002:a05:6512:2241:b0:471:d2b9:1f00 with SMTP id
 i1-20020a056512224100b00471d2b91f00mr20638593lfu.342.1652274163515; Wed, 11
 May 2022 06:02:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:9814:0:0:0:0:0 with HTTP; Wed, 11 May 2022 06:02:42
 -0700 (PDT)
Reply-To: nikkifenton79@gmail.com
From:   Nikki Fenton <cldominique77@gmail.com>
Date:   Wed, 11 May 2022 15:02:42 +0200
Message-ID: <CADuPsQ9YQaUK89akt7qMX_VXm8uJbrHsBvNQ0oNYr6K60CArzA@mail.gmail.com>
Subject: Please Read
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [nikkifenton79[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cldominique77[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cldominique77[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good Day!

Your swift responds will be greatly appreciated. I viewed your profile
on Linkedin regarding a proposal that has something in common with
you, reply for more details on my private
email: nikkifenton79@gmail.com

Nikki Fenton
nikkifenton79@gmail.com
