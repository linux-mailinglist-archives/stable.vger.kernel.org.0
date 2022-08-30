Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2695A5972
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 04:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiH3Cbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 22:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiH3Cby (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 22:31:54 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3365558B4D
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:31:52 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-33dce2d4bc8so240887927b3.4
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=F1mp1QGvbuAThlfLTm3f9xOw3j/SSOwPUjdtQPwE5sw=;
        b=BON4JlaguKETjBYu5HmZ2OS351m07RYB56KofrJpHKjmg8+vaeTcsSQZ2jV5S2Oy5J
         TpCwKDfWrs5iVzsa7KvbsYJuphB7uJ5hZdtoSuiy7EZCCD+TNMEheV55ooSS1vCyAtVr
         MXBoF2VMUq9g4ylDI1mkG8ysP0Jr0LTequ86lqAtkXsnrk9lrix/QZy1PTR1YPLxMulh
         naO73iSwOJ921lKvR3CnWf1uUrSJ0Vx+NIGG6YLoCiBBnB0ZcBOxj1JX29mImSIbdyft
         /9xnoyg8JHwqCVufVlYz9I9AttpWE2sEB1ZOP4Hl7rn8wxI9l92GvzMWcgAfYTXR8dGE
         9pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=F1mp1QGvbuAThlfLTm3f9xOw3j/SSOwPUjdtQPwE5sw=;
        b=q3f16Fal6ZnxpQE7fZygqU18h0Pca20rk2NELBQ9n8vm5MHP93nlOB5GHWuPm67/XO
         zlUkjmOCeZRN2GFPKu4u+D7yRqTXcftkA9m3/GH0ySABwvR9+T0fCEqP/LZUPBg5nou8
         E/gJK6iSgYScJ2NJFfPdMyFZfRQa0T3Y/FI1ZdMeTtgiPFWj/MokJcDz0U0fu6th8iNY
         rDE1aU7BLMS4M12h/beDOFT13Ip8QvodLX51BmhWTiCdVMH4KFHhWz9+scnpOKra9fQh
         vl4jTWBAkPsVy8LtzoQELW56q7qB62txbmhZF+8SisPJx1SIdGBLa2iW4PfVzqSQtB9K
         Us4A==
X-Gm-Message-State: ACgBeo2FcNxcWNFXRVgtNngdGye/ki7llQkwI9MByJjq98/cYD2cZfaT
        kd24Q8b0L2lh5IVmFNZBtFYFK5B3XwnZwMWFLf//1rKmc4xY9A==
X-Google-Smtp-Source: AA6agR5aV5b2mTSCjkmDChAg9JU25noBXuw0eB2PdIQOTKhliBaCLXuPt911wnjaFpbpQkIlaLrRmfgJF1svVxnNaN8=
X-Received: by 2002:a81:b410:0:b0:33d:c31b:c088 with SMTP id
 h16-20020a81b410000000b0033dc31bc088mr12744572ywi.88.1661826711217; Mon, 29
 Aug 2022 19:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAPTxkvQJHAxYOSmXCro7Cf1uR4y202HTrYLVPCY0JNGc30Y0aA@mail.gmail.com>
In-Reply-To: <CAPTxkvQJHAxYOSmXCro7Cf1uR4y202HTrYLVPCY0JNGc30Y0aA@mail.gmail.com>
From:   Lucas Wei <lucaswei@google.com>
Date:   Tue, 30 Aug 2022 10:31:35 +0800
Message-ID: <CAPTxkvQXXeawY-LmmfVsM76MCUOQHRRQN=Sim7Fza0s0aAY6Rw@mail.gmail.com>
Subject: Re: Request to cherry-pick into v5.15: arm64: errata: Add Cortex-A510
 to the repeat tlbi list
To:     stable@vger.kernel.org
Cc:     Daniel Mentz <danielmentz@google.com>,
        Will Deacon <willdeacon@google.com>,
        Robin Peng <robinpeng@google.com>,
        Aaron Ding <aaronding@google.com>
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

Dear Linux stable kernel maintainers,

I would like to apply the below patch into kernel v5.15-stable.
 - subject:arm64: errata: Add Cortex-A510 to the repeat tlbi list
 - Upstream Commit ID: 39fdb65f52e9a53d32a6ba719f96669fd300ae78
 - Targeted LTS release: v5.15

This patch is an errata of #2441009. Since v5.15 is still in its LTS
lifecycle, I think it fits the rule of "New device IDs and quirks are
also accepted" and I want to request to apply this patch to kernel
v5.15.
Thanks!


On Tue, Aug 30, 2022 at 1:15 AM Lucas Wei <lucaswei@google.com> wrote:
>
> Dear Linux stable kernel maintainers,
>
> I would like to apply below patch into kernel v5.15-stable.
>
> subject:arm64: errata: Add Cortex-A510 to the repeat tlbi list
> Upstream Commit ID: 39fdb65f52e9a53d32a6ba719f96669fd300ae78
> Targeted LTS release: v5.15
>
> This patch is an errata of #2441009. Since v5.15 is still in its LTS lifecycle, I think it fits the rule of "New device IDs and quirks are also accepted" and I want to request to apply this patch to kernel v5.15.
> Thanks!
>
> --
>
> Lucas Wei
> Embedded Software Engineer
> lucaswei@google.com
> 0287260408
>


-- 

Lucas Wei
Embedded Software Engineer
lucaswei@google.com
0287260408
