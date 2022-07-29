Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E753584F57
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 13:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiG2LHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 07:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiG2LHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 07:07:47 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970DF39B84
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 04:07:46 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id u3so4045021lfl.3
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 04:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=Xp3jiYKdfD+2KOmUSOr0cVdDmDB/vg9vLamjcTiNnoc=;
        b=iSlId0y1VigBB3mnwQGDTqOIJbuj+SS97kKqyCMfK0v8vE9nUW5SMzF+2W3Fe8he3U
         jqhhUhfzSuer717/M8GN+JOlEeoFRYpGNFVD9tjvoiAJmWQs684uzVq5nUpm1kr2UeFq
         SNyyWYBGcVtrUchw55G4qA2qzmll8gGEnlqNtGUQ3739qKHJ5hHnQR3xFCRqJWahfujc
         9urMjy/tb74bQvh3B26huEpsbwiVIhmdjB0SBTBIEB9UiGVDMwSUCPuhTQLv0LLj0LvJ
         7NztmnSXZSHLe0uP1lrjwfHq1icQGb/fE2WFfn/EiEis6yDdotEu7Tq6Eb2eBBr+S7oa
         qXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=Xp3jiYKdfD+2KOmUSOr0cVdDmDB/vg9vLamjcTiNnoc=;
        b=6HUFNpUijOvMhBXQKj+h0YaB2H0WM7Yo8zrkxqdGJfy3cqZVdc60Fd4OV9s8MgZO5r
         hwur+9rdDiSS3Eoys4x2lHJhw/Y6PFJbURZX40KasAMd/OfXWE0gXkggZ0FzJbif3b3+
         ET2U0vnJEWnzjqbX+M8mLy6A3PT3YV5dAENp/CZDMU7EOOl8/Nq3qk2K8c7u32j8Wgi8
         SmnRKFjXuqXC9ygo56mVvoWZ5CsTNhZbKBGUxS7lnRQr8fjuptRelh1s37/YOGDJ79qN
         HXAmFBolIG8yg20d4nEkjYi/ltgT5z1Co7KFl9SEfiPobr/NMXC6u48hnT2ZZ/FUzwBE
         Cy4g==
X-Gm-Message-State: AJIora8z6BXa2HaMiftw3pGdp94rEJ+jbjzNCQWDziIhlVrHR7I/RZ0Q
        H872AwSGPwNoiJsrlyv4j2IdwgYW0cPWtx0JtZQ=
X-Google-Smtp-Source: AGRyM1sNtJ2dLSp1wa6NrMafrqMQfUvU8u9HBHHxqW9tZx10a4Mtkgyw90lM12QoKdjt6X31QhbIW4LnO0EhHD1cB6o=
X-Received: by 2002:a05:6512:b27:b0:489:e045:394e with SMTP id
 w39-20020a0565120b2700b00489e045394emr1015453lfu.202.1659092863383; Fri, 29
 Jul 2022 04:07:43 -0700 (PDT)
MIME-Version: 1.0
Sender: hgghghhjhghg06@gmail.com
Received: by 2002:a05:651c:1583:0:0:0:0 with HTTP; Fri, 29 Jul 2022 04:07:42
 -0700 (PDT)
From:   "mrs.sophia.robin" <mrs.sophiar.robin424@gmail.com>
Date:   Fri, 29 Jul 2022 12:07:42 +0100
X-Google-Sender-Auth: lQZfqhiI7lklBZdNbLdIj01coqs
Message-ID: <CALjxKU5etMkY74f=9PjiHumnzQdGs5UbvV5Fcvt0G=Fg8J9izA@mail.gmail.com>
Subject: Dear victim,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12f listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8442]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.sophiar.robin424[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hgghghhjhghg06[at]gmail.com]
        *  1.7 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear victim,

   this Is National Crime Investigation Center USA.
In our Investigation from banks on International and National Funds
Transfer (INFT) protocols In The past 10 years from all banks
Worldwide. We have come across your contact details and record with
One of this Bank. in view of The carried Investigations, we have
Contacted you confidentially for vital Information toward your
transactions with This bank. It was clear That The bank have delayed
Your payment Thereby looking for a means to divert your fund to
Different Individual account not belonging to you.

How ever, all bank officials who mishandled your Transaction has been
Duly sacked and management dissolved and dismissed from bank work as a
Result of This attempt. Upon our Investigation conclusion, we found
Out that your Transaction was Legitimate and for This reason, a
Compensation Amount of $3,150,567.00 (Three million one hundred and
Fifty thousand, five hundred and sixty seven dollars) has been
Allocated to you for Immediate payment through our accredited bank,
Platinum Federal Credit Union USA. Kindly contact the compensation
paying officer with The below details.

Email: mrs.sophiar.robin424@gmail.com,

Yours Sincerely
mrs.sophiar.robin,
