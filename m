Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD66621DF2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKHUrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 15:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiKHUqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 15:46:40 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE3AFFE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:46:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y4so15233151plb.2
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 12:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vdU0l5q7SwDqyQdrl+AlHir8nP1WSQabvgknUb9WZQA=;
        b=KqpAWA/gDNnYa4LOJhen7UzlTjDJtcMLTXpEYMEeakVwVEgRG0ANaXVOTUks29L0+k
         ilg/SOISavl5h4XwYKKYasIcwbDx0y3XngNf5stMmbBG8YJub8f9B2V4Lzw8kF09rv4O
         aOqkI5ST5FC/XllrtTpuBOdxs5nVAYtrFxeHkLblQWmtdn0r3czVlN0OmSv2lvqZSW+c
         kXP7LR9KWh4rcqaSMNDqSc39LPX+RHOl2QMCX2g+g+qCdUUhXFgA2+RBEJ+AZzRQ41z+
         Saj2I7dzOvjdATSP289abDTIuxNW8/Dv5fUiqUralFgGL2X69lXU7yy31Nfx9dE6Cqmr
         j60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vdU0l5q7SwDqyQdrl+AlHir8nP1WSQabvgknUb9WZQA=;
        b=HDAGBQkNLy2cbZtgmbL+RhFvO+Fde3576v0/B7iYQfoV6GIQtaPpHUJqroHtTKtEx6
         BUmDq2q1K53pIzrN1WvWgKpmdo5e5mHptR1mqvBWWwprVYMHxEgQFiQ2kHgXMo2ZSHsw
         zo0GuU2JfFO6+rQ2LGvqsGwZXRFsJxYUaNIzOho5SwGqtzBy0VgPd6Y7mkF5nek1qta4
         rI1ebsG6PSyU0eVDEisoeAdHmj7J1NUmBvCvJs23EqhEbl5xAjXSQBI1sU2LDD8Y2u/O
         7uhg0abM/8rvMmO+zOmm1a4G3vCq4GILf5d0kBfzIbBIqN/mFISnTfyNFkHtxe7kJfgq
         F4Og==
X-Gm-Message-State: ACrzQf1uR9nR0rhl6QQdn9mQajOZ3i0lnVtMiDQYGAxloIBlgvJZ/pJU
        Pn6tFUnKwidRSwY8MpEyg4FtFBjKAF5uyBAwfWw=
X-Google-Smtp-Source: AMsMyM6mOT7t1+LOQmdblzd1OzDXepP2PBuECcWZmEtDMnducXOHOG4OQSYz3oXJerOnxUL0K+quJyk0mp67IG0dix4=
X-Received: by 2002:a17:90b:4ac6:b0:213:ef82:b111 with SMTP id
 mh6-20020a17090b4ac600b00213ef82b111mr46572382pjb.170.1667940390475; Tue, 08
 Nov 2022 12:46:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a06:319a:b0:57d:af60:aa53 with HTTP; Tue, 8 Nov 2022
 12:46:29 -0800 (PST)
From:   Ved Manish <vedm60013@gmail.com>
Date:   Tue, 8 Nov 2022 21:46:29 +0100
Message-ID: <CAGwWHSQTG2iMKbz7GUxu4TcZSAVRA6_jkc2ko0GKZGUJC0e5hw@mail.gmail.com>
Subject: New message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Did you receive my mail yesterday?
