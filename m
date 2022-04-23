Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95C250CDDA
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 23:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiDWWCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 18:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiDWWCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 18:02:01 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA162BCD
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 14:59:03 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id y129so8345765qkb.2
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=CtX/jLR1VwOFEdS0fLnGgBaJwDdhZNwe/u0NQoR2wVU=;
        b=fOrBhnqc3UwDHFj1uarUYL6rTbXHiJqNMn9b1V0MJ8Eae6ndaQsFu9jDLo2WgoEBz3
         miKgT7Nzh3BN1cvtI+0IfNCOMBugmS9gZ8iTx3fenqGVA/xnQfurNvd4PusSi5D554bq
         hq3EB8ylNqGvlP4FhJqGS8RT+LW410TA+jMPKBZhw581U9pApGVh5UcYOCR6v7d353dO
         3iRexOi5LszXHT8bTPayJ1ls8IaKpzJTD1O0IWxNqk9hncpoARMmXwADR5gjHSxnl365
         pwy//7BjGZhBNUTdPP3v5GOaqUctdg7S5CBvyP4Z8LAV01vxY1GZ0JCFof65ee5jxl2J
         f8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=CtX/jLR1VwOFEdS0fLnGgBaJwDdhZNwe/u0NQoR2wVU=;
        b=3WoW1i8z6NAORFNfEWg650ofl2pye7ANuBqnYd21/FzQ0haZZC2jKLK6eP9CeckZP1
         VQ5Q1uzmJhAf9zqmJ59uDUic/gXAtQ53C75/Byl2JvxBML9Riq9b9n2ovrfYmg3FC8vg
         6dLS8PZwm8w/TWIIWM8t7WmN5ov1LOnu7Irvq0HoOBjrTRk3wGbaP2PxpoVW5fVwIsL7
         XJWlVr9OVITqGJWPka9K2ERDPHfvsghykq0p7ITgpsUF2QqEuGSXME5Bbrqe3ALY9VkL
         V4ekxJOlUh1ePHnGRtY8tuC6qLLhpHlhir6jSA1aFiA+i8CR33p4o43u/svtKg3VPEoM
         9PDA==
X-Gm-Message-State: AOAM531HzxP/fh9pOZh/Qs/q+ItegS8mrkfJEWHJ4FoexJhILdlFnQCk
        YUXo0bAQxr2mO9WeDup5Hs4OG6GP5apBTWTFfvY=
X-Google-Smtp-Source: ABdhPJzcqlnvrJbSKsg6tKo6i2oOMeoN2Hu5iFkOiFsnvG02pcfROTPObnD4ut29zSFRMVwyDb817BqaB4YOuZMbYB8=
X-Received: by 2002:a05:620a:280e:b0:680:d1b9:6b0 with SMTP id
 f14-20020a05620a280e00b00680d1b906b0mr6484023qkp.391.1650751142295; Sat, 23
 Apr 2022 14:59:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:484e:0:0:0:0:0 with HTTP; Sat, 23 Apr 2022 14:59:01
 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Mr. Jibri loubda" <gjibriloubda@gmail.com>
Date:   Sat, 23 Apr 2022 14:59:01 -0700
Message-ID: <CAO=FyHL3mM6q9hjm+44aXWFm6rMxSfWLN=NizGC10TzsCBLZNw@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4846]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gjibriloubda[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:72d listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
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
Greetings,
I'm Mr. Jibri loubda, how are you doing hope you are in good health,
the Board irector
try to reach you on phone several times Meanwhile, your number was not
connecting. before he ask me to send you an email to hear from you if
you are fine. hope to hear you are in good Health.

Thanks,
Mr. Jibri loubda.
