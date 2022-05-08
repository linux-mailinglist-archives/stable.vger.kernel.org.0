Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3156651F062
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiEHTVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 15:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354503AbiEHSPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 14:15:40 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFFD645C
        for <stable@vger.kernel.org>; Sun,  8 May 2022 11:11:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l11so4679067pgt.13
        for <stable@vger.kernel.org>; Sun, 08 May 2022 11:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=vjoDpwFE1e6L5UDSC4nVKYfI29sZ8oap5maxe+DRdss=;
        b=UgpqNaLiwx2EQHyBEpCmAK5T9xvYwIa+OcAOTqqAh7ZpSagg+jpBrbg5xj2aZWDS7k
         AhpHyx7PK5jF1stlaJhQT+iAk11H8hGOGPyD69NFcmfeL5hSQSpd/d5fRQ9Kk3opXVFO
         yi+F8qfmfize3/IvGswsYBL0xnY4+gQ8FuO9BbxKhllsYq4SEmKEyNzekRmJeVzmunF6
         rrH/bDtWN9jDfOe4B6VJs/euM+k0rmytvaWtWO6RsuHA33JP29DQvUnMEpz93VCu+Qm2
         5MbFdBxWrrNdKoaANYmUhuOmUQwgzekU6jaZc4Oc0wU/biHmo2ZPt7RrfmD+cADo/SBc
         KY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=vjoDpwFE1e6L5UDSC4nVKYfI29sZ8oap5maxe+DRdss=;
        b=56sy+QMPJXV3UHo93gecfH606qm0XYMHS2GLSD4sXOEb3dKXotjTmoW934QhBVN+7n
         dx/r+asQqcXSrZ2wPwFWd2K9IulJvN+gfA+RSuiQJE4lmjWnqljQJ9OcnW552OdZMCHO
         Ms9Ce94RdAXrs44+9p8gIP3QzMcbEeN30UA30tbgw75tUSTjbxBgIWNvFmz1aLNsq/Z9
         p2ibNx5d/i9ImXW9zOue2i/YSrxygc77nsyiv+t6vJCZkDMkgTSQ0kmFzLxpMrZ2XCt0
         FS/gwHRDn6sE0lzPprz7ewbT/KJA8svjDC5fDA0g4iAgynMnR5xaZsUyqYiV1syxUfA/
         08UQ==
X-Gm-Message-State: AOAM5326uspSQsPwmdutwaTsnSKrUbsvPefUTtBmgKs9zff1uOhPYe1x
        /xZgcEuJXf7kpzUOTrE5OLk6dNuM8Ktbdzxn8oo=
X-Google-Smtp-Source: ABdhPJx7juh31B4BNT6GmJEiEheKSgnGBAT3SAaTeaLT/G8ScuBFsxQBHLWC0DEFA2i0yE15GfUtIm6B/8/qBwOSNCk=
X-Received: by 2002:aa7:8c4c:0:b0:510:8573:e7c0 with SMTP id
 e12-20020aa78c4c000000b005108573e7c0mr10896305pfd.52.1652033509276; Sun, 08
 May 2022 11:11:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: edmondpamela60@gmail.com
Sender: service55089line@gmail.com
Received: by 2002:a05:7022:439a:b0:3e:40c4:563f with HTTP; Sun, 8 May 2022
 11:11:48 -0700 (PDT)
From:   Pamela Edmond <edmondpamela60@gmail.com>
Date:   Sun, 8 May 2022 18:11:48 +0000
X-Google-Sender-Auth: ONzwc2QLlCGIZH2AtDraWSdr3fU
Message-ID: <CAE-=xEOwd2chXSbJ9_aPJA6OGH0kCb_XJM7-_-02kk4DUgczjw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I was wondering if you could recommend someone ?
