Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D95045E7
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 03:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiDQBUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 21:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDQBUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 21:20:25 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F76644A33
        for <stable@vger.kernel.org>; Sat, 16 Apr 2022 18:17:51 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id y129so1136711qkb.2
        for <stable@vger.kernel.org>; Sat, 16 Apr 2022 18:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=bZjpwB+wNCLwsZCSnLxqmC4sXR2mJpModolDDWKFE0Y=;
        b=qTRrilPG3uzz9rI7FFIkgEV1gHan3IDtRkDO+doSoJ2G+fxxP65G3i3KbeEpPVzfJW
         rPtkSq4ofGbtEEXu2uSg2bnUc5UOckwgMYbh88w/+gCJI83LptxfLOnSTImggQSzVZi1
         FqbJaiJT6Ho2Tr/FMIVw9nHV1ZCPAE7Ap7fOxPVmLBJ3pMvawkV3aSK07C848rpnC0rr
         ndvAokiVApFtmSwQPoIuciicmVUN4K5tPUz7IC4n0ZF32sVVDpV0oBPWCZTDTPXPAPwb
         AitjY72kJh1JBpdtZ/Bg8KBLVNo3Ji8XeK58R/aWbmUaNXT/U0xsQZ9OAHOedJLLAQYr
         JMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=bZjpwB+wNCLwsZCSnLxqmC4sXR2mJpModolDDWKFE0Y=;
        b=b/TFZH3/iI+bg5hkvYpdiogUwLSSIkmcGT6ZWXhKGdB5L4qgEVg4G8+cU9xMrS2Lri
         /iMpHpakXFInQ8anqvm5PXs6X3Ld20magejSxTrKiWLZNlgIUHo6ztqwm+eUwbZ8gZG4
         o5OGY3+wJ3GJCt2iC3DFItHckoc1/IRONnhJdLB98nXP6Pxz7DpasHRsdp+2ynvy14bV
         iO/nBWYlra5yNLjHX+oMcn2kspumDcd+SSQBUVtM7kI6RTKqbXe4sNufqV3UiFypvcwO
         zpPdc/A8U4vTqxFyxcJhpHrPkjgh2GfaerOUfrBR2ILYd3L8BNqmy0eQcWUDN12zNnk/
         NGMA==
X-Gm-Message-State: AOAM532sIhL2cieBh66LNv3KggH25GKCB+Hai7Uxyi96dPS8+i55nThg
        KRFIrWq4aeNxTjG3A/0MtRkxhkRYxQKFaFje7BI=
X-Google-Smtp-Source: ABdhPJxTHWjxjCId2MD5CrlQ9muveC/NjzGGK286iCLzWs2+skOz3TJjCLsk5eoN2P9n0rwz7lL/JOfQ7AreBLt+NR4=
X-Received: by 2002:a05:620a:280e:b0:680:d1b9:6b0 with SMTP id
 f14-20020a05620a280e00b00680d1b906b0mr3277738qkp.391.1650158269940; Sat, 16
 Apr 2022 18:17:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:484e:0:0:0:0:0 with HTTP; Sat, 16 Apr 2022 18:17:49
 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Mr. Jibri loubda" <gjibriloubda@gmail.com>
Date:   Sat, 16 Apr 2022 18:17:49 -0700
Message-ID: <CAO=FyHLdH20peTn8J3zG+Py6g=EfP68jHDRWTwS3PSOkU4KWZQ@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:72d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4654]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gjibriloubda[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  1.1 HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
I'm Mr. Jibri loubda, how are you doing hope you are in good health,
the Board irector
try to reach you on phone several times Meanwhile, your number was not
connecting. before he ask me to send you an email to hear from you if
you are fine. hope to hear you are in good Health.

Thanks,
Mr. Jibri loubda.

Sincerely,
Dr. Irene Lam.
