Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1BF6B5F7E
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCKSEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCKSEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:04:38 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857E813534
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 10:04:37 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so7992795pjg.4
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 10:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678557877;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4H+bNpp97fNs0DJvfrKKJ7SEqIL0C336vSLgUyHuDQ=;
        b=pnsQT2Olgp3ETN+upnO2/6KgZU532oBGrXzL2D9YsZgRKngmDo2kq4Zo/6Q0PqRVH5
         RpGC0fwghm0QLBkxdcKl4h/REzkks4cvPoWqrZL5AiFEaKlx+Ic4/XBY2yKo9H3KKoTY
         QXT+rSGIjj2/2m86pYgSVMXpqVxT8YFJhnxldrq4lWuwXsdn8nCRxXBljAONY3T/Qmya
         Wxn6xYKn2DnU2FWrWistyQFYANNpxzT8dS585KzO+kTv9iSE16O36XJK+L93cjdL/E4C
         Fo7lAroVMFW+CfCZGspw0pd5E0jUHbGZLh/ya26r4enZYnQ4hR8R/ZVlYX9zxI0kCHtw
         katw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678557877;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4H+bNpp97fNs0DJvfrKKJ7SEqIL0C336vSLgUyHuDQ=;
        b=F/4BEScX8KVCn7df3mEs3hF6znPNHgDXra7xZ5Xyof17QI9xL9UnH/S9JiTREV/g90
         KKQGYXgu4PwM/RpvXVFqeO/7HsYWYuUf4pRyXlT0PLyr0N4U/o2wQfyvY4JPDceiL9Xd
         jUBbZFNMqtv+D7CpzDVO0ORqwTaCBG9q0Hq9jVaj745gxKDAQJwhIKm2FPqfnYR7kqZP
         8T5/9FM2Iu28IGhGqE+4XozNL2BtzOPT8WESuq9Ql+xYlECgrO0n2dM3F437G+Hd3GO+
         IInrB04QCO6auOKtQ1yEZlNbTHQgjZL10X8J+tNNMGSLfZ1HJqnb5sBjxHyqpLDUyysP
         DmLw==
X-Gm-Message-State: AO0yUKUpft0tNmGZPH8P4KtJa7cI4hoOoFeYyxTGjnirAaNB4/2ktjeM
        iGwCfQYMcOW6ZWVVebzsypOOuOIqskt1FgDReXg=
X-Google-Smtp-Source: AK7set9IpsY8MembE3uh1obwEcLhRbw5+qy6LVrWf3eFoUN9rXithHRbYTTgb0LQoMtVi/97zJCQDQTpTB5GgaDwyVM=
X-Received: by 2002:a17:902:cf46:b0:19e:f660:81d0 with SMTP id
 e6-20020a170902cf4600b0019ef66081d0mr5020577plg.12.1678557876935; Sat, 11 Mar
 2023 10:04:36 -0800 (PST)
MIME-Version: 1.0
Sender: hamidousebgo46@gmail.com
Received: by 2002:a05:7022:238c:b0:5f:a9bf:c13a with HTTP; Sat, 11 Mar 2023
 10:04:36 -0800 (PST)
From:   Mrs Aisha Al-Qaddafi <aishaalqaddafi3@gmail.com>
Date:   Sat, 11 Mar 2023 19:04:36 +0100
X-Google-Sender-Auth: RKP41DB6TtJV5YPbdoZpjwtc49o
Message-ID: <CAGHciYygOfEeAYgWpP9Df-_ZwNSdJpTP8Tyv38a19NQkRFg51A@mail.gmail.com>
Subject: Assalamu alaikum,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Assalamu alaikum,

I came across your e-mail contact prior to a private search while in
need of a trusted person. My name is Mrs. Aisha Gaddafi, a single
Mother and a
Widow with three Children. I am the only biological Daughter of the
late Libyan President (Late Colonel Muammar Gaddafi). I have a
business Proposal
for you worth $27.5Million dollars and I need mutual respect, trust,
honesty, transparency, adequate support and assistance, Hope to hear
from
you for more details.
Warmest regards
Mrs Aisha Gaddafi
