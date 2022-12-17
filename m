Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A373D64FC63
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 22:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLQVNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 16:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLQVNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 16:13:37 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCE21004F
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 13:13:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a14so3918556pfa.1
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 13:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=Q5CynEHzrNUTSw9N+ZVF0ExD4B8uuoj7VBpIfnZ8cHVTpOxpQrxWCZHJACU7mc7Xag
         JDxwyNVERhp2G0akuDf2Rl6wSqHUukch+vRgIM5PqoGl9jXUvtTGUW3RzeAi1L+b19pp
         H5o1MKf2kN9ePjYR1++y/sWNLtZKkTiQZKsB1x1VgjsnfaOjqtZB1hB9n0Xm+rm9l4PA
         Vo0MFWU1arAOvlRJZLVNUAxiskh+o3R2ka8PkIgp5jwraujJgqgUY7sv7cQdL9tF1Pns
         ksLvIL/mwl6KmqspVs8uGg81jfK4s/3b5onmGnLmO1r6tr/bpSOkwwRa0WCWtb+I7RnT
         EFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=q77H0GK65hHS93t/zBPT/H9NNA+ZICwR5KROX5q2B4GQLXXKlMv0KeDf7lWE7JunEN
         e/yimhhJmGlSf3DK/tgX62la4XLg1y32h1a9A9ub5sYSuftc38z2CgUpmtWJpRo/hLiE
         trEg7M8YynVdkJQ3I9tJGbwXW1TeeQUEIezYuIwg/rojFwkQdsu7700zqnnl4Re4aiSl
         NPGIvDcwGhkv6oaJ30myN1TAmQZ7BzPQ0F0SF9aPjS+dvr7zfSTS3Y8yvOd85sJT9qHZ
         yjMHxg7VRGkpEkaOfBORaxwrWTBXKUJh3stq07RiVdyYDlGv34rIYjzOuXmn/GUnk+Tf
         W8+w==
X-Gm-Message-State: ANoB5pk24/BWI6IuyEqkhrf5DpoHzKCe+DALjbh82GaREF1OWS4e86VQ
        /coVQdvXHHHCJUmhE4EDMPKq7H3gFkiXdNySRgE=
X-Google-Smtp-Source: AA0mqf4+Uoi+4XrGgW6VAgp8A/AlrNDPbqC+pTH92kpOdbs2gTMu1x+1mbvWYNgZHHcbCMylmGcvwDkInnk6V/6WuJo=
X-Received: by 2002:a05:6a00:1d06:b0:577:4103:8da with SMTP id
 a6-20020a056a001d0600b00577410308damr13530660pfx.1.1671311616070; Sat, 17 Dec
 2022 13:13:36 -0800 (PST)
MIME-Version: 1.0
Sender: samuelaraba79@gmail.com
Received: by 2002:a05:6a10:d58c:0:0:0:0 with HTTP; Sat, 17 Dec 2022 13:13:34
 -0800 (PST)
From:   John Kumor <intercsctg@gmail.com>
Date:   Sat, 17 Dec 2022 21:13:34 +0000
X-Google-Sender-Auth: 6gcz3P97mmK4ZcFGGOoCWt8U5x4
Message-ID: <CA+62wYB1R=prA7SwueGSssAHOqGiPoaHUT5sVCywnAnHtS-oMA@mail.gmail.com>
Subject: It's very urgent.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
