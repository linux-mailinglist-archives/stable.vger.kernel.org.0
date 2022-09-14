Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC65B8F73
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 22:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiINUBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 16:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiINUBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 16:01:36 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B183BFF
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 13:01:30 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-11e9a7135easo44029861fac.6
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 13:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=BbPIabeYxp+htvQq4h4fipPdXH2O0nKzw2UilQe7Pmz4K67asJgz1nVDctnBhbmb8Z
         8ZyUg/X4iWHL7syby6iRb/YJxfo4t5aptFRxXyFzAihRmE4mt8SmNNas/vLJzWE7V2jo
         n9APU1FrGZs7pZOkEPBlHxZewVHVlO7gYcrtPUUb8si2GtUZv7yG3g+rUahcDfS3i0y6
         bsCmENsPC63Ysh6172kPEPEcGrp955dJaPkv3IMl1y9IJ/ggxc76Ue70dbBqFXbD2ZuM
         j0F3DAbPiYt1Xo+T0ejQ4dmypMGKhQZsFqCYdcxnWZ8/7u1QB4vfRaUhwPH1dmiIzAsC
         A7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=mX8Q0VMDA599G8UoNbzumlI9+OdfTV8ypaXNCgVbzr9nIjhs32xORML4jsopPb7IZk
         5L6J0aLtED5dp7MEkuGwjdCSGfytWW7YSFCqrPpNEmcCxUUuhmBFJxkVsCaCPwPA2GBo
         G/JnpZ1nGB2b7vQ7gy07ErWxpzmK5juAa5O6cJmerMxJhDcVCqnlkBrqP21apnFhbAJ+
         BWMQ2M/hyW6LbDGH8+6VthKBSd3O9h5wcTRwIsenGXp2runmzbVeNFPlaKNolwJnqAXz
         J6fTHhpFkZPNMtUSecB2x/XS8DsFIzCzgeBktIAbbWyhfIeHh1wIHDDRiGbujZR+ds8E
         BWjA==
X-Gm-Message-State: ACgBeo2EpVK5PzpQZHm9fLffH0se5UZdLQfdkIg2fAyjs9+4lGaa/YSD
        qNlJdv9kYQJrROhoRt32buk4TNQiYyd3dtpo3Pw=
X-Google-Smtp-Source: AA6agR5K70Ur60cLXd5UoQgrFsMI1QFmxq4lUAdoXnJZmaj1siWGCE2rNSpLPX9HmMrrsd9csqeUmFNmoyE9C7jnh/A=
X-Received: by 2002:a05:6808:3187:b0:350:3194:c29e with SMTP id
 cd7-20020a056808318700b003503194c29emr284991oib.174.1663185690372; Wed, 14
 Sep 2022 13:01:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:7e8a:b0:a1:ada:7451 with HTTP; Wed, 14 Sep 2022
 13:01:30 -0700 (PDT)
Reply-To: maryalbertt00045@gmail.com
From:   Mary Albert <desouzabayi7@gmail.com>
Date:   Wed, 14 Sep 2022 21:01:30 +0100
Message-ID: <CADVjuPps-624-AP=9mp=nVXSiVs9E+o9Apk7JHLxpqmAToogKQ@mail.gmail.com>
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
        *      [2001:4860:4864:20:0:0:0:35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [desouzabayi7[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [desouzabayi7[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbertt00045[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
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
Hello,
how are you?
