Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3FE6DB207
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDGRtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 13:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjDGRta (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 13:49:30 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF94FE55
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 10:49:29 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-54c0dd7e2f3so101552807b3.8
        for <stable@vger.kernel.org>; Fri, 07 Apr 2023 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680889769;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fJVg8Gl2LewiFBwfXuZdFen7zFN7fEmSltJ1m8owDpE=;
        b=BenTdjYEwVTVh6h+bBrQEU6tlnbBF3DhuWff69pCx0B1p9U/5BP6IehVugfJgAWQvu
         UtU3LdIZcI8z+tEh9krnHYqXNtriQIGsJ1TG0GWHeOJx6wjq9qUQ6ZFaeiy2jEh/jvgv
         q52Djb1Cgpf5aL1aI8bqnplwHkNLFyw511TZAj4mcb827Rp3DaSgaBCd1+DTdK7+SuP5
         R3GWJTJ/Rt2OVtQsi5HuBpRLA0YMr567WLgTy5KeytW7ky/+RWJnubHPDc92Mu68azLP
         DGHNuI5+BPBkpKdOo3hB4m9qTZ9Pb08VT4lgWfJoh2SLz/au7kVnTzfHRTQl9rjMCNYk
         Ocag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680889769;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJVg8Gl2LewiFBwfXuZdFen7zFN7fEmSltJ1m8owDpE=;
        b=A5HKHBjfKA5IIzoBEt/wt0uPeMxMqhpSZKUxZBFYyciVKcarh/0wNTPNVoObVZMT6l
         fDIzJO/5Ys0wvRSEYvxjAgWPmtYH6SWYyLABTOcnSWZbI6Wz9EYi/psy8PDjtJ7XSXsp
         M+xBFKYWszOAtyojy195r+jjI73mWHW2js/bozjz1uNV9uMAhjJSsCRiih8hmE0sDT6H
         3zDBPNmjUtWMu3IG5ZwfAl4FVHPcVXkiE2q6q2thOjqZAI2UzyrTxAD6TeiSMwEr2gCp
         DYz1vLVCx1335IrRPbFfyjIz5AnrlThqdxvySjbwr6YT9ts5Q5OPxeMMBjTF7ty4vkKH
         v1Yg==
X-Gm-Message-State: AAQBX9chKCXjWGyYGCGtAMN+/nvtMs5TsTI32dDJA5VmYnaG2VfebRUd
        D85nzAjt6qLFhT0iei2xgvcjB/Vdo67NNyfml2I=
X-Google-Smtp-Source: AKy350bt9BJp5O1s5Zvo+aOqvOgTMKgQPB0VyNgxdiMvT71RPVB5SPIna5NpWy36KNjo6kU0HbIA8qFuWVvllPLExEc=
X-Received: by 2002:a81:ae45:0:b0:54b:fa6f:106e with SMTP id
 g5-20020a81ae45000000b0054bfa6f106emr1558647ywk.4.1680889768874; Fri, 07 Apr
 2023 10:49:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:1412:b0:341:7e65:bad7 with HTTP; Fri, 7 Apr 2023
 10:49:28 -0700 (PDT)
Reply-To: dulfertoppa.consult@gmail.com
From:   "Dulfer D. M. Toppa" <makoya.dougan@gmail.com>
Date:   Fri, 7 Apr 2023 17:49:28 +0000
Message-ID: <CANTjUUOitaJ-F2sTS9g1nH-hBvyCwPLmf-8YEZA7=YuRwDOPWg@mail.gmail.com>
Subject: Immediate responds. Thank you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello. Please I was wondering if you got chance to review my previous
email. Thank you.
