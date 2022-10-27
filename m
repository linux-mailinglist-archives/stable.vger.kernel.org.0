Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0843C60FA3F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiJ0OQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 10:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiJ0OQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 10:16:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CEF5E301;
        Thu, 27 Oct 2022 07:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1B5E6234F;
        Thu, 27 Oct 2022 14:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA96C433D7;
        Thu, 27 Oct 2022 14:16:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UXmae/6I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666880164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZgmrLfv/Amd75ACrAmk9g0ZYukTbMZEvwaZVjYcEMHw=;
        b=UXmae/6IRHAI2ildKMAO/gbPRi6FcHkP+hF9k/sQndGwQ1MXXL4w0tixYbm4N2HHuTjesF
        mnmdtCue+ddx9imQoMIkSKYCjuc6PUtEed2Wmq6TkVfmnCJVabRXNYEmnOl0/ViK78yDzM
        ETrPVyAT8lMnxlcftfxaV8tW/cmxmdE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c3454d45 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 27 Oct 2022 14:16:04 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id t85so816133vkb.7;
        Thu, 27 Oct 2022 07:16:04 -0700 (PDT)
X-Gm-Message-State: ACrzQf2+xqYR92zlN9OEIZu501+0z9C3oo1NPxHGTAs277uk8S8HCCyW
        5CsdLB0hViz3fLvtGN1fpPDvXXaMv7vsaW1/ihI=
X-Google-Smtp-Source: AMsMyM764zAP22qj9lwicEImIGn8cwRXOHoT6zmFbrnpwLX0+GubvsZ8ATuhLvRlmz3dsjLog2Sy4Ife0L8lbIKdyBI=
X-Received: by 2002:a1f:2041:0:b0:3b7:9c37:74c3 with SMTP id
 g62-20020a1f2041000000b003b79c3774c3mr6035295vkg.13.1666880163284; Thu, 27
 Oct 2022 07:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
In-Reply-To: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 27 Oct 2022 16:15:52 +0200
X-Gmail-Original-Message-ID: <CAHmME9r9NRATt5YsApkTRBQtXCDGCkCZO9TPtyk9Oi9BUcyw5A@mail.gmail.com>
Message-ID: <CAHmME9r9NRATt5YsApkTRBQtXCDGCkCZO9TPtyk9Oi9BUcyw5A@mail.gmail.com>
Subject: Re: [PATCH stable 0/5] Fix missing patches in stable
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 9:20 PM Saeed Mirzamohammadi
<saeed.mirzamohammadi@oracle.com> wrote:
>
> The following patches has been applied to 6.0 but only patch#2 below
> has been applied to stable. This caused regression with nfs tests in
> all stable releases.
>
> This patchset backports patches 1 and 3-6 to stable.
>
> 1. 868941b14441 fs: remove no_llseek
> 2. 97ef77c52b78 fs: check FMODE_LSEEK to control internal pipe splicing
> 3. 54ef7a47f67d vfio: do not set FMODE_LSEEK flag
> 4. c9eb2d427c1c dma-buf: remove useless FMODE_LSEEK flag
> 5. 4e3299eaddff fs: do not compare against ->llseek
> 6. e7478158e137 fs: clear or set FMODE_LSEEK based on llseek function
>
> For 5.10.y and 5.4.y only, a revert of patch#2 is already included.
> Please apply patch#2, for 5.4.y and 5.10.y as well.

This is confusing and there's no way Greg is going to do this right
given the limited information you've provided and wrong ordering of
the patches. I couldn't really even follow this without some detective
work, and I wrote these patches.

Here are your options:
- Let the revert of "97ef77c52b78 fs: check FMODE_LSEEK to control
internal pipe splicing" work its way into all stable trees; or
- Send a proper backport series for each and every stable kernel,
depending on what each one needs. Send these as different patchsets,
marked with the version number it applies to. Make sure they apply,
compile, and work correctly.

Anything short of those is going to lead to chaos.

Jason
