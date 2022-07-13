Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0735732E7
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 11:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiGMJgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiGMJfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 05:35:52 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E705BF4222
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 02:35:06 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id l2so4418039qvt.2
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 02:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=X/3QfIjI3sIds24h6irro/teG0psxAX/nmagqEtqAiUFCcVLABGdj+jyDMUxNWXi/J
         777mcKrnwFpRzGQex6bdEd+WgEiY7iTJ48KEDXhn6g1uhKs3yc0Tqtq0hKH3n1rj2Ysp
         QG+4Bv2GnvBfgc9cb0FZhu2EezWfB5Y++cWuLoELlKZMH3191LRftwA8hoDW/mgNUdyr
         mAWHM+rSdMjXnC3wBB/25BD12d3EGi8rWMiXeHToI7zXMlns7EHLhTJYFS9EKY3bmvJ1
         +cuI7VbFlf2nnFZ3nFeO/kFyyzh1WXr8VWU/jHEVpfS5xLLy0aKrVQ9+eXBhvP/H01uB
         Zh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=WAP9RBGI/JGp0/K68CrU0V2QDjuIPMY4gFZXzGOADqB7sCoefTbcg7GOAXi/zZicjH
         MEyzc+XlI37V4jXgAZIfZ9W8ckulYj52lwEMgoSAPKoYsrh3hSnjA11RbcbR2YApT49w
         RhVzzsybqzyPot9TTQZAmBpbvmuhRWuAnrI8uQhKMiwOGjztGW2EooetbCtaM2fZCqco
         oCmi853h/8rzl6Eh+hqT5kvB9twa366/yiBh8yUpBUM76xVxTXoCaNb0mVgcglCfT6Id
         nBed6lbODMM9+Ea5jp5UegurR+C78hpj+VEM38cilnYETj/lgX43SnAY5UTdlltSLAOl
         m+hQ==
X-Gm-Message-State: AJIora9j1dyL2VaseEjSN9p2FAr8rW/YnBkabJsuPkNrM2EvKJKTc/xx
        sSnlvuGurWtblDYgBgru5hyvnCr7f/cBvK9g9sZhRA7bnH0=
X-Google-Smtp-Source: AGRyM1ta36pMoZFdcksDiGjoowkvlEp1BEeZ5Ws+Bih8AwDGo9cRkdxwDRr4Rh0mFtngVwUbEjtAjYO/OwIL0hM+l+c=
X-Received: by 2002:a05:6214:5287:b0:473:3032:1602 with SMTP id
 kj7-20020a056214528700b0047330321602mr2167911qvb.61.1657704906052; Wed, 13
 Jul 2022 02:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183236.931648980@linuxfoundation.org>
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 13 Jul 2022 15:04:54 +0530
Message-ID: <CAHokDB=rj+movo_u+4z31DQ1OkqkgXqO9ZadUyWgAjF1T_nMTQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
