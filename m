Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880596A567E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 11:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB1KRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 05:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB1KRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 05:17:15 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E9319681
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:17:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ck15so37911170edb.0
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677579433;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzokvzxM0LCkG1USVcKNtdjW2vzZWsAXkdLnUMHy3RE=;
        b=cdHXUBgnEnuxwd0w0ApjqLeaAt8XP2LODP7DsjfQFIthYfYS6ilfo9HT/OFRX4egK+
         Donc5i6ASemF9lIOshh1Ua72RDwSPyh4Q/yRMprnpTEaowXRPW67nTw1AyaD8kpfAD+u
         63PAZAx52TH1n/IO8eqZWBjWD7Dg0jy464K22TuXZ8C4qVZdOWB44guxsWt6vFcNmeMh
         j5Mj7c+1/ZD0OlEoDlsugsMvKHTOCE03rRhsMNfKz1oAbOj898riNRNdzRR0CZCxMIpQ
         970aaWTr6osMTEmtEUPVUECTizlO+RdZgZyoD6k4V9cfSzwI3nTPO1aWK3sgQOR4ma8y
         wvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677579433;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pzokvzxM0LCkG1USVcKNtdjW2vzZWsAXkdLnUMHy3RE=;
        b=SttAq9WxZX7agdVIDEjAbFmaa2Jtaf3hr1iPVOMlr55j0DQeYTxRdwSPl/illz2e5H
         BYYmmHMdyxvRrY3ttsdvcBOhLtWra18U8Q8ZqBNsDDCZ+NL4y1t0jXZESvHi0DHQ7jZO
         xCXZcrHYHAhausPpjtx3p44Y6torMiq0hvXPXG/UwX44CJSjAjIoy+dAgZ/PgmqycfTC
         UorGJlTO/aRNmKdleCOIrt7Vmt1ogspQcdBH1XqjBx8HWUhzYCfz8/4rUbG4/blrCO+O
         MlQTKxna03a6tlqT6v30FJQvzY3XX91MWWVnoPp+nlYVcm9JXc9T4dgboAi6OYKgPP4Y
         Oyyw==
X-Gm-Message-State: AO0yUKWQPLINfR2rCymI6GpbO/ZopiNWkMVRXRgTl8tcgJnX1dWqwUGo
        uDQAoXFbr8z4EpvMkjCmyhFSPAo45rITkOU+CRk=
X-Google-Smtp-Source: AK7set8CeU/13CxaaXNbE6psoCOHsjuGHUKAQeY2AdqpzVEEY9dAlfFyWknqFuRybvAMtHTU0lY+G9rZp+A3SDp0qmk=
X-Received: by 2002:a05:6512:402a:b0:4d5:ca32:6ed8 with SMTP id
 br42-20020a056512402a00b004d5ca326ed8mr1283792lfb.6.1677578946807; Tue, 28
 Feb 2023 02:09:06 -0800 (PST)
MIME-Version: 1.0
Sender: frankbillion112@gmail.com
Received: by 2002:a05:6504:171b:b0:222:2e59:9241 with HTTP; Tue, 28 Feb 2023
 02:09:05 -0800 (PST)
From:   Aisha Al-Gaddafi <aishaalgaddafi112@gmail.com>
Date:   Tue, 28 Feb 2023 11:09:05 +0100
X-Google-Sender-Auth: vTN52Rtvto2jg_RywIgbUS7ZhWU
Message-ID: <CANHURE7an2fQnCCrc0TdPkJMKCPY1ffH+d1d-Ad-WFdxgKG15w@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:532 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [frankbillion112[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishaalgaddafi112[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please, I have an investment Project transaction of US$27.500.000.00.
that involves transfer and I would like to have your advice on which
Investment / Industry that you think that can bring us profit.

If you're interested, kindly reply for more specific information on
this project.

Mr. Aisha Al-Gaddafi
