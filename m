Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9978E58C4ED
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 10:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiHHIdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 04:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHHIdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 04:33:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE6213DE5
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 01:33:20 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z19so7928463plb.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 01:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=K/FYN1zvN+b7oXMhqI+KTbmCOwOgcniR1F6fn5h0uqE=;
        b=irR/6ac5tunj5439Mcmz9FYik2XzIciquRexhusx3C4KUSXf+KaFue3eOXX7fCl2sr
         92ZSzDnnPlaeBaUUTLRRX+/9Y9HyPrUaJLl2zB5c7Cum1zYc41E79neu/vBSWq2VEnJq
         eJV4En66wZYrCe858rm6YsL2aybyOYZQaqySs4k41s9A7MbDXd9QEyPUuKM3wlNc50IZ
         5TMGNSuI4ZLhRY6FyNxhLTprP2HoHZ9fKiGgSOlTwFRUZfJqYqjVPhJm+Frtdj2l4J1o
         X6lntQmQMFznC7ZHMEDX7tU8e5+qbE5HRqirN2N2sowqwW9p33JYqc7UPGubtJ4Ycc6u
         sr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=K/FYN1zvN+b7oXMhqI+KTbmCOwOgcniR1F6fn5h0uqE=;
        b=5ao81jlfgEbs7Aj/q/20vDbSLKKFj2rATCw/yNaz5U+QgZKx0mQJ+QFgT0G0+MnlMs
         /cbxSgsJS2QCdsKvpd/Ya5sliYGKfOj84NwRnGUrOqAWrlX3hThQW+m2Ihq1RPKA0thw
         coFE0DBExbV7xsRfegWJSdFKmvv/r7x52+5opsETYnVjKMp+Afr4oO/X1nLQv/x9/vgR
         iAxgJzyP56lraCZ9DsW731ycqeYY+0tKXoUqPW8123B0xbR0Vlqqia0f2Cg1VtFuFpW2
         x71tgpFdxOrSHnu1/vGy5z5fT75W3m8uCnbSze5X7FHmWpAoYESi0g1PN918UHyd+q58
         fB+Q==
X-Gm-Message-State: ACgBeo19RvOGBpIGj4mdnC4U/NI2SQBzU9jWJLOnEd/5NdLthOvQ6pon
        ZQ9fZF2fqf/qEVwUtQSkPuKqOsW/QRHK769DgDQ=
X-Google-Smtp-Source: AA6agR7/Wn93iML2qripVxio0a9hXKYaFr59oWn7Ow12rsD5UkMdcoMnUkXIAddQzcinEq5//qOHLbrN7E9YN+RWKIE=
X-Received: by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id
 q18-20020a17090311d200b001678a0f8d33mr18007667plh.95.1659947600361; Mon, 08
 Aug 2022 01:33:20 -0700 (PDT)
MIME-Version: 1.0
Sender: aklessopessetoki90@gmail.com
Received: by 2002:a05:7022:6392:b0:42:cb55:150e with HTTP; Mon, 8 Aug 2022
 01:33:19 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Mon, 8 Aug 2022 08:33:19 +0000
X-Google-Sender-Auth: 2seNaYXa--I_y3h6b3SEK_kO9xc
Message-ID: <CAL_1YZnApvuF=W6Uhk3oC7DP7bemjn5mncTcu=wEjST9=EEDEQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello how are you? I hope you're okay. did you receive my two previous
emails?  please check and reply me.
