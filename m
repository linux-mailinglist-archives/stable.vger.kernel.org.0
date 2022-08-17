Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1759B5973C6
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbiHQQHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 12:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbiHQQHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 12:07:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2C89F76E
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 09:07:39 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-334dc616f86so70038277b3.8
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 09:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=p2x78/WQCLJNFEWzdhn4/Al1RTNZOb4LssUAtfBZhvs=;
        b=Swv06RaMipn6W+y7P0AJ4kcBDOsaRuHXuimIcXlOzegVLMVgPDlHZhx7NR853416g9
         BlLbyy7gyMrElXhP8+slP/JauxYZPbf7qVdaD6mghi9g719REqN/HusytgkdX04Pfz8Z
         SwaFZDU9Y+3McYtKuPgs9QjyF6nkvvyddyFjbePIWPWRxvQ1lg48DeqFzSGYHwz5+yK7
         F+6HQF8lLc5noT3A1oJRmD828bZjfiRKnvYtjlrZkDBcRAEqj1kDziKg8N+Xyae0rkib
         lEcRCTeIFYUNQib/LJyY1Yu5dyamlvbEeLkr3snBuc6e8GSSuiCPm9bGEz4Q7MKBKEAh
         pKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=p2x78/WQCLJNFEWzdhn4/Al1RTNZOb4LssUAtfBZhvs=;
        b=V+LLOshaotKYW6fAVWH4ZcHYokxsWg9uD1CXu/ruXe7QSq7p7AyXJM002pvxC5ByNp
         UEuUYzpFm9z7tDyvtPYmz1GLycxOKYWv5vQdWd3rCFX4Nn8750kC67gLiuN4VmtW9gTg
         UZYzc9sEVpa8qYMB+mmz1351W4tO26S8DywV9NeG232817PH8omFLH8WELoQi/4wLhSb
         i6Rv4A4lVSv951k5JwTiQNqhbu0Da1xL7xX5FL9vFsXTUKmtomVpc1oy6s6bDuPHF5Iu
         x3BLjtW2+kFrbmUMkv7J+ZXmzrOBSF0yyphfdGWvXRsAF2vzxO1od+FwuxZz3aflv7l8
         g7pQ==
X-Gm-Message-State: ACgBeo0jzDCHZnMgW9StIKpiYLqlEnFqNs83vjLANe8MDa7EEW2U2qNR
        YUindt5zh4q7Gni1Hxqi85mUEh5MjJL49a1rUg4PVkNoakZIV7Uu
X-Google-Smtp-Source: AA6agR5Ab+rt1oFa8W7qeyo+8kiyZqYCdphtRpL2nZ+igKEQeoSW8cuGuUfjDNNiMNsVQ/wW0nXPQNOIh565fcnxYfg=
X-Received: by 2002:a25:be03:0:b0:68f:2ce4:d83b with SMTP id
 h3-20020a25be03000000b0068f2ce4d83bmr5844842ybk.136.1660752458074; Wed, 17
 Aug 2022 09:07:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:210e:b0:ce:a442:9539 with HTTP; Wed, 17 Aug 2022
 09:07:37 -0700 (PDT)
Reply-To: us.army.jameswalton1@gmail.com
From:   Major James Walton <ibrahimmuhammadr32@gmail.com>
Date:   Wed, 17 Aug 2022 17:07:37 +0100
Message-ID: <CA+x0k49CtJmaqNabDigO1NGT2pK8czMR0r_VZeRD5cXKHRY3hg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ibrahimmuhammadr32[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ibrahimmuhammadr32[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [us.army.jameswalton1[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello

I am Major James Walton, currently serving with the 3rd Brigade
Support Battalion in Syria.
I have a proposal for you. Kindly reply for details. Reply to:
us.army.jameswalton1@gmail.com

Regards,
Major James Walton.
