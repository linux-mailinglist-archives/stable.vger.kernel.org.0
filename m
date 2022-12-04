Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BAA641A50
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 03:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiLDCI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 21:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLDCI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 21:08:59 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543DE1A060
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 18:08:58 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id jl24so7900720plb.8
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 18:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GgJHtMHpzXbj05C7ce7ovzjgU/ig9Bv71B/QfO8lIWY=;
        b=jwOK/LYk4eJVkdq0YYacpR58W85nTdoqjFb4LXTilR8wGid7E1c6nWbziNbkAKwbdC
         VZIHibTgqPxzxxM+AqquEvMwFXnI/hRG5J3zxdZ59suC4vkwDIfyjA+vDMPPxlDBJAk+
         gRA94z0H8X6jrGpYAE0WLaM3Uv9EbMaokkCrrfelCobh2NrtHzBzWc3sZQYze53fEtsx
         njKmj1NRmvypRFdLoO9duM3d3IyJYzsmNYF5J8fLuClBfJt8h1ZnwcfcL7EbHVIx5r8Y
         huRg/gt6+aHvyiE7DtPMFD4NGgX7oSsgfT8w8fuSm10M+Fc4jEhjs83R5wJ1AC2wBsol
         4mcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GgJHtMHpzXbj05C7ce7ovzjgU/ig9Bv71B/QfO8lIWY=;
        b=2fkGAzgjljNXxRCXPHayhLjyitm8y8flCn/735H/HkfZM+JLozVTCYUrSb0AX2/Jf8
         GTKoI6QY0eKJr2xY+8ToHsdTA+98LDqunx0QhqDc64dt5Y6G1Vxya2a3hmj2qs8bChc9
         JI41Fd5dbOcywZURpGonY26JpKwrA3OY6bIqPHt3OU/4Ry1APHqcskgfmKRkousCt4nl
         o5ooygdjD9snklEf77AjK+XLvDFjqjERU2pS873U+26OuAMA08pROYwukx2G34Otds8O
         a9gm7V3JSJhv0YR3DdsuJsnMqJdLqRwZXm+zlMBp0PYkExTt5Dav5fmDKdDmTLND6PxW
         oSfQ==
X-Gm-Message-State: ANoB5plKVGvVhmyXNJFFDvPk7B5Q0O4wMWLwFL89oQn+vjYnxWhaafNJ
        QMrnjeJ1hPT/E6VBHRTnaYIwXOsLdb2Nlr9PRPg=
X-Google-Smtp-Source: AA0mqf70MmLzPfD8EjnPvKW1ESxWOdinlWIJD+XOe0fYfTEEIzmdWo9z5WPD/TP2skjOUcjfdRjU4R7xaP7eUt3Kvmo=
X-Received: by 2002:a17:90a:a595:b0:218:b050:d693 with SMTP id
 b21-20020a17090aa59500b00218b050d693mr67501434pjq.130.1670119737713; Sat, 03
 Dec 2022 18:08:57 -0800 (PST)
MIME-Version: 1.0
Sender: drkimyoon846@gmail.com
Received: by 2002:a17:902:7d92:b0:187:2e72:35db with HTTP; Sat, 3 Dec 2022
 18:08:57 -0800 (PST)
From:   "Mr. Danish Asad" <danishasad074@gmail.com>
Date:   Sat, 3 Dec 2022 21:08:57 -0500
X-Google-Sender-Auth: 4blH4kZj3Nokxpnpv0HjTvYI3Zc
Message-ID: <CALhVJqpjG5rC20L84iD=A6qZX-h0R3oQ3TrU-NbZ3GZKKMqoAQ@mail.gmail.com>
Subject: I await your matured response to my business proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

 I am Danish Asad a gold miner from Burkina Faso. I have a
Mutual/Beneficial Business  that would be beneficial to both of us. I
only have one question to ask of you,

 Can you be honest?

 Please note that the deal requires high level of maturity, honesty
and secrecy. This will involve moving some bars of golds, lots of
jewelries ranging from neck less to rings and bracelets under my care,
on trust to your hand also note that i will do everything to make sure
that the bars of golds and jewelries is moved as a purely legitimate,
so you will not be exposed to any risk.

 I request for your full co-operation. I will give you details and
procedure when I receive your reply, to commence this business, I
require you to immediately indicate your interest by a return reply. I
will be waiting for your response in a timely manner.

Please contact my private email address.
danishasad074@gmail.com


 Yours sincerely,
 Mr.Danish Asad
danishasad074@gmail.com
+22667440112


 NOTE: Please treat it genuinely.
