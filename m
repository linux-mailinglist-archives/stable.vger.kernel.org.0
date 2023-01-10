Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C96643DF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 15:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjAJO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 09:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjAJO7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 09:59:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D2E59317
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 06:59:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 18so17937375edw.7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 06:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FoRX2f/YZd1ew3w9a7uXRMrccel34cHi9ReaKIRWJg=;
        b=Jwknglc5/Rcxb7qQlnbwQRcOTuFr0n4qThHaVE70YcfQAPmOiMeE7CBZDFMERPe28Q
         mmC65fhz0EmlfkoZOsyqxiQBj43epzi0cX6uTQr621+XtpiFpafELtUYghi2SVD689Wx
         tXKmCugSo1YYA1sje0f5lzvIXoNLe237ZsdO4I2fGhfE4OMyitk+fuu2nzLMEy9kkUT3
         /OivWZhFDgFlpGbyKxYmO0nSlJPiQZ4kACizdj7cdTJUtFcBnikc3+OL42q6E4jHSnd6
         9/7cCBlX4h/09EcsU8DyzOlCj2HEo3aRVy/z7Ji1UrVQCiCa+7u+Bl/4f7oAOsZYkWnY
         tn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FoRX2f/YZd1ew3w9a7uXRMrccel34cHi9ReaKIRWJg=;
        b=waC1tcYKoXdzNlV5hODEYmCbsLkvQf6ia4C1P5ixxY2bksh/Y0PugcfXcFHZrER/fZ
         7iag0ODsTbOPfHa/yfpT7VoCrWXQ0vuLbNep/+Y1NOn6snCNFDs+PLlWgb4pybnVNxet
         Rty3BgM5Ic72YFEmC+Uta6q/AxPezyOVvICaTpghLrUmy9zud2GUnTyB/H8ptKZ7GfUf
         KLZGGRtM+fb5eZ0Kojhiy33vE/83caNTnUSCbuqnOi3p7klDRK3h4MTH+zhMrbEGBvT6
         yTs4+ku1CWLL2izW83fnUued92mo3au7GMfJcehfYWZzwwE58Ktq19d79OVjPzSnxtr8
         y7bw==
X-Gm-Message-State: AFqh2kruzCDvLX2jXRgp9HjGS6ioFVyt1s3uXbdvz+UWtjrbZ9M32T5M
        N6+/SPAaaSwhzCgR8R5cmVGs9VlhGBasqtQu6nE=
X-Google-Smtp-Source: AMrXdXsRnywiOJhSbncx0nIxEQGQMT7VT8XxRmVNwxPaUfqktyFpfuoxc4V62uMZWwvxZu8zpuu5YGvEroo0XWgIoyo=
X-Received: by 2002:a05:6402:5383:b0:496:d77:b440 with SMTP id
 ew3-20020a056402538300b004960d77b440mr1403061edb.397.1673362743038; Tue, 10
 Jan 2023 06:59:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:640c:1bc5:b0:1a0:4232:e524 with HTTP; Tue, 10 Jan 2023
 06:59:02 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <oyomdemian@gmail.com>
Date:   Tue, 10 Jan 2023 15:59:02 +0100
Message-ID: <CAHqmVpaXkbbHNLsp1qtL=xSoOWFkFF3bETD+J4BpmqaY7nz_rw@mail.gmail.com>
Subject: REPLY FOR DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [oyomdemian[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings.

I am Ms Nadage lassou,I have a business for our benefit.
Thanks, i will send you the details once i hear from you.
Regards.
Ms Nadage Lassou
