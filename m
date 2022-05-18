Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7536552C1C6
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiERSBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241274AbiERSBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:01:36 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA38FD61
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:01:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i23so3451101ljb.4
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=FGNV2ED3IrhnMl4e+8JEHNUGqrAN7lzTmHnGXJd/lFnbABk5bw3mTLWSsuqcxfkt9Y
         Mt46rp05THPw6kyLJ0EEtth/wtkyYVit7jNow0gVPtV+XbciySTDES50f4xLR6VS/8Cd
         OSlr5jCpAwT9v5zRYN2WZoAQ7fDgOLv9TMoXdArE/+kx09lggzHAKQETVJ2uJl1a+ENF
         EZLVO/iewj0+oWNyIRjkal1A6UTq/jU00RWvMLj/5GEUI6sjBk/pcfgdhyWDFb7Q2VN1
         f/rQYAci5tdd8ibVbH2xE0/fRidXiWrQfaqgY8ect6vy84XA0Ri1A3/C+KGnHqZSS2ih
         ElNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=wGNamiLiGo7HsT3H7SWUBrYel/3KEw4BUI4MLlHNjoiEXgjWxVTYOI3h/p5xvhtY1m
         AsewIGmhHKZlHxFODGQOF1qGRhBWly4uueXGBBqTR9NsmekM2vmyAbWL0UHo2VG2WY8f
         DbyREkDrxtK2o1AM7gzgROG3iUnjmDaB4cF2zsXEmWja1ixFCfBVL+nHzGJ08znm3TDY
         VPVsFgqCN53gnS4wCQIL/mQWBKJwN1JBN/RzkvpTzhoYJH6uoe5/vhIBKgrlJ2F5RoYm
         bKtW4Wjb6zVAXlU3ozhmHaYkcLk51r/pWsrw5SmlJNP7QRkenXGVr0539zgYKB4hj0sp
         1gzA==
X-Gm-Message-State: AOAM533mEw9B2Oa2aGZwdNCH12Tp29YTxd1YPaOfI1rKc6GoA/2Nqcmz
        UomwByny3x8NNyrdod/ZpkmWb7HvPGtpn+U3/gk=
X-Google-Smtp-Source: ABdhPJwp+zYwGZ3P7yO77KzPC3bO2s96TMmcSTli53gT3xQw1+Gn86ONKdBME1+SM/x6QCN0laqGXQlCVDQap5xbCVs=
X-Received: by 2002:a2e:b78e:0:b0:253:cee8:629e with SMTP id
 n14-20020a2eb78e000000b00253cee8629emr328712ljo.244.1652896893021; Wed, 18
 May 2022 11:01:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:33c6:0:0:0:0 with HTTP; Wed, 18 May 2022 11:01:32
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <fm5432967@gmail.com>
Date:   Wed, 18 May 2022 11:01:32 -0700
Message-ID: <CAJAKqLrxFRYLz_E-xRSyJ5zDk9BuvVjqtNA6mFPiHX3-BSDJMA@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:241 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5005]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [fm5432967[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [fm5432967[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
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

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
