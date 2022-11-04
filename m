Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF8C61983E
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 14:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKDNhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 09:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDNhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 09:37:51 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1EA2657C
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 06:37:50 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id d3so6404328ljl.1
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 06:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EdY+MOU1TmeQWcJcFS/IvhQ+5RhMFDPkRQk2g/H9YA=;
        b=MaGRQfNV1+y25NptGQxeB8reBxVbOPRvWFFDUb68t8fRXMBmQ0bnFQQRw/zRFwZmey
         MUbdG53C77bYa4b0+EJB5E7nhY5ATTGrOMEp69Q4NUPw8KZef7IEpnlXcyQN7foL+7f4
         y3xUsdwaqbPuTykZEMmIAvmt0cnpjkp9T80R7zX+534+LYB5y2skY6x8j66LGDVY3jrz
         L12FTBoRAVlZA120YhqYZNgclidFl7eVuoJcwcPEbkyTKuivho8IjO1f0b/6G7quAHt6
         7JXQQ4BGl2BqxDrmn+7V0Lo4XezwszuaIql36hOHNNPijxzUxH/Rtoae0TXpBK+oAi94
         /Pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EdY+MOU1TmeQWcJcFS/IvhQ+5RhMFDPkRQk2g/H9YA=;
        b=XNOFSoq0zWuNHB3CbpQ5/PyZGQXLIW3m513nvwW06EqRre0rM7Qqa9MYqoE6tJN4Jq
         y7lOT7kjPJksYhHE2jFnqHp2exBsA9HgIEPSg//WY8xUTEq8SDUfqPGz5zBTD5j0Yt09
         IZZ0NM8jrx7RnSa1YJg/rKGPRnH+YLktXuhHv0jRIp68qpETtl+JoJEi+dosDUHd/VfU
         FXZJ6v1AyIgNPNfea2eZ2FKdZAFOwAmQ3O678zdqF520BDiyHDva7fDLse5oJfQ47n5x
         u3i/n/FqYyoPOtR2zEb5DaYq0JS25YuD9X8saK2J5GpOyyxbcFC+0Qb1LhkMacmj+uyo
         eOwA==
X-Gm-Message-State: ACrzQf22KMOEzLmyb42oqClVztlZ/eOC9s7enRVQx05VEqNA99hcTQ5n
        rIak1au88ZpIRcciQSaYnbz3Dh4MyXS6BCKuu1A=
X-Google-Smtp-Source: AMsMyM6d2voh7dK/6dLKnRZ/nWvj6iUemC8r5MpMVL0CB5+i3TDe1e8f/7QuKQD8sBEUKMbuXnfiquDTaXiEpNl188g=
X-Received: by 2002:a05:651c:194d:b0:277:5ff3:90d3 with SMTP id
 bs13-20020a05651c194d00b002775ff390d3mr8663437ljb.100.1667569068190; Fri, 04
 Nov 2022 06:37:48 -0700 (PDT)
MIME-Version: 1.0
Sender: frankbillion112@gmail.com
Received: by 2002:a05:6504:88:b0:1da:d7bc:801f with HTTP; Fri, 4 Nov 2022
 06:37:47 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Fri, 4 Nov 2022 14:37:47 +0100
X-Google-Sender-Auth: KN1vTF11PO-k_tu6oW7V3eytdoU
Message-ID: <CANHURE6H16k7tDg2mnk7KfkfbEn6QPJoEyhpTfMM7HpyDe-SdQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:232 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdltdkggl3455[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [frankbillion112[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dearly Beloved In Christ,

Please forgive me for stressing you with my predicaments as I directly
believe that you will be honest to fulfill my final wish before i die.

I am Mrs.Sophia Erick, and i was Diagnosed with Cancer about 2 years
ago, before i go for a surgery i have to do this by helping the
Orphanages home, Motherless babies home, less privileged and disable
citizens and widows around the world,

So If you are interested to fulfill my final wish by using the sum of
Eleven Million Dollars, to help them as I mentioned, kindly get back
to me for more information on how the fund will be transferred to your
account.

Warm Regards,
Sincerely Mrs. Sophia Erick.
