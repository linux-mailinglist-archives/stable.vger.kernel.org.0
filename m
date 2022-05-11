Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299A4522DBF
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 09:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbiEKH6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbiEKH6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 03:58:30 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED32651E59
        for <stable@vger.kernel.org>; Wed, 11 May 2022 00:58:28 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v4so1507230ljd.10
        for <stable@vger.kernel.org>; Wed, 11 May 2022 00:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=ozlj/mvZnxgmGr7FON2kxKq48mQIlKtxkY7HEDN44dGYSLoAgk1OQ7CSJdCtiryrcG
         ZpstgAWFMlbXn400JLwyvKWDWmao7YGAX7sQbgWjBwYhn6awSFgomIYdP+wKzr5NkftQ
         TX7x9Abt4mhw75VfzGK8DUZ2dlUypg7Eprrmo+Dujpy3BxlTYiFMvTEXoCd6JgzA9xm2
         skbWXaic3l6Y8KdL4yR5G2z3uTT5cii93PFwLyAjZsxwCKB3sdsxFGgyNG+tpia5AyPL
         kzE/4JIgUFcuJLEazDgksy7JnFgHgVlUoTPIpEsFiZaHoIqkpWrp0cMBbd6P8evviNYT
         IPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=iT6aVM+I9qgpD2hUEshWsJpeXoEVpjO/yvNoxfM9IEMIo4Dy9vbDmZxGcV5PKpFBMl
         UMjMaEFnPmGgOKytKg1Fogm16JOr7WrLn8utou38Y1dYyLgTbXm6gqGvSjRNCsrcUf+Z
         Kte9X4BVL6lvOPu9JTnBUVTnGlUYIyZCscbyd4bzxC0G3VUOtkbcowg+cROROXj9Itn3
         ZFdxjTpPJMTKMTTINaLi1PUebuZ+jXA7gW8mih0vpKTebSzAUZdDjbzhGk7Cb4fcZpXi
         iuyypN1s7QPViOEUqB4WlnjYF1UhViz6CsyKFwBBsxMCT0cql3bd1sc0HgVbEYEYR5iS
         ak+g==
X-Gm-Message-State: AOAM530U1z0ntiOaJ9N5t43bI0JyorrajkdrAmC3NtdSRsHVpMYlqcvl
        hlF7TzS6Ykv8i8rR0v0FLX2vnS71huIwscjOuUX1jj+e3oKS1Q==
X-Google-Smtp-Source: ABdhPJwsYY5a8D646HAJ6D4fZv6AFT15qsm91IiOR7q5+SoZ+Q1+MTHtjpa/sZdInfekCCmNh63NiszVKoW1YtM18kw=
X-Received: by 2002:a2e:8744:0:b0:250:9bfe:b777 with SMTP id
 q4-20020a2e8744000000b002509bfeb777mr15853555ljj.523.1652255907131; Wed, 11
 May 2022 00:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130741.600270947@linuxfoundation.org>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 11 May 2022 13:28:15 +0530
Message-ID: <CAHokDBmNhTLZAg7X0fYY+Td7WtLJ-E8-QeMsh_yAxnfZG1FYUA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
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

Tested-by: Fenil Jain<fkjainco@gmail.com>
