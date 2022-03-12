Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7434D6D8F
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiCLIa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiCLIaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:30:55 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CF0291B8F
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 00:29:51 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id w4so9520986ply.13
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 00:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=frf6TGQGeDZfagbCAkI2xcmLSgJXKQaSiXpRYmpACLJbEIhbcq59l7Dp4XtPTMJQr3
         Ydyeu74Ztq6tBjZ0R81mxKwXgg+1TeVbMYC2Pwwqudad9P+27Q8ZxCbn6MUIRJG4L8G8
         p2p5+g9YIY/wuVU+dW8bBc0NvCFkUVn8X84KIMWsHxcb1N5NEH4Hf7R1NE6y72pTwSLt
         JCNTy1a68Gde7X7OQEviRhDQwItTvu2/NfViRH+ehBQqg9oadIM2HgfWHP39cM91QAOM
         MMxNQ3pPY+sFZVFHH+A/xrrUH14jk+MMPvVAKh7akxmE9w8GoJ4DDCXx9J6pmCXkUpJI
         u3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=ke5527lRhb50MVu0hXqtPg/n854F+nT/oxrJ3tjbJSc8RfsRI3SL+btmhsJzNTeFS6
         9DzQga4Bbcj6bJzj8lrgyWZJpcuOGnqyY+r4jGdRVfbXzl31luX/7XdYdebrAC0+Hlgt
         gQqHpzwYJ8KWe3oX+Dm6QpjxiHW2SvHclMUAenZcxhPttj8dBOJEz253VhlNy7drxQ3M
         RKDws14oeIQ33s4HPdL8bvgp1YwZk7QfsJtIKVQCp19XE0jwD0GQFpaaIMBt1xW05vZJ
         QsqRDDP3AHGiLxlsBcnNpDPCpd1hD8wOZBLvg85+b3V3Ok+iTaUbKQS+owq3nUVFgk/n
         6Sbg==
X-Gm-Message-State: AOAM533SiRo8jIcQ9R8/QzFz5afHWvjBVvp+j5jrln127NZr1L/LMpaX
        Xo42LEgDOUZXnju9LpWoZf/2sO5HnDAxMsIFv5Y=
X-Google-Smtp-Source: ABdhPJzyPrhIAvE2RoAMXlz4SjK173SX7r41Rf3JetK0NHBBiAd2LZI4Nm34S/zK0zUcaZToFVT25wXYoipOG1+rE0w=
X-Received: by 2002:a17:90b:1b0f:b0:1c5:d3ce:38ac with SMTP id
 nu15-20020a17090b1b0f00b001c5d3ce38acmr688976pjb.158.1647073789979; Sat, 12
 Mar 2022 00:29:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:4419:0:0:0:0 with HTTP; Sat, 12 Mar 2022 00:29:49
 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <witracy8@gmail.com>
Date:   Sat, 12 Mar 2022 00:29:49 -0800
Message-ID: <CABPxxX+h62b2oH0jPcm3c3e9vUfrYT5ks9FtZq9ggb0h60p6hA@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.2334]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [witracy8[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [witracy8[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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
