Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46760623E3E
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 10:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiKJJET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 04:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKJJES (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 04:04:18 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0233253ECB
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 01:04:17 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p21so934329plr.7
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 01:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=qCrlppL2fNnGAgEJY9mZPq+ekjvqAlBuPHBnU+cXfOKqO/3tCgBKGIPcqA2iZ2rP+v
         rdmSdp/aLjQni0DwX4qVBROdobBdtgelDG6VCd+qdBKuKWsAD9Gew8LHo2xqzJxAexqT
         qFgEzksfRu0KjmbHW2P4UuQmeqg/T9eS0cTJfOg0/uUxoFPfnWxE9eIfM3mdS1qigO4l
         yZ6H4EqEZB9LL1tW6YP9EN33ZfkpLI6SdT6QTspMqP6TCMSGZ/Bf7+L1koVUCrjl2uA1
         gJxDL1fb3KdURxt74ssyb5zGn/yGTjLaNOAtrri2vP+9sJThMB9b7LqpZwPtQ7NJQzDb
         ULLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=K9f5NtA/2Y7DjnXs9zS7it9IpyF/C0yO8CHr8mybv87lzZJyAzixh2PcthFCtOXMuI
         4kxMKfrgbVnZvtDBkmnMet4qaQU4TkCxpi3mnpYfxhyCEaig1Mx14Ww9rqnDf4y8szmO
         KFUGZhsgHLhgzGJ0OH0jutL+wOUHFGdtJks6uw175I4wEE7Xw+R+fldkpqNo0gyU9vv9
         BLyxThJW6T20AORthjSMKQzJi7UH423ynv9q7eAMRJRUSpw83+EVMvVQ1Fv0GdJphfTE
         i+pnreU0RpV66dliMDSLR80mItA7WSW3jxvc5Gw21kQdyWhVEdvHzzuvqC+Obk7wnYyt
         Ktdw==
X-Gm-Message-State: ACrzQf1BNuyWz22U5u+cN4zuF+9OynrtYYVeKU4FEdgjon0Ntd8cYu3R
        Fq/KZvL99h9V9qCjaYMJEPBEyxsuNpJw4d+hvg4=
X-Google-Smtp-Source: AMsMyM7Q6RGMeOxMrySZSGvumQr+np+bzrGyOchropNIY9AOG1bor1dUllKHQlh2dBOH4UTgWKNm5FB4kUuZPn1ts9E=
X-Received: by 2002:a17:902:e74f:b0:186:a962:8f92 with SMTP id
 p15-20020a170902e74f00b00186a9628f92mr64870961plf.41.1668071055869; Thu, 10
 Nov 2022 01:04:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a20:4da2:b0:a4:c01c:5df6 with HTTP; Thu, 10 Nov 2022
 01:04:15 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <mouyae84@gmail.com>
Date:   Thu, 10 Nov 2022 01:04:15 -0800
Message-ID: <CAGacB3GdR3SpYBMPb=dmiZ+u8wq+ObBGLCKCQ6DH0ysEvU3ULg@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:641 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5006]
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mouyae84[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mouyae84[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
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
