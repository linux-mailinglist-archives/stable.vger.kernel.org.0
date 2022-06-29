Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE255FA3A
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 10:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiF2ISP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 04:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF2ISO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 04:18:14 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E436360;
        Wed, 29 Jun 2022 01:18:13 -0700 (PDT)
Date:   Wed, 29 Jun 2022 08:18:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1656490689; x=1656749889;
        bh=deP7GyXC9ZxqfXEwFpsGYTw5aRq5KASPRxGk3xoBFW0=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=X340piRB8ju8NyA3rXUUUfd5isroFkdGe9CndDe6KCMKho9Aw/iVxdsmEL9ViEyqR
         y7Skte++X7O0cjcgDE+FTxYx/BQy9ZaHQf57DSrWFSCAsK5r/akUxlRId7O4UVfbg2
         Fa7QAYqrlkOUST/yMP7nfkk8AKVhS8aelHiFiavTCokC9QnX7Gedj3Mrt8wrPwJcMp
         F28RVx9WRurUj2bI9acKcLBola59rNK3uNtlhXnN4lPq5TYDxxZKC5pJd4uafEXvRi
         bBLBc3lwn3ogTC/HHcaMbC4C5CFd+10lvRuRb1Jcs4zIrhmqM3oU8G4F96eKLzhl1E
         2EHPAEiDFIMmA==
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: linux-5.10.127 modpost warning
Message-ID: <B9ViOjUL7reNao5fkvKkt4S91RPpLSuY6lGtyNIFW4WCgET8Z5Y_9-Y7O1GuZJ9FJFk7QouCfASA1ogdd-xaSVQNtR9RN2r2kFD7zu9vbMw=@protonmail.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This shows up when building linux-5.10.127

  LD      vmlinux.o
  MODPOST vmlinux.symvers
WARNING: modpost: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section =
mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit to =
the function .init.text:drm_fb_helper_modinit()
The symbol drm_fb_helper_modinit is exported and annotated __init
Fix this by removing the __init annotation of drm_fb_helper_modinit or drop=
 the export.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

