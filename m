Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC42E673B08
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 15:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjASODQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 09:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjASODM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 09:03:12 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDB54957E
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 06:02:48 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v10so2945959edi.8
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 06:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AV4rd40WVbMFZkIUJcsvF7Mjp/MQlzSIO2ZQCTrdWbo=;
        b=OXQOmghGyCb8V2An46Q5rEwannyfAY9j9RPhjGSLsI+yUam7MDEVSEZlLcV+z8McyB
         BUDVPz4yogv2aebDB6IlPSTOxYaYy8hIElWjlP091FOuAdsOkmyA8r5QTVwtIOPvu0lo
         R/P5qeVLMHnDAvnH/EaAmSmm7JtDwHuUJFEAOdEv6+VnCjs5pG0CvjLR3BbEIJ+VQb2P
         iw938928QTzhQ955w7bJm0shPBpotdJCFJqK2uJppjf+xIFfnAdZg+CiB4DUjviyOxET
         ynLLMXnME2iAId9L+2h7BwLU0yH1GVQsZZbXVgQy0fYNM7i7TMIhP2eQet67sQwZdmF5
         eM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AV4rd40WVbMFZkIUJcsvF7Mjp/MQlzSIO2ZQCTrdWbo=;
        b=bxUQ1FacUiadbdv0VM/YSLwkWK0Zc7WZsT0jHAguNbctb8ItKqd1H9b/Zwpdjqc4Mj
         2hl+ZZcoJCCfe8831yQVvHKl0C5klZxTkAppnYshr0YHJYe96bs+JgBm6B/9QLw8kFJ9
         OAh/agZXlrpDKWhXT050jyElCmwxLoQnzimo7PHdvOyoUqAb4lj8ecqAUpZLojt9u2Um
         oSD3on1uw+oLJxXm+RK36ZMTyHN7BqQnbAn3m1mHBCcS1bbfK0S4SYHk+55Dleoj2Y/F
         gvz+YTUsoFradJ/W0rwI1/GtOuyiRKn+m0MwL0qFQ42juxtDdP86zBQeIfEXryTn1oWF
         A2iA==
X-Gm-Message-State: AFqh2koGZpg/05A1zzP4G33Mc4+MvStfFPos3hGuo1La7c44camfahKh
        gRl2aMetbfwexxcBJZMjG76w/O0KgeL/59rgdXs=
X-Google-Smtp-Source: AMrXdXsdQ0AthZldDr9iuI/6s+/OLi4DMDvVivEhENJasfwWYwr41XRRwhFSqflHVS8F9XOS/InJUBDb5OUHxpqu6Jw=
X-Received: by 2002:aa7:c548:0:b0:499:b60f:5741 with SMTP id
 s8-20020aa7c548000000b00499b60f5741mr1010162edr.80.1674136961979; Thu, 19 Jan
 2023 06:02:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:ce2a:b0:84d:feae:677f with HTTP; Thu, 19 Jan 2023
 06:02:41 -0800 (PST)
Reply-To: fiona.hill.usa@outlook.com
From:   Fiona Hill <mr2848830@gmail.com>
Date:   Thu, 19 Jan 2023 06:02:41 -0800
Message-ID: <CABtAzOav3Wxep5HiLO5x8VeDrnKSomvUB=LFxkJQyd-F_Oxcbw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:542 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6030]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mr2848830[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mr2848830[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello did you see my messags, I sent to you
