Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475006165D2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 16:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKBPQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 11:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBPQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 11:16:29 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97316DFED
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 08:16:28 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id t62so8692910oib.12
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 08:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=kzwABXZnkM6VwLBnkGMtr1OWPxHJuV29816+jCVmahwnties2nf1HCCwyk/W7z0m2K
         DIFnZdxDfsqz8R1t9EFIsFaS4Bmx8tzhTJsMOjAcHw4xcitl+IcAe+ZP5qnZtVQ6ZPP+
         PRnd5q41iAP4pm+ysu3yOSzvBz0JDB9TYPWYRI2gcIddYO45dljDPBmAo41UZv1JMmyB
         RUDBpe7XTRa+/ulM3VEBNcmCT1N25LqhVGTgKD/26q+BH1jI36F47vxr23yKdLrrPFvD
         T+Us0Y3cpGAfeZC9czuQBp61ZGQKtBJebtQKn0CknnK49cbOSkYP+ZClVFnyAL61oi/E
         5DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=GUE2X7XWY5QH0HCI67diBbE8UbzeQFU4+++R+LI2kBEspg4sTZ6OnDGJO4UL3CgU24
         COvXerPJK4UNVYIX2WTIFPTTLPkx9DZrfNsyWOEbGU6Ja3mD5T77Gnqv1uWVxziji/44
         vyDucTcQBk4yKeQwA8uHUac1LoVWJ1sIWNyu+ZEDM33xHWfxQ8KBDMm6ZUALFyfMrpvW
         W+1cYM2dOrTZirsNe6GsA4zMitx7MQfPy+miIWyateudOHjLamGyscBUpFuN/z3pMFWa
         k8DWImAZRuGGfmOYBIvhPKNY6d8qQOsS3qy4nN9KpV9IkT9/QfVKJRXi7MMBVJHGKxQK
         InPw==
X-Gm-Message-State: ACrzQf2U7tlXkiGcxpUsIFIMwxo83Aea5P8viZibPWQQ/i4htgGbiEm3
        11RZsYkfYYJADFOUVzqOHEvsY29W8fDUHt4ZdJY=
X-Google-Smtp-Source: AMsMyM7saFosgEjWlib0GK3KswfjgEKw0pmoj3LusnULH1Jq1/SkkrN8snIQhsumRy64v+DHooUiPmbcNhpWikXYpHY=
X-Received: by 2002:a54:4618:0:b0:35a:1fa4:30a4 with SMTP id
 p24-20020a544618000000b0035a1fa430a4mr6883905oip.15.1667402187882; Wed, 02
 Nov 2022 08:16:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:2ac6:b0:da:7c1e:ee26 with HTTP; Wed, 2 Nov 2022
 08:16:27 -0700 (PDT)
Reply-To: subik7633@gmail.com
From:   Susan Bikram <redw07882@gmail.com>
Date:   Wed, 2 Nov 2022 08:16:27 -0700
Message-ID: <CAND8bMLadVDjLxU+KbREsXVCpJn+gfWsZmXw5VT-QevcxONaUw@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:229 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [redw07882[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [subik7633[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [redw07882[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
