Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DA155A7BF
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 09:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiFYHdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 03:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiFYHdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 03:33:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F295D2BB36
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 00:33:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so7731056pjr.0
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 00:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=jE0JLsfEdPpE7rbsOBNLVDtif/ZpFdFdV55NgbKwOcE=;
        b=E9WdAEB1qcgN3JiCKBRd3anbFcpA80y2P2RFw0bTE8HFv/KrOz8PHAZwAygZqkTS3P
         WjGKLF3m5bDKK/N1oocZVlDTIu8UTIFBya5ifEqAS2CsqL5iusRSIed6SyEDw70YW2A+
         fssiW/1SEko2lOFXvOdukr9pWZFV8wSLBrjr9/ggqUTiy6p4CjMbkYJeOW6D2cch59EI
         hb6RhABYk7QydLOIhCZruc+rxpg0jAJvy7UiXeMpMyP8QTHT4f88ylW+6ntI7kuUKXA8
         auI0LioKuw6aFVfExdurxzrOx8AdKhyasOkqe0cBngkgEV4h04uzeBJLs/Np+zPhsvYf
         X6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=jE0JLsfEdPpE7rbsOBNLVDtif/ZpFdFdV55NgbKwOcE=;
        b=3APS5jxeX50X9vEVJRHt/lm+vcf2BfDALQ/XNtFO9V0+1HNWMcZkfGRKZ9vl1Y+pzW
         K33DmCobowlbBWv6OGbTN/EEuGyzhs264XlyORF4fhhGXh9qJbBsPX4vm/UVLl2Roxr2
         pX3PDWb2ygGnjRmeCjL5ELjYijJ8X1aeoAQCzdHPNhkvv3Qrwi2IPKHyvIVRQs8NLyen
         rRXaOZtjxO0pKhPfWKCcxVGShHutS9FuI0ZHpcxYiQmzgugSYivQlQEOgHGbDBZdpZHs
         wP1rhdc/jFm3li5nFXUJ5ALEitiYkow4KPqSBm0KkVUl42n/kek+qf6kRWg3nd6UG8N3
         kELA==
X-Gm-Message-State: AJIora+851WiSlRkXOrU1eaeToiObKGmWXkzXiooRf+nFIajEc1DopqI
        RWOzAZmdAm90Gu+QiAU9cZuWSkR7uHwJ54CEKvQ=
X-Google-Smtp-Source: AGRyM1sxvDCjhuXaQczaBbtMy8koGn9fXKEYfCBbqgEHhz8OXnvVz6rfPaIUetGHYWKifEXFR/rMt0TPE0orRF7VVvQ=
X-Received: by 2002:a17:902:cf0c:b0:15b:63a4:9f47 with SMTP id
 i12-20020a170902cf0c00b0015b63a49f47mr3167029plg.1.1656142392306; Sat, 25 Jun
 2022 00:33:12 -0700 (PDT)
MIME-Version: 1.0
Sender: goodmircle30@gmail.com
Received: by 2002:a05:7300:6ca6:b0:69:587e:30fd with HTTP; Sat, 25 Jun 2022
 00:33:11 -0700 (PDT)
From:   "Mrs Yu. Ging Yunnan" <yunnanmrsyuging@gmail.com>
Date:   Sat, 25 Jun 2022 07:33:11 +0000
X-Google-Sender-Auth: AzMtHxTTs7f2c3uLYcutvB4gRuQ
Message-ID: <CAPsWReTQAF-YVd5i9Ty4Dov6ZEfUDshVNjdNWiHa4Fnqp8esNw@mail.gmail.com>
Subject: hello dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello dear
I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it because all vaccines has been given to me but to
no avian, am a China woman but I base here in France because am
married here and I have no child for my late husband and now am a
widow. My reason of communicating you is that i have $9.2million USD
which was deposited in BNP Paribas Bank here in France by my late
husband which  am the next of  kin to and I want you to stand as the
beneficiary for the claim now that am about to end my race according
to my doctor.I will want you to use the fund to build an orphanage
home in my name there in   country, please kindly reply to this
message urgently if willing to handle this project. God bless you and
i wait your swift response asap.
Yours fairly friend,
Mrs Yu. Ging Yunnan.
