Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA14C0621
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiBWA2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiBWA2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:28:53 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BED555753
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:28:27 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d68d519a33so192650657b3.7
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=f7/unPBlOodnhChoPkJICSWRyiuFSdr9Fh0Fceik+yjgBLU1bF0rlrnDqlggufKwQs
         i38hSv7IJGS7dLY02CSL19AkYLrQkaCYqWjHLQpe+7/If3bEuXsIFq1VJuRLCvmURs8X
         reGZFDIwtRO6IyYNJkdY2nVVQDhlvKYupq5aKICipBdldHy+63PjMvq5axf3Y3EDUuYC
         0k3ZbkJ07qXw6vg7o9HdCct0UhTrcyRgqWYqQwyhXOdSAH7oJFn2VcsUpS27mvtOstsq
         EiniBiaTZhN19KTof3Z+jLbynWVLOTWcc/lJb6/XEOAVS/BCnnlT67uBNDUN9pmNheP/
         XhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=djQIkxH3LklHjD5Fs6SUTzE1a5E8OK1WbTpstAJr6onihwXtEJS9bFbQjfDMqDB3p0
         DW7LTY2DME9n5arvhsJ8UjDKFZHp/ySpl8K+TgMmcVEQwnTyplZ/a3xOIEQbWq1mdali
         xy/rK69Z/3yAcuIO8h9kCyrlOmdeRgjdnNbfnqMbsJ0atKz/4S7/LgU4anjWC/Re6DFB
         AUquZqtIwasF28jN4nlYvQPvZE0fuhNWx0kJF84YyoTS/0Zsrag5l5GvYq9kzE4dDk0c
         XwQUjZB5KDe/Mn2gWAvMMi7XkTFBTrP7/JraBdwf83sBXB5Myuj2WuHIsvPgJponNvde
         B8dg==
X-Gm-Message-State: AOAM5306mXBsHTNoaHOsJXR9z3MBWwwNKuSgYhlObEbZwDnn9Qb/ktC0
        nHDpLgB4N9pwYpd363E1egT98w4fnLoxJE05J9btEV6o2gY=
X-Google-Smtp-Source: ABdhPJz3Hau5Fw41AO223GgtnQveAYLj8CM1zQwVuxlWs7DbJPcFFAFsQpmFld92glsqRNNeJAx1Q8InrBUukhRwA6E=
X-Received: by 2002:a81:4d41:0:b0:2d7:513a:f3d3 with SMTP id
 a62-20020a814d41000000b002d7513af3d3mr11148655ywb.34.1645576106703; Tue, 22
 Feb 2022 16:28:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:7048:0:0:0:0 with HTTP; Tue, 22 Feb 2022 16:28:26
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <arafaeloxford@gmail.com>
Date:   Tue, 22 Feb 2022 16:28:26 -0800
Message-ID: <CAM=40BJLGxb4Phv0fw_k6VpPScGp9x=E5qXC=-hANH0ZJnvEJQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Please with honesty did you receive my message i send to you?
