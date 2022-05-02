Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00007516E4D
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384617AbiEBKqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 06:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384723AbiEBKqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 06:46:32 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938F9220F1
        for <stable@vger.kernel.org>; Mon,  2 May 2022 03:42:47 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id t12so6429202vkt.5
        for <stable@vger.kernel.org>; Mon, 02 May 2022 03:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=BaRuJlspYtNnmmra72ppn/I3QxjLdJPztd99ldK+5/DonI/zD1UHB/FJDq5b3hUEXY
         6v1daVM85IMTfbaEGqriVH4QRKRv+UysCc3cg8Hmp175VFDfdYPyF8muzfmfgInBOhSc
         akVdPARD1PBBWUlPjfskfuu6OsYE+9AjSflqZMDdfBC2pKuMhhQ4leYmQ1jhXE0tbX0k
         0DNqWUSEtq64dCTX5hNj9dqAn0+S2L4dSzMvXfi3LaCbkdnGopvrN61yvM0wQ4r3sDTk
         D5Moi2dVRhwO1c6n2YVH0xpS0iAgPbmDJMiS1OnaeWzoVmvcpGsBd2dP+lNURs888071
         0W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=boX2GMO1feTrEakzzHdj0yuNoPKFSc8+T1AAQIXc1HEN3q8UO66l9mQQmDazxsjGbw
         uLkR+QA8QxmWJ1nL5e/T7l6GuhRlJ+9wrz9/SDIdf42diieUxkidT7VZXCL5DOV8j6fx
         wQO1Q+bGe74XUc+E4NVr8sglBX4kR+Lxp69gDJ6EbKMCmArRwAV/y7jHO1DviBESyxXX
         tGq8GFofcn9ZRuvBVkwg//3kyZuHZAeRXgruAX0uT5pIODo9ML4LBIrHbXTYbq2p2yyI
         gqi1UlENJmv9X9Ds1oGK+6Bz4p4L6dzSShqXnsBRRCAIO5RxuSzqyQE8KBIQdXRdvVUq
         KVxg==
X-Gm-Message-State: AOAM532hPgGxk7++bA2StgKxfiFObw51ncw9o7MoYEnhkiYOvKf7CDrM
        /1MD0kzYFy33r+x1KYtVnoalwS40PZ7gmAI7ZnE=
X-Google-Smtp-Source: ABdhPJxpklhbVqRo93FQssvECh3GHdxlM97Y6YRwYP6qc6FyNYrnjKIdUqQEd6Ezhk5Vi5ZLxhsVNJhWRar/p7iNn58=
X-Received: by 2002:a05:6122:1354:b0:351:bed1:611d with SMTP id
 f20-20020a056122135400b00351bed1611dmr252994vkp.26.1651488166594; Mon, 02 May
 2022 03:42:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6102:1347:0:0:0:0 with HTTP; Mon, 2 May 2022 03:42:46
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikram <woloumarceline@gmail.com>
Date:   Mon, 2 May 2022 10:42:46 +0000
Message-ID: <CAKM2rXu8AD36LUfHJGJHqZmnjDoGzQenzc3tsQiQfUuzBa9-nQ@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4844]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [woloumarceline[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jub47823[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear ,


Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.

Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Julian
