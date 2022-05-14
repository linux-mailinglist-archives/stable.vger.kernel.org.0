Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0555272A4
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 17:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiENPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 11:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiENPdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 11:33:10 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53663CA
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:33:08 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id q2so11329338vsr.5
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ejmbDSRtrvmXLPtD7L18FmBC6JgH3lWpgMvMBM820Rg=;
        b=RCkW6EoKVsTyY+YT5TWDGJsq7VRsPvYYPp7SUJ4WSJvHj9rK23KzlnYJWuLfprId/A
         +XwG9TmkUEk8nxpyVICnXkIGY3SQ7jn8Jffcyc63C8Vj0+FkeJsdZCpmL0KAtNGlzVDU
         keyq/goROEcuHsxpRUbdZgA3kZGyPJ43Vav7iENNnl0nBfYfw8eGXvYcuG0kBsfBhD7H
         avlpl4xUvm+AhOnWUrU6K2I1UextVU9UxFh6jczFlS6ZLyO6fLhM8shHMoiwmCgnSQ94
         XTpvIBf9PDnaGdu5h7Yj1+7n/ZNP5G8ybL+Amtflo5tA50vvOkUDKTqYf3/jwHd1szws
         8bKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ejmbDSRtrvmXLPtD7L18FmBC6JgH3lWpgMvMBM820Rg=;
        b=pAEVyYQk3n+YumlcYygLKbuJUouxs+VQcr7/7he8w6LFkAKrAii33YETWacu426Ow+
         B7jwp54wLkA4KZDCUgxOeUSpNIfC+ljoVu/x6eryYJ+lk5fdTnz5hO/MiT/E2f8U0ZJA
         V2Yc2zO7HUPVGJ/KLG9f6gwxkRq3jq8LMyGaM8Kb2QbXGqQ049cwIzb+AnvEY5F0V+xP
         Ppk0aQ2ext3lYRedTgYoGTVJ14hDw+ACTU+ofP3MXKdF+JuSeAnPuS712KypkAhYn4bk
         BQNbElXHwd68eJvFTxWsWlv9VvvrjGVa1QIlvzcR9AwAyHzwQ8BJTVpvBJ6I/spWEIAM
         eNTQ==
X-Gm-Message-State: AOAM531J9exWpHLSNIe9Ep2ro0Ys0djhbNScnGqo0n6OBo+1+4tVSEpN
        E2uE1AanaQOOXMuOObXesI4fCYRqgoEF6ZIV+II=
X-Google-Smtp-Source: ABdhPJxnpsV3zd5jGmZpgTAXkyuVALXbU0mzyo2th97svT5L5JK10rpd26vNzbxD2BuGeXPoVZZ1yanKQVga5rFb65w=
X-Received: by 2002:a67:eec9:0:b0:324:c32c:dbdd with SMTP id
 o9-20020a67eec9000000b00324c32cdbddmr3946158vsp.33.1652542387384; Sat, 14 May
 2022 08:33:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6102:3e8f:0:0:0:0 with HTTP; Sat, 14 May 2022 08:33:07
 -0700 (PDT)
Reply-To: douglaselix23@gmail.com
From:   "Mr. Douglas Felix" <kekererukayatoux@gmail.com>
Date:   Sat, 14 May 2022 15:33:07 +0000
Message-ID: <CAN5qXwEbDBhPdzOpBdgwaph7xQVx82ayNgVPwX7+K2435Y8YMQ@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4990]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kekererukayatoux[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [douglaselix23[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e2b listed in]
        [list.dnswl.org]
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a retune mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Mr. Douglas Felix
