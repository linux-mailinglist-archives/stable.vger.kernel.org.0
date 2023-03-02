Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB5F6A7E20
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 10:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCBJmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 04:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjCBJmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 04:42:08 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9993B22F
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 01:42:03 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id f31so21905862vsv.1
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 01:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677750122;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+CEZRZEOJVmAfb07UohKPHalX/8xKQCW3mCwVUhKXY=;
        b=R0g1qCG9KwXMjfKp+SIIAE1i5cSucm/+IJG5FOxVf8XM7pgUTOV2sxWb+pHyXNgNHg
         DjFbM/Lveh8l4+2TnpjuO/3AARM2u+xdRTrOPpzc8DRYY9vKNmaG3KvSQ+UTk0GQV7+2
         8whpyWx3jqLB8p4kFcaZ0eqh3qUB1QRC+vu1penVjzNZspnqCUSReSOGfT2fIqKdKSYW
         zy9C7stjBuKQ/198BdO+f0q1GOjVLx5behlZvjWy06v+/EVbuS/JzvY0wxPReqSofZm5
         QFfBWBacpxrd0ciMltX3y9hqVMZdcCdc9e6N8pl1ZRF4Rpdpm0VNrbGg4R5m3UjusaQe
         4Qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677750122;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+CEZRZEOJVmAfb07UohKPHalX/8xKQCW3mCwVUhKXY=;
        b=CADvHJfLDqT7Nd0u+s3MZSPQQhMD4Sh4w/deTvHBXhhVTsXhO4VihcjDTtmt00Lr8g
         OYI+QrMU01q2NjMLD4d42xlqKaow3H257Ja3RBzDmvpEFPCKANlSt4+jkNw1iMgePTnL
         EGkiyEES67Gqrtjk1uTmNTIH0xQ+nhJzKi4geCb0Ch8oyBeeNATywsytPdRajMVi3gfb
         DeZUZwEquyXKDVHlZkdS9a9O3DZbTrdasg4tyjxJ6HcfyoWRsoLAg1rJjKgXJagpBxHK
         KFkUQ+xlP2y1iLnVWkWmyYNACc8y6f4Nbw8Pc2bKmk1GoZGaQjIGfZ46K54dXpGYFPjL
         xxqw==
X-Gm-Message-State: AO0yUKW6EuK0UiQtgjk2M0ck08+CWRkZtWQ1FYqcjoZOJB8Ec/UEcIzb
        r2DYY3uiY/SMPb54nlEbSYyNR/2tsSQLExHBHMg=
X-Google-Smtp-Source: AK7set+OAk9sNKI6i8zO0j2G6KGfjGkMgdN0CSUOklPontGwEmn++1NY+2YQao9SfT7/+PrN8fDIjbc/xFdh8uZmPDo=
X-Received: by 2002:a05:6102:5717:b0:41f:729a:6b98 with SMTP id
 dg23-20020a056102571700b0041f729a6b98mr1266163vsb.3.1677750122488; Thu, 02
 Mar 2023 01:42:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:706:0:b0:3aa:fda:e563 with HTTP; Thu, 2 Mar 2023
 01:42:02 -0800 (PST)
Reply-To: godwinrichard700@gmail.com
From:   Richard Godwin <wr9236251@gmail.com>
Date:   Thu, 2 Mar 2023 01:42:02 -0800
Message-ID: <CABx9BKD8vRAXOjex-iTXkzM3aVVOHy2gkm2b-8gWOWVXOZi-wA@mail.gmail.com>
Subject: URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e31 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5391]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [wr9236251[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [wr9236251[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [godwinrichard700[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear Good Day,

I hope you are doing great,

I have something important to discuss with you

if you give me a listening ear.so that I can

write you in details thank you as i wait for

your reply.

Mr Richard Godwin
