Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9265B30CB
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiIIHtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 03:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiIIHtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 03:49:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844EDEE52E
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 00:44:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m1so1239953edb.7
        for <stable@vger.kernel.org>; Fri, 09 Sep 2022 00:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=ZwPxd8LtjEuPX3lP8M/ewsRzKiwOr4k1fCds3gC7Jk4=;
        b=OG/Af2sRler0zxFmOIwLUrQY/DrFztZwW1VQsfZKk70nIwetaNfp24L++52B09M+Bm
         5dVwCJQ0Ej/sBSo9tGSE6lEHc50X89S7nmUCTT4Cya8oJ5wc5TJhwmmLUOdi3TeXrbnQ
         nAfjFzFska9i/QZGesOOaAMz7j3ftvltE05bPQLYjqSE5bv/qtTD6Qfs1aWzmJ9YJ2MX
         iY3SgH6lCpZdSZ7V6M4fvG2gR2j+NqWmCz1IwEnOlL6p5jfwxKeGqU8hAilSxbogGhnV
         1tr+TqRv7JtlSL/sfFdFR//WPJWWto7xH3KbICPCCfiv+VyLeJMl/WW+iw6udqqdLwCT
         /YUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZwPxd8LtjEuPX3lP8M/ewsRzKiwOr4k1fCds3gC7Jk4=;
        b=b++GjE+n1TyDxPJtU/922fPzzTW4h7OT5R80ZLDfL1vbnfqsscHT7Fs/iS0FJPHqiP
         qg7By4r7h8TvpHvcX4INIs8SSO5x5P0t2dm43mXU3cSEbFKBn/+f9YxUhBpUcHIiIOgu
         bh5K+ieLNXsK8NulWej9r2AycBjW2SVo3AIxdIhc01Wy6heh1X3zbUOIfa2bHUGhfEdo
         eendKqgQvYZn8qPH2tiaghcaaYdr35LwQfpOEz+8sHyUpH3zATuNxrWOLCkd9ky2ZGpu
         ns3uNTCcLWWh7xImEgU5uH8sZUH/z6vf5HNdVIraGoVGMWEkHmAaI8RfymROqr5iZOY9
         EM8w==
X-Gm-Message-State: ACgBeo36R6F2B5PQ1rPgBqHUFvyhwcaXSfeeaj7Bks66Cnl+Z1yGpgll
        kI8m48Eeg2xZVpCwlGpFX8LGHMVDUGTWd8kZOFU=
X-Google-Smtp-Source: AA6agR7jKC/lQmN48BA3gwbakUHx8h/7A3ktBER0XkqBa7hfT5Mc4KzDI9GbCYeRegwKxGNYsII0wgMBfuiBRXrS/oo=
X-Received: by 2002:a05:6402:524a:b0:450:bab6:cd5f with SMTP id
 t10-20020a056402524a00b00450bab6cd5fmr5465447edd.233.1662709492050; Fri, 09
 Sep 2022 00:44:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6400:2546:0:0:0:0 with HTTP; Fri, 9 Sep 2022 00:44:51
 -0700 (PDT)
Reply-To: stefanopessina14@gmail.com
From:   Stefano Pessina <yahayaatsahir@gmail.com>
Date:   Fri, 9 Sep 2022 00:44:51 -0700
Message-ID: <CAF99hYtKqJ33Bibb8Jk5a0e7RQZLJvf2GOUVzUcpF7GLxTgCOA@mail.gmail.com>
Subject: Donation
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yahayaatsahir[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessina14[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
I am Stefano Pessina, an  Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25% this year 2022 to Individuals.. I have
decided to donate $2,200,000.00 to you. If you are interested in my
donation, do contact me for more info
