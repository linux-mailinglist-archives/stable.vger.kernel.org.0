Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1906C6504E7
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 23:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiLRWB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 17:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRWBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 17:01:54 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90117648
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 14:01:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 4so7336880plj.3
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 14:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T9f0Ku46RA66RnD1s7kuU6MfXVLxET4cBAuDiB4K0jo=;
        b=B9140m+7GOOtIoyl+XxoMzUCwWRYhXKo6ccbH6GzdPzZBGzP0lCOojvqJWg9q4Fbi/
         wdYPDLxBWL2l60ODuSP7gxs1GWTLcC3U0ybod+FfrdQ1c9oWzuchtGChNZKq2nyAMUc1
         kxdawef9kUkmqlSHPsgCnHZPMIv3IOlgxTRk2tirUTEyojgFJCltOnrx2WG15BwQ3je0
         n3ZNX7K5CUzAfE20e2Dxzp0z47b3/vB+5PNY/CY42Kel8p/uMxcDUskNga+0OxgRp2xb
         PicDoWd+66yNQHISyJC+GRgcUnJTqvNPjMqfXSQjvd92XevhR3ygPBJfEKe/Bknhemj8
         w5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9f0Ku46RA66RnD1s7kuU6MfXVLxET4cBAuDiB4K0jo=;
        b=aGlyO2o+8viCmYjcyzlGDAnKLSZNb7VqT2odAYItzbHfPVbZnvaiF7Zy6C4WEAnC9x
         5vEFWzatCPFemKmLG2GgDP47+6Hw/rcR1fmeYI4AQ4E88Dnaqi9OqOGBje7BoJOY7uTM
         aNuQV3q67vwGfXuCCKpIO9pgt4kp3bOAnhyu9Xu8q3+RHnhl1jL/4wxpER3Gfx6Th9qD
         LGEmIzHIBte0Tu+a238ZmMv+yf84yq1RivAIuVGiZdpL31vmGmXOa/HWy2+bjc/ZbhJg
         QvnnKMS4bJhzYF35ClfgHMGnLw7RWzLtslIBQFbqc9s+LNmNow2gSq65KjjdE7qP3Exb
         T5bA==
X-Gm-Message-State: AFqh2krqX20IDbaGxHwWKzfr5vCX3IbSURmpZGmsyVuuDcBYFJVZKUpB
        C6vyJsN+c+teyBxLYEo+kZ9Q1IK9eU9anDRC6+w=
X-Google-Smtp-Source: AMrXdXv1cWk7WRfGZmpcIsItp3bo7jj6WSSFpyl7S5bxWUESTspHxw7ZZxcB3d5+O6/H8EnzFQ6TXHGagMzUc7qkZeg=
X-Received: by 2002:a17:90a:94cc:b0:219:8198:c121 with SMTP id
 j12-20020a17090a94cc00b002198198c121mr1248525pjw.139.1671400913218; Sun, 18
 Dec 2022 14:01:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:cc94:b0:346:f765:548d with HTTP; Sun, 18 Dec 2022
 14:01:52 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <hyep1657@gmail.com>
Date:   Sun, 18 Dec 2022 23:01:52 +0100
Message-ID: <CAKeFKLT9t9s4sYq0f=Cvsc3046Hy33gwhodLNdQWKiZJV+iA6w@mail.gmail.com>
Subject: REPLY TO HAVE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:635 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4987]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hyep1657[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hyep1657[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

I am Ms Nadage Lassou,I have important discussIon with you for your benefit=
.
Thanks for your time and =C2=A0Attention.
Regards.
Ms Nadage Lassou
