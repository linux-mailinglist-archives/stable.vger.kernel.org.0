Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4685F46DA
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJDPmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 11:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJDPmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 11:42:35 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC94E617
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 08:42:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w10so6492479edd.4
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=BIQlOzH6m90fviX5hb7346RuFfoJ5L2MWJyXL3a9j/FqluDCtma4GrS8DTUsVmexQ1
         Sd5LhbKzGkxJXVkrkCNxlsjzQOP7WyEeGClg2AT7Zyj5w7XpxupB1T/wmMicSIpvmEZP
         Lj7MmxAzGIfQJMi4/wwJSAOruQhrv0M0x6T8cPprnCGmgy2NmL1U5zE3dfLR6rYPh6W9
         d1DchyyAF5vtzwqA1+F7769SGDwIi7XfGJ6Cz24Wv2OjCR48RbiX3TTM4zdJ+NSjgbaN
         5SL1//CWtHZ398wEWDJ9LM99YQV9s4MzEbZ1K3wQEyfIdacWJcQu6Sdtx8K+voF/0JEj
         IiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=e+bQOYeFobfswtWf4b3K+kXZDhXas8a5BJ46yP6sOLrmyuspy2RqlQkl1+83QxGMNx
         vV6I6s1mIo279I40mAh+91L593f3rp7Siyzpk8jAyTVCVXzQd82Ni/oRVQ1DskFzi4CL
         pKjK+ZyKxDi7/qRyN3pXk5L7MphJi7MaLBStLjeGhd88uMvl/2o21LYrquTF5MnkQGoN
         U9IWs/e/Ffe2+nXM0/o3OxNvM5C2n7zey+r0PMnp24GftwmauDMbNE1eom1TJKgW8OMf
         89K9XjWYEC8urB/hW4cn51lkmbPjZb7D6PWOf8fx3epS3VKlKpLGmzi1EYQVw1CluQX6
         owBw==
X-Gm-Message-State: ACrzQf3IgG4dXv00tBkoO8J62SSY4VD39HEO31HVCC2bPMIpsLg2fl6o
        VH+MSrNbxED1Xyo9GQ75jmwpfQldAopR1YlVnDU=
X-Google-Smtp-Source: AMsMyM4/7vnro0BtpdBa1hv7rNLsFq4o4CP4nHHjUagOpWwJRNygbxFvwQaoi4lxLjvWXvX/IenbnywKwGUnu7a0Jbo=
X-Received: by 2002:a05:6402:1d83:b0:458:bd8e:5b32 with SMTP id
 dk3-20020a0564021d8300b00458bd8e5b32mr14748664edb.175.1664898153303; Tue, 04
 Oct 2022 08:42:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:d203:b0:77f:b0a8:93c8 with HTTP; Tue, 4 Oct 2022
 08:42:32 -0700 (PDT)
Reply-To: linadavid0089@gmail.com
From:   Lina David <deladelagan@gmail.com>
Date:   Tue, 4 Oct 2022 16:42:32 +0100
Message-ID: <CAJCXKVr3H8HA-eX9aXsZDOGkY0Kvf+7uLDLYPWu79yFUkyC6rA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
how are you?
