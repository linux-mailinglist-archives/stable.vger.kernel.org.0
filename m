Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3FA6B23F3
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 13:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCIMSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 07:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCIMSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 07:18:43 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF7D5FEA9
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 04:18:41 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a25so6335459edb.0
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 04:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678364320;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y11Y5KdPkwrAw/IOuZS6dmEpq7iLh1L5ALC9YtbNvoo=;
        b=M6x5QbTMUYy52Hp79x5vbXRdwu1OihoDcsJADEBDs2ZX+0Gpvmew5AO2VF4IOZVQu+
         Spcy6jffxe6FYGw1cxQMXSbbPwjL51fvqAbm8iaS3nlyC0pYXZXxFlllD4cQERsBAyjI
         XjXMcZlDUTdLreVHkn9ZD07pjzQlP5hxQgwq5GLxNEd3zBYfj60m6n1fGOdje5vvYv6Y
         R52k7YUskD9dWPVMuq9pWQnN7Ng2iOtpkI5KXwpWyhFVBPnduT8lveFfgNonLyBVFkr6
         Jx8Uw7tT4QNpZMTSowWiwiMXAFafGFdcxAHtAZqbZ04loeaEhX8SXK267To6+HEHdsyh
         7gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678364320;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y11Y5KdPkwrAw/IOuZS6dmEpq7iLh1L5ALC9YtbNvoo=;
        b=TQwhe1/qac646h55Mz8nKwP4/UxAiNey1/X4UKCMPqC4IMDWVTQoEYDJF0aa/QVR/J
         sMpT385S7UUjdfI1uDDYO90ev1naLJNnVkQqtscPgy0Qig7Iov7+p5RPk6QCuxDwwSt0
         SLGp9dPrtHjmpgnbL8WIdUpIAIYvWsHx1a8bgZkhpprPp4E+0K6tL1DVIojT0hKzfalp
         4t9STeoUYqRHYYn9o8TTW37ddU6C3sDNM+QuDIu3Ngyc7UqoicTgjcUHXo1iq33K5iYq
         oPjT3Rlb0W1st8WhQqFpB58jzfcaEE98CYJbxFxnGSBQlEAHq9QOTCqC/Vt5yRJ/denX
         jF6w==
X-Gm-Message-State: AO0yUKXXa4HQroSHPH4pvU4kQdZZ+rj52FewKaAhqhMjgcJd40Zqsu6n
        9q8orVTH6OQFewl652fL1FjxRMWJo+JmxcKmBRg=
X-Google-Smtp-Source: AK7set/kctAozFndbRG/Lz5laYQfJTi1/V7OyIO3fzNjfM2ZQvdKFEkR/KqKixsbzMt7s/s3hSKQN5gQ7DXylJ5ux0c=
X-Received: by 2002:a17:906:7803:b0:8db:b5c1:7203 with SMTP id
 u3-20020a170906780300b008dbb5c17203mr11035443ejm.11.1678364319998; Thu, 09
 Mar 2023 04:18:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7208:420e:b0:64:ab2b:f16 with HTTP; Thu, 9 Mar 2023
 04:18:39 -0800 (PST)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <claudehouedakor@gmail.com>
Date:   Thu, 9 Mar 2023 04:18:39 -0800
Message-ID: <CAGd3Dp9DTDGgqkjgCgSqds3_VpOXViDjN_QpfMb+rQC6NEo0nw@mail.gmail.com>
Subject: ASSISTANCE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:541 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9376]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [claudehouedakor[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [barristerbenjamin221[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello dear friend.

Please with all due respect, I will love to discuss something very
very important with you, I will appreciate it if you grant me audience
with your reply.

Sincerely.
Barrister Amadou Benjamin Esq.
