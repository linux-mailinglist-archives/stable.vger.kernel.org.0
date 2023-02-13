Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308BF694447
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjBMLS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjBMLSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:18:25 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150ACDBD7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:18:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z1so13140936plg.6
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w08RRSiGes/din6ZO5YkmaML7Zeo5YEC2K5kyi9SsfI=;
        b=g6T7vx+nS23LFkkRM7tvzakx/XpX2nPZFaLMLPpWWI8M/EAF4jlhacMUzg3aygvGeZ
         OyACiN/OIhAUrtdkUrBeURu/Fekmk77NRKpyRFcpPui6Z+mXoKbGNWxTW5jJRYGuMgCB
         8QZIpJ2IeCtjM5u3YZucAJSa31NGkn5AWxayhyN90s4CIVeeZujDsTCaDgYd1FD5EXxf
         KpJR0NmPhsVmxShtMC7tairPsleiWmq7aIcpbQdJxzGWYGF78cKUiAthvGge0lPt9SdR
         kXhwoBxla/eB7EvstANoOqOEcAcAZF6xuUvXe7ihdzxzHLztM2vjOXlvSN65HWDWKVTe
         FceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w08RRSiGes/din6ZO5YkmaML7Zeo5YEC2K5kyi9SsfI=;
        b=AyiJSazekZ97IVEHtOZP0VeJpUoghTHPxofE+acJZqootj0b0TQnJRD6QTQNctPeea
         tvm5UY2IgsC1yks+CpDIOkymIVwEGTHuU1kvvH9a11FYQmKaJuXv3qijQ+4jAsxUdcpX
         7y/4uEykfzH7qDv8ZqlaECAna+KbUpx5IntIFiCj2el854jzRqPJF02e9rv2R9namBFG
         QDWqjIZ8WRQxZFVNuM9x1sOx7oZ2si7BCy4fhgIXAS54QWAJSIfiCIyE/8xZWjpH76P4
         d90+FDvvs9liwkgLti6oYtDmt5Iy0Lj1UdW6Y7HVJpmsb8uya/CzHCA3Kt8xYMMDpeSR
         CmOw==
X-Gm-Message-State: AO0yUKV0pE//YxerfSmZVfuRL7bJDE2oI7fKWchT+rr12pkpEBcZxmrr
        8OYAVHMyaJJlzei5gpQm04sXNqsC5rv56x1z9xs=
X-Google-Smtp-Source: AK7set/t7sj6er5361pO1tHdKrhgAVUo441QjxAeXQeWZSHRRU08s06Qrvwkg027cFiDUBkmNe8A11RfVjqwsEUlS/o=
X-Received: by 2002:a17:90a:680b:b0:234:117c:970f with SMTP id
 p11-20020a17090a680b00b00234117c970fmr231007pjj.28.1676287103422; Mon, 13 Feb
 2023 03:18:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7301:3c9a:b0:9c:1817:9053 with HTTP; Mon, 13 Feb 2023
 03:18:22 -0800 (PST)
Reply-To: ahesterann@gmail.com
From:   Ann Hester <johnricher844@gmail.com>
Date:   Mon, 13 Feb 2023 03:18:22 -0800
Message-ID: <CAAAsin3+Ht=_xreWwcRohzpNN=X2Vg=7rS9=A2wwbZk538Uthg@mail.gmail.com>
Subject: URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
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

Miss Ann Hester
