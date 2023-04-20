Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AA06E9F8F
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 01:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDTXCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 19:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjDTXCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 19:02:40 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B9E3AB7
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:02:39 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2a8bcfbf276so9023901fa.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682031757; x=1684623757;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QEzM+W+OEmpHfEeEaAySJoGydPuqhtpau7d10u77fwA=;
        b=cOefhpn4c0qoFnFi+POJqMV+G1WQ7/vUBhYVMM9f/i303aGK4pMzsVC/+vuW6naslX
         iPhHDF2sAbYpmMP1zzmloHjgZtN6VEaP7frV7Gpl5zgUcCCA3PX9YCq7cB2OvSKND3MJ
         mDzMULdnq6zj9Pi7bGks9wNYAs1iNa3BE+S2ZcFkcOf3A806JFrbtFiBBa1wIK8RqSAd
         iF59dcj1XopFz6hdAGLmqGTd4fdnwmQwJN/hijmch+WXjOgJuyJTRwiwKa3Qq2Xq3k/V
         5UA/+gnLt7mjAtdpGDrtiyug4td7Fh7QlGfIKUie4UXsPxZ2b7DXcQ08sa3pFi0RlIV7
         uk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682031757; x=1684623757;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QEzM+W+OEmpHfEeEaAySJoGydPuqhtpau7d10u77fwA=;
        b=NBND6Xx3OzZe0xf6rdHNNppNE6wMUqO24NH70r5yxHDdbjsU8QHIE0PtCYaYUrbjhY
         GFD530eWJlOp1K5CpZJWPMnq+zzlX/K/wv1XwPNEM6mjIYCRVgDrpxDQDi5ShxgFf4aC
         SuckXjnJXhLhl+t3PXKFzd1ySANbWYAYW8LrC6cC1Es3DefP1wGdOsPEu6z7as7F5fLc
         ui0PdGzYp1Uyb6FZVHaEByFMq0pLFPhvjarITk5l+pNS/DKO5GAaxPtU7B2zuw7jDmRs
         JFUw6wB84vQLVLPMk+YguFhHI1PXRpVdAXGsnrBBNTE6NH6CIL4HpAPYJkgGXhQHEJws
         Nxqg==
X-Gm-Message-State: AAQBX9eHs/AWvcyn94mlriQPVGdBA3v3wVZcevG0TzM4x2/zKrw/NMgA
        NOe0rG2fpU2r39fh+3rd+9jo9HRbLRxLgA1sCbA=
X-Google-Smtp-Source: AKy350ZcmK0V1xLejGa3RZyPsVbfAUmmJBQuPT3o/MJDFa2RaTnzmeAdMVagn2DRG2wQnw9hYFIGh/RxcB1bQOvRm2k=
X-Received: by 2002:a2e:80c5:0:b0:29b:ebfa:765d with SMTP id
 r5-20020a2e80c5000000b0029bebfa765dmr191417ljg.1.1682031757373; Thu, 20 Apr
 2023 16:02:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6022:507:b0:3d:74bc:2633 with HTTP; Thu, 20 Apr 2023
 16:02:36 -0700 (PDT)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <ava19938ava@gmail.com>
Date:   Fri, 21 Apr 2023 00:02:36 +0100
Message-ID: <CAGUqzHfbt8YOGrMvHPn38a2PFWOP17oQ1UbTL=Aj9Lq2ETQZrQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today? I hope you are fine
My name is Dr. Ava Smith, I Am an English and French nationality.
I will give you pictures and more details about me as soon as I hear from you
Thanks
Ava
