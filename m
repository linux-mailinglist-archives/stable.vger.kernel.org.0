Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44522653E12
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 11:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiLVKO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 05:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiLVKO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 05:14:27 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4AB165BE
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 02:14:26 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c7so983179qtw.8
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 02:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wvYkwC9H+gGNd4NEom3+Xu/RR+x+eUQGji6VjEa7w/o=;
        b=X60+g+IpE68qK+Nk1Rfd3JNrBluDPAj8OZoMeKkWEB83v3Q3jGwQmGLrHySoRqsbOS
         m1ie23xVYSDTiIFNbGvDzQOpUSe4yca4kNGZ+LDCskFg5FGnwWoYAlGO3ZSLGt6UXfLO
         g0rw7P+ky4ZOk6z2a03eyTS1RO2ykAcdzSyh0Uj2t4ljU3xLSohly0QTSUkpDYly96Nz
         IB3ZsXAPnVC0ih6kgvQYZegto4D2DIq8wlehNV/nCcVdVkwjKsMUNE8gEN17tiTOTQ8Y
         BgcENi9XzQsS9OLWHcwyQC472SmkBPFxgFYr/uLnMERPjNu+hXW7Y1JkK4DM9n+4g/z4
         S7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wvYkwC9H+gGNd4NEom3+Xu/RR+x+eUQGji6VjEa7w/o=;
        b=UyK3iBbTIMU/8+2m/mnjGSgc6gN4xhoRwVgNH1WTnszFOqManyHCLdJTFdFtmUElYg
         zD1YNBlKJyU3T3G0n+Y9FGm0uM+leIuQZ9dKsXG6ugslyL2bUqhqfRz6NPWTJy67jv6v
         /PhwoEcp3NCbNjLuElQJnUYA7z+K167AjRIAx030lMZYazT53Gf9wpY/omEls/6RKrlA
         xmlO+xBQXNjACBu1do8Lj/chIYFuN3QRA2RrvJCcoyJaZ+p/zVozCXH00qiY5HSGbvuo
         ajJUTqkbP+hMjNKzYkNmCBJVTQ1AFcZuT3GW2YpJQUVNHeqKt5YlnCPBqakDlSmR2uE6
         WvyQ==
X-Gm-Message-State: AFqh2kq2WH0pcjcCoKeKZk+D2ts08yBzAzRfrLJT0d9Wd5HuY1tiQVQK
        c3DyzBGL7mhSk413j2QsUYqM4hRFtFwMhVFIols=
X-Google-Smtp-Source: AMrXdXvYnDydec/5kM+dri/907ltgVJr2ozXbZ4ugDuknfYctzESRkeLR0pZjSjgy6rO0ELnO32+1+DyerfJ2H6UknM=
X-Received: by 2002:ac8:5e89:0:b0:3ab:5b4e:d1da with SMTP id
 r9-20020ac85e89000000b003ab5b4ed1damr218337qtx.681.1671704065294; Thu, 22 Dec
 2022 02:14:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6200:5c8d:b0:4ac:7e48:3154 with HTTP; Thu, 22 Dec 2022
 02:14:24 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   "Dr. Michelle Daniel" <dmitrybogdanv07@gmail.com>
Date:   Thu, 22 Dec 2022 02:14:24 -0800
Message-ID: <CAPi14y+SjNFnNte5ksik+nZtWr5L88MAxxAG3aXrLUWOMP1yzw@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Dr. Michelle Daniel
