Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131236C1DB0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjCTRWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjCTRVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:21:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2D52715
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:17:37 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id r5so13957097qtp.4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679332653;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrrJV4TAqEmgxo9rixIsFGuHr/xHVp3vP2akrcoLEqU=;
        b=fbqTyUi8uOB0N30mfG21m3in8Jh4RgrmgM/qkx9UCkyNUceqlfak8/+lZ1kbd6p76m
         7Pljc79kdNDPi3EPZdBi82TqozkZZgfcElem3JvmyNM4Q2VIhpeJninS3KUypr+dr2Og
         CYmoolcUuv8cxsSs3EzYtxgs07oNB0FkMlgbFWkv0h5tZ3LA4HMWtZQghUahhrpx8drb
         aI5UaHU2ORq+4aNU4FSUJWvaCSVEl7qrBq84rYh9Ki+9VBE+W6jhZW2Vo2p4tsDSiLdw
         LDUJl0YezKH1BkydGdQ3saOHWQmrRVawKHllXYvwqLf9kw1nnyci38FFNFADUt2EJ4Fl
         rzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679332653;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MrrJV4TAqEmgxo9rixIsFGuHr/xHVp3vP2akrcoLEqU=;
        b=gptzuai8ti9YT3TVUT/BGn10Qww3sF67FcDLRi+XG3a1B/Ezpcxlb2xAZ8OHw91sfe
         TxjyumoG2ofg+vDy5IwHKaBp5fRGkm5KzDcek1PK4LwBYSxTZtZP3jJqIm0ESFdKon9+
         HC+cCRUtw74q8tUO2/Su77mHOnCfSZ6Njg7QnmoDpZdT0Lbh2rJaRqRPgYTxLOgeTFmi
         syYknPxCjdCeIASc0kXdCi4R7DaGQGssj9wPW1ZU8dfLVMpoE/s2+R8f2GENGK/AL33z
         Lxu4coAvtQrslVVuxaMVkSeAKMtyrBvuYTYm0xw2/wGaEj8FgcnxPY7Qt2C+yCozu1dG
         lxPA==
X-Gm-Message-State: AO0yUKXMEscb+HSCaM2ZfutNBm538IBBd54VTI/5WeENbKc7Xt5GOhu7
        dfH7371TB1icDUSm4n9yu9q4SlMcQR13MZO24FY=
X-Google-Smtp-Source: AK7set/vPoO4xk2zb8MtjSQ27JXQcI7kzyh1Mdw+Ogj/5MXrnVsbRuRfmrWoNR4uY89voC5QC0WYRRPZdx42bYxJXyk=
X-Received: by 2002:ac8:7e84:0:b0:3de:1720:b54b with SMTP id
 w4-20020ac87e84000000b003de1720b54bmr8109qtj.0.1679332653031; Mon, 20 Mar
 2023 10:17:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:164c:b0:3bf:c368:3727 with HTTP; Mon, 20 Mar 2023
 10:17:32 -0700 (PDT)
Reply-To: felixdouglas212@gmail.com
From:   Douglas Felix <df8143114@gmail.com>
Date:   Mon, 20 Mar 2023 17:17:32 +0000
Message-ID: <CAG=btNb-wD6kCcHg-jnmPEhMmMyA6k_phf4LSNGU2wFnJ66NQQ@mail.gmail.com>
Subject: Good day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:844 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5010]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [df8143114[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [df8143114[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [felixdouglas212[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister. Douglas Felix.
