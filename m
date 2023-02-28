Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75C6A598F
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 13:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjB1M5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 07:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 07:57:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60702C656
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 04:57:28 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e37so7149037wri.10
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 04:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677589047;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GhlkRwo0/MVQ8IqGxOda4TidL5dTyhOZwe41sBSABC0=;
        b=SfIU6Jsank7N6tThHqfwf1LYqUmLO7Trf8e6xWvn14TqqpXQ7MZHexMcjNPggnBAVU
         IIps1E2tbvoiGO1ZCc9S8a9yu66/q0fwx0A7ijLyAn05CCKMhggmAQeLVB1ETI84jsmj
         CqEwuG0tQNcFNrgQ/EDZHAwsRoopc9IOIcqs+zVHJFhjWms8wjHefRzAtimmLEr8lGEp
         tUNBkdDNRc45I7CdBU3MPghwJmUx/Y1SeIVmfv0K/eoBWIBUR/ucWdJ91PWNnaApSHhX
         e4YTOFoGo+7nvppr3r2qav7L9QWrPJIWRaSkcFNlPP3KxMuhDg45oA+hLl+iR5IzBwCI
         H48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677589047;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhlkRwo0/MVQ8IqGxOda4TidL5dTyhOZwe41sBSABC0=;
        b=Pcqk/Adcqf8NIcyTSFJCFIcxG1Iny6WfjVb9X71VzXrgZ5QIiGVsRGbwEU409ruXHQ
         UFXxDMia1lVCf2dS24Y9F+eNgAhV9Rd6ubln650vXvlRxmlVdMbE3gOL2HL7eU0llX/1
         GxM7NfJxPUWrmHagrklUQjJAdOrDD+im4Wgfu+ZVU49hPJZu2cTsTnEt4hAHr9iuuVBU
         xe4hVxxaROmAcJWwvDD+LDNO6GJ2yFaDwjKCyANxO8lapsY7M4lCVf5ISsoQjWbggXA0
         zMlOEaiI1mZg98nNWZQ9nsV8xORUuJv0G2PrnuJqFJODiwvEdBoadeBArqUR4531uqMn
         9hMw==
X-Gm-Message-State: AO0yUKXK/pDayT/lCCNP3EvizmsQs2RQP5WN8GpI1zIy3Ra2Uqe6rbp1
        ueep7YCnR+U2fvaS6oJot7C7PYLeR19Pr+Zx0HY=
X-Google-Smtp-Source: AK7set9u10oAqA3s5o5cihTWUOASk7zfLJ3G4DKFGoI/ulx74OxhuVYzJcRmkS8BHzauIbig6EQo3SbXCCfti4AJOu4=
X-Received: by 2002:a5d:4d81:0:b0:2c5:7eb5:97a6 with SMTP id
 b1-20020a5d4d81000000b002c57eb597a6mr548188wru.12.1677589047180; Tue, 28 Feb
 2023 04:57:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:e18a:0:0:0:0:0 with HTTP; Tue, 28 Feb 2023 04:57:26
 -0800 (PST)
Reply-To: silverlynrojas94@gmail.com
From:   silverl ynrojas <koudjoro.kk@gmail.com>
Date:   Tue, 28 Feb 2023 12:57:26 +0000
Message-ID: <CADMyR2M_4FCS6x5CM7ENQycZNrGcUDUUVqX=T1AzTuDFr9+Bug@mail.gmail.com>
Subject: Ahoj
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:432 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koudjoro.kk[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [silverlynrojas94[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
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
