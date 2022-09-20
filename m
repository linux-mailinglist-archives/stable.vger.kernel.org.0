Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912E75BEE6A
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 22:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiITUXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 16:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiITUXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 16:23:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF8858085
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 13:23:37 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e17so5567377edc.5
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 13:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=tpb/CksIcauPLKtHDROGP9ypZapyC0a7CkyCLaex6gg=;
        b=I/i4k1EFfX3q4AXVC8mW5llREBnn6dPwnR52G2hrty0Unm5QV4erUAPRpDmZ3I1BUT
         QV0CE3Wq/vsutexc/wIndYznxHFav1v8O10mffWvJTJMoZd18epaQO3XrLfK0YN3JEKA
         4Oc/0ursM7KkhrXLok8Tc4Qi9JrK9vX5x+5Mou0O1lmhwPk0RMyo/RT4O47OFLl2Mikh
         IwCAMzJodDopsRRNjOzqYU8fzdnPlfZR19765b8HsDtO+TZ0go9cMpergz/WczSYplu3
         +FrjOnWYrzXqcNGRAWIPvZpWK362y5t7FavY0yv9asAYcs4fKexhieKsinOxjULi5wwd
         Yfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=tpb/CksIcauPLKtHDROGP9ypZapyC0a7CkyCLaex6gg=;
        b=d/LnghtRB23gFMTsqNziEv8Gtc/nhBdAbtHzgWI5zQKMRDc2Z1W1G59CBN+RP50TZG
         xwp9/fiePDT+a/bmabjRoSPu13n+hhzZ+Rpw+Z+wWLXrvtBk81e5lFLfDr6Os7cjTNya
         Zb94a4ZjSxhHRcI/l2QkulZN6dTkqYrNta2oSaDs+OzOZbAegreOnaNIyzZ7W0zIdV3r
         8JABnq/WZ6rTPEWBKB/NHXUxTda9vIx8Htt/RQDcO77v7pfaITDHFhWKd1yl/JRebuTz
         dWIczvEg8TqPt78MNpVETkWvVPpjwHJcasRLg/9KWqpAIhgrWxQmv8VV9LAEsW9wXTJx
         /9WQ==
X-Gm-Message-State: ACrzQf1LLOhcZ6zwwmlKa936I07kbC7U3VMM6kOmn/V2RdhDPU0Rq5Q4
        OJYeMIJn6+iRgBAN0G2h2SUc62v3kKab+UA5zgkJHNdXilNZ7A==
X-Google-Smtp-Source: AMsMyM5qCghDCITyL/Q7LUdUtGmIDWzZ5sLpELXVaywzpPaoG1xUDKicJK/hGZPBvb8DrGrlTHs345oztzBzHdmwLUw=
X-Received: by 2002:a05:6402:5243:b0:451:6d52:5928 with SMTP id
 t3-20020a056402524300b004516d525928mr21669274edd.328.1663705415348; Tue, 20
 Sep 2022 13:23:35 -0700 (PDT)
MIME-Version: 1.0
From:   Sewook Seo <sewookseo@google.com>
Date:   Wed, 21 Sep 2022 05:22:58 +0900
Message-ID: <CABhgAgdbHH2hORTF-6UeCSroY6Hbpdr2+v-XBdWhTt67ndgoUQ@mail.gmail.com>
Subject: Merge of e22aa14866684f77b4f6b6cae98539e520ddb731
To:     stable@vger.kernel.org
Cc:     Sehee Lee <seheele@google.com>,
        Amruth Ramachandran <amruthr@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I kindly request to merge below commit to be merged into the relevant
stable trees.

commit id: e22aa14866684f77b4f6b6cae98539e520ddb731
target version: 5.4, 5.10 and 5.15.

Thanks Regards.
Sewook.
