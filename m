Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F65501FF
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 04:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiFRCcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 22:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiFRCcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 22:32:01 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7595069B64
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 19:32:00 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ef5380669cso57215887b3.9
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 19:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=nqMcTIyoSvvnM5POB8NmFzBAs57spzRgAlh3jE992T4BernTIo/HteSIGK9Gj/KUgC
         a1kEowGjSV+4TOkKPDmT7aAOrDF8O29kdc4HHEw4U4ltK5CXiBKcc1AspqQvcTGPvnqr
         Cuxqt1dLywGkdQR+oItq1KfMNwh45W8oNAxgHhDJg9k94/SeBaE5aeD27YyOs+cQIYxg
         wycD8ht+sYqlLv4hbvvoVQrLDe4POWZHZrMzrguue6mtsLfMjxmGPQYB3E016rA6A4cf
         O01ow7gq7cVVmF/nxbBDxyKeDb6d9N4FCeT7huSUkekXhDR2ZvQZ/9pVBqEKWnfrCRnl
         esWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=XTmwo5ezxVM03ur6xWVxoUyKNhFQz8P2+RBlM3ZuXmEQRv5eFqNimtXcURJxi+YrI3
         SGcO4TQbqMth116s2ztVY25zu80n3hJ3SpqsYsrLBXVwdBE7Ojd9ziZtZIHk/J3KhcEN
         yNIvm1KZHsZ4nYAUWLCTYUZ6OFwwcbU0L02Lckw8mWSWcV0F2Ieie8gBxdVO+mQHV7wZ
         hsFIWk1Tq1ozKmgJ5KuqiGyLwhtpVn+UtK7FrD70/UUH5XelaNC7RxmHrf4oBKTbvFb/
         ONADNERiyNFycgPRM1KpA+OjJzOCWmcAkBWEl1cdfN6YEkyjsTCCRsLNn083cYpi9ovN
         3pYg==
X-Gm-Message-State: AJIora/yIY5bTnJL5S+8cnzI+mBdvCeGrp+cZKJJ8MtKCCyOwbnuZtca
        E/MosC3Njxy6iD2zW/aG7hB3U40l+eFCD/K+Fy8=
X-Google-Smtp-Source: AGRyM1v0qd1hsSDWS5Zv+BuiDN4I2qR3Jjb1ZM9KVyPuMAKpsYgjvyTGrP7/j5xrnwqkwlZP5KH9UhgqNRaHIye5WsE=
X-Received: by 2002:a05:690c:113:b0:2ef:260b:3801 with SMTP id
 bd19-20020a05690c011300b002ef260b3801mr16288050ywb.49.1655519519555; Fri, 17
 Jun 2022 19:31:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:b381:0:0:0:0 with HTTP; Fri, 17 Jun 2022 19:31:58
 -0700 (PDT)
Reply-To: mrscecillelettytanm@gmail.com
From:   "Mrs.cecille Letty Tan" <smcpeterrobert@gmail.com>
Date:   Fri, 17 Jun 2022 19:31:58 -0700
Message-ID: <CAGzzBQ-0gT4Eq=C7L+7EFuhMh4aEtkV_CA15UXTp91t0cEHo7A@mail.gmail.com>
Subject: Hello
To:     smcpeterrobert@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

How are you doing today, I hope you get my message urgently, please.
