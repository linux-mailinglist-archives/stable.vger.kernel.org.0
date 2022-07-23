Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF157EB05
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 03:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiGWBVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 21:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiGWBVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 21:21:06 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A75417A95
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 18:21:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g17so5899107plh.2
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 18:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=U+dzFxYjoIej96hsMOeWWW1NbD1aNdMbXqxmt3AZoRU=;
        b=Oc1m0loTqZGc8bD3oH3sln8JelGh0Z8BJVyzGWVNrUCWnYTLFkb8UnZvIUVPMpD4AI
         rm34HDEFxgltUwdgDoc/T05bmZGOFa5Ma0+Lp4QsxSQT7pWLmMjn3PTkpj+i4CdmL20K
         /gDgL18C/JkxMIId02IqxaX5KGXlWrKrWg1agO5/dxbzBV1JdMYrCzoN2viMU+5h49Lw
         J1XWWqufXLoP/S/9iCLwjSeC96KG9yZrHRCb+nlfA8uKWFKEKhV+LpVI6/6imU3WinJt
         A0UULnKKv6IxaQdd1mrPeJf9pH+4H+mJZ+hCFfYj2Wu9qvT9O90l8/kC+24+58Wp+rgQ
         l+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=U+dzFxYjoIej96hsMOeWWW1NbD1aNdMbXqxmt3AZoRU=;
        b=MA/rfqMUOgZ7yz2nUptOVTMaNKY/7rrevq6E5K37HBWR0VCunb22o0XKiUKK3xz8Oo
         Y7veBMwP1QeVfOXeYmmLKwcfj6ZpHBsS/tx3nG4cBJSGeEcYYnzwDlFiu7RG1hoBMTSl
         2HAUFM0VN+h328GolwZI+vzWKmr9nYd3chcG7zXSlPa9d0Zbl9E/+6RjMFivLqJuN4S3
         mB3MV8cKBsbVu4YCSM63tJEOrVHtHKGKb+Gm8uXTNoIK0y8t0q0OmpV95ibuqWva/6Q9
         b63XpMXOTlh24dzxsCbH7bzA2iLT/u7colB3nh/xsP/QK4EAM4V25p6CyzswZGpqZRt0
         8YIQ==
X-Gm-Message-State: AJIora/yrSuiIWtjEgqG9guZwpKjsyoMpuRzcChA0K0/PWisG9DhGe7d
        hS0L0KEB6o+So1kndE5axN4Hi0H1Hj2HNZ0Xc6N7mJGSR2ydDok+
X-Google-Smtp-Source: AGRyM1srus2lUts8KJm0vDKTr2hIpahwn7nE9g4SG5iEgDUmfKAjQEgATxeg4xIZdcdIB3JKrZt0ykg7ddIK9hdscVA=
X-Received: by 2002:a05:6214:20ee:b0:473:aaf4:c63d with SMTP id
 14-20020a05621420ee00b00473aaf4c63dmr2422700qvk.9.1658538870592; Fri, 22 Jul
 2022 18:14:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:7fcf:0:b0:31e:f577:d651 with HTTP; Fri, 22 Jul 2022
 18:14:30 -0700 (PDT)
Reply-To: shahabayub01@gmail.com
From:   "Mr Shahab Ayub." <shbay2987@gmail.com>
Date:   Fri, 22 Jul 2022 18:14:30 -0700
Message-ID: <CANzX9m58fHcTkOf1jRKkT+JARakykyrpyWQcFYpeVgWHYL1kCA@mail.gmail.com>
Subject: Greetings Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:644 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5010]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [shbay2987[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [shbay2987[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [shahabayub01[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings Dear,

I am the Compliance Officer working with security services here in UAE.
I have a good business deal which I want us to work together as a
partner. I will explain in detail in my next letter if you are
interested. I look forward to your reply.

Yours Sincerely,
Regards.email.(shahabayub01@gmail.com)
Mr Shahab Ayub.
