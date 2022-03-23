Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A284E59F4
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbiCWUiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240098AbiCWUiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:38:17 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A102A2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:36:47 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id t2so2235231qtw.9
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mMTusA8cjkUZZ3IctdXtFXM1psk1o/up3U1VXV8axKs=;
        b=FYNcGcOLPE6h8ZgOlrO4dA9FCQyRN3SMrWcXLpLVUB66VNn+RlXLVzP5I+aNOsOoyy
         WlaUtVbqQJ5y0fneeAy18uI4T8ZqkQYvQ46NreApbSVsTf+/TQ9Uo99gpWtu/DgZg7RL
         Ue1KenTARNII/JQ4uxVJLZD7cj1gTBqAWlCpNcZgpqdp5E/UylinrC6i6PiR68BKUxDA
         3ZF7cyyluukH5hTUmp01NflgbnFlcgV+7/PjwsXeyuWxy5OgvYN1+Wwy9de6c4KRn+eL
         TSgeRlZjY9XmjvgdJT+nMa47AUNiAilYdoMRfX8vq9bqvMBGJ5fq0pMFy1Sp0jW9+wVh
         YGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mMTusA8cjkUZZ3IctdXtFXM1psk1o/up3U1VXV8axKs=;
        b=05Th+qmOgAOP6n8dotYZ0uSZTLorcNpLvx2MaJiYpTCHtNnpuTIjDRbH7pS9DRgoD3
         aMcRdhXHkEZ9w/xAmj2Wq0xcisNZFptTrjuKF4gEyNBChn+NTj2cT6sKHUz7iJuQWzsz
         8xF2LH+ymx4Y4fndBiZutpq8rPVYDDDJQzNHhfaZ4Ojf7pO1xvy6giex7NY8kcY7IBDX
         5F/bNGv0xxwsJ+3Jq/OYmbTwwkj79rqnRvRTSd6EjtbXk1fPbVEBxLXiEMvizrUbPPxK
         dlynvYpVqHihN8yqoD1SuPJEuylaAlw5dF6+aMrql1L/4zOxYQvtFDAS9B/Z6nFMo0ef
         eKPw==
X-Gm-Message-State: AOAM533Z6eN/1ilBzf1GguvDGUdApZvyzEqCFWvZZCKD+l6wpmAKmPPX
        21S6bYWoBQUTHghzOgCHemXr9M84RFp8BtqPO6Q=
X-Google-Smtp-Source: ABdhPJxhnqgoWbZwoIXPEB+2lgiD6jn7JfL3EOcxdoLt/B8/3lAmwKUFu75zrqaPf3rjp8NRG3umB+wqJJtiD3aLEW0=
X-Received: by 2002:ac8:590b:0:b0:2e1:e001:e851 with SMTP id
 11-20020ac8590b000000b002e1e001e851mr1565520qty.176.1648067806658; Wed, 23
 Mar 2022 13:36:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:5f8f:0:0:0:0:0 with HTTP; Wed, 23 Mar 2022 13:36:46
 -0700 (PDT)
Reply-To: mrsvl06@gmail.com
From:   Mrs Veronica Lee <anigret111@gmail.com>
Date:   Wed, 23 Mar 2022 21:36:46 +0100
Message-ID: <CALgpPr3e2WHJrvQr5pdzd7MhxubEwwpkPd8fhVUJYz42fdt1+w@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:835 listed in]
        [list.dnswl.org]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3977]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [anigret111[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrsvl06[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [anigret111[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello dear, I sent you an email without a response about a contract
which I would like to share with   Please answer me for detail .
Thanks
Mrs Veronica Rebek Lee
