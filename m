Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11B5630AC
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiGAJt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 05:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiGAJt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 05:49:26 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188C27694F
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 02:49:24 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-fe023ab520so2808569fac.10
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 02:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=DMyolhHXpmu1+9rKonQ8Ub5Er3bhcnEayHaPyRlkSA4=;
        b=GBrFvYFYOVBzzpmDHs3IrrfJPWTh6RCiSsJBTWQSl2QmDgws/O5CzbbvaoYo7P/SJf
         cyhOGlDu6Sy/aJd1T9ENNALBTKHhubukyjTytEz5ksj1SfTpIDkxMeNNkK0i66J2J7aD
         T22Pj2T34mGGznldlkSe4GcLvzDzzbDCAUo7xC7XmHsgEQxx4Prha3Uyr4yPd9WzTZBj
         US+cZB51ElKLZPX1ckN42uJz3Y2Q8FOvCJ/Eq7TyFFGPJ6Pi6rl84Q2WgBKtR3UVOJtR
         jt03u3XwJDf3PfURRZlrovDUFv44xp0ZXH7T7lRQEM3b4E/TBU4sOFbPamIb3L9f9yf1
         kSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=DMyolhHXpmu1+9rKonQ8Ub5Er3bhcnEayHaPyRlkSA4=;
        b=HE/dUV+OKGpVcVvvG8g9mSqLAfcGPpctE/DPloWXy6BI0U4qWo6JnzTq5SBMUpc46X
         ArrHTnHz9n+MEOmAfav1lB56OBrkd6JVRRfl09FP4+pgTANFFYrn/Jdn9X6nWEWWHy1P
         B98JlASsIdlibUVm3IrBzHqMehyZG00h8fKQ6a1HO9evAQE0a4PAkkYHPkt3ucU+GWbR
         mliOaCe0UrTj0woS0RKtkFPIzcwOAKr5gUfIoqMjWGU3veCPnlVBgnt/E602od8O8WgQ
         DWUXCywfk1Irai0FURJXGaf5VFJhgIl+1K9y1lEnn2q45YfP+nKvMLPOfYTKi/DmzAl4
         TfmQ==
X-Gm-Message-State: AJIora8NkbZf9+uR8wVnGs1E31ZGsQlD+GeLis0jeNWWL28NMA3KZxHm
        k/4CWIE0H021t0f4RRtFTV7CNKzPjfXSi2JeVhQ=
X-Google-Smtp-Source: AGRyM1vUEnxfVBXnLthcFdYPBiJex2ydqSUkRs3JBYl50JOjTOlBaOXlFT8Lm5+/LueeNt5C1Zsv3fMm8ZXYb+a7VHM=
X-Received: by 2002:a05:6870:8195:b0:101:9342:bf1a with SMTP id
 k21-20020a056870819500b001019342bf1amr7805666oae.149.1656668963662; Fri, 01
 Jul 2022 02:49:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:f85:0:0:0:0 with HTTP; Fri, 1 Jul 2022 02:49:23
 -0700 (PDT)
Reply-To: fredrich.david.mail@gmail.com
From:   Mr Fredrich David <randywoods212@gmail.com>
Date:   Fri, 1 Jul 2022 09:49:23 +0000
Message-ID: <CAAAmqEZoJXvR7bNFTw7wgM9EcEBmT+Vx+5RsO3evURK6PFAN0Q@mail.gmail.com>
Subject: dcv3
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-In risposta alle tue email, ti scrivo per informarti che i progetti
sono ora completati e sei stato approvato!
Cordiali saluti,
Signor Fredrich David
