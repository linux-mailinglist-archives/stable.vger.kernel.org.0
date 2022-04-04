Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D21D4F123B
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 11:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354565AbiDDJqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 05:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbiDDJqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 05:46:07 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9E62BB02
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 02:44:11 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f23so16490736ybj.7
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 02:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=juDa0Yw6buqdWmoHK6QWWkUn60WSIKFmFbVs8+wn+ma3f8VeDzRlgw2j4+UnHBt0Op
         YfnLRFXTk73aX/4/udu/DlOjWUQOe7LFC3hUXo+6igmMVLQFd3Uplw2LHsLlkHEp6fdl
         dMEhsHtG5icfAy0gMtqfuy+cSLyzDJ0H8s0TAes6FD+0ZvgKCFYKIWlxVzsUOO7yIaiQ
         i0Oe8yxFiAVC1HIy6MpwLGemZL95OMaX+Vxyn1FMvFw0i/rAbtVFRe58Jx3fRP2rAo3c
         yQxphtf/zFqQWggRENt7D4c2qyutPFlgtuNTdb0kvjqvA21CRw8S8HuqnaUgf4Z3XnZn
         yo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=kTowmLi75FeeYH7It1oCSD6w3CRdNbwJljWGnwLn2lq/8FnQVbIGfnP85uo+RdKV/q
         56P0PnRekTYDFgvPbcDJE7Jo57/GHgkxoiXmKZs2arAogwnXKz6dmRoa0lDP2oWEn9NL
         Ww7pb1yYCpOu5pPUvPzy/+nS2VqFvT2XkvHHikW9CrmmeP2wsLKS8C/r54tCL0AVbP9B
         IJ3TE9FzPkOJ+zWV71pOIyJ7VIEzr3iLO7xdBv+GYlS7zaU1YURgvJI0TVshBaak8QeL
         pfVlp650qjEtfdAIhMtJqMfwQrgCDqrAusKVB8VouTOU6HbrAKUjJ3sZf40KNOOTBsTX
         psGQ==
X-Gm-Message-State: AOAM531loOstPkYtEQKO/ENFmEaJkUvRqlhqNE34r9FrMWQ104mlrFAx
        tDykU7WgOaDPwPqA+6wVaL356cUUaWTAzftZwS4=
X-Google-Smtp-Source: ABdhPJxKnigJCDdvbPWsmQX//3OpVSx7kjnOlps3Kc2deeWvmzBqgvWE9WR51PRQu0sA/kRwpLIcuBAIXZR9v/by8NU=
X-Received: by 2002:a25:d2c4:0:b0:63d:d9a2:29e7 with SMTP id
 j187-20020a25d2c4000000b0063dd9a229e7mr2979145ybg.564.1649065450896; Mon, 04
 Apr 2022 02:44:10 -0700 (PDT)
MIME-Version: 1.0
Sender: vmrjude906@gmail.com
Received: by 2002:a05:7010:a607:b0:239:64df:1595 with HTTP; Mon, 4 Apr 2022
 02:44:10 -0700 (PDT)
From:   Nance Terry Lee <nance173terry@gmail.com>
Date:   Mon, 4 Apr 2022 09:44:10 +0000
X-Google-Sender-Auth: NERHsqsSxki81YdHSkOhkKSGw2Q
Message-ID: <CAHKUWg-AiW2cF-ARG_0nK1_-2WVuuB5MBHd1iy3hUP2aQBUQwA@mail.gmail.com>
Subject: Hello My Dear Friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [vmrjude906[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [vmrjude906[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        *  3.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.9 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello My Dear Friend,

I am Dr. Nance Terry Lee, the United Nations Representative Washington
-DC - USA.
I hereby inform you that your UN pending compensation funds the sum of
$4.2million has been approved to be released to you through Diplomatic
Courier Service.

In the light of the above, you are advised to send your full receiving
information as below:

1. Your full name
2. Full receiving address
3. Your mobile number
4. Nearest airport

Upon the receipt of the above information, I will proceed with the
delivery process of your compensation funds to your door step through
our special agent, if you have any questions, don't hesitate to ask
me.

Kindly revert back to this office immediately.

Thanks.
Dr. Nance Terry Lee.
United Nations Representative
Washington-DC USA.
Tel: +1-703-9877 5463
Fax: +1-703-9268 5422
