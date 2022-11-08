Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10633620EB9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 12:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiKHLWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 06:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiKHLV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 06:21:58 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB14AF27
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 03:21:57 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id z192so17058990yba.0
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 03:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jD/YBCtOhOa1ipEyheDVa6geA3XolzkSqDbroMLmTEw=;
        b=AdhsaCgya4Uw/NDi74k4v+ptnRM6NWfDP3Cct/+IZOAN/zvg3uT6mDq3Sl565h5KcM
         nVE2iYxTQebDf5bKOKDeJvL9YuEMDLDcaSGX2X9U7rihRLUG1D4mHFLPz4TjDiYC8CHN
         4xt12DE0vTvI6GQjyJP8AjBsz3nyYGdHCiHeSGATiBVI1oKMFHtYYUuF+by+2WjTZMYb
         xNCVQzhllhIR2+3s6TeZk+txG+LkCmu379gN+kjDHuKTqLkTeKzU9d4pJ49zjiRI3B8u
         abWNXyAEJ1D8ADgokATsCFGwhZtps2rskkucF0nO8obyTMccQfGa5YGrbuYU4mg1xFBZ
         ECkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jD/YBCtOhOa1ipEyheDVa6geA3XolzkSqDbroMLmTEw=;
        b=SBevXCmFHHyuHTQlzuRd1UnL53sXC9jYhHhMPO78QL7s9dGt4eCzJjvbNL0Y8gvOUz
         wFWnU9vIH50k08mTqNulb7SLdpvRuwXN8EeySTALT7zngA9BQte8lYXhLFIcrj+s2LkC
         riYEddY6FLj07Kg18erQ6VpKxp5sVfiF8sRimHrveM3y63h+BcwKXUxwY7H+26+UkIQz
         wr7jU3uaHq5XhlSLkNU1RF2w699oSEgiXfJEvTxZ+Zrz9zy+JyXrlI2th5L8UwWOECUi
         pG052PQi7m7QXBnHfyjbS3G+JwYs4cfWaPCV5vewMEQ8EDZCbNUJUVQwfsUpj3jNqXRX
         fwIg==
X-Gm-Message-State: ACrzQf2CkcZONE8KKujjy5bC1bGXVB2IK7AWPnqWDpD6fKKrNmLVeO91
        338l5SWl1oTCJTYKpJEBFkq55X1+Y7JuBAOm/zw=
X-Google-Smtp-Source: AMsMyM6u7tI8EhyL28gRugEIpRAxftwa0r+hvW6VHsDLxEDnU5ffqwRrTElEyjiAGKyFp812yFuR7UtEypEn/NKnpPE=
X-Received: by 2002:a05:6902:722:b0:6ca:260e:cc5 with SMTP id
 l2-20020a056902072200b006ca260e0cc5mr56261343ybt.336.1667906516677; Tue, 08
 Nov 2022 03:21:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:a38a:b0:313:c983:1d7e with HTTP; Tue, 8 Nov 2022
 03:21:56 -0800 (PST)
Reply-To: mrinvest1010@gmail.com
From:   "K. A. Mr. Kairi" <ctocik2@gmail.com>
Date:   Tue, 8 Nov 2022 03:21:56 -0800
Message-ID: <CAC9COZct3ABggmAwfHQsTtQYVufMOYDqkqtLX6x9HPG9YZk+dQ@mail.gmail.com>
Subject: Re: My Response..
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b36 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrinvest1010[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ctocik2[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ctocik2[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hi

How are you with your family, I have a serious client, whom will be
interested to invest in your country, I got your Details through the
Investment Network and world Global Business directory.

If you are interested for more details.....

Sincerely,
Kairi Andrew
