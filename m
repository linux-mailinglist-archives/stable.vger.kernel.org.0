Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC3516C5A
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 10:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383851AbiEBIuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 04:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383657AbiEBIuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 04:50:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C51329808
        for <stable@vger.kernel.org>; Mon,  2 May 2022 01:46:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 15so11222828pgf.4
        for <stable@vger.kernel.org>; Mon, 02 May 2022 01:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=MH9GoXRahu4SMmYhSvghO17RCo5GfuiftTiQ2WPDRzo=;
        b=EiqWkFE+/Y4xWokxMjTLJ/kAeLVkzsMUCJvgY1cFzB1n6b57HewSvSg7GuxlhBN+Wp
         La0gxFi+PEX33xD/1E7SV0dXpdcflvaBEWmhQl7elsFfN30jZs+43lkv0Y3DSLDnXS6n
         Hk8nooZuAOt0JCCT6Ct9Bew4VE3wGudjx5ejwbiLQRAoDPoS+sRLKhqBMfzoPuET2Hde
         8axIx1fhnvgeJyYioduWDJyJEkCrJPNTyCWh+lp55zFiTy6HAOYSa3fqR4h9ZTWiLctO
         c094g2LO+6d1p6iDZHPBluyxFVU4ST3uGRjZJsicpmqQmzsZnRgq3cKrtI0sTB7C/IWn
         yk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=MH9GoXRahu4SMmYhSvghO17RCo5GfuiftTiQ2WPDRzo=;
        b=LKG96aXRtogBgZ3pjzQzkcHeehUP+wy350UfP07hIQK6kuVy5q8PCW/Jsr/YHCRu18
         g+DvJOHFrnhmfmAmLFhbx/5cblL/vBqNuEd7/9TQh6Getp9VFeqnHlOC6DivFjLs3+aU
         pvO+6GCum/gb6cGGdxnMQcmJ48q++xsHCXdaYGfuM87OIbIgEvWEhoy1NfFP8QQTrMc4
         BlZ3uuj0jhcZj9j9VnQLyIHf7kwxyr/GD7N7aaNZkxvfAoupjwT5t/mzIldvllwHHYAG
         qZhyzulyyKTigLqBcUdGLx/SZMOFnB9PUhG61oj3m9Dj5WgwlXLMXoC4f9xaGkgZdpH9
         VySA==
X-Gm-Message-State: AOAM530mhDdBY/maQjrBw3YM5eMDCHpc3NjUpnojk5pGiGtPGBhApgdo
        uXNWbrnTnfThvr21/MIuMJB2CLjFC006bMaiRhE=
X-Google-Smtp-Source: ABdhPJwCRbivkRIsYQjpbBvaeLj08QjsHveG2QPhcDFKql5D4wa0lbFdW/BPFcznx6LV1Qe9wU8WMeDgWQl3uvHNI/Y=
X-Received: by 2002:a63:5223:0:b0:39d:2318:f99d with SMTP id
 g35-20020a635223000000b0039d2318f99dmr8785633pgb.268.1651481197350; Mon, 02
 May 2022 01:46:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:8d6:b0:4ac:283b:9c08 with HTTP; Mon, 2 May 2022
 01:46:36 -0700 (PDT)
Reply-To: adilnla372@gmail.com
From:   =?UTF-8?B?TmHDr2xh?= <sanchez43florence@gmail.com>
Date:   Mon, 2 May 2022 10:46:36 +0200
Message-ID: <CAP_Nrfxk_HpWJ=o4BzGgtrsGpvd=DiLm18pACE0_jc4iykgSsA@mail.gmail.com>
Subject: Hospital Message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sanchez43florence[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [adilnla372[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
My humble greetings,

Dear friend, how are you. I have a charity fundraiser that I am
Donate with your help. Try contacting me for more information.
I'll tell you more about myself and my plans with this money when I am
To hear from you.

I'm waiting for your reply so I can give you more details.
