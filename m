Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81E678A55
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 23:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjAWWIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 17:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjAWWIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 17:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571437F21;
        Mon, 23 Jan 2023 14:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 444A361029;
        Mon, 23 Jan 2023 22:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2162C4339B;
        Mon, 23 Jan 2023 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674511677;
        bh=UA6PwuBMR1R6OEpQ1y1U1ciJD7dpLom6iSBNaOXEvFk=;
        h=From:Date:Subject:To:From;
        b=A8pS2lio0i5GlQOFR34qulmtqsenDp/Nz/nWdOaqvUhROvucijrANcoSAMkNaz5sJ
         zt28vKFrWdO4C1iQWsy9wtMizo4SaFNViMnda5hOFQJ/EnnYZsmSCQHZbc6PgajsN0
         ZfduOV8mMbFPeRBsneyaZe1yoTuOc1OV6PTBQPa8zYDj5TEVITPqJjid+L0YmecxX/
         Nvh4YdvaUaVk1Zmsa21EssgGWgD24wNFCDHRMIOL9UQ/vbRQ3/zSCkMJfZkMEXy6mR
         1aZZwkXVTRUhWhYjPlXpr8HpZvOaAmKyHuqn+4fzv/AcvWpI7OlojfA7mIXlOdtGuw
         ZIvYruqX0e3pg==
Received: by mail-lf1-f46.google.com with SMTP id a11so20502058lfg.0;
        Mon, 23 Jan 2023 14:07:57 -0800 (PST)
X-Gm-Message-State: AFqh2ko1mGy8SL1aLis5ENZs2ZNT8qvacDQZvwM8vtOOkDwAqsEvinQh
        uRk/pNYN6AeoW7oC5R7jdgb5ZcNBqR4OJyvlXME=
X-Google-Smtp-Source: AMrXdXvqrXtZasOqML5R3LcH8DEu/J2VIe5+leviAX9YFMvkFP78QgSqOoZG29AkYeU7by/X+QPw0h98qlqA3k0hkTw=
X-Received: by 2002:a19:c501:0:b0:4b8:9001:a694 with SMTP id
 w1-20020a19c501000000b004b89001a694mr1252525lfe.426.1674511675641; Mon, 23
 Jan 2023 14:07:55 -0800 (PST)
MIME-Version: 1.0
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 23 Jan 2023 23:07:44 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEZUi5nwe0vq2v5sYved-6_dxHBhb+UVm2qLMDKM8AArA@mail.gmail.com>
Message-ID: <CAMj1kXEZUi5nwe0vq2v5sYved-6_dxHBhb+UVm2qLMDKM8AArA@mail.gmail.com>
Subject: please backport EFI patches to v6.1
To:     "# 3.4.x" <stable@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

please backport these EFI patches to v6.1:

8a9a1a18731eb123 arm64: efi: Avoid workqueue to check whether EFI
runtime is live
7ea55715c421d22c arm64: efi: Account for the EFI runtime stack in stack unwinder
