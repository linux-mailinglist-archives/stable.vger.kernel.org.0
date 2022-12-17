Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF564F92A
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 14:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiLQNzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 08:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiLQNzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 08:55:01 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34813F11
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 05:54:58 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id c14so3511118qvq.0
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 05:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=D1PRUyv/HYRy+qB27d/g+CB1D2akP+es73S1ygDjjtFnXFBX3YoX7Pu1ns32nupF60
         YPCg07uado3P/ovyGJ4LiRnuPxELxTug69bwvjlIsmdNPdulk2Hr0j/Nqzt1Tuy4DUHq
         Q7dlvZklGyM0kfSZWf6nvG6/e5EQjqIYn4w+FpR4a3fAvU2ADZRzipfLj0W3Lmuc90FE
         kJaYbQFvyuntG3J/zpyOKBMl3fOn51SU2ODY0t+vQXuBA+vyeaMdw3JMcM0D07yPiKWw
         vRYdqSxVB5RYsts+uiyzG0Kb0oqkkai95Z69/snnOmbLSi/7WvbhKIlCiJ49BlMyeiB1
         dOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=SeqL6yLCBuf+W/F/90uwY6Q3VvTNhpmVsmM42zoXwZdey/xApkqUxynSXgkXTF1cdf
         Hwc6sl5zSav92nMIwsgQBwOUAwU0/myPEvR0U5Fg/O0mImyMiI6YE6k2kjGdU7rRTvDi
         kBNAYSYjm33S/qBRKyGtm77XNHj3PgITIhQLbntyAnSO8akNJUNLxoTLPqW3o7RtvZVf
         7o/tK2UFSdGeUxHv0nLoBPV/TVhbOfmQJrcsFf+tnM6OH6butKT20rVH0KCZZyruv/bo
         Gwzy8xq5PSYBqh8plHzsRodpprSXiOVebQH5DhIZCdy0hQvkYWTTMQZU3WmWyP+60G/l
         sPGg==
X-Gm-Message-State: ANoB5pnxT4ZTNtNGKy6KSJMSnLq7fkB4BTgGkTUITKjj8fcCugg/mpVE
        45fFkRcj/BJ7fsbN6wohzDWm+Ail3Y2Jp7Yglwo=
X-Google-Smtp-Source: AA0mqf7lCnbALq3WZLOYVmwLPm1uNwRZFn04XzmHUnTUjMRRU/cOLCT/JiJPNy7mJ7eyPzDQWsQrPUn7eGZuBLrkltQ=
X-Received: by 2002:ad4:55cd:0:b0:4c7:57af:c44 with SMTP id
 bt13-20020ad455cd000000b004c757af0c44mr20844924qvb.98.1671285297866; Sat, 17
 Dec 2022 05:54:57 -0800 (PST)
MIME-Version: 1.0
Sender: asfiss2018@gmail.com
Received: by 2002:a05:622a:38f:0:0:0:0 with HTTP; Sat, 17 Dec 2022 05:54:57
 -0800 (PST)
From:   John Kumor <a45476306@gmail.com>
Date:   Sat, 17 Dec 2022 13:54:57 +0000
X-Google-Sender-Auth: qmfptrVryDAEdz_G4wWmCDajJaQ
Message-ID: <CAMhHx7-pKJbRUq6vn__nUpM7sPxwsGwVWyQ9AZGUkJzA42dAMA@mail.gmail.com>
Subject: Kindly reply back.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
