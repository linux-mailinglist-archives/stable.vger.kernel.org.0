Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4196B1758
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 01:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjCIABi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 19:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCIABK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 19:01:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682B7D13D1
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 15:59:17 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so2447029wmb.3
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 15:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678319945;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1MqfsTDNMLK7+gh1fN7iAex3OlUpUvgCzJeLfH5gfk=;
        b=LIneLzoSTv34UFrU+BkgYyG/OFj36od+/b0DhqI267vw8GccWDZQeLP3IfHnqBJPsc
         g0qBFCFW5Hit9Ud9CgBJeM1NjPAWG1UC9vtbjY47uw9IzHriFd0HuFQvE6aed3zEIos+
         16EBAQA1C8lyzDElUzu6A0Y2Gx6j1ZeTlzjj/+GANNwyUi3ky/0kLbOUPFRHNdtg3sAt
         yxvmRxrBlVWMNg99IUvJYF8r0HvhaSDfhCpTnjodvTqRFnJ//qEONMJvCRJshw/TtUei
         DRs7k6+BL9/3NnDXcuItu9sb7olngA2ncDvYscAMrXkbFZgqXBlCxDK3FKGHbYF9PQeb
         vo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678319945;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1MqfsTDNMLK7+gh1fN7iAex3OlUpUvgCzJeLfH5gfk=;
        b=wvXaJb7CVZhj6FHMG0BRf/qYajGHFNyYkf0k1GpqB6h9NyeCy9qfailtO87ICXWWWA
         EU1Aw4jD86uYNhRAj5gAKSBKJM7X9DWeNdQeu04EFyK/TNvLNw1V2jcDNoWJSy8nWeqQ
         sK+MTl2stoHstmcnyJTyeJN/+5k7cis0nUnRz0QOCKgLG0Tps9gTVG+p0pXxM1dUAWSA
         QlZxWJjUbxFy0Pqj6YhJCLzAjJTyT95lfAVtbnCk7FzjtLlhy6/BA0u5mc+GUXcxD2bN
         DAXf0pWG7oYjoz6vSCBbn9g3nnLtW3I3ZE/DqhX9lT9ESL5Cg9iPTzSmbI6IYDhrBlSF
         Ey4Q==
X-Gm-Message-State: AO0yUKVYLBr1yZNTC9MHmuX+2xeX+3GU5lrM1hnyxJ/uea/k13kjYyKf
        iLV7AOVKKaewBxMqR7jdwspmmcsOf4jia6ACN9c=
X-Google-Smtp-Source: AK7set/mFC+i1NW61+e+DF8GaoX3VrwudwKve+vDq0mITsXGBefYdG9luX5VqACVC1Ui/64RoGYODspA58U5XDvs7RE=
X-Received: by 2002:a05:600c:1e20:b0:3df:97a1:75e8 with SMTP id
 ay32-20020a05600c1e2000b003df97a175e8mr9026476wmb.0.1678319944761; Wed, 08
 Mar 2023 15:59:04 -0800 (PST)
MIME-Version: 1.0
Sender: aishaibr868@gmail.com
Received: by 2002:a05:6020:c388:b0:261:f371:cb72 with HTTP; Wed, 8 Mar 2023
 15:59:04 -0800 (PST)
From:   "Mr.Patrick Joseph" <mrpatrickj95@gmail.com>
Date:   Wed, 8 Mar 2023 15:59:04 -0800
X-Google-Sender-Auth: fBGH0jiKHTPz56XzIuZCMMpoahQ
Message-ID: <CAPPPfrK5iPEQ+vHaT58Rop9Mb64iPYGrXbPdnJ52Ui9A=rMRjw@mail.gmail.com>
Subject: It's urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:335 listed in]
        [list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9827]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aishaibr868[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrpatrickj95[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good Day. I know this message might meet you in utmost surprise.
However, it's just my urgent need for a foreign partner that made me
to contact you for this mutually beneficial business when searching
for a good and reliable and trustworthy person. I need your urgent
assistance in transferring the sum of $28.5 million dollars currently
in my branch where I work. If you're interested please reply to me
immediately so I will let you know the next steps to follow.

Thanks.
Mr.Patrick Joseph.
