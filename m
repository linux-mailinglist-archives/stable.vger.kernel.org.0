Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366C958E217
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 23:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiHIVsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 17:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiHIVsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 17:48:11 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D656BD4B
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 14:48:10 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a9so18719373lfm.12
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 14:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=hnUM0lzwulX2q1QwimZooJGSc8HzCb0oOd/8o0YSo68=;
        b=cCH8YEQhsEmjNkK1MEQHVJ9z/5IynKDy94dtwdB05FKwTQJnZs0BHDgsJxs5x1xoBO
         zDudrmYohOW5IZMYh9HMQSn3L/eoQl7Av5dDkHi7ySnQZKCacYK2jDMFval3lRF+DyPE
         E3kb8yzMGOuwNpLGaT9Rwl8GvnhrRPhszTFnYwqQay+Ag6JOmhCzOAGFwND7CsDyehmE
         Kw6eBOWpXPUGBsf9EL9U6BnPD0rs8OOvfR4F4vISJBnSOCh0sUQ6tUB4UdKt32qq5WDF
         ufNTPbr2Iz6MmEAq85RBM46NQ/3YXQSNfy2nuT8lNHMQ1Va3jyE7O2TLPYbVTRYFcEzn
         qKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=hnUM0lzwulX2q1QwimZooJGSc8HzCb0oOd/8o0YSo68=;
        b=V44VctLCf6rwZZAVncyvv7EQqZnbR2ZNo+NDCCgjRk0mKXT/95Fyh9iWBA+oGgxr5r
         n8oHwSa8D56voxAb1NNBTP9VMTA7MXxJfIR7EoaF0rGcPD2Ruiq1DYyksy9JnHywXJpY
         x3/WZlqQuIiV65UURizGwBxoctr5r2flahzNF9pB0SQZh2E1q9GVRUP01Ki97b7ReIAa
         HBMAtVUVIkyB8Dz1Ey3D1/3wRNMa1g2IUMG8m869m+R6yYuS2SGefx/Rf/Oe+JtxPMDL
         QhKS2xYE2FJhCe9CrDEyUvTSfjCsqp1I1KXXJ6MZ0h+fidYalQse1GB1smLvyIEqNAsu
         deaw==
X-Gm-Message-State: ACgBeo3CKG1mOh3KMm2BWhpeEOYjVvkCtrWoAp6ovTSIYOaOkFQ7VYva
        +aa5+l5YFG0ek/Xw31ejSVyJkEQ9fVJS5b/frjA=
X-Google-Smtp-Source: AA6agR4ikLVAtMzJOaLadhB8n6sMNnAhFodcD0EH3DHjeNBG6BsdoEgWfZNc5UimHSs2BBIgJ6258iNv0BGrCzZVWuc=
X-Received: by 2002:a05:6512:3583:b0:48a:e811:3d89 with SMTP id
 m3-20020a056512358300b0048ae8113d89mr9322651lfr.371.1660081688915; Tue, 09
 Aug 2022 14:48:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6504:1985:b0:1d9:6119:6b37 with HTTP; Tue, 9 Aug 2022
 14:48:08 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Mr. Yakubu Abubakar," <yakubuabubakar1884@gmail.com>
Date:   Tue, 9 Aug 2022 14:48:08 -0700
Message-ID: <CANt38euNc53v9DCUWvZJr9rBHhsZy9S7z85fAZe-_qKU-qWWyQ@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yakubuabubakar1884[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [yakubuabubakar1884[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Dr. Yakubu Abubakar..

Sincerely,
Prof. Chin Guang
