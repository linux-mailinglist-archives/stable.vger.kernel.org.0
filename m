Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304FC512101
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiD0PRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiD0PR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:17:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C4438797
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 08:14:18 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i24so1839216pfa.7
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 08:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BF+tCt1laDDIWaRTm2Tn2q5CGPS2vC38NYhiWS0MAvI=;
        b=Xp9QldiaeHXqKphJPbczMVNvKgHLIMl8kl9lg+qnlFG0JRpa0IrdR/6LM1rfhjllXN
         WBFHtiecq5Tug484MVlaym27PSSEq6bdTaU66/mZVXvj88qmDzfnGVOamJ+SIba+Y7Fv
         K/aAUenNe0aM10CVeiGfpyM+O90ZpnMflt7WmcHR4X0w3scI2FVi7e8S0QhPmSdgsCIq
         6dCz4j5L1O8T3TcXWzD7IveDfD61JZG93btYubEaZ0Rwx2eV1KJL0r7XlptFsk5eCrmZ
         5bnNXhsw69buveGKgLRzJsUcGKqJRF0Bj8MiaImGQdQOMT7UUXyp63JLNdg/7J3l4XhM
         MrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=BF+tCt1laDDIWaRTm2Tn2q5CGPS2vC38NYhiWS0MAvI=;
        b=3aK1A7r05y2A4mfHGSDYNBE9JOboPouB2SVV22ySuqiMlifzNeSMLMwnvCggK1KmJZ
         nACut8bzSLjt0zmHz8/tEUTdXJoLH3KT9Ubh3MF3K+9KsZ4bBI/Z0DOQN4nM1MoFT+yR
         9wT7R9mncnL7C7jpxrjmvqtmiJ3FoR72zehz1GlAZf0M9D4o6jjwOzPpMVd6OxqALmeG
         17dwcGe0qTpR/OmKv4XMDdQXj8tgpyflHdaPqmtGjcWCHWE0RmByFGpXCbI/+IyEX49m
         dk0RD4Y7+ANhrSmNK8omSk+/+qjJWCgb2RfwLfRFByQ1Mfkwg8YcSwsY65urQucnSpTV
         52lw==
X-Gm-Message-State: AOAM533yp3zBjTi4fLEgs5x0yUoYIAbb1iYseFURQu1CPqMxkjpkCG8m
        DT/AkC/9iI6WyIUJgcTdnWqz1tsNqfOTzFxof0k=
X-Google-Smtp-Source: ABdhPJwzNZ+9WtonQn5UB3GPNEaLAr961Qh54Jw5JyiTrytX9i+npt7Q03aQDHzqzMjl/DHkqW6+abjO4nGy76EbNgU=
X-Received: by 2002:a63:5d1c:0:b0:39c:c5d7:ebbb with SMTP id
 r28-20020a635d1c000000b0039cc5d7ebbbmr24118816pgb.54.1651072457422; Wed, 27
 Apr 2022 08:14:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:c7cc:0:0:0:0 with HTTP; Wed, 27 Apr 2022 08:14:16
 -0700 (PDT)
Reply-To: lindaahmed804@gmail.com
From:   "Mrs. Linda Ahmed" <martinhoward868@gmail.com>
Date:   Wed, 27 Apr 2022 15:14:16 +0000
Message-ID: <CABMvHDwu4E5CA8eygoJYdxYEv3ChyQR6NpfQB4ddK-Y+PbpX8A@mail.gmail.com>
Subject: =?UTF-8?B?5L2g5aW9?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:429 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [martinhoward868[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lindaahmed804[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [martinhoward868[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

6K+35Lul5bqU5pyJ55qE5bCK6YeN5oiR5oOz5ZKM5L2g6LCI6LCI5b6I6YeN6KaBDQo=
