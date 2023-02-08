Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F228968F790
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjBHS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjBHS6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:58:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1353543
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 10:58:31 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ge7-20020a17090b0e0700b002312568942cso1209319pjb.3
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 10:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dkVne6QOQuiWRjarawnc2yDR1hi271zLDnK3/8Voi0=;
        b=UVbJ9xsLJiIJd2F3wQr18Dc6vf1t1u0vmP2LeaC8EAJTD0YwmMSpbp2WHw1gHsoG/g
         QYPN0EFStY/TgncavC3gzVnLZ0j3eANngoaJgpPhsPwgsUrShOB2ys3OL70zo3NnZmXZ
         3X/VdPwZ/EQXItjYA62Vk5s5T/8eTlUE9hKnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dkVne6QOQuiWRjarawnc2yDR1hi271zLDnK3/8Voi0=;
        b=rPeow6wvNrUAaZQL9UBnrOHVmiwk8sg7Yvs2es5Y1vlTHDwkZAkD236v2LGqL/plEN
         LCdDlYmQllNakflM4yn+t5aLkIzTFsr0iHMQXCrFn3fLDvclIGlf+01v6EV9/VHdaZY2
         nJ7rm8CM/rnUJ0V2s4QX3l0UEJWoSJimYc+hZAO8zyTUh+Q6UlowzJ09D9yTeuFSRVtg
         ZjhTTRW4Ff3PomR9tdm3rPjGwgFQxG0hI66awi3b9lx493Fv2EMHaTFpWpb8MKA6ujgS
         5eoP/w6+RT9nMPCy5zjs0V2/QHcXadIc7l/CzUrzBbtm1txsMtf1Z3O4DOaau80gOPZX
         dO0g==
X-Gm-Message-State: AO0yUKU+FhdIVKdzTDwejjt+WSORQyGdUls1B1haUirkk5b928OPqV7i
        qKC5ZolW4jpqMTDiNWlmzZJv/E0D+LP7ifHG
X-Google-Smtp-Source: AK7set+W13zod//i71uQI6lj/ZQHRIZUB6Bc0TJ8c+Ig+pIur65SH1HtUzuX+65B2W8SuYAFLnoWGQ==
X-Received: by 2002:a17:90b:384c:b0:22c:2d76:2713 with SMTP id nl12-20020a17090b384c00b0022c2d762713mr9884383pjb.32.1675882710714;
        Wed, 08 Feb 2023 10:58:30 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090a1f8300b00230e733599esm1850623pja.48.2023.02.08.10.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:58:30 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org, ebiggers@kernel.org
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        morbo@google.com
Subject: Re: [PATCH] randstruct: disable Clang 15 support
Date:   Wed,  8 Feb 2023 10:58:21 -0800
Message-Id: <167588270061.464935.14207013093507497315.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208065133.220589-1-ebiggers@kernel.org>
References: <20230208065133.220589-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Feb 2023 22:51:33 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The randstruct support released in Clang 15 is unsafe to use due to a
> bug that can cause miscompilations: "-frandomize-layout-seed
> inconsistently randomizes all-function-pointers structs"
> (https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
> on the Clang 16 release branch, so add a Clang version check.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] randstruct: disable Clang 15 support
      https://git.kernel.org/kees/c/7ee3819f2ba9

-- 
Kees Cook

