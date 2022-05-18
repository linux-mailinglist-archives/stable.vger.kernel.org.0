Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E0B52C752
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiERXHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiERXHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 19:07:50 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461A166D6F
        for <stable@vger.kernel.org>; Wed, 18 May 2022 16:07:46 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2fee010f509so40065097b3.11
        for <stable@vger.kernel.org>; Wed, 18 May 2022 16:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=k+ynB2WezJOP1EvXfos5flWjmDxKhxduUMWd38bmoXayMpaLyM0z1TMuynrzvUcYIL
         Unf92E3uMcXboVUY0i0n8o7+2meRo+VdLceDixCNZzaW3MMBD8aYeuae2pbz/NQRWB+M
         XezpCYc6QwV0Z1g+Q8OoYLV1FMfcJ6VlOl+uV0yIb1WzY04684C981HsTGNj2miJtBJi
         uCqYqE45NOhKa4DhAcVn8pxet9/CrhwrvdqsPC3mUqygAIcfaeX5Hke6W4qBcV3c6vnH
         602PJ9SASe4f5RImG2vohYzK1AGJnG2sB1Wg33UnSylsJ/bp+lIy8pF6vHJHykE8ajrB
         ZrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=cqGNjZtqIR2xoDPEzsaGEOk+iAza3hUIvsbqHJ19GPC2eKB8Wjm8z5WL4ISh3wOUA2
         0OOCnXE2+jHaXmsau2udvXY3OgP47RDRLvqblY/lK5euJsLpm2BLt7nABmMVbRTPtEul
         zqwr0njII6oW+z41PkKTXtaTHae3FbErdLeaJ2DPjnk51bOA10VOingtX0oSHbIWT1jC
         uH2Bek/rag/VzCZPWddW/0yMBdeOQJppe+/vNMHHxT9X/9nooS42UY4iVyOMwGfA80tS
         wgHCiLQkSnrg/KLElrq5rrP+b5tl1IJ+fMY06gNTvsrbiOKb6BeA7Qnnu8eau+WoDsqI
         qCbA==
X-Gm-Message-State: AOAM53069VN4z4OaplCZSQDHMCkAsQN/40XroGaxJ3qn7dY5DjKhxV+l
        3f2+AIXaL+OwbVlJTUD/vu6N5/2jTbUMeeqS2B4=
X-Google-Smtp-Source: ABdhPJzL0XrAy6L06BUXk0x4mwIGkCGx6wr2Eve9VMIv8uKoJLOFhqMl+PKq+oI0KeQaQ1MuZDCAM6tEN5HXezRWWa0=
X-Received: by 2002:a0d:c0c6:0:b0:2ff:bb2:1065 with SMTP id
 b189-20020a0dc0c6000000b002ff0bb21065mr1999211ywd.512.1652915265574; Wed, 18
 May 2022 16:07:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:7143:0:0:0:0 with HTTP; Wed, 18 May 2022 16:07:45
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <weboutloock4@gmail.com>
Date:   Thu, 19 May 2022 07:07:45 +0800
Message-ID: <CAE2_YrB_gtPN=gJYODqVFx-3C1jO1NB7yF_Y6aqMjW7odTT9Dg@mail.gmail.com>
Subject: engage
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4753]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [weboutloock4[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [weboutloock4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can I engage your services?
