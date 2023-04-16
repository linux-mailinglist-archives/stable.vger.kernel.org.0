Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6323F6E3516
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 06:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDPEza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 00:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDPEz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 00:55:29 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AB326BB
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 21:55:27 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n203so10952486ybg.6
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 21:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681620926; x=1684212926;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVu7EqIbWkNlmwNlipJ46UoFCevsxuPg12JPiUAToRs=;
        b=qnZ3QpEe7yAPgrvSFibm18Zx+r64pQDjQOaUS4bM7CagldF8drzI0krMYgrtGN2EB5
         3Qo+Aet6E3NSUmUJ8KEBhLIBVdaICbvdOVW9qihIYvgDGU+sShwJpjxsXcHxyyNS5Wyo
         f5CLw+qbUxftz2GT0bObXnGa21BpGs9dEI995zZSLnagJ0vHUQfocXBDcUxHsK9SjVl6
         XqqJndu+adnH7zusBhSRLZBAjjcIfdasmoPCecfzg/6nBXPagy0lLFXcoTfd64SSBR8G
         PXrKvtElw7DmJbyvJYRZ5ZoB16dvDNWIJBv5P5sYZsSS2fXjOokKTLs+kcdD7pygdYxa
         dQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681620926; x=1684212926;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVu7EqIbWkNlmwNlipJ46UoFCevsxuPg12JPiUAToRs=;
        b=OdiGvlbYOwqAWbeqEQfuAqMkNA9pT1aHJczDYxSmCTa/+HJeqJh+4xh0gYW1dUBEpi
         phRH4/Ic6zAHEvrVT7+fu9Px2QbEkLqZ8erfCCS5kGQTMJxyJ6SZDrDf+ZVFeWlNCpIm
         i2wumEc/ghluG901/W7AZIyg0TMjCS7swx/5d4q/+7p3dx3fEaeOx8Zuvo2PY3dcBXZT
         cd5xWW7fKQzD1Wcls2+JydQCm2MlSMU4aVR1DCWLEeKt3kx3Rk9VWEu6Zftry4a2wrKz
         Wf4cNTlT1whhM23mOh5qW2ZZlbQTN6GJ3y9kMApgvjvkepMjp4oYQVHJKRYy+rudDlNE
         L8dw==
X-Gm-Message-State: AAQBX9dNhM0q7bQLjYcA8avLTTWwlQ4VUlIO6C5Ul70zLvFDkau3yQua
        JNleR/6YEZPi7z2yG1mLGGAW7wSZqZFZFBV2Mfk=
X-Google-Smtp-Source: AKy350Y8Og/BGywe6QN95eqBk/6M4SG/hFxXAe36vxoe/mASIGOvXn728DnsbrEql5SJTRCvYoI+7FJtiFLqLDbO4QI=
X-Received: by 2002:a25:8488:0:b0:b8f:5b11:6d6c with SMTP id
 v8-20020a258488000000b00b8f5b116d6cmr6501823ybk.1.1681620926463; Sat, 15 Apr
 2023 21:55:26 -0700 (PDT)
MIME-Version: 1.0
Sender: hamidououedraogo879@gmail.com
Received: by 2002:a05:7010:6445:b0:347:b8a9:352c with HTTP; Sat, 15 Apr 2023
 21:55:26 -0700 (PDT)
From:   "Mrs. Bill Chantal Govo Desmond" <mrsbillchantal.govo@gmail.com>
Date:   Sat, 15 Apr 2023 21:55:26 -0700
X-Google-Sender-Auth: MSvtAjtyjK0jGiB-Y_xvxVs61K8
Message-ID: <CA+CjZ=B5Pz5Mdw8+0-y2yKpfBw9vuL7BchAAVqPputx9S-VPFQ@mail.gmail.com>
Subject: Hello Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Good Day, you have been compensated with the sum of 3.6 million
U.s dollars in this united nation.

The payment will be issue into atm visa card and send to
You from the Santander bank of Spain.

We need your address and your whatsaap number.
 My email.ID (mrsbillchantal.govo@gmail.com)

Thanks
From
Mrs. Bill Chantal Govo Desmond
