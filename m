Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A7664BA2E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbiLMQuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiLMQuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:50:17 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBD7B49
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:50:16 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ud5so37993855ejc.4
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRDHZJgN1WOatkSwWcHNN+BZgOmjHryvGA8jZd/gKug=;
        b=EenO/rNwBIM2RFoU9+VUHcDTbG907gHJ8FyPUIgRs5sdPgnu0kAPUkgI+zTef27MqI
         MajdyKjgsPey/reS7tRMQ3A+O25rYbsT6VHb/BBgHRbpE53DW7PpOx2Uep6Y1E0W8+ss
         4l5fqvjQLjPX5K5b4y8kud8G5pM6DK2PJdFHRxtVAcOjoMt2NqOdP3ekAj+3NQpFtM0B
         UTnpIujirAtcJC28ZCWRL+gF6AxCX4XFx87RfVM1iJr+hEmbW3heAPnYhDjIudI93qX1
         dbqrqyUVesAb3FX4jHaC5DFpYhj+vzbP6COEJal1mSdYdMOFlMLNnCg1F3V+4ky0vczV
         Qs7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRDHZJgN1WOatkSwWcHNN+BZgOmjHryvGA8jZd/gKug=;
        b=nhmhMorOX5LJBV2P+G1QIPOI8lKIIAhtabpW1v43292z7ubzWcOxyS0AUV4fxL/s0T
         +45VgW3Tp/q9b4J9qgoEB6ce64IyMvZhBerYTlCV+8Bn6aakQp8SLxgaAhh+0YccV5xN
         dtBuhwcvmQMtEqVDgbRGdAnnt6ydvQcD9Fh2+3L/WgReXfzo8QO9XYNjQcAH/5fx2JPm
         lXsymBQaNKzOIdyY/P2FVKZCvtbkbXwyr1+hi3ROa2KK/PSbfdUEJ8RhfQgeSfYs7QcQ
         haKqT+aoX2n0ww7n4QOiMZRsqaX8Uka2fVAJIlyr4z5D17/MWEwj+LaD4/67p3nowINM
         JT4A==
X-Gm-Message-State: ANoB5plz0UPmhFF8DjVjWY4GHxyeySj1tPhvj7YEcQfHpNpW38JmCM8o
        L8wvCHYgKIPclXiAyt4Iq7hceLsf9GbT2FktORs=
X-Google-Smtp-Source: AA0mqf6gjUDPU8ufQvOW1aTgvCynJiOXwPzZjKDNRFUXtuWpeE+L4TARL+nvIepSqc8VOPIykO2/mo1y9d72m2rgR1E=
X-Received: by 2002:a17:907:2c68:b0:7c0:999d:1767 with SMTP id
 ib8-20020a1709072c6800b007c0999d1767mr32291748ejc.301.1670950214483; Tue, 13
 Dec 2022 08:50:14 -0800 (PST)
MIME-Version: 1.0
Sender: lruby0209@gmail.com
Received: by 2002:a17:906:3384:b0:78d:f24b:7329 with HTTP; Tue, 13 Dec 2022
 08:50:12 -0800 (PST)
From:   Aisha Al-Gaddafi <aishaalgaddafi112@gmail.com>
Date:   Tue, 13 Dec 2022 17:50:12 +0100
X-Google-Sender-Auth: npWs8mS6N1QiwIFmHJo72WHO8O4
Message-ID: <CAEPObtMZpgiskVEQYYvGvD7G5tvDBwLhgh0=P_OUidssszfznQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        MILLION_USD,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lruby0209[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lruby0209[at]gmail.com]
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.6 MILLION_USD BODY: Talks about millions of dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello
With sincerity of purpose I wish to communicate with you seeking your
acceptance towards investing in your country under your Management as
my foreign investor/business partner.
I'm Mrs. Aisha Al-Gaddafi, the only biological Daughter of the late
Libyan President (Late Colonel Muammar Gaddafi) I'm a single Mother
and a widow with three Children, presently residing herein Oman the
Southeastern coast of the Arabian Peninsula in Western Asia. I have
investment funds worth Twenty Seven Million Five Hundred Thousand
United State Dollars ($27.500.000.00 ) which I want to entrust to you
for the investment project in your country.

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds.

Best Regards
Mrs. Aisha Al-Gaddafi.
