Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CDF5AD032
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiIEKdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237620AbiIEKdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:33:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5E74BA55
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 03:33:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mj6so8058410pjb.1
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 03:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=cayK0H6IQy1d0QUC88HsF24/yaLJdFvFfYMkqrp9K4s=;
        b=qSNNT6ZfnPW/bMsu7VsO4W9E5HfpsO5KKH4BVPc8awo2Off5bxZvynopH0DAtJbM53
         8LXCynHiVmT65qJUQV1AS9K3bhFtirKCwlj3LhOS9WmodK3iN9zp4A3tfPRmL7KlicMA
         NTENGmolQkYs4WEfpfi6X2pCK+gcCFuJZWmJaDnZv/yQU4eQQDqOtVKXf2SJGOkE5AJ1
         phsnro9xga8vuswJmYJjrFlG+Et1aQzHgtWYHSjyH5Fw50T+8FLDvVQieWRSY/a8Pblv
         eAuvX2WrptBlXdWK5Pb5WXDhnc71P3z4NrnnXL0KfjxuUMEXrk5CWLqd/2TkaefEP84V
         +TSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cayK0H6IQy1d0QUC88HsF24/yaLJdFvFfYMkqrp9K4s=;
        b=qx1v2dy83rAkhceqmn8dNtCngPdX9E3PfszYXbQbM/iFks8xZcmbLilUhf1mRi7G5W
         BSxCyagiqX+G/PLE9nuRNbMG77AtvcBLL9vxEOPUEdh+tOdJSjz+8fg9UVbO/gUagTPn
         QtyAf1n/lGvQ8De3J5qGrkIRjPGc9oDoq4BU0eOwJz+fLKH6F8Z/96E72N0p/r+ccX6O
         d5SROTib/NNgbfDqJGbr8sEPCRYZrVehLTwwuOBCS4q7/0vnkNEo2rZVElL8JRSQ5jsV
         TQbihQ6/Bsq67h+PPCHZ/4etRSD8OConH/gxo4e27tE2eZT5RTWeoT/rUlWmyG5AaNkB
         VsbA==
X-Gm-Message-State: ACgBeo3TJ6T2yR66y+uVyBlLtAhowb7aibQfJqryQnl87W54/0rk2m3g
        b8M1oxPbSwcpaD4B5/lUf2uayNdBi++SX2d7SHI=
X-Google-Smtp-Source: AA6agR4oBIU5Lzw16uRsHxiaDdI65HWIiNR799/n9Mzr9MPgQGH4d+UHQSGYsd5n7q7d1su4sjJsfYUtFgLl6kDzm6w=
X-Received: by 2002:a17:90b:1c0a:b0:1fe:4c0d:99ba with SMTP id
 oc10-20020a17090b1c0a00b001fe4c0d99bamr18546384pjb.88.1662373984251; Mon, 05
 Sep 2022 03:33:04 -0700 (PDT)
MIME-Version: 1.0
Sender: chijosco1990@gmail.com
Received: by 2002:a05:7300:64cd:b0:6f:79cd:7587 with HTTP; Mon, 5 Sep 2022
 03:33:03 -0700 (PDT)
From:   "Mr. Ibrahim Idewu" <ibrahimidewu4@gmail.com>
Date:   Mon, 5 Sep 2022 11:33:03 +0100
X-Google-Sender-Auth: Db91XIx6WMoBzN0B7uDiGO5VuU8
Message-ID: <CAMsCVzChyX+MuRwh6on9mFvU5eV6ZTLn1v4-HdB=Uf3zgUfy0Q@mail.gmail.com>
Subject: GREETINGS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=ADVANCE_FEE_2_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FORM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [chijosco1990[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [chijosco1990[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.6 MONEY_FORM Lots of money if you fill out a form
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.5 ADVANCE_FEE_2_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have a business proposal to the tune of $19.3m USD for you to handle
with me. I have opportunity to transfer this abandon fund to your bank
account in your country which belongs to our client.

I am inviting you in this transaction where this money can be shared
between us at ratio of 50/50% and help the needy around us don=E2=80=99t be
afraid of anything I am with you I will instruct you what you will do
to maintain this fund.

Please kindly contact me with your information if you are interested
in this transaction for more details(ibrahimidewu4@gmail.com)

1. Your Full Name.....................
2. Your Address......................
3. Your Country of Origin.............
4. Your Age..........................
5. Your ID card copy and telephone number for easy communication...........=
....

Best regards,
Mr.Ibrahim Idewu.
