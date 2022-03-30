Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4704EC545
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345745AbiC3NLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 09:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbiC3NLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 09:11:38 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2E8207A0F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:49 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2db2add4516so219182477b3.1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=WK6OLngTEGMQZnXAmgyK8gksEaTtYBKX+MRhgq0dtFw=;
        b=n49xo98ONv8A3ML/9wMA5smDzn+GnC+DouDAinXJNJtqPq+8CbKEWTJaKA9od2/4b7
         VgVp5fQF98kGdjr8pYFtHL3EauETrl6d8wZ7M36TDZyfcO2Wu9tjk3kDKWK+cNQQq+T5
         HbZeBlAjl/pxFMmojYLQPhvkdJYzQ5mcj8FcZOi5hcbOIyBtFJKmAynHKFp33dpDuMLN
         zXOptVWIHBu9eWals9HC6UyVQ5RWA3JHBvWSQ8CkmN2Cm/zmKU0IprE2ejlXorw/zydQ
         ZU3ZyfiQDPrxbUEEmwPUhQ3ZsCWFD/jj3W0vwxhFAQ3gtLjSrDAUciHps+7s2j7/bjDe
         wSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=WK6OLngTEGMQZnXAmgyK8gksEaTtYBKX+MRhgq0dtFw=;
        b=eJ9QL1F6Dfrr1GQ0Wqj0L4mBS8BB7CvOLnPAhuFC8Zq26FoErCxXs15fHoYCx7HGFb
         E+N9dj573kdo3yiXBHWpcBc+NvWX0CkSaMaFFR+fWhzgiEXTXP6E1deSSlzuDC67c8jf
         TRHtStYeMDMx8hYFHkRdBGQyK6crVLd/zEqutSOn+tS2GytRVe8LpGFpVJVU0x711enO
         7/Xbe5cPBXS9niCZ0+f5bpZvZM27U2NaSTaF2SrXkLyZyoV8NKdiwk6aEDjmgnWmNzhJ
         RgC+Ksr9x7o4eWjApKnzPNzDuQpEFrzSC6sGTFPyDBj4VEtgJgAaUAWhMmXblg031Phc
         eaNQ==
X-Gm-Message-State: AOAM532/SiaU8/dyAahvN7wXbW8LTX8jWwpOKf8du0hpbu0oGjBs6HAi
        ZUEydBcd66/dnYzOSyl9uohOlE8ObHaCSbCkVrY=
X-Google-Smtp-Source: ABdhPJxPN67RYwL0WxZ9JkPPHIkdo4Hemwbg0waunw/vuXlRoU1mNu0+sWTGnwusZWW+1fYbkTVCNx2P/r6aAAYyOaI=
X-Received: by 2002:a81:8106:0:b0:2dc:1f07:920b with SMTP id
 r6-20020a818106000000b002dc1f07920bmr37057233ywf.330.1648645788374; Wed, 30
 Mar 2022 06:09:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:1b0f:b0:239:1dd4:55d6 with HTTP; Wed, 30 Mar 2022
 06:09:48 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   SgtKayla Manthey <shemlitisa@gmail.com>
Date:   Wed, 30 Mar 2022 06:09:48 -0700
Message-ID: <CALPVM-X+iYh-cn-UbfAthKGF6XtFxGtYjf=MKXgsB_CiNYEvLA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
Please did you receive my previous message? Write me back
