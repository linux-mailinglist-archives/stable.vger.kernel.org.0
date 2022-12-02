Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69996406FB
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiLBMkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiLBMkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:40:09 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B2B91C16
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:40:08 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id c1so7208121lfi.7
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 04:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmMhzLW1Ky3aYrauJIOEu3sGYQQwtA8U3ujVQrJjKtQ=;
        b=Q9PmexYMHRrvPI1V0dyydJ15k9xp4TxbAmGsLY4O+9FUdtDE7/xWK1LRQm3eSyUoIC
         4XDcDuWmOFD2Wp/LAJU25p3sMAVSicaKYeIIXwJYF5yvPO6G/66zsTNoPhNp5Wj7ae4d
         5QNmTO7o6V6eTxoNwKKJxD78PgWcJl7bvQvZM4vg6NEk4eFsUapNz7wG7bx05SjWM6uZ
         n5iQIWIiDRO/PitFt1hYD183ORydIVSHxMxTtdOqzb50rmN3MiLfMqI9uYKj+aHkXr3c
         ZlVYI17NsfmntwYaIe4WAD6VHdamX95QgJ5JNAp4naCRaqTSSNbzRSentcM9nhkky3s4
         EOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmMhzLW1Ky3aYrauJIOEu3sGYQQwtA8U3ujVQrJjKtQ=;
        b=uX87Twd4o4KzAlZFFRvKXKCxfzJPPUrwAfmN/Imnst+Kf049mVunLuXsZ1hFvnG33+
         D7C4ua3C0Dq9gsUxkklJx+Zc0Yv2Qc4ItFKyg1cI1pxKIeVbAnvHdjWz83e+6q4Z3VBM
         7r8TVNXT/PseEOf/nCBWI7CCGBFUSECBK93ZV/vIrSh0aHeep/RPD/DzVASwCvdaAwMk
         1XIdC9iprL62sjFsAmA1t+5kQZ/U/VPCWAljMR+7cQFbemCNsLu/OMlZM5HNteeKWHI2
         XtdzkXk6zNqAaqB+JbfCBncJnnQe4Tp0ZdB1krZ+CJUiC9Ffjz9/oH/uCvBkmRekTyNS
         zh/w==
X-Gm-Message-State: ANoB5pmJuhUB6UUaa4gG0KqZH5OYGeGjb2hnkr+1TW+egncV/oH431N6
        qXxp9Ts10mAGGfMWG9FTlZqlw4GK23cBEI4bDv8=
X-Google-Smtp-Source: AA0mqf4U9Lsp/Rb12VvqP2lzsDjq52Qdu+SaSHMA5a9PyUs9yyPHBXmL9t7bsQGFBJ74bqHWHqUwzdUT+yW/faNAZfk=
X-Received: by 2002:a05:6512:52d:b0:4a2:7574:b64a with SMTP id
 o13-20020a056512052d00b004a27574b64amr23101259lfc.336.1669984806846; Fri, 02
 Dec 2022 04:40:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:a547:0:0:0:0:0 with HTTP; Fri, 2 Dec 2022 04:40:06 -0800 (PST)
Reply-To: chuinh021@gmail.com
From:   chuinh <flexmr271@gmail.com>
Date:   Fri, 2 Dec 2022 13:40:06 +0100
Message-ID: <CAAWWbsJK0_gOt4fBf8V9Kx7NKqYuK23CnAWFiLc_QTW67PeVcw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [chuinh021[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [flexmr271[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [flexmr271[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 

Dear Friend,

I have an important message which i want to discuss with you.

Sincerely,

Mrs Chu Inh
