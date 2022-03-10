Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242174D4738
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242135AbiCJMvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242111AbiCJMvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:51:16 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D73014995D
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:50:12 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id b190so5788715vsc.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=CSHkRcUO7pOnoHiPdBjpBwrYVvybBqjF/L42qAmaB93hrprBdCf1/YBYPM5O2E4kw7
         0AyETRdckGGSlJEmyrnkR/fZCs6vG/IAbnPzJqRuc9YA93yg0pcIvKS0/P7jxMt6YqOp
         Kx74DrnVYtSF5aKF944+L4b1KEbGSZmDrJR2rYGjHubdCgnzayanwKuDtEzEU3UM+igY
         hamzVHdpa7aN9H4IHjj0mH+ZuUbzxBIi5sDuenIy+5USfQa8R5+3a8QX+jpUQpaGRrGe
         4jF0QTy8Y5PxSqCJHk+vJOFxchbi+4830Iw3FS9ICu3BW05y6t8W9oL2MfXqMMqkemlD
         peiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=oCRo52h3go/0FaQK3JwxsT6mr62gdWxToTIGalOA7dV2lzCRftCRkwJ/O8wZTwBN7g
         L6wRm+jFBISYUX9W6+QHJBUwkQ1Ho+B1Uua2ZzkwTlWlDoOElESAPoWlHSqnhXWn7TDa
         sQIZf6CHvGwyI6lFvmyWWfLntBkS1XmHalCyfThts8lGhEUPwToOD8e+MMdeeIr8omDi
         wK7/Mp3FcgA6WkmjXpDgoYnSSV3y9xqaWpsZdgTgjT3CXEsnRNJyfjPm9gf5q/soWhg1
         7uWUBNNcMplXqn4Lh3q2hHi86KPyCLKbw7jFDrjKlnYuaZtBaiDCPAVwZHyw6Kw0j8hu
         KA4Q==
X-Gm-Message-State: AOAM531LV85+KGGhB30LFLDyK1iFjMmhtq9UqZvz/YeNYZ10BrYO/rUv
        PYEqfXWtcflPIyE438KjVwxZkneiLEmpWgIos78=
X-Google-Smtp-Source: ABdhPJxAQSy8LVsEvuwrobNx1dvOIU3HtZ2G5QXWADLnJ73nrOaXnD2wAE6ztOd4uLTLiSILca58jT+MVd/9hAlvB3Q=
X-Received: by 2002:a67:fd0e:0:b0:321:d721:e5af with SMTP id
 f14-20020a67fd0e000000b00321d721e5afmr2106261vsr.58.1646916610967; Thu, 10
 Mar 2022 04:50:10 -0800 (PST)
MIME-Version: 1.0
Sender: rosinamasara470@gmail.com
Received: by 2002:a05:612c:2606:b0:28a:b1d8:3f4e with HTTP; Thu, 10 Mar 2022
 04:50:10 -0800 (PST)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Thu, 10 Mar 2022 12:50:10 +0000
X-Google-Sender-Auth: TGk9air7cJOxaIYkjfI8GSs3MkQ
Message-ID: <CAGdO=19a3=cmsCzJz6uuO25C=nrVbHw6u236e8_JPCn2hxwmmw@mail.gmail.com>
Subject: My name is Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hi Dear,

My name is Lisa  Williams, I am from the United States of America, Its
my pleasure to contact you for new and special friendship, I will be
glad to see your reply for us to know each other better.

Yours
Lisa
