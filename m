Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F310662AE2
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 17:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbjAIQJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 11:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbjAIQI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 11:08:56 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DD63D9CB
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 08:08:54 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h192so6180126pgc.7
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 08:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xXEx32e2dayMDF1s8Z2ckfFPg2j4FmTkUanUbBsNRQw=;
        b=iocKpOw5aoUEK2oPJ8GMewYGFtlYRin8Ek6rd/Hxr31Qjxc2lGydTzlgZqUFyEq3n1
         4sSlAq2DUJPatYHuyFojM/Be2wKAEukpJOIi4VArSKJ5KgLdOjORnXL6xsM8F64t2TAE
         b0cbsr5BGRgRICsN3bfTskXtIMpOKJZHOTzB7bX7ytFkWU9mu3eRutEEinRJ0BMsx2dI
         lvigrFdzcA4ORAAfp2xhJe25zdpU/31l/RnmRX+k0JYi67sD7lb8SSMW+58+qNoUd1pd
         ba7KLECsxUX6AXigN5a29aKB9yQ9VaEDMws+q+l0ZYlH4yGLN/19Fq/BtAdvxElA6ynz
         ZgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xXEx32e2dayMDF1s8Z2ckfFPg2j4FmTkUanUbBsNRQw=;
        b=e4yZNkY9WMSBMGe+N0oOqwWmK57IudFkjB57V+gNk3PgVTUBJcwWTqxpbOGYd/dqBu
         Ky+xHCoBs5z78dznMUQoEoHKpu5nvcB/S5bxlD3qqo/qSv2n31jUj1ZwNODExua/nuXp
         EgBBrEeNsW6SSbsBXxd5FjsU8t4N6Dt3TG1UWBHN8URpf5xW7uMzWwCca3GSod1vYklC
         t6MXZbiVnnXdHPQINu/MdC/7wzgYBUVGFFFeGp9ZEdPu8Ni4FFWDRKYJBEba1drVpPOA
         vEApQIoJ3eZ2HGFFU65gmXKIPUDu45A7s1eLksMYZlO+rxuoL5pNIrbd7XobfglyIgvS
         1qlA==
X-Gm-Message-State: AFqh2koyY4sGL0KApODg9+g5ql/YFAb3+zkCIE65GhP0EBT6uNV0xFNa
        w0BsSMWepJkXXPSodNOngiHDCLeDGhzkQryiPgw=
X-Google-Smtp-Source: AMrXdXulcoIi3kuPjUfF1D8f8ARh6KD2MAKz5q0KvduVwZFEAunwHUUSP27qrvDla5HibngxHC4v8jdeKV9oHM+Z6II=
X-Received: by 2002:aa7:87d8:0:b0:581:29f0:202b with SMTP id
 i24-20020aa787d8000000b0058129f0202bmr3620113pfo.74.1673280534363; Mon, 09
 Jan 2023 08:08:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:f3d4:b0:395:5f19:2e52 with HTTP; Mon, 9 Jan 2023
 08:08:53 -0800 (PST)
Reply-To: ga951039@gmail.com
From:   George Abah <ga8651383@gmail.com>
Date:   Mon, 9 Jan 2023 08:08:53 -0800
Message-ID: <CAJgBLQi+OyjS7F6GWY4umrVUAMw50ndWUC7m_s4FOGQepay-Kg@mail.gmail.com>
Subject: GREETINGS,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Friend,

I am (George Abah) from the United Kingdom, an Executive Assistant
working with the  Global Asymmetric-Chain Funding Inc. Having taken
cognizance of your profile, I would like to discuss a partnership
opportunity with you regarding Finance. If you have any viable project or
innovative Business  plan with high ROI, you can as well bring them on
board as financing is also available under reasonable and considerable
terms and conditions.I look forward to your response so we can discuss for
more introduction and to have a mutual understanding.

Best Wishes
