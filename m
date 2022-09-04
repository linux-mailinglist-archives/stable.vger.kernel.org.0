Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22D5AC3D1
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiIDKMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 06:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiIDKMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 06:12:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CFB43E5B
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 03:12:09 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b142so4951755iof.10
        for <stable@vger.kernel.org>; Sun, 04 Sep 2022 03:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=qyAC9pGA3bM4rM543zM+YmJ53hSTj7w0+tIgvP3ytYE=;
        b=fni/DB29A4mcoxdkeDYOVtLQ18yNuq8nPWzkYMQcGfamXVTwgwMzqpIP733mrudtZl
         hvcMqOejh3CqWhp7LD6V2CGr2yqbZHVzHORji1atjbfRce506558JF+xBcJvtZQv1L+V
         O4YdfNJia29eMrdKkGuYKOOS0Y2awjuq2AuGQTOq0DFISQYrklupQas9EgOp8iTtypqd
         wfWTOajakuE9N/Y73/SXbCEDvj/oSwtR4yP9xrSg/cl0zxGNQ3AsFtOvE3uBE1MS35Sy
         L3uIMJqN/IlNObCx7nt4362/RM9F28jrMfNBwE1dugKzKR/hdf6q0sKdBU+WnbJnpePS
         vlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qyAC9pGA3bM4rM543zM+YmJ53hSTj7w0+tIgvP3ytYE=;
        b=Wf5ZZpmvlE0p+BMoVVsU7A8C+QLAzOyIFGCgsK9JD71vLBhY3yNYfpDPF64Htt4xqV
         ld3SaWrDSCQch6g7i7908kLJfHj9RB/6kUA8FwbhsG0xWcGlQyWDzR7rPRoGQhuxrA+U
         u8+Zt8oBDIgyKN/GjJEA7mTr4N8rKh+2Vcd9cP//9v21xxvBDsnuGNZmTV9aREN2Dnmb
         WgcSSsIe9aF2KCqfSy1lm0P8/s2dPwC9pCCDbsXxNM03zbvfLr2WQ8kXk+2Ipi0GplEQ
         ZUw3+6T2gD0vY3MJDEpHjyvjGSozvhSDnAjp1f4CdnWdgCCung4bz+6t9VccGd098kS+
         7J5w==
X-Gm-Message-State: ACgBeo0llZ2ysdT+CKqUoH6YRlmZ2mh/+UZYzsPUPVuoGsUXGPNJKttD
        qC3nv4GY7gv3rY6HHYoPaQALXFkiEFb8lN50cOo=
X-Google-Smtp-Source: AA6agR40a8eU8Sqbi6aFzSlkqeoY/ibYaP2DTMPoIU+Nv7l68v1iHAeIBZCfABNpNA12ngahIV4Lrm3jWrq90DewNK0=
X-Received: by 2002:a05:6638:430d:b0:343:69f4:2016 with SMTP id
 bt13-20020a056638430d00b0034369f42016mr24334534jab.90.1662286328384; Sun, 04
 Sep 2022 03:12:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:f649:0:0:0:0:0 with HTTP; Sun, 4 Sep 2022 03:12:08 -0700 (PDT)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <bartolosimon103@gmail.com>
Date:   Sun, 4 Sep 2022 10:12:08 +0000
Message-ID: <CAE-MJHLcHAgAJw-Jq0Bz7d2Pno7-2jFFEOj4+Q5A-L+26XwE1g@mail.gmail.com>
Subject: ////////////////////////////Hello dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am contacting you again further to my previous email which you never
responded to. Please confirm to me if you are still using this email
address. However, I apologize for any inconvenience.
