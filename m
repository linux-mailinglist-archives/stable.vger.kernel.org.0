Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5D6E6978
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjDRQ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjDRQ1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:27:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC28513F9B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 09:26:51 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id k15so13086785ljq.4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 09:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835210; x=1684427210;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cM+I9ew7rDo2jLgC5Y7dk/mIiN8hJwpEi457dXk4lg=;
        b=jbZKDla1Mjgrfyn1sfI6tnm6E2HDjC4dZ+LKkSG4LOSI7RW+r2E2NbVPTkpSJNiGlU
         kIler9tvNaVH/IDCusIISA3Ce1O2kDSSb3iIBgPomQi8F0r5tOetJC6o0hxjyZAk5c7B
         fKPaVP2+UpdviiWhQs6doA5PV7xGPyPq7zMIO/LbZuCInArDt9T2THEGUpb8n3pvZE0R
         1kkTWw0SIcV/XYijAgAIclvg1QDpKCbIZD3Of14EWDaL6C5/3u9SMtdhF+gAZrjFJZwI
         O69GBPwnsXCC6illT52wjU3P1JcBTgRYtA9SVxiAbjYEJCjxH6In9/2EgK1X+YePH7sD
         FElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835210; x=1684427210;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cM+I9ew7rDo2jLgC5Y7dk/mIiN8hJwpEi457dXk4lg=;
        b=EdvQzi4ySfEE4r/hR9vGvYjgdEAow3QynJJNZDoN8sI1NQHtARDNATgcz8Gc7vWTNb
         4I+mxyWQr5Im6VXb8XHB3IGtleO/lm6lafwIKkJ3x+H/cLvtXn7XReAHnw6PT1F9aDLv
         MRZVm3vWkA0svPd/m4q/Vw+hRZxrH7JjXP/WqtN+JxSouQAnwXnTP5obFrXJBrE57NnK
         g38mp23jbmgq2JKsn08sxypRYwKdH5MyYZUT6bMYVo/ShqqhTH200ODlmm932tC3QvHE
         1oElpEkM0AL1mt6b3kGWf7+aSdxcBcMfs+b7g9C1b+IU3y4rChdnkzbe921t81j4jD/c
         RcaA==
X-Gm-Message-State: AAQBX9fdFVqCO5MDJLcqU2EErv+ggSz+/SbrgCiDiu/pI47m0waNx80T
        bkSPx0IzfNpmULmKRxh9uociURcj05cWcTuta5g=
X-Google-Smtp-Source: AKy350an1y3oZb5rCXFOxDH2Hb8UhOa8BEMCoLU/6qlJvUZckW2ZqfhlFcrN9EEJv3GVtpJVN52oB58TJJ8O6VKbLTI=
X-Received: by 2002:a2e:9809:0:b0:299:ac5e:376e with SMTP id
 a9-20020a2e9809000000b00299ac5e376emr1019039ljj.2.1681835209901; Tue, 18 Apr
 2023 09:26:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6022:901e:b0:3a:ef39:3c4d with HTTP; Tue, 18 Apr 2023
 09:26:49 -0700 (PDT)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <thajxoa1427@gmail.com>
Date:   Tue, 18 Apr 2023 09:26:49 -0700
Message-ID: <CAA2Y7B_F_kTiTfEwW4SBHGPz25fuuk_EL=c+zehDfDd6-U-nVQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:231 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [thajxoa1427[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [thajxoa1427[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Friend,

I am Mr Thaj Xoa From Vietnam and I have an important message for you
just get back for further details.



Regards
Mr Thaj Xoa
