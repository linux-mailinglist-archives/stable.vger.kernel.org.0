Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EACF4E58A4
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 19:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343963AbiCWSp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 14:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiCWSp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 14:45:28 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EAA89339
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:43:57 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o10so4702941ejd.1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=OvP7zaDxaVy7EPm1ZBUWshU8UonWjcbwHIy545PbRr8=;
        b=d0oxINqjnZehsGj3cY0sFUga0CXpTb7p3rZGRvO2Lv+zgnxERgg/n/vex5KYsncEDO
         70H8pr5Y1mD/NqRfPOymWmGSxw3K2FtGX9x1ityP1Et3clmOcZ1uRkjRxoBPcltgwhME
         rNo6V4V0hkkjoO0ZibsJELGewe5k28DTMjMCX25GtrFcTBqO9zU4uy0WY7gmuLpr/eSi
         pTs/EOuXN7tCApkwF0aCULBWH2AhU+av2w8w1zQdq3TiXfE1REGKDzEBfjDc7u9DbswW
         Nm00db7quWUHkvWqFdq/yskp2u+mgOSjDdqmWNQqCbiEPyqKzoNu3LpJ0uAJ1qhG8MwM
         G7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=OvP7zaDxaVy7EPm1ZBUWshU8UonWjcbwHIy545PbRr8=;
        b=kb4ptHbndjC+0nV1AfjWG9sSOmNZO/riKA+yuT+BxYwMBWRRctLljrCvxY5e+C9fSK
         uQXjL2PGyiOn+FjYvE3xBJWk74dxwPByYBlZ/NxeRo50YwSW91TBMyYeSEDpW7X1tnup
         eknfuRbK44Wprw74RKmOnUvLSan5yZtlnWBPbO4FKr5Cq6fWfKTCyUELs6bXdeBhkRCH
         Pq27AsmP1xXWWFKmKOcMalXrkk2+kbCv8LnDzJYIYm/RJVeaF1TIMrKC6jKjQceIyABV
         t1/SWtv9SQ6RnsmYMjXuyJNjEJ6uqLTyTi+WRCpri1boxhkb8EFl1vSp2URdqnVI6f3a
         zASw==
X-Gm-Message-State: AOAM5321yvxXzfqGF3n7DxC6Jyou4f2oJqE4jj2jX4LLqgQGi8/icm/t
        YoZJsbzB6Y69exvg28yh647xxSixi6Xm7TR2tIo=
X-Google-Smtp-Source: ABdhPJwL72Zrtqk56cXNZUkGJqXpdK2DCutAH/SUheufj/quiBXRYYmkIfRUNzkIXdHcK4z01kkuHsE8p9mvzm7Rtrw=
X-Received: by 2002:a17:906:a0ce:b0:6d1:cb30:3b3b with SMTP id
 bh14-20020a170906a0ce00b006d1cb303b3bmr1566020ejb.582.1648061035394; Wed, 23
 Mar 2022 11:43:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3503:0:0:0:0:0 with HTTP; Wed, 23 Mar 2022 11:43:54
 -0700 (PDT)
Reply-To: dewaleadeyemo448@gmail.com
From:   Dewale Adeyemo <pw895168@gmail.com>
Date:   Wed, 23 Mar 2022 19:43:54 +0100
Message-ID: <CABhgAWXZJBs8JeEkia7f8pm=0FcYNoa2fymvSnC-DPPBFUsiXQ@mail.gmail.com>
Subject: Greeting,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4664]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [pw895168[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dewaleadeyemo448[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [pw895168[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 HK_SCAM No description available.
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

P=C3=B3ngase en contacto conmigo para su dinero de compensaci=C3=B3n.

...................................

Contact me for your compensation money.
