Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B4D6C7D47
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 12:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCXLhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCXLhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 07:37:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B201CF7E
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 04:37:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso1307907pjb.2
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657853;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZeK4ZJ1o6tGrUVsDjmi+mms9O6S9hGyBZoeD/hC1EM=;
        b=NQQ9dPB+EcaahwWLFdJbvT0iUxwUAAfJQYR81VAMuLoPaE4TVm1Or6CGRrQQyYhjUG
         ctgl/+nV0Lj89b89P4wYyJkc5HV6MMxKkpnYvCF0nBWpB++ok3Oy0mvVdYn+KKvTW8eG
         d/M6GnvG+AG4voRsGegCjiu/Zyg30/ApdwZTXrqswG5Iof0Bsnfw2clkt46SDt6zAviG
         1DC8eNzJluexbkRz1M+nfL+M4EKFDl2GNUymbKlXeiuu9FwQbnYII1mmLmR4IQ+xF2bu
         /ezFIpDRA+P7LCGRN5mz+YWVS9HgnNIgfYMBRcVAX5uI31MfiqANEwh3dhVF+oaUfFHQ
         UwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657853;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZeK4ZJ1o6tGrUVsDjmi+mms9O6S9hGyBZoeD/hC1EM=;
        b=TtY2aFm2dbDSoAvpTIx7ww+DHWotU2nGmYS0YFcU58usr6UBPQ+ahFaLcOclUMZasA
         t18AXGR1y2jS8BqOCTUC0CpfjCoVSni6ogDkWe31B1Bq5CZZlIvqC1HUczfJ9EkXUvFo
         GFJvdjDEiCXQ9TEsYd1Qej9btWgo5dom05kFm74kvAnBYQXMpJHP1BHQYU8E5dixZf9/
         EPsEG/Ys22rw87zRpnHtkxvWfnE1EwtbMyGUy0UYW6LmldeVXJbPOirUv42u/M7YcFDU
         WRj1izpUpmBafsCWsqpZgi7LKK4f+Kv2lF8kXGYLv7BAARdqOtVM8UQQreWB8zu/SUKE
         T6Sg==
X-Gm-Message-State: AAQBX9f3wjU5QlTqkBA7kin8jvznowIO5Rpnv2Jw0rhZ2yoFNyWA5iGR
        Ovij2+nk1HZnIYcR64SscIOFGuMOCL+EeoRJ/sg=
X-Google-Smtp-Source: AKy350YncST/T8n8qWLE9gsBHFnZnOt4Z+nkMHrLd6/skvmJuEEd9roZ7cwEm8eyDL3jdpd+pltkrJQ+WdrzlkaHfqA=
X-Received: by 2002:a17:903:454:b0:1a0:5057:1b77 with SMTP id
 iw20-20020a170903045400b001a050571b77mr696540plb.10.1679657853254; Fri, 24
 Mar 2023 04:37:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:c7c3:b0:40a:64ae:d236 with HTTP; Fri, 24 Mar 2023
 04:37:32 -0700 (PDT)
Reply-To: fionahill.2023@outlook.com
From:   Fiona Hill <kevinhansen8819@gmail.com>
Date:   Fri, 24 Mar 2023 04:37:32 -0700
Message-ID: <CA++QgS9J4Q4dF6bvQ8MiHppzGMiSBOmHQAWm+pLMgFNYQU0QSA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello friend did you receive my message i send to you? please get back to me
