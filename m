Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30B16DBF6B
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 12:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDIKSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 06:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIKSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 06:18:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1054239
        for <stable@vger.kernel.org>; Sun,  9 Apr 2023 03:18:14 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g19so46247996lfr.9
        for <stable@vger.kernel.org>; Sun, 09 Apr 2023 03:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681035492; x=1683627492;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vE40mJuVkISt0zg8IVAmmNvtPq9ArtEbvKSLEgCOttk=;
        b=e2gcPU+jHaX3nrJ3GX7Jg13jdLT1Xx7hmlSERzL4krlvO+NF/daZPRK5JffwtcBdzb
         6AaYAQVWTUgw9JK0ErVvMius5wyJWqk/2z0bmsCeSMbag6E8F4/8Fk7WQpSFsgeS2VHU
         hNfmOez4e1tu2VmF75yH5WK1FDVJR7o+WYkG2ObIRZn2TKpDFpk8Ccf0Yll3DErxvcBd
         3GNirHeWKa8x7OkXHBZrnwF5zqzili/5q7zm4OJ50RC2kGtXUcQV2HLuvBirZxXIS6wD
         f8ihX/CQM+HO+s+p39CVJaS+wcY9O0uUpxII60EVk4G65ysENdLxZy7qA/6Z8a+D+ue6
         4Yfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681035492; x=1683627492;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vE40mJuVkISt0zg8IVAmmNvtPq9ArtEbvKSLEgCOttk=;
        b=HbfvLxUe8NDaeU7aa5jYpbrQtZaiKpu0e6fD/0MUr8r6dru5eNa5xOJ7dM1MuqTCj4
         MpmN2MoxPZYjmFRywyGQzvqq4yBHD9jPavn/vcBHSuMg+OoerUhU1D5pKKieZifUzlTt
         blCDcHd5DdaA6/PS/hdJjLix9k5/dGa4InkwUZOx+eOfjhlbzOaFWQHnoPhZ2arvlqI/
         4JoEAXXBg3G+v2qVh4l9+uKylDfys4yyT7z5pQZUe9nT1WBYCcQxm1aqjDtDvAwQe7Q2
         ERl1fRYYg/rZVfLwSlAo75CXAZcQ9XE4nGnkdEcEKIcjAPTNnX/jjiA8wSRS3zFQ/r4v
         kQqQ==
X-Gm-Message-State: AAQBX9eVwY3yQv0KfBNeO9thMlzHCbuLQEBMPX01qFjFH7u7zwtWEamM
        ovFh+tyoWFSuYtMYDCm5yIzpFB2XYP3mqWHQLIc=
X-Google-Smtp-Source: AKy350bSsSjyBv0ibwuVq4bhpcUY5ArvjB0zxgQjKFZ523JgZqENTbUzQ1vIpL4dW2bk7Z60cvuQosOTGUMiCPcX17g=
X-Received: by 2002:ac2:4908:0:b0:4e9:b146:1fc9 with SMTP id
 n8-20020ac24908000000b004e9b1461fc9mr1099787lfi.8.1681035492268; Sun, 09 Apr
 2023 03:18:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:63cf:0:b0:224:2f90:549e with HTTP; Sun, 9 Apr 2023
 03:18:11 -0700 (PDT)
Reply-To: saguadshj564@gmail.com
From:   MS NADAGE LASSOU <pjihin96@gmail.com>
Date:   Sun, 9 Apr 2023 11:18:11 +0100
Message-ID: <CADXuY1chRaA7EYjtbTVe_0zcrBtr8=nwwQTiJQHKo+BUbfqBMg@mail.gmail.com>
Subject: PLEASE REPLY BACK URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have something important to discuss with you.
i will send you the details once i hear from you.
Thanks,
Ms Nadage Lassou
