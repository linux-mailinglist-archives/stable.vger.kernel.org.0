Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB44056704A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiGEOF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiGEOEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:04:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2553F22523
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 06:52:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h17so4517963wrx.0
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 06:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GR2p63BS/ChSrJTErcsL6FDgshrMMqE2JBQFZoqpd64=;
        b=dqSIKCvXOcVmZzmdj1Hu623wQcxtOTcW0yOApqpVfIKfdp5i2S29GPBXY570h01uG1
         pTY3r3x3qETrZ1pxCMxOAmxo7zGBbDtBdK4/6ZTWrmDdsBM06jNiqkmdeWTFcPrtQ2fQ
         myjN9dOjGlVTinbzV7/Z5PsNjlkqgLp7dFDNvHhECBA3HRUEb4elfJdGsPg4GXMX37eB
         0j/i3YdknzrmnHikx3sfa2iSZ2eE9QnRQigAU+1Un0VJSj1TjojvKJtt+kF2WqQDSOge
         rM9tTdPQEW5pjj2mvx7IMSkxOYV6ZfVvN+jAn4Ak98e2sr31VfrYRmRmmmz1eZa1mGki
         LPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=GR2p63BS/ChSrJTErcsL6FDgshrMMqE2JBQFZoqpd64=;
        b=qA7Ntoz/6yvwPrET9xvi3HsxiKZEdEoexPNGmO7V4Sj/zutjvi0nwsAiJJSHAt+AiB
         Qzvyg1yoC0WqpbinGvHPb1KgXA9MK2NetQiT9EugkId8k7j+uZ8Hor8poOp353wiI0o6
         crWlFbyFYe1fZPnPIrD4CducHoKKVLmRHuYH0X7k/R7Pg8qE3E96r1DOut+/cnXq4JSA
         HpZfyZRUMwEIcW/G74yaBiLx61AlXkg8GMlK19eWj09U8YJU8OlX+EmaWZT1yvfEhbYL
         f6XUhstqu0xZhvv5tH5PK7zqVwiMadPkrkSdPAL0FsOPYBTKeTVQb64Oqn3O+9qGTvAE
         ZrSA==
X-Gm-Message-State: AJIora9nQXioU3cCpEvL6GpcUjX45aSCMGQQ027bYYKeeIq+OJacVHRD
        5GDbrcOw/HsS+XE9N1LcxA1AA/NO0kJo2k5okMo=
X-Google-Smtp-Source: AGRyM1ubMTi4bA741CcjAwvR52sCyVoyrDBDQQ6ifw6PgeZ0IF0dPrqKR+LOFyjp10WkDa7BWbNLcaNfAecJi2SqaKo=
X-Received: by 2002:adf:f7cd:0:b0:21d:6e8d:ee13 with SMTP id
 a13-20020adff7cd000000b0021d6e8dee13mr6448930wrq.11.1657029132781; Tue, 05
 Jul 2022 06:52:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylamanthey612@gmail.com
Sender: finoureine@gmail.com
Received: by 2002:a7b:cb86:0:0:0:0:0 with HTTP; Tue, 5 Jul 2022 06:52:12 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Tue, 5 Jul 2022 13:52:12 +0000
X-Google-Sender-Auth: uPwQFYZLJbMQNO7DqQiRrDWIKy8
Message-ID: <CAD36dZzAwicrTDs+33JuR0gZHR-0UE08OFg=rXwYiSAb3Egedw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dobr=C3=BD den, neobdr=C5=BEel jsem od v=C3=A1s odpov=C4=9B=C4=8F na m=C3=
=A9 p=C5=99edchoz=C3=AD e-maily,
pros=C3=ADm zkontrolujte a odpov=C4=9Bzte mi.
