Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29A52B74D
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 12:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiERJfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 05:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiERJel (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 05:34:41 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43894B0D38
        for <stable@vger.kernel.org>; Wed, 18 May 2022 02:34:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k126so790942wme.2
        for <stable@vger.kernel.org>; Wed, 18 May 2022 02:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=FZ95qdZ3wvViKCVVSAIgEilKZv6cVU7hDoEgouhXbFcOa+B2+bVf2kG5Yfp447dDq7
         UuqzyRpwCH4cqBdX0SPsqDn7OdLVzDPE34HKrzhZmUTw9riwVmlUqgNFibq1UrrrFVij
         flUDN6uTNTkJXjCr+YhZhiL8VLDfEUSPqAvwP5pc+DAjOkc9ZsOQU9bMgiINC2krQngn
         U+ZvtzoTI4EOEFGPSbS0j8QzkqGYKyTjUsbwP87LU3NLgeJv0j/sEkShqC88lr1qS/8x
         1LEcMlUTtHGlhYc1dZF8j3WNa+ec2oTu/SqmSP8mVTaR/4VjrkTYWV3PVh1+DxK/OW9B
         U0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=KFsUBi99g0MK8J/IIH57NVOUTodglH2Q/MKKl2P5qgAIbzSqvQxdxzfkWmS2xCHWsn
         CreG1ZfwlBxUtRnouR/k5Fe46zkqRI41QS5Rr296FhyO6UfLbTBpyHjm4+0sgqyaUgBo
         mnMnmXXGEdqhGrE8zV1UOJW1/Y3/ERyfSdWsy1p2UD/sRNaCWUM8Tvi5K8+luTw5tyaQ
         QCyLBUnqqrKB2pl5V8pDifAXzdzfbdfwgUa+9QDztbZYrqw4mSRj5tI0ixRM0UfJJCQY
         km2jVCBpnPeVWyiPsm/Ex96wwL1NGdoER8oCFMyTaM/Dfbj383SUEY+OQtO6vfNjMGaV
         jsKg==
X-Gm-Message-State: AOAM531keMSewlAqpXJQ7FowBWqK9qtuB0E0tl/u/vbYsDBK8kmMzlKx
        0aPTPAoHzCY6/gHpRacD/yenp+QI2I6M9Yx5FH0=
X-Google-Smtp-Source: ABdhPJxY1Od01jINHCMGTdKhEQslEpx2d1VAyPgPZKm7NMM3iTYoUHxOo+tz9BMJ8pvKnjeacRPs/0uskN8OJ2dKNtI=
X-Received: by 2002:a7b:c041:0:b0:394:44a9:b017 with SMTP id
 u1-20020a7bc041000000b0039444a9b017mr25359438wmc.169.1652866471080; Wed, 18
 May 2022 02:34:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f750:0:0:0:0:0 with HTTP; Wed, 18 May 2022 02:34:30
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   brigitte Patayoti <brigittepatayoti0@gmail.com>
Date:   Wed, 18 May 2022 10:34:30 +0100
Message-ID: <CADhLwcRV7O0r+n9=hdCtXPxW3-_TVDzyHKiK0hfSwaw1Qsq5hg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:32c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4993]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [brigittepatayoti0[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidnelson7702626[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [brigittepatayoti0[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
