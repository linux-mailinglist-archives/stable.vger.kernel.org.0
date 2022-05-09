Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDF35207FC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 00:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiEIWvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 18:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiEIWvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 18:51:10 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D02A7C01
        for <stable@vger.kernel.org>; Mon,  9 May 2022 15:47:14 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-edeb6c3642so16401648fac.3
        for <stable@vger.kernel.org>; Mon, 09 May 2022 15:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TWHtNc5CMFyUPEqVyWjeJSltBYUU2tOmvnHyg6rnd7E=;
        b=K84PZxzPrxYDK4fAvELR0daolPBPWa0AKlM2aS3DCvneXYvGyfhsSl8XaaIoPaSRq0
         b7vYcUObvsaHm/HSMk07Bg/wKGbDEcS+X+RbYdP3R6qh7sPCF9TUBX9efW6DA/+UadQ3
         O4I5iKSX9YgwB1Ip5aHyUb4sZOqBVxbBvnJ00pDGWyaX3M1+hE2M5LD2tfJ84YouXCcl
         zwilJwaFz/9G9Zs9vS+NEUNr6RvR3T3Ci3lTixPXUrqmhU3npQkoN2oFkorNKUbn/iv4
         8gsqP/wo/bn8/4ge83iEFlJuZl68/Tvw5/96W7jxJOVfMTz7X8TzgOhRK4XF6MwxjkXA
         XBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TWHtNc5CMFyUPEqVyWjeJSltBYUU2tOmvnHyg6rnd7E=;
        b=MJRj4pLPJnO9OXKDIuze4re7FaSH5UU6d7SS12k33zTbtCu3yagQPAwzdnN3zOyVpt
         SmiDetgUHtLuENjo5l3UZ+YfOiUxxQnUaQFmQ/N4RzH7SFQ+pkrB41pOBEFXtEk7X0aI
         Zl2LW+QCJquACuBEhEBtksWAKCivBjTdX2OjGNTmxJXWOtxLbkB1Sk/X4dMP31cqjeE7
         tXOtdS85CVWo2tAG2viApunwjj4qmPWAp402r3ntzchyVsFtUZux9QUMlpGO1djEu10X
         k5Kf3NbPqMlnVWNfNXlTQpd71EgWmNVp0ggamNQgDheRe9q/Ob7PnkN1tUN+N1U4aPVj
         mH4A==
X-Gm-Message-State: AOAM5332P7YRkoUbFy+tznojcndKDmMw27AR6+5kKeftbNF5uKjsoPd7
        GVIKcr9im394FDA+q3KxiLbk8qaYddczhq2PIxZTGHtWkYSUebJk
X-Google-Smtp-Source: ABdhPJxBRS2JXix4RFkuhuFFCzxDcqilDNObnckNFEhSxwlG0Mm8D6GRk0Uspoj6GG5oiqZe9Dvs5BoM6A1GsTC3CPA=
X-Received: by 2002:a05:6870:959f:b0:ed:754:a261 with SMTP id
 k31-20020a056870959f00b000ed0754a261mr8901464oao.296.1652136433597; Mon, 09
 May 2022 15:47:13 -0700 (PDT)
MIME-Version: 1.0
From:   Dexter Rivera <riverade@google.com>
Date:   Mon, 9 May 2022 15:47:02 -0700
Message-ID: <CAG5dfppH0s-ujBjXyJJ62mGiJRiKz1NOYBPYOx3A1550Z8X7Mg@mail.gmail.com>
Subject: Request to cherry-pick f00432063db1 to 5.10+
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello all,

Commit f00432063db1a0db484e85193eccc6845435b80e upstream ("SUNRPC:
Ensure we flush any closed sockets before xs_xprt_free()") fixes
CVE-2022-28893. Looking to cherry-pick this fix to versions 5.10+.

Thanks,
Dexter
