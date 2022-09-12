Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411395B5D0A
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiILPWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILPWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:22:37 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FCA1F2E2
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:22:36 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 198so8263929ybc.1
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date;
        bh=MbE5/R0x/uLTcGo1XaQOPDK9fXe06AjBY6BMQ4dhUXg=;
        b=MaJmKK1xp1vjqWOhCzUIT+X8Xx5jqLwocndf+TdxHoWGcygn0awtmNYkP43TdtapaQ
         DizHaEnRRx64Tij201BIdeTRU8zHYGxBWdQbPh+HEoQKVxe9XoE58FBdWaBZjqw7u5TY
         iWw8+R21OlQsisMCxYux7KGdcWzcePmhEvh8s0pQGcV/THs78PfJ8hdQIslknfVS/WyL
         pKX4LaZWfi3jzBwrW9jqE4LbuIcocO9gfoVcRPXfTbwjER6zTs4FBrwXYkMCkvljD2nT
         BYtz5+KlW/+HYGtV/Zj4I8XNDg7PXMbCfmB3kQOPBl6wc+fi1oL8o10yErKtZnIrIdKd
         DmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MbE5/R0x/uLTcGo1XaQOPDK9fXe06AjBY6BMQ4dhUXg=;
        b=EUCUZqmkZSkHs7K7IlNzVef0dnsxqLTxAK3dPcButvpepk3mzLHt01h4Pq4nDBimp0
         I3KmVLgI2q3RuEfvJj4n/a25MjMpGrDspKUWeRF0p+67LH+KywxnYGFP+S+2GKxW1VJa
         191F2N2oIn+z5o6tVSmUbUeUAT1Xms0Lwvno+GJeyb5RmvpG/+6bI9lmH2ciYunDwPJn
         anifMSfSA4zxM5lSGc6LjxZlEggYFqqlxiWmHFyXTmtdtLMzKuyRthuj++lgMr4rEcwM
         hIZzg0GjASSi9G8FJBPFIebanPjKXOXHR3C/sK4dRvCNtSD3Bv8EWAwEK01Qwms+Fik0
         W9Hw==
X-Gm-Message-State: ACgBeo1lKBb//lsJtbtpX8eLEoKeVfUIiZGA686BcC/q6CHPIAtV9E6Y
        x+8e9e4M9GNes6/o9vI5cRp8YcCDu9Mln5hvyWE=
X-Google-Smtp-Source: AA6agR7gJb/3ga1xvIWtytoJ91ZQcfAZ95IbA1FDhQLdfCQqSOMxC3xERbOAplsF5lP8rpFtpMB+uZUzoq9qTf6PpNM=
X-Received: by 2002:a25:4e43:0:b0:6a7:4012:4856 with SMTP id
 c64-20020a254e43000000b006a740124856mr22886549ybb.177.1662996154656; Mon, 12
 Sep 2022 08:22:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: issasalif505@gmail.com
Received: by 2002:a05:7010:5925:b0:2ef:6bab:eaf0 with HTTP; Mon, 12 Sep 2022
 08:22:34 -0700 (PDT)
From:   Zahiri Keen <mrzahirikeen1@gmail.com>
Date:   Mon, 12 Sep 2022 15:22:34 +0000
X-Google-Sender-Auth: xpJL3Gm7LtQ2Fh1c_xPdJnjw0ns
Message-ID: <CAO1GMARmjLVir0UXqVEmE2FZhyMPCBsRjP0KcZ6xre4bXO1NpA@mail.gmail.com>
Subject: URGENT.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [issasalif505[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrzahirikeen1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good Day,

    I know this email might come to you as a surprise because is
coming from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
