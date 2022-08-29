Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC67E5A41FE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 06:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiH2Eil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 00:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiH2Eij (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 00:38:39 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22993ED51;
        Sun, 28 Aug 2022 21:38:38 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id i12so403555vsr.10;
        Sun, 28 Aug 2022 21:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jHNnwmbjBYZKaOXiwt4aqA/JYeUVn93i2pze3fOwVgE=;
        b=aIO2JDIWNRe8AzQMAJqnqX9VIAGIQWOwz6EAjpUpVNML7XwvMusE7IXpGvneuPvHh7
         yim8Mawz5I35hmGouts532ssgpfO847VR+hJE+XEoFfC1V8iqXJDipmGB8yaR8JxIN98
         5c4daFiaov2Hm4mIX0U/2HAsqDoGyHBX8WRTYszr8krxGnkR6KiXY4sGrZCxUWQR6WwL
         CtOqhnZoC6COupS1Kj24yR3WNtSJHMxtkvY19I/Pb28Dx25oma/lCGLFJQlUR9ovq7M6
         ea0wwrSYeCnWVgi1PkdDI7aPczjtN9cgM5AB0H0FyHzXvivSqRRNb9frPHe2q9BX4VkA
         WoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jHNnwmbjBYZKaOXiwt4aqA/JYeUVn93i2pze3fOwVgE=;
        b=Pf5Uu3CzC3aXFxJRSC7Nv8etq0dFSnXSHVKACEmxioh5EVofyVFAVk1oDPKTudRjpf
         4+T8CJ6Pf2iMrAu2UY2Xr6iFUzEJDjRd++77MmMcVIBfbawDupoMO0FH3z8XTAyyO+wo
         H8pEnmzGhTDMEGjpa0+Svcy4J/ToNCuewb3+/XzoHLK5C3aJkIGlY9ZUDZDU+cH804yM
         tGcvVaHPooSwowJ6cz1mlXqY1pqrSkmeh7VcJ+zebSb86LIqLKlgOGuLXCIiLUdojwnT
         xSJGY6xmzNa3ZBt/X8kDhdvkciv1FW/0m+Hm0UitzjGjcCOCIu6/4SgFsrlbg1u9zr0J
         aLBA==
X-Gm-Message-State: ACgBeo0FH48MF6ZsSMTtW7WRpmotghK8GGjrEXqtuKFx1eDZP6iPxGGs
        eT7IUpnKt779SeeJqc1w7k0VA2kXlypHNqv6kEKPjQRQidM=
X-Google-Smtp-Source: AA6agR4C8ztE5SuCSa4vCbi0CnHMWmKGU1dcFB2I/zVJYvhmmU+2NTe5JKLIAxiPgxD9gny4EO97+PjLS0XyESwj7Wg=
X-Received: by 2002:a67:b205:0:b0:390:7910:aae6 with SMTP id
 b5-20020a67b205000000b003907910aae6mr2614450vsf.61.1661747917777; Sun, 28 Aug
 2022 21:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <87r110nocu.fsf@cjr.nz>
In-Reply-To: <87r110nocu.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 28 Aug 2022 23:38:27 -0500
Message-ID: <CAH2r5mtabDb-_B7M2SqL073oFKe8Xf+_s-_PgpX6N-LifVZcpw@mail.gmail.com>
Subject: Re: cifs backport request
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
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

Acked-by:  Steve French <stfrench@microsoft.com>

On Sun, Aug 28, 2022 at 2:45 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Greg,
>
> Could you please pick these commits for >= linux-5.7.y
>
>         ef605e868212 ("cifs: skip trailing separators of prefix paths")
>         ee3c8019cce2 ("cifs: fix uninitialized pointer in error case in dfs_cache_get_tgt_share")
>
> as part of a fix for
>
>         bacd704a95ad ("cifs: handle prefix paths in reconnect")



-- 
Thanks,

Steve
