Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C506A54DF
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 09:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjB1I4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 03:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjB1I4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 03:56:09 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D84F4EF8
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:56:08 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c4so2315009pfl.0
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677574567;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GhlkRwo0/MVQ8IqGxOda4TidL5dTyhOZwe41sBSABC0=;
        b=ln9/6ZtYP29uvnVnn38STV5PJMsnzOW6y1nl+4zNKPPIxgknhkTGTr6Wb2F4O9k1/w
         3e3JuKABndT8xGT9q4nSHi1rS2elH7wtO6zVEW5nszqaWiHkEBZ7t6/0WusZkjeWUmtE
         SP7sUtr3qxGj8aLx8A6ig6sms8vEzBrjTh9SlbCxR+BkKrCq1ZCGrnFw8hbyFcNgmluk
         jFgKpo6hO/GzKuE801FruK0ymNumUkOcXFqu7pkdIc/FhnqD3IdvVqRvhZT7/Lr8gqon
         yj6i4wCwwhkvuZ43ImL3libI71Hxdi4NOh8ZZguV9eLAV+s6GzQ2p8Rjkni6bB6Xc5U0
         HQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677574567;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhlkRwo0/MVQ8IqGxOda4TidL5dTyhOZwe41sBSABC0=;
        b=SQ2Sq1bP8bLW9j9b1v8gbLld7c6e7YiRv0a6Ki8jeLfHrJkhWQikPK/XwAca7YEuLq
         Bla5lZTrFHBGRE6q7G63Zn2EviuqQi8NutQ6hJ8r1O1L7DGGRU8NRqmnqoliH3WgaE7b
         QT8k/0SpegQ1YvmjWrUu3jA88wyLBZrE3mupfg3wqiM8cDf02c8dUs13i4vwLmHwDAuW
         wL3+yel472a87SX98h82T1/rRt8XLq4NxxzeYBxy35GSos9k2KdYkeIdbk5hKrGo7QB7
         sVJFf006DVI0BJaPXj7gWDFR07E3qojCKuq8jDmNrHVSEyZVW2yNxcm8YzUWqBzd1pEL
         l6wQ==
X-Gm-Message-State: AO0yUKWdJlQ0vuFW+UTP2iiDbSmBqEUsqgxSzliTJbF25vmzli93H3Ia
        GIz92fOB6gj5aAuDKgRicFZGzx7B/KjzHE1UwKk=
X-Google-Smtp-Source: AK7set8V7DpV8KgA+t0gYBZMUzx+rvgkvqWpGtqB0No4ar5DdbtWZK07TPVjy4ZE0YsxjsCVGjQYi80r8sJiaXw0nhk=
X-Received: by 2002:a65:6944:0:b0:4fd:2170:b2da with SMTP id
 w4-20020a656944000000b004fd2170b2damr510174pgq.0.1677574567656; Tue, 28 Feb
 2023 00:56:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:ed04:b0:444:fffe:1bd with HTTP; Tue, 28 Feb 2023
 00:56:06 -0800 (PST)
Reply-To: silverlynrojas94@gmail.com
From:   silverl ynrojas <bdelyandi@gmail.com>
Date:   Tue, 28 Feb 2023 08:56:06 +0000
Message-ID: <CALtJeBhaocVKQqr8cRitGuRJcdzaJ-Js8DGyNeMfrn8CkkpsOQ@mail.gmail.com>
Subject: Ahoj
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:432 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4446]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bdelyandi[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [silverlynrojas94[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ZHJhaMO9IHDFmcOtdGVsaQ0KDQpKYWsgc2UgZG5lc2thIG3DocWhPyBNeXNsw61tLCDFvmUgdcW+
IGplIHRvIGRsb3VobywgY28ganNtZSBzcG9sdSBtbHV2aWxpDQpuYXBvc2xlZHkuIFYga2HFvmTD
qW0gcMWZw61wYWTEmyBWw6FzIGJ1ZHUgem5vdnUga29udGFrdG92YXQgb2hsZWRuxJsgbmHFocOt
DQpwxZllZGNob3rDrSB0cmFuc2FrY2UsIGt0ZXLDoSB1IFbDoXMgbmVieWxhIMO6c3DEm8WhbsOh
LiBWYcWhZSBzcG9sdXByw6FjZSBzZQ0KbW5vdSBib2h1xb5lbCBuZW3Fr8W+ZSBkb2tvbsSNaXQg
cMWZZXZvZCBmaW5hbsSNbsOtY2ggcHJvc3TFmWVka8WvLiBOZXbDrW0sDQptb8W+bsOhIHByb3Rv
LCDFvmUgc2UgbXVzw61tIHNtw63FmWl0IHNlIHN2w71tIHrDoWptZW0gbyBwxZnDrXBhZC4NCg0K
ViBrYcW+ZMOpbSBwxZnDrXBhZMSbIGpzZW0gcsOhZCwgxb5lIG1vaHUgb3puw6FtaXQgw7pzcMSb
Y2ggcMWZaSBwxZlpasOtbcOhbsOtDQpmaW5hbsSNbsOtY2ggcHJvc3TFmWVka8WvIHDFmWV2ZWRl
bsO9Y2ggbm92w71tIHBhcnRuZXJlbSB6IFZlbmV6dWVseS4NCk1vbWVudMOhbG7EmyBqc2VtIHZl
IFZlbmV6dWVsZSBrdsWvbGkgaW52ZXN0aWNpLiBOZXphcG9tbsSbbCBqc2VtIHbFoWFrIG5hDQpz
dsOpIHDFmWVkY2hvesOtIHNuYcW+ZW7DrSBhIHNuYcW+aWwganNlbSBzZSBtaSBzIHDFmWV2b2Rl
bSBmb25kdSBwb21vY2ksIGkNCmtkecW+IGpzbWUgbmVtb2hsaSBkb2rDrXQga2Uga29ua3LDqXRu
w61tdSB6w6F2xJtydS4gRMOta3kgbcOpIHNuYXplIHBvbW9jaQ0KbW7EmyBqc21lIHNlIHMgbcO9
bSBub3bDvW0gcGFydG5lcmVtIHJvemhvZGxpIHZyw6F0aXQgdsOhbSA4NTAgMDAwICQsDQphYnlz
dGUgc2kgcyBuw6FtaSBtb2hsaSB1xb7DrXZhdCByYWRvc3RpIGEgxaF0xJtzdMOtLg0KDQpOZWNo
YWwganNlbSB2YcWhZSBrb21wZW56YcSNbsOtIHbDrXp1bSBwcm8gc3ZvdSBzZWtyZXTDocWZa3Us
IGFieSBtaSBwb21vaGxhDQpwb2RhdCDFvsOhZG9zdC4gTnluw60ga29udGFrdHVqdGUgbW91IHNl
a3JldMOhxZlrdSB2IFRvZ3UsIGptZW51amUgc2UgcGFuw60NClNpbHZlcmx5IFJvamFzIGEgamVq
w60gZS1tYWlsb3bDoSBhZHJlc2EgamUNCihzaWx2ZXJseW5yb2phczk0QGdtYWlsLmNvbSkuIMWY
ZWtuxJt0ZSBqw60sIGFieSB2w6FtIHBvc2xhbGEga2FydHUgVmlzYSB2DQpob2Rub3TEmyA4NTAg
MDAwIFVTRC4gViBzb3XEjWFzbsOpIGRvYsSbIGpzZW0gdmVsbWkgemFuZXByw6F6ZG7Em24gdmUN
ClZlbmV6dWVsZSBrdsWvbGkgaW52ZXN0acSNbsOtbSBwcm9qZWt0xa9tLCBrdGVyw6kgbcOhbSBz
ZSBzdsO9bSBub3bDvW0NCnBhcnRuZXJlbS4gUnljaGxlIGtvbnRha3R1anRlIHBhbsOtIFNpbHZl
cmx5IFJvamFzb3ZvdSBhIGRlanRlIGrDrQ0KdsSbZMSbdCwga2FtIG3DoSBwb3NsYXQgxI1la2Fq
w61jw60gdsOtenVtLiBLYXJ0YSB2w6FtIGJ1ZGUgb2JyYXRlbSB6YXNsw6FuYS4NClDFmWVqaSB2
w6FtIHbFoWUgbmVqbGVwxaHDrSB2ZSB2xaFlY2ggdmHFoWljaCBzbmFow6FjaC4NCg0KUyBwb3pk
cmF2ZW0NClJvYmVydCBHIE1vaGFtbWVkDQo=
